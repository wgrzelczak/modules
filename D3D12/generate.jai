#assert(OS == .WINDOWS);

USE_D3D12_AGILITY :: true;
D3D12_AGILITY_SRC :: "d3d12_agility_src/build/native/";

DXGI          :: true;
D3D12         :: true;
DXC           :: true;
PIX           :: true;

#run {
    set_build_options_dc(.{do_output=false});
    
    if DXGI {
        opts := make_default_generator_options();
        if USE_D3D12_AGILITY {
            array_add(*opts.source_files, tprint("%include/%", D3D12_AGILITY_SRC, "dxgiformat.h"));
        } else {
            array_add(*opts.source_files,                               "dxgiformat.h");
            array_add(*opts.path_suffixes_to_treat_as_non_system_paths, "dxgiformat.h");
        }
        dxgi_versions := string.["dxgi.h", "dxgi1_2.h", "dxgi1_3.h", "dxgi1_4.h", "dxgi1_5.h", "dxgi1_6.h"];
        array_add(*opts.libnames, "dxgi.dll");
        array_add(*opts.source_files,                               ..dxgi_versions);
        array_add(*opts.path_suffixes_to_treat_as_non_system_paths, ..dxgi_versions);
        array_add(*opts.source_files,                               "dxgitype.h");
        array_add(*opts.path_suffixes_to_treat_as_non_system_paths, "dxgitype.h", "dxgicommon.h", "fwptypes.h");
        
        generate_bindings("dxgi_bindings.jai", opts);
    }
    
    // Debug
    if DXGI {
        opts := make_default_generator_options();
        array_add(*opts.source_files,                               "dxgidebug.h");
        array_add(*opts.path_suffixes_to_treat_as_non_system_paths, "dxgidebug.h");
        generate_bindings("dxgi_bindings_debug.jai", opts);
    }
    
    if D3D12 {
        opts := make_default_generator_options();
        array_add(*opts.libnames, "d3d12.dll");
        if USE_D3D12_AGILITY {
            array_add(*opts.ignore_headers, "d3d12sdklayers.h", "d3d12shader.h", "dxgiformat.h");
            array_add(*opts.source_files, tprint("%include/%", D3D12_AGILITY_SRC, "d3d12.h"));
            array_add(*opts.source_files, tprint("%include/%", D3D12_AGILITY_SRC, "d3dcommon.h"));
            array_add(*opts.source_files, tprint("%include/%", D3D12_AGILITY_SRC, "d3d12video.h"));
        } else {
            array_add(*opts.source_files,                               "d3d12.h", "d3dcommon.h", "d3d12video.h");
            array_add(*opts.path_suffixes_to_treat_as_non_system_paths, "d3d12.h", "d3dcommon.h", "d3d12video.h");
        }
        generate_bindings("d3d12_bindings.jai", opts);
    }
    
    // Debug
    if D3D12 {
        opts := make_default_generator_options();
        array_add(*opts.libnames, "d3d12.dll");
        if USE_D3D12_AGILITY {
            array_add(*opts.ignore_headers, "d3d12.h", "d3d12shader.h", "d3d12video.h", "d3dcommon.h", "dxgiformat.h");
            array_add(*opts.source_files, tprint("%include/%", D3D12_AGILITY_SRC, "d3d12sdklayers.h"));
        } else {
            array_add(*opts.source_files,                               "d3d12sdklayers.h");
            array_add(*opts.path_suffixes_to_treat_as_non_system_paths, "d3d12sdklayers.h");
        }
        generate_bindings("d3d12_bindings_debug.jai", opts);
    }
    
    if DXC {
        opts := make_default_generator_options();
        array_add(*opts.libpaths,      "dxc_src/lib/x64");
        array_add(*opts.libnames,      "dxcompiler");
        array_add(*opts.include_paths, "dxc_src/inc");
        if USE_D3D12_AGILITY {
            array_add(*opts.ignore_headers, "d3d12.h", "d3d12sdklayers.h", "d3d12video.h", "d3dcommon.h", "dxgiformat.h");
            array_add(*opts.source_files,  tprint("%include/%", D3D12_AGILITY_SRC, "d3d12shader.h"));
        } else {
            array_add(*opts.source_files,  "d3d12shader.h");
        }
        array_add(*opts.source_files,  "dxcapi.h");
        array_add(*opts.source_files,  "objidl.h"); //IMalloc, IStream...
        array_add(*opts.system_types_to_include, "IMalloc", "IStream", "ISequentialStream", "tagSTATSTG", "STATSTG");
        generate_bindings("dxc_bindings.jai", opts);
    }
    
    // Compile wrapper
    if PIX {
        src_files: [..] string;
        array_add(*src_files, "pix_wrapper/pix_wrapper.cpp");
        make_directory_if_it_does_not_exist("pix_wrapper/x64");
        build_cpp_static_lib("pix_wrapper/x64/pix_wrapper", ..src_files, debug=false);
    }
    
    if PIX {
        opts := make_default_generator_options();
        array_add(*opts.libpaths,      "pix_wrapper/x64");
        array_add(*opts.libnames,      "pix_wrapper");
        array_add(*opts.include_paths, "pix_wrapper");
        array_add(*opts.source_files,  "pix_wrapper.h");
        generate_bindings("pix_bindings.jai", opts);
    }
}

#scope_file

