UpdateSubresources :: (cmd_list          : *ID3D12GraphicsCommandList,
                       dst_res           : *ID3D12Resource,
                       int_res           : *ID3D12Resource,
                       first_subresource : u32,
                       num_subresources  : u32,
                       required_size     : u64,
                       layouts           : *D3D12_PLACED_SUBRESOURCE_FOOTPRINT,
                       num_rows          : *u32,
                       row_size_in_bytes : *u64,
                       src_datas         : *D3D12_SUBRESOURCE_DATA) -> u64 {
    // Minor validation
    int_desc := vtable(int_res).GetDesc(int_res);
    dst_desc := vtable(dst_res).GetDesc(dst_res);

    if int_desc.Dimension != .BUFFER ||
       int_desc.Width < required_size + layouts[0].Offset ||
       //required_size > U64_MAX ||
       (dst_desc.Dimension == .BUFFER && (first_subresource != 0 || num_subresources != 1)) {
        return 0;
    }
    
    int_data : *u8;

    hr := vtable(int_res).Map(int_res, 0, null, cast(**void)*int_data);
    defer vtable(int_res).Unmap(int_res, 0, null);
    if FAILED(hr) {
        return 0;
    }
    
    for 0..num_subresources-1 {
        //if row_size_in_bytes[it] > cast(SIZE_T)-1 return 0;
        
        dst_data        := int_data + layouts[it].Offset;
        dst_row_pitch   := layouts[it].Footprint.RowPitch;
        dst_slice_pitch := layouts[it].Footprint.RowPitch * num_rows[it];
            
        for z : 0..layouts[it].Footprint.Depth-1 {
            dst_slice :=  dst_data + dst_slice_pitch * z;
            src_slice := src_datas[it].pData + src_datas[it].SlicePitch * z;
            for y : 0..num_rows[it]-1 {
                memcpy(dst_slice + dst_row_pitch * y,
                       src_slice + src_datas[it].RowPitch * y,
                       cast(s64)row_size_in_bytes[it]);
            }
        }
    }
    
    
    if dst_desc.Dimension == .BUFFER {
        vtable(cmd_list).CopyBufferRegion(cmd_list, dst_res, 0, int_res, layouts[0].Offset, layouts[0].Footprint.Width);
    } else {
        for 0..num_subresources-1 {
            dst : D3D12_TEXTURE_COPY_LOCATION;
            dst.pResource        = dst_res;
            dst.Type             = .SUBRESOURCE_INDEX;
            dst.SubresourceIndex = it + first_subresource;
            src : D3D12_TEXTURE_COPY_LOCATION;
            src.pResource        = int_res;
            src.Type             = .PLACED_FOOTPRINT;
            src.PlacedFootprint = layouts[it];
            
            vtable(cmd_list).CopyTextureRegion(cmd_list, *dst, 0, 0, 0, *src, null);
        }
    }
    return required_size;
}

// Heap-allocating UpdateSubresources implementation
UpdateSubresources :: (cmd_list          : *ID3D12GraphicsCommandList,
                       dst_res           : *ID3D12Resource,
                       int_res           : *ID3D12Resource,
                       int_offset        : u64,
                       first_subresource : u32,
                       num_subresources  : u32,
                       subresources      : *D3D12_SUBRESOURCE_DATA) -> u64 {
    required_size : u64 = 0;
    payload_size := (size_of(D3D12_PLACED_SUBRESOURCE_FOOTPRINT) + size_of(u32) + size_of(u64)) * num_subresources;
    payload_data := alloc(payload_size);
    defer free(payload_data);
    
    if !payload_data return 0;
    
    p_layouts := cast(*D3D12_PLACED_SUBRESOURCE_FOOTPRINT)payload_data;
    p_row_sizes_in_bytes := cast(*u64)(p_layouts + num_subresources);
    p_num_rows           := cast(*u32)(p_row_sizes_in_bytes + num_subresources);
    
    desc := vtable(dst_res).GetDesc(dst_res);
    
    device : *ID3D12Device;
    vtable(dst_res).GetDevice(dst_res, *uid(ID3D12Device_UUID), cast(**void)*device);
    vtable(device).GetCopyableFootprints(device, *desc, first_subresource, num_subresources, int_offset, p_layouts,p_num_rows, p_row_sizes_in_bytes, *required_size);
    safe_release(device);
    
    result := UpdateSubresources(cmd_list, dst_res, int_res, first_subresource, num_subresources, required_size, p_layouts, p_num_rows, p_row_sizes_in_bytes, subresources);
    
    return result;
}
    

#scope_file
#import "Basic";
#import "Windows";