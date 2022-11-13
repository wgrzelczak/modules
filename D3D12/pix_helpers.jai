pix_gpu_capture_next_frames :: (file_name : string, frames_count : s32) -> HRESULT {
    return pix_gpu_capture_next_frames(utf8_to_wide(file_name), frames_count);
}
pix_begin_event :: (str: string, color: u64 = 0) {
    pix_begin_event(color, utf8_to_wide(str));
}
pix_begin_event :: (cmd_list: *ID3D12GraphicsCommandList, str: string, color: u64 = 0) {
    pix_begin_event(cmd_list, color, utf8_to_wide(str));
}
pix_set_marker :: (str: string, color: u64 = 0) {
    pix_begin_event(color, utf8_to_wide(str));
}
pix_set_marker :: (cmd_list: *ID3D12GraphicsCommandList, str: string, color: u64 = 0) {
    pix_begin_event(cmd_list, color, utf8_to_wide(str));
}