#load "pix_bindings.jai";
#load "pix_helpers.jai";

PCWSTR :: *u16; //@Cleanup: probably should be in Windows module

#scope_module
#import "Windows_Utf8";
#import "Windows_Resources";
pix_runtime :: #foreign_library,no_dll "pix_src/bin/x64/WinPixEventRuntime";