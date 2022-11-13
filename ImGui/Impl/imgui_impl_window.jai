#scope_export
Backend_Data :: struct {
    hwnd : HWND;
    mouse : HWND;
    mouse_tracked : bool;
    mouse_buttons_down : int;
    time : int;
    ticks_per_sec : int;
    mouse_last_cursor : ImGui.MouseCursor;

    has_gamepad : bool;
    want_update_has_gamepad : bool;
    want_update_monitors    : bool;
}

get_backend_data :: () -> *Backend_Data {
    if ImGui.GetCurrentContext() {
        return cast(*Backend_Data)ImGui.GetIO().BackendPlatformUserData;
    }
    return null;
}

init :: (hwnd : HWND) -> result : bool {
    io := ImGui.GetIO();

    assert(!io.BackendPlatformUserData, "Platform backend already initialized!");

    perf_frequency : int;
    perf_counter : int;
    if !QueryPerformanceFrequency(*perf_frequency) return false;
    if !QueryPerformanceCounter(*perf_counter) return false;


    data := New(Backend_Data);
    io.BackendPlatformUserData = cast(*void)data;
    io.BackendPlatformName     = "imgui_impl_window.jai";
    io.BackendFlags_          |= .HasMouseCursors;         // We can honor GetMouseCursor() values (optional)
    io.BackendFlags_          |= .HasSetMousePos;          // We can honor io.WantSetMousePos requests (optional, rarely used)

    data.hwnd = hwnd;
    data.want_update_has_gamepad = false;//true;
    data.want_update_monitors = false;//true;
    data.ticks_per_sec = perf_frequency;
    data.time = perf_counter;
    data.mouse_last_cursor = ImGui.MouseCursor.COUNT;

    //ImGui.GetMainViewport().PlatformHandleRaw = cast(*void)hwnd;

    io.ImeWindowHandle = cast(*void)hwnd;

    return true;
}

shutdown :: () {
    using data := get_backend_data();
    assert(!!data, "No platform backend to shutdom!");
    
    io := ImGui.GetIO();

    io.BackendPlatformName = null;
    io.BackendPlatformUserData = null;

    free(data);
}

update_mouse_cursor :: () -> result : bool {
    using data := get_backend_data();
    io := ImGui.GetIO();

    if io.ConfigFlags_ & .NoMouseCursorChange
        return false;

    imgui_cursor := ImGui.GetMouseCursor();
    if imgui_cursor == .None || io.MouseDrawCursor {
        // Hide OS mouse cursor if imgui is drawing it or if it wants no cursor
        SetCursor(null);
    }
    else {
        // Show OS mouse cursor
        win32_cursor := IDC_ARROW;
        if imgui_cursor == {
            case .Arrow;        win32_cursor = IDC_ARROW;
            case .TextInput;    win32_cursor = IDC_IBEAM;
            case .ResizeAll;    win32_cursor = IDC_SIZEALL;
            case .ResizeEW;     win32_cursor = IDC_SIZEWE;
            case .ResizeNS;     win32_cursor = IDC_SIZENS;
            case .ResizeNESW;   win32_cursor = IDC_SIZENESW;
            case .ResizeNWSE;   win32_cursor = IDC_SIZENWSE;
            case .Hand;         win32_cursor = IDC_HAND;
            case .NotAllowed;   win32_cursor = IDC_NO;
        }
        //SetCursor(LoadCursor(null, win32_cursor)); //@Incomplete winapi    }
    }
    return true;
}

is_key_down :: (key : Input.Key_Code) -> bool {
    return Input.input_button_states[key] & .DOWN != 0;
}

add_key_event :: (key : ImGui.Key, is_down : bool, native_keycode : s32, native_scancode : s32 = -1) {
     io := ImGui.GetIO();
     io.AddKeyEvent(io, key, is_down);
     io.SetKeyEventNativeData(io, key, native_keycode, native_scancode); // To support legacy indexing (<1.87 user code)
}

process_key_events_workaorunds :: () {
    // Note JAI input library doesn't recognize difference between LShift and RShift
    // Left & right Shift keys: when both are pressed together, Windows tend to not generate the WM_KEYUP event for the first released one.
    
    if ImGui.IsKeyDown(.LeftShift) && !is_key_down(.SHIFT)
        add_key_event(.LeftShift, false, xx Input.Key_Code.SHIFT);
    if ImGui.IsKeyDown(.RightShift) && !is_key_down(.SHIFT)
        add_key_event(.RightShift, false, xx Input.Key_Code.SHIFT);

    // Sometimes WM_KEYUP for Win key is not passed down to the app (e.g. for Win+V on some setups, according to GLFW).
    //if (.IsKeyDown(ImGuiKey_LeftSuper) && !IsVkDown(VK_LWIN))
    //    ImGui_ImplWin32_AddKeyEvent(ImGuiKey_LeftSuper, false, VK_LWIN);
    //if (.IsKeyDown(ImGuiKey_RightSuper) && !IsVkDown(VK_RWIN))
    //    ImGui_ImplWin32_AddKeyEvent(ImGuiKey_RightSuper, false, VK_RWIN);
}