make_default_generator_options :: () -> Generate_Bindings_Options {
    opts: Generate_Bindings_Options;
    
    array_add(*opts.system_include_paths, GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH);
    array_add(*opts.extra_clang_arguments, "-x", "c++", "-fms-extensions");
    
    opts.mimic_spacing_flags                &= ~Mimic_Spacing_Flags.VTABLE;
    opts.generate_compile_time_struct_checks = false;
    opts.generate_c_style_api_for_vtable     = false;
    opts.generate_vtable_helpers             = true;
    
    opts.will_print_bindings = () {
        for context.compiler.global_scope.members {
            visit_declarations(d3d_visitor, it);
        }
    };
    return opts;
}

generate_bindings :: (output_filename : string, opts : Generate_Bindings_Options) {
    log("Generating %", output_filename);
    bindings_builder, success := generate_bindings(opts, log_results=true);
    defer free_buffers(*bindings_builder);
    assert(success);
    
    success = write_entire_file(output_filename, *bindings_builder);
    assert(success, "Could not write generated output to \"%\"\n", output_filename);
    
    reset_temporary_storage();
}

d3d_visitor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result {
    // Make unnecessary typedefs for enums and structs disappear by 
    if (decl.kind == .STRUCT || decl.kind == .ENUM) && decl.output_name.count > 2 && decl.output_name[0] == #char "_" && decl.output_name[1] !=  #char "_" {
        advance(*decl.output_name);
    }
    
    if !parent_decl {
        if array_find(TYPES_TO_OMIT, decl.name) {
            decl.decl_flags |= .OMIT_FROM_OUTPUT;
            return .STOP;
        }
        for PREFIXES_FOR_TYPES_TO_OMIT {
            if begins_with(decl.name, it) {
                decl.decl_flags |= .OMIT_FROM_OUTPUT;
                return .STOP;
            }
        }
    }
    
    if decl.kind == .ENUM {
        if ends_with(decl.name, "FLAGS") || ends_with(decl.name, "FLAG") {
            en := cast(*Enum)decl;
            en.flags |= .IS_ENUM_FLAGS;
            en.flags |= .VALUES_IN_HEX;
            
            // Clang on Windows claims that all enums are signed, but MS function declarations expects at least the flags to be unsigned
            if en.type.size == {
                case 1; en.type = context.compiler.type_def_u8;
                case 2; en.type = context.compiler.type_def_u16;
                case 4; en.type = context.compiler.type_def_u32;
                case 8; en.type = context.compiler.type_def_u64;
            }
        }
    }
    
    // Replace integers with their corresponding enum flags, where possible
    if parent_decl && (parent_decl.kind == .FUNCTION || parent_decl.kind == .STRUCT) && decl.kind == .DECLARATION && decl.type.number_flags {
        new_name := get_enum_name(decl.name, parent_decl.name);
        if !new_name    return .RECURSE;
        
        for context.compiler.global_scope.members {
            if it.kind != .ENUM  || it.name != new_name     continue;
            
            en := cast(*Enum)it;
            
            // swap in the enum for the integer
            enum_type := New(CType);
            enum_type.type_of_enum = en;
            enum_type.size = decl.type.size;
            decl.type = enum_type;
            
            // we'll also need to output a cast, like "cast(EnumType)5" for the default argument
            decl.decl_flags |= .NEEDS_DEFAULT_ARGUMENT_CAST;
            
            break;
        }
    }
    
    return .RECURSE;
}

get_enum_name :: (argument_name: string, parent_name: string) -> string {
    if argument_name == {
        case "Flags";
        if parent_name == {
            case "DXGI_SWAP_CHAIN_DESC";  return "DXGI_SWAP_CHAIN_FLAG";
            case "DXGI_SWAP_CHAIN_DESC1"; return "DXGI_SWAP_CHAIN_FLAG";
            case "DXGI_ADAPTER_DESC1";    return "DXGI_ADAPTER_FLAG";
        }
    }
    
    return "";
}

PREFIXES_FOR_TYPES_TO_OMIT :: string.[
                                      "__REQUIRED_",
                                      "LP",
                                      "IID_",
                                      
                                      "__MIDL_",
                                      
                                      ];

TYPES_TO_OMIT :: string.[
                         "WKPDID_D3DDebugObjectName",
                         "DXGI_DEBUG_ALL",
                         "DXGI_DEBUG_DX",
                         
                         "DXGI_DEBUG_DXGI",
                         "DXGI_DEBUG_APP",
                         // Double definitions:
                         "DXGI_CPU_ACCESS_NONE",
                         "DXGI_CPU_ACCESS_DYNAMIC",
                         "DXGI_CPU_ACCESS_READ_WRITE",
                         "DXGI_CPU_ACCESS_SCRATCH",
                         "DXGI_CPU_ACCESS_FIELD",
                         
                         // Below two had been defined twice in header files...
                         "D3D_SHADER_FEATURE_ADVANCED_TEXTURE_OPS",
                         "D3D_SHADER_FEATURE_WRITEABLE_MSAA_TEXTURES",
                         
                         // Temporary define in headers (d3d agility)
                         "INTERFACE",
                         ];


#import "Basic";
#import "Bindings_Generator";
#import "BuildCpp";
#import "Compiler";
#import "File";
#import "String";
#import "System";
#import "Windows_Resources";
