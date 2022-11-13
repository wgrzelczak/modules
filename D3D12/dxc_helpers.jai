dxc_compile_from_file :: (shader_file : string, defines : [] string, entry_point : string, target : string, debug := false, extra_flags : [] string = .[]) -> bytecode:string, errors:string, success:bool {
    dxc_utils    : *IDxcUtils;
    dxc_compiler : *IDxcCompiler3;
    dxc_include_handler : *IDxcIncludeHandler;
    defer safe_release(dxc_utils);
    defer safe_release(dxc_compiler);
    defer safe_release(dxc_include_handler);
    
    DxcCreateInstance(CLSID_DxcUtils,    uid(IDxcUtils_UUID),     xx *dxc_utils);
    DxcCreateInstance(CLSID_DxcCompiler, uid(IDxcCompiler3_UUID), xx *dxc_compiler);
    vtable(dxc_utils).CreateDefaultIncludeHandler(dxc_utils, *dxc_include_handler);
    
    if !dxc_utils || !dxc_compiler || !dxc_include_handler {
        print("Couldn't create DXC objects!\n");
        return "", "", false;
    }
    
    args : [..] *u16;
    array_add(*args, utf8_to_wide(shader_file));
    array_add(*args, utf8_to_wide("-E"), utf8_to_wide(entry_point));
    array_add(*args, utf8_to_wide("-T"), utf8_to_wide(target));
    if debug    	array_add(*args, utf8_to_wide("-Zi"), utf8_to_wide("-Qembed_debug"), utf8_to_wide("-Od"));
    for defines 	array_add(*args, utf8_to_wide("-D"), utf8_to_wide(it));
    for extra_flags array_add(*args, utf8_to_wide(it));
    
    //
    // Open source file.
    source : *IDxcBlobEncoding;
    defer safe_release(source);
    
    vtable(dxc_utils).LoadFile(dxc_utils, cast(*s16)utf8_to_wide(shader_file), null, *source);
    if source == null {
        return "", tprint("Couldn't load the file: %", shader_file), false; 
    }
    
    source_buff : DxcBuffer;
    source_buff.Ptr      = vtable(source).GetBufferPointer(source);
    source_buff.Size     = vtable(source).GetBufferSize(source);
    source_buff.Encoding = DXC_CP_ACP; // Assume BOM says UTF8 or UTF16 or this is ANSI text.
    
    //
    // Compile it with specified arguments.
    result  : *IDxcResult;
    defer safe_release(result);
    is_success : bool;
    {
        hr := vtable(dxc_compiler).Compile(dxc_compiler, *source_buff, cast(**s16)args.data, cast(u32)args.count, dxc_include_handler, *uid(IDxcResult_UUID), xx *result);
        
        compilation_hr : HRESULT;
        is_success = SUCCEEDED(hr) && SUCCEEDED(vtable(result).GetStatus(result, *compilation_hr)) && SUCCEEDED(compilation_hr);
    }
    
    //
    // Get errors
    errors : string;
    {
        error_blob : *IDxcBlobUtf8;
        defer safe_release(error_blob);
        
        hr := vtable(result).GetOutput(result, .ERRORS,  *uid(IDxcBlobUtf8_UUID), xx *error_blob, null);
        is_success = is_success && SUCCEEDED(hr);
        
        
        if vtable(error_blob).GetStringLength(error_blob) != 0 {
            errors = copy_string(to_string(vtable(error_blob).GetStringPointer(error_blob), cast(s64) vtable(error_blob).GetStringLength(error_blob)));
        }
    }
    
    
    if !is_success {
        return "", errors, false;
    }
    
    
    //
    // Get binary
    bytecode : string;
    {
    	shader_blob     : *IDxcBlob;
        shadername_blob : *IDxcBlobUtf16;
        defer safe_release(shader_blob);
        defer safe_release(shadername_blob);
        
        hr := vtable(result).GetOutput(result, .OBJECT,  *uid(IDxcBlob_UUID), xx *shader_blob, *shadername_blob);
        is_success = is_success && SUCCEEDED(hr) && shader_blob != null;
        
        bytecode = copy_string(to_string(vtable(shader_blob).GetBufferPointer(shader_blob), cast(s64) vtable(shader_blob).GetBufferSize(shader_blob)));
    }   
    
    return bytecode, errors, is_success;
}