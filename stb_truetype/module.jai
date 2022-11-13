#scope_export

#if OS == .WINDOWS {
    #load "win_bindings.jai";
} else #if OS == .LINUX {
    //libstb_sprintf :: #foreign_library "linux/stb_sprintf";
} else #if OS == .MACOS {
    //libstb_sprintf :: #foreign_library "mac/stb_sprintf";
} else #if OS == .NN_SWITCH {
    //libstb_sprintf :: #foreign_library "switch/stb_sprintf";
}
