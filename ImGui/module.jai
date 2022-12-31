// Note that you need to define a handle_c_assert somewhere in your program:
/*
#program_export 
handle_c_assert :: (condition : bool, c_msg : *u8) #c_call {
    if !condition {
    	new_context: Context;
	    push_context new_context {
        	assert(condition, "ImGui: %", to_string(c_msg));
        }
    }
}
*/


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
    user32      :: #system_library "user32"; // Needed by imgui unless ImGui is compiled it with "IMGUI_DISABLE_WIN32_DEFAULT_CLIPBOARD_FUNCS"
} else {
    #load "unix.jai";
}



// handmade bindings
Payload_IsDataType :: (using payload : Payload, type : string) -> bool 
{
    return DataFrameCount != -1 && type == to_string(DataType.data);
}

// from imgui_internal.h
Window :: #type *void;
PushMultiItemsWidths :: (components: s32, width_full: float) -> void #foreign imgui "?PushMultiItemsWidths@ImGui@@YAXHM@Z";
FindWindowByName :: (name: *u8) -> *Window #foreign imgui "?FindWindowByName@ImGui@@YAPEAUImGuiWindow@@PEBD@Z";
SetFocusID :: (id: u32, window: *Window) -> void #foreign imgui "?SetFocusID@ImGui@@YAXIPEAUImGuiWindow@@@Z";

#scope_file
#if OS == .WINDOWS {
    imgui :: #library "windows/ImGui";
}