// Bindings for Dear ImGui.

ImVec2      :: Vector2;
ImVec4      :: Vector4;
ImColor     :: Vector4;

ImVector :: struct (T: Type) {
    Size: s32;
    Capacity: s32;
    Data: *T;
}

ImDrawCallback :: #type (parent_list: *ImDrawList, cmd: *ImDrawCmd) #c_call;

#scope_module

size_t :: u64;

#import "Basic";
#import "Math";

#if OS == .WINDOWS {
    #load "windows.jai";
    user32      :: #foreign_system_library "user32"; // Needed by imgui unless ImGui is compiled it with "IMGUI_DISABLE_WIN32_DEFAULT_CLIPBOARD_FUNCS"
} else {
    #load "unix.jai";
}



// handmade bindings
Payload_IsDataType :: (using payload : Payload, type : string) -> bool 
{
    return DataFrameCount != -1 && type == to_string(DataType.data);
}

// from imgui_internal.h

PushMultiItemsWidths :: (components: s32, width_full: float) -> void #foreign imgui "?PushMultiItemsWidths@ImGui@@YAXHM@Z";

#scope_file
#if OS == .WINDOWS {
    imgui :: #foreign_library "windows/ImGui";
}