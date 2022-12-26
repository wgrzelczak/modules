
#import "Compiler";
#import "BuildCpp";
#import "Basic";
#import "Bindings_Generator";
#import "File";

#run {
    set_build_options_dc(.{do_output = false});

    src := "source/stb_truetype.cpp";
    lib := "stb_tt";

    log("Building static library:\n");
    build_cpp_static_lib(lib, src);

    {
		output_filename := "win_bindings.jai";
		opts: Generate_Bindings_Options;
		
		opts.generate_compile_time_struct_checks = false;
		opts.try_to_preserve_comments = false;
		array_add(*opts.libnames, lib);
		array_add(*opts.source_files,  src);
		
		
		log("Generating %", output_filename);
		bindings_builder, success := generate_bindings(opts, log_results=true);
		defer free_buffers(*bindings_builder);
		assert(success);

		success = write_entire_file(output_filename, *bindings_builder);
		assert(success, "Could not write generated output to \"%\"\n", output_filename);
    }
    
    //log("Building dynamic library:\n");
    //build_cpp_dynamic_lib(lib, src);
}