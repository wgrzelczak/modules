#scope_module
//
// Config:
USE_DEBUG :: true;
USE_D3D12_AGILITY :: true;
USE_DXC :: true;

#if USE_D3D12_AGILITY {
    #program_export D3D12SDKVersion     : u32 = 706;
    #program_export D3D12SDKPath        : *u8 = ".\\".data;
}

#scope_export
#load "d3d12.jai";
#load "dxgi.jai";
#if USE_DXC   #load "dxc.jai";
#if USE_DEBUG #load "pix.jai";

#run {
    // Copy dlls next to the exe
    {
        copy_dll :: (dir : string, filename : string) {
            #import "Compiler";
            #import "File";
            #import "File_Utilities";
            #import "String";
            w := get_build_options();

            src := tprint("%+%+%+", #filepath, dir, filename);
            dst := tprint("%+%+", w.output_path, filename);
            //copy_file(src, dst); //@Incomplete: for some reason copying files doesn't work with final workspace
        }
        
        #if USE_DEBUG {
            copy_dll("pix_src/bin/x64/", "WinPixEventRuntime.dll");
        }
        #if USE_D3D12_AGILITY {
            copy_dll("d3d12_agility_src/build/native/bin/x64/", "D3D12Core.dll");
            copy_dll("d3d12_agility_src/build/native/bin/x64/", "d3d12SDKLayers.dll");
        }
        #if USE_DXC {
            copy_dll("dxc_src/bin/x64/", "dxcompiler.dll");
            copy_dll("dxc_src/bin/x64/", "dxil.dll");
        }
    }
}


check_hr :: (hr : HRESULT) {
    assert(hr == S_OK);
}

set_name :: (object : *$T/interface ID3D12Object, name := "Unnamed") #expand {
    wstr := cast(*s16) utf8_to_wide(name);
    vtable(object).SetName(object, wstr);
}

set_name :: (object : *$T/interface ID3D12Object, name := "Unnamed", idx : int) #expand {
    wstr := cast(*s16) utf8_to_wide(tprint("%[%]", name, idx));
    vtable(object).SetName(object, wstr);
}

#scope_module
#import "Windows_Utf8";