update_key_modifiers :: () {
    io := ImGui.GetIO();
    add_key_event(.ModCtrl,  is_key_down(.CTRL),  xx Input.Key_Code.CTRL);
    add_key_event(.ModShift, is_key_down(.SHIFT), xx Input.Key_Code.SHIFT);
    add_key_event(.ModAlt,   is_key_down(.ALT),   xx Input.Key_Code.ALT);

    //io.AddKeyEvent(.ModSuper, is_key_down(.WIN));//@Incomplete no super key
}

update_mouse_data :: () {
    using data := get_backend_data();
    io := ImGui.GetIO();

    assert(!!hwnd);

    if !Input.input_application_has_focus return;

    // (Optional) Set OS mouse position from Dear ImGui if requested (rarely used, only when ImGuiConfigFlags_NavEnableSetMousePos is enabled by user)
    if io.WantSetMousePos {
        pos : Vector2;
        pos.x = io.MousePos.x;
        pos.y = io.MousePos.y;
        
        if ClientToScreen(hwnd, xx *pos) {
            ImGui.SetCursorPos(pos);
        }
    }

    // (Optional) Fallback to provide mouse position when focused (WM_MOUSEMOVE already provides this when hovered or captured)
    if !io.WantSetMousePos && !mouse_tracked {
        pos : POINT;
        if GetCursorPos(*pos) && ScreenToClient(hwnd, *pos) {
            io.MousePos.x = xx pos.x;
            io.MousePos.y = xx pos.y;
        }
    }


    //@Cleanup: Prefereably mouse should be updated in event loop
    pos : POINT;
    if GetCursorPos(*pos) && ScreenToClient(hwnd, *pos) {
        io.MousePos.x = xx pos.x;
        io.MousePos.y = xx pos.y;
    }
}

new_frame :: () {
    using data := get_backend_data();
    io := ImGui.GetIO();

    assert(!!data);

    rect : RECT = .{ 0, 0, 0, 0 };
    GetClientRect(hwnd, *rect);
    io.DisplaySize.x = cast(float) rect.right - rect.left;
    io.DisplaySize.y = cast(float) rect.bottom - rect.top;

    current_time : int;
    QueryPerformanceCounter(*current_time);
    io.DeltaTime = cast(float) (current_time - time) / ticks_per_sec;
    time = current_time;

    update_mouse_data();
    process_key_events_workaorunds();
    update_key_modifiers();
    update_mouse_cursor();
}

process_event :: (event : Input.Event) {
    using Input;
    io := ImGui.GetIO();

    if event.type == {
        case .KEYBOARD; {
            is_down := event.key_pressed != 0;
            if event.key_code == {
                case .MOUSE_BUTTON_LEFT;     io.MouseDown[ImGui.MouseButton.Left] = is_down;
                case .MOUSE_BUTTON_MIDDLE;   io.MouseDown[ImGui.MouseButton.Middle] = is_down;
                case .MOUSE_BUTTON_RIGHT;    io.MouseDown[ImGui.MouseButton.Right] = is_down;
                case; {
                    add_key_event(jai_key_to_imgui(event.key_code), is_down, xx event.key_code);
                }
            }
        }
        case .MOUSE_WHEEL; {
            //@Cleanup: haven't checked what WHEEL_DELTA is...
            WHEEL_DELTA :: 120.0;
            io.MouseWheel += cast(float)event.wheel_delta / WHEEL_DELTA;
//     case WM_MOUSEWHEEL:
//          += (float)GET_WHEEL_DELTA_WPARAM(wParam) / (float)WHEEL_DELTA;
//         return 0;
//     case WM_MOUSEHWHEEL:
//         io.MouseWheelH += (float)GET_WHEEL_DELTA_WPARAM(wParam) / (float)WHEEL_DELTA;
//         return 0;
        }
        case .TEXT_INPUT; {
            io.AddInputCharacterUTF16(io, xx event.utf32);
        }
    }
}

#scope_file

#import "Basic";
ImGui :: #import "ImGui";
Input :: #import "Input";
#import "Math";
#import "Windows";


