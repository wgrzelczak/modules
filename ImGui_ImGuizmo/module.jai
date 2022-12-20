
#scope_export

#if OS == .WINDOWS {
    #load "windows.jai";
} else {
    #load "unix.jai";
}

#scope_module
#import "ImGui";