jai_key_to_imgui :: (jai : Input.Key_Code) -> ImGui.Key
{
    if jai == {
        case .TAB; return ImGui.Key.Tab;
        case .ARROW_LEFT; return ImGui.Key.LeftArrow;
        case .ARROW_RIGHT; return ImGui.Key.RightArrow;
        case .ARROW_UP; return ImGui.Key.UpArrow;
        case .ARROW_DOWN; return ImGui.Key.DownArrow;
        case .PAGE_UP; return ImGui.Key.PageUp;
        case .PAGE_DOWN; return ImGui.Key.PageDown;
        case .HOME; return ImGui.Key.Home;
        case .END; return ImGui.Key.End;
        case .INSERT; return ImGui.Key.Insert;
        case .DELETE; return ImGui.Key.Delete;
        case .BACKSPACE; return ImGui.Key.Backspace;
        case .SPACEBAR; return ImGui.Key.Space;
        case .ENTER; return ImGui.Key.Enter;
        case .ESCAPE; return ImGui.Key.Escape;
        case #char "'"; return ImGui.Key.Apostrophe;
        case #char ","; return ImGui.Key.Comma;
        case #char "-"; return ImGui.Key.Minus;
        case #char ".";  return ImGui.Key.Period;
        case #char "/";  return ImGui.Key.Slash;
        case #char ";";  return ImGui.Key.Semicolon;
        case #char "=";  return ImGui.Key.Equal;
        case #char "{";  return ImGui.Key.LeftBracket;
        case #char "\\";  return ImGui.Key.Backslash;
        case #char "}";  return ImGui.Key.RightBracket;
        case #char "`";  return ImGui.Key.GraveAccent;
        case 20; return ImGui.Key.CapsLock;
        case .SCROLL_LOCK; return ImGui.Key.ScrollLock;
        //case .NUMLOCK; return ImGui.Key.NumLock;
        case .PRINT_SCREEN; return ImGui.Key.PrintScreen;
        case .PAUSE; return ImGui.Key.Pause;
        //case .NUMPAD0; return ImGui.Key.Keypad0;
        //case .NUMPAD1; return ImGui.Key.Keypad1;
        //case .NUMPAD2; return ImGui.Key.Keypad2;
        //case .NUMPAD3; return ImGui.Key.Keypad3;
        //case .NUMPAD4; return ImGui.Key.Keypad4;
        //case .NUMPAD5; return ImGui.Key.Keypad5;
        //case .NUMPAD6; return ImGui.Key.Keypad6;
        //case .NUMPAD7; return ImGui.Key.Keypad7;
        //case .NUMPAD8; return ImGui.Key.Keypad8;
        //case .NUMPAD9; return ImGui.Key.Keypad9;
        //case .DECIMAL; return ImGui.Key.KeypadDecimal;
        //case .DIVIDE; return ImGui.Key.KeypadDivide;
        //case .MULTIPLY; return ImGui.Key.KeypadMultiply;
        //case .SUBTRACT; return ImGui.Key.KeypadSubtract;
        case #char "+"; return ImGui.Key.KeypadAdd;
        //case .VK_KEYPAD_ENTER; return ImGui.Key.KeypadEnter;
        case .SHIFT; return ImGui.Key.LeftShift;
        case .CTRL; return ImGui.Key.LeftCtrl;
        case .ALT; return ImGui.Key.LeftAlt;
        //case .LWIN; return ImGui.Key.LeftSuper;
        //case .RSHIFT; return ImGui.Key.RightShift;
        //case .RCONTROL; return ImGui.Key.RightCtrl;
        //case .RMENU; return ImGui.Key.RightAlt;
        //case .RWIN; return ImGui.Key.RightSuper;
        //case .APPS; return ImGui.Key.Menu;
        case #char"0"; return ImGui.Key._0;
        case #char"1"; return ImGui.Key._1;
        case #char"2"; return ImGui.Key._2;
        case #char"3"; return ImGui.Key._3;
        case #char"4"; return ImGui.Key._4;
        case #char"5"; return ImGui.Key._5;
        case #char"6"; return ImGui.Key._6;
        case #char"7"; return ImGui.Key._7;
        case #char"8"; return ImGui.Key._8;
        case #char"9"; return ImGui.Key._9;
        case #char"A"; return ImGui.Key.A;
        case #char"B"; return ImGui.Key.B;
        case #char"C"; return ImGui.Key.C;
        case #char"D"; return ImGui.Key.D;
        case #char"E"; return ImGui.Key.E;
        case #char"F"; return ImGui.Key.F;
        case #char"G"; return ImGui.Key.G;
        case #char"H"; return ImGui.Key.H;
        case #char"I"; return ImGui.Key.I;
        case #char"J"; return ImGui.Key.J;
        case #char"K"; return ImGui.Key.K;
        case #char"L"; return ImGui.Key.L;
        case #char"M"; return ImGui.Key.M;
        case #char"N"; return ImGui.Key.N;
        case #char"O"; return ImGui.Key.O;
        case #char"P"; return ImGui.Key.P;
        case #char"Q"; return ImGui.Key.Q;
        case #char"R"; return ImGui.Key.R;
        case #char"S"; return ImGui.Key.S;
        case #char"T"; return ImGui.Key.T;
        case #char"U"; return ImGui.Key.U;
        case #char"V"; return ImGui.Key.V;
        case #char"W"; return ImGui.Key.W;
        case #char"X"; return ImGui.Key.X;
        case #char"Y"; return ImGui.Key.Y;
        case #char"Z"; return ImGui.Key.Z;
        case .F1; return ImGui.Key.F1;
        case .F2; return ImGui.Key.F2;
        case .F3; return ImGui.Key.F3;
        case .F4; return ImGui.Key.F4;
        case .F5; return ImGui.Key.F5;
        case .F6; return ImGui.Key.F6;
        case .F7; return ImGui.Key.F7;
        case .F8; return ImGui.Key.F8;
        case .F9; return ImGui.Key.F9;
        case .F10; return ImGui.Key.F10;
        case .F11; return ImGui.Key.F11;
        case .F12; return ImGui.Key.F12;
        case; return ImGui.Key.None;
    }
}