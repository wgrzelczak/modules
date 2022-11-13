#scope_export

init :: (device : *ID3D12Device,
         num_frames_in_flight : int,
         rtv_format : DXGI_FORMAT,
         srv_desc_heap : *ID3D12DescriptorHeap,
         font_srv_cpu : D3D12_CPU_DESCRIPTOR_HANDLE,
         font_srv_gpu : D3D12_GPU_DESCRIPTOR_HANDLE) -> bool {
    
    io := ImGui.GetIO();

    assert(io.BackendRendererUserData == null, "ImGui already initialized!");

    data := New(Backend_Data);
    io.BackendRendererUserData = cast(*void)data;
    io.BackendRendererName     = "imgui_impl_dx12.jai";
    io.BackendFlags_          |= .RendererHasVtxOffset;  // We can honor the ImDrawCmd::VtxOffset field, allowing for large meshes.

    data.d3d_device           = device;
    data.rtv_format           = rtv_format;
    data.font_cpu             = font_srv_cpu;
    data.font_gpu             = font_srv_gpu;
    data.render_buffers       = NewArray(num_frames_in_flight, Render_Buffers);
    data.num_frames_in_flight = cast(u32)num_frames_in_flight;
    data.frame_idx            = U32_MAX;
    //IM_UNUSED(cbv_srv_heap); // Unused in master branch (will be used by multi-viewports)

    return true;
}
shutdown :: () {
    using data := get_backend_data();

    invalidate_device_objects();
    free(render_buffers.data);

    io := ImGui.GetIO();
    io.BackendRendererName = null;
    io.BackendRendererUserData = null;

    free(data);
}

new_frame :: () {
    using data := get_backend_data();
    if !d3d_pipeline create_device_objects();
}

render_draw_data :: (draw_data : *ImGui.ImDrawData, command_list : *ID3D12GraphicsCommandList) {
    // Avoid rendering when minimized
    if draw_data.DisplaySize.x <= 0.0 || draw_data.DisplaySize.y <= 0.0
        return;

    // FIXME: I'm assuming that this only gets called once per frame!
    // If not, we can't just re-allocate the IB or VB, we'll have to do a proper allocator.
    using data := get_backend_data();
    frame_idx += 1;
    buffers := *render_buffers[frame_idx % num_frames_in_flight];

    // Create and grow vertex/index buffers if needed
    if !buffers.vertex_buffer || buffers.vertex_buffer_count < draw_data.TotalVtxCount {
        safe_release(buffers.vertex_buffer);
        buffers.vertex_buffer_count = draw_data.TotalVtxCount + 5000;

        props : D3D12_HEAP_PROPERTIES = .{
            Type                 = .UPLOAD,
            CPUPageProperty      = .UNKNOWN,
            MemoryPoolPreference = .UNKNOWN,
        };
        desc : D3D12_RESOURCE_DESC = .{
            Dimension        = .BUFFER,
            Height           = 1,
            DepthOrArraySize = 1,
            MipLevels        = 1,
            Format           = .UNKNOWN,
            SampleDesc       = .{Count = 1},
            Layout           = .ROW_MAJOR,
            Flags            = .NONE,
        };
        desc.Width = cast(u32)buffers.vertex_buffer_count * size_of(ImGui.ImDrawVert);
        check_hr(vtable(d3d_device).CreateCommittedResource(d3d_device, *props, .NONE, *desc, .GENERIC_READ, null, *uid(ID3D12Resource_UUID), xx *buffers.vertex_buffer));
    }

    if !buffers.index_buffer || buffers.index_buffer_size < draw_data.TotalIdxCount {
        safe_release(buffers.index_buffer);
        buffers.index_buffer_size = draw_data.TotalIdxCount + 10000;

        props : D3D12_HEAP_PROPERTIES = .{
            Type                 = .UPLOAD,
            CPUPageProperty      = .UNKNOWN,
            MemoryPoolPreference = .UNKNOWN,
        };
        desc : D3D12_RESOURCE_DESC = .{
            Dimension        = .BUFFER,
            Height           = 1,
            DepthOrArraySize = 1,
            MipLevels        = 1,
            Format           = .UNKNOWN,
            SampleDesc       = .{Count = 1},
            Layout           = .ROW_MAJOR,
            Flags            = .NONE,
        };
        desc.Width =  cast(u32)buffers.index_buffer_size * size_of(ImGui.ImDrawIdx);
        check_hr(vtable(d3d_device).CreateCommittedResource(d3d_device, *props, .NONE, *desc, .GENERIC_READ, null, *uid(ID3D12Resource_UUID), xx *buffers.index_buffer));
    }

    // Upload vertex/index data into a single contiguous GPU buffer
    {
        vb_dst : *ImGui.ImDrawVert;
        ib_dst : *ImGui.ImDrawIdx;

        range : D3D12_RANGE;
        check_hr(vtable(buffers.vertex_buffer).Map(buffers.vertex_buffer, 0, *range, xx *vb_dst));
        check_hr(vtable(buffers.index_buffer).Map(buffers.index_buffer, 0, *range, xx *ib_dst));

        for 0..draw_data.CmdListsCount-1 {
            cmd_list := draw_data.CmdLists[it];
            memcpy(vb_dst, cmd_list.VtxBuffer.Data, cmd_list.VtxBuffer.Size * size_of(ImGui.ImDrawVert));
            memcpy(ib_dst, cmd_list.IdxBuffer.Data, cmd_list.IdxBuffer.Size * size_of(ImGui.ImDrawIdx));
            vb_dst += cmd_list.VtxBuffer.Size;
            ib_dst += cmd_list.IdxBuffer.Size;
        }

        vtable(buffers.vertex_buffer).Unmap(buffers.vertex_buffer, 0, *range);
        vtable(buffers.index_buffer).Unmap(buffers.index_buffer, 0, *range);
    }

    setup_render_state(draw_data, command_list, buffers);

    // Render command lists
    // (Because we merged all buffers into a single one, we maintain our own offset into them)
    vertex_offset : s32 = 0;
    index_offset  : u32 = 0;
    clip_off      := draw_data.DisplayPos;

    for 0..draw_data.CmdListsCount-1 {
        cmd_list := draw_data.CmdLists[it];
        for cmd_i : 0..cmd_list.CmdBuffer.Size-1 {
            draw_cmd := cmd_list.CmdBuffer.Data[cmd_i];

            if draw_cmd.UserCallback {
                //TODO();
                // User callback, registered via ImDrawList::AddCallback()
                // (ImDrawCallback_ResetRenderState is a special callback value used by the user to request the renderer to reset render state.)
                //if (pcmd->UserCallback == ImDrawCallback_ResetRenderState)
                    setup_render_state(draw_data, command_list, buffers);
                //else
                //    pcmd->UserCallback(cmd_list, pcmd);
            } else {
                // Project scissor/clipping rectangles into framebuffer space
                clip_min : Vector2;
                clip_min.x = draw_cmd.ClipRect.x - clip_off.x;
                clip_min.y = draw_cmd.ClipRect.y - clip_off.y;

                clip_max : Vector2;
                clip_max.x = draw_cmd.ClipRect.z - clip_off.x;
                clip_max.y = draw_cmd.ClipRect.w - clip_off.y;

                if clip_max.x <= clip_min.x || clip_max.y <= clip_min.y continue;

                // Apply Scissor/clipping rectangle, Bind texture, Draw
                rect : D3D12_RECT;
                rect.left   = cast(s32)clip_min.x;
                rect.top    = cast(s32)clip_min.y;
                rect.right  = cast(s32)clip_max.x;
                rect.bottom = cast(s32)clip_max.y;

                tex_handle : D3D12_GPU_DESCRIPTOR_HANDLE;
                tex_handle.ptr = cast(u64)draw_cmd.TextureId;
                vtable(command_list).SetGraphicsRootDescriptorTable(command_list, 1, tex_handle);
                vtable(command_list).RSSetScissorRects(command_list,1, *rect);
                vtable(command_list).DrawIndexedInstanced(command_list, draw_cmd.ElemCount, 1, cast(u32)draw_cmd.IdxOffset + index_offset, (cast(s32)draw_cmd.VtxOffset) + vertex_offset, 0);
            }
        }
        vertex_offset += cmd_list.VtxBuffer.Size;
        index_offset  += cast(u32)cmd_list.IdxBuffer.Size;
    }
}

invalidate_device_objects :: () {
    using data := get_backend_data();
    if !data || !d3d_device return;

    safe_release_and_reset(*d3d_root);
    safe_release_and_reset(*d3d_pipeline);
    safe_release_and_reset(*font_resource);

    io := ImGui.GetIO();
    //TODO: Not exported??
    //io.Fonts.SetTexID();
    io.Fonts.TexID = null;

    for * render_buffers {
        safe_release_and_reset(*it.index_buffer);
        safe_release_and_reset(*it.vertex_buffer);
    }

}
create_device_objects :: () -> bool {
    using data := get_backend_data();
    if !data || !d3d_device return false;
    if d3d_pipeline invalidate_device_objects();

    // Create the root signature
    {
        desc_range : D3D12_DESCRIPTOR_RANGE : .{
            RangeType           = .SRV,
            NumDescriptors      = 1,
            BaseShaderRegister  = 0,
            RegisterSpace        = 0,
            OffsetInDescriptorsFromTableStart = 0,
        };

        param : [2] D3D12_ROOT_PARAMETER = .[ .{
                ParameterType       = ._32BIT_CONSTANTS,
                Constants           = .{
                    ShaderRegister      = 0,
                    RegisterSpace       = 0,
                    Num32BitValues      = 16,
                },
                ShaderVisibility    = .VERTEX,
            }, .{
                ParameterType       = .DESCRIPTOR_TABLE,
                DescriptorTable     = .{
                    NumDescriptorRanges = 1,
                    //pDescriptorRanges   = *desc_range,
                },
                ShaderVisibility    = .PIXEL,
            }];
        param[1].DescriptorTable.pDescriptorRanges = *desc_range;

        static_sampler : D3D12_STATIC_SAMPLER_DESC = .{
            Filter          = .MIN_MAG_MIP_LINEAR,
            AddressU        = .WRAP,
            AddressV        = .WRAP,
            AddressW        = .WRAP,
            MipLODBias      = 0.0,
            MaxAnisotropy   = 0,
            ComparisonFunc  = .ALWAYS,
            BorderColor     = .TRANSPARENT_BLACK,
            MinLOD = 0.0,
            MaxLOD = 0.0,
            ShaderRegister = 0,
            RegisterSpace = 0,
            ShaderVisibility = .PIXEL,
        };

        desc : D3D12_ROOT_SIGNATURE_DESC;
        desc.NumParameters = param.count;
        desc.pParameters = param.data;
        desc.NumStaticSamplers = 1;
        desc.pStaticSamplers = *static_sampler;
        desc.Flags =
            D3D12_ROOT_SIGNATURE_FLAGS.ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT |
            D3D12_ROOT_SIGNATURE_FLAGS.DENY_HULL_SHADER_ROOT_ACCESS |
            D3D12_ROOT_SIGNATURE_FLAGS.DENY_DOMAIN_SHADER_ROOT_ACCESS |
            D3D12_ROOT_SIGNATURE_FLAGS.DENY_GEOMETRY_SHADER_ROOT_ACCESS;

        //
        // Note: D3D12On7 has been removed from here (lodaing D3D12SerializeRootSignature)
        //
        blob : *ID3DBlob;
        if D3D12SerializeRootSignature(*desc, .D3D_ROOT_SIGNATURE_VERSION_1, *blob, null) != S_OK
            return false;

        vtable(d3d_device).CreateRootSignature(d3d_device, 0, vtable(blob).GetBufferPointer(blob), vtable(blob).GetBufferSize(blob), *uid(ID3D12RootSignature_UUID), xx *d3d_root);

        safe_release(blob);
    }

    pso_desc : D3D12_GRAPHICS_PIPELINE_STATE_DESC = .{
        NodeMask = 1,
        PrimitiveTopologyType = .TRIANGLE,
        SampleMask = U32_MAX,
        Flags = .NONE,
        SampleDesc = .{Count = 1},
    };

    pso_desc.NumRenderTargets = 1;
    pso_desc.RTVFormats[0] = rtv_format;
    pso_desc.pRootSignature = d3d_root;

    vs_blob : *ID3DBlob;
    ps_blob : *ID3DBlob;

    // Create the vertex shader
    {
        vs_text :: #string _DONE
            cbuffer vertexBuffer : register(b0) 
            {
              float4x4 ProjectionMatrix; 
            };
            struct VS_INPUT
            {
              float2 pos : POSITION;
              float4 col : COLOR0;
              float2 uv  : TEXCOORD0;
            };
            
            struct PS_INPUT
            {
              float4 pos : SV_POSITION;
              float4 col : COLOR0;
              float2 uv  : TEXCOORD0;
            };
            
            PS_INPUT main(VS_INPUT input)
            {
              PS_INPUT output;
              output.pos = mul( ProjectionMatrix, float4(input.pos.xy, 0.f, 1.f));
              output.col = input.col;
              output.uv  = input.uv;
              return output;
            };
        _DONE;

        ps_text :: #string _DONE
            struct PS_INPUT
            {
              float4 pos : SV_POSITION;
              float4 col : COLOR0;
              float2 uv  : TEXCOORD0;
            };
            SamplerState sampler0 : register(s0);
            Texture2D texture0 : register(t0);
            
            float4 main(PS_INPUT input) : SV_Target
            {
              float4 out_col = input.col * texture0.Sample(sampler0, input.uv);
              return out_col;
            }
        _DONE;


        layout :: D3D12_INPUT_ELEMENT_DESC.[
            .{ "POSITION", 0, .R32G32_FLOAT,   0, D3D12_APPEND_ALIGNED_ELEMENT, .PER_VERTEX_DATA, 0 },
            .{ "TEXCOORD", 0, .R32G32_FLOAT,   0, D3D12_APPEND_ALIGNED_ELEMENT, .PER_VERTEX_DATA, 0 },
            .{ "COLOR",    0, .R8G8B8A8_UNORM, 0, D3D12_APPEND_ALIGNED_ELEMENT, .PER_VERTEX_DATA, 0 },
        ];
        pso_desc.InputLayout.pInputElementDescs = layout.data;
        pso_desc.InputLayout.NumElements        = layout.count;

        bytecode, err, hr := D3dcompiler.D3DCompile(vs_text, "imgui.internal", .[], null, "main", "vs_5_0", 0, 0);
        check_hr(hr);
        pso_desc.VS.pShaderBytecode = bytecode.data;
        pso_desc.VS.BytecodeLength  = cast(u64)bytecode.count;

        bytecode, err, hr = D3dcompiler.D3DCompile(ps_text, "imgui.internal", .[], null, "main", "ps_5_0", 0, 0);
        pso_desc.PS.pShaderBytecode = bytecode.data;
        pso_desc.PS.BytecodeLength  = cast(u64)bytecode.count;
    }

    pso_desc.BlendState = .{
        AlphaToCoverageEnable = .FALSE,
        RenderTarget[0] = .{
            BlendEnable = .TRUE,
            SrcBlend = .SRC_ALPHA,
            DestBlend = .INV_SRC_ALPHA,
            BlendOp = .ADD,
            SrcBlendAlpha = .ONE,
            DestBlendAlpha = .INV_SRC_ALPHA,
            BlendOpAlpha = .ADD,
            RenderTargetWriteMask = cast(u8)D3D12_COLOR_WRITE_ENABLE.ALL,
        },
    };

    pso_desc.RasterizerState = .{
        FillMode = .SOLID,
        CullMode = .NONE,
        FrontCounterClockwise = .FALSE,
        DepthBias = D3D12_DEFAULT_DEPTH_BIAS,
        DepthBiasClamp = D3D12_DEFAULT_DEPTH_BIAS_CLAMP,
        SlopeScaledDepthBias = D3D12_DEFAULT_SLOPE_SCALED_DEPTH_BIAS,
        DepthClipEnable = .TRUE,
        MultisampleEnable = .FALSE,
        AntialiasedLineEnable = .FALSE,
        ForcedSampleCount = 0,
        ConservativeRaster = .OFF,
    };

    pso_desc.DepthStencilState = .{
        DepthEnable     = .FALSE,
        DepthWriteMask  = .ALL,
        DepthFunc       = .ALWAYS,
        StencilEnable   = .FALSE,
        FrontFace       = .{ 
            StencilFailOp       = .KEEP,
            StencilPassOp       = .KEEP,
            StencilDepthFailOp  = .KEEP,
            StencilFunc         = .ALWAYS,
        },
        BackFace        = .{ 
            StencilFailOp       = .KEEP,
            StencilPassOp       = .KEEP,
            StencilDepthFailOp  = .KEEP,
            StencilFunc         = .ALWAYS,
        }
    };

    check_hr(vtable(d3d_device).CreateGraphicsPipelineState(d3d_device, *pso_desc, *uid(ID3D12PipelineState_UUID), xx *d3d_pipeline));
    safe_release(vs_blob);
    safe_release(ps_blob);

    create_fonts_texture();

    return true;
}

#scope_file

Render_Buffers :: struct {
    index_buffer       : *ID3D12Resource;
    vertex_buffer      : *ID3D12Resource;
    index_buffer_size  : int = 10000;
    vertex_buffer_count : int = 5000;
}

Backend_Data :: struct {
    d3d_device :*ID3D12Device;
    d3d_root : *ID3D12RootSignature;
    d3d_pipeline : *ID3D12PipelineState;
    rtv_format : DXGI_FORMAT = .UNKNOWN;

    font_resource : *ID3D12Resource;
    font_cpu : D3D12_CPU_DESCRIPTOR_HANDLE;
    font_gpu : D3D12_GPU_DESCRIPTOR_HANDLE;

    num_frames_in_flight : u32;
    frame_idx            : u32 = U32_MAX;
    render_buffers       : [] Render_Buffers;

    //srv_heap : *ID3D12DescriptorHeap;
}

Constant_Buffer :: struct {
    mvp : [4][4] float;
};

get_backend_data :: () -> *Backend_Data {
    if ImGui.GetCurrentContext() {
        return cast(*Backend_Data)ImGui.GetIO().BackendRendererUserData;
    }
    return null;
}

setup_render_state :: (draw_data : *ImGui.ImDrawData, ctx : *ID3D12GraphicsCommandList, buffers : *Render_Buffers) {
    using data := get_backend_data();

    cb : Constant_Buffer;
    {
        L : float = draw_data.DisplayPos.x;
        R : float = draw_data.DisplayPos.x + draw_data.DisplaySize.x;
        T : float = draw_data.DisplayPos.y;
        B : float = draw_data.DisplayPos.y + draw_data.DisplaySize.y;

        // TODO: clean
        // cb.mvp[0] = .[ 2.0/(R-L),    0.0,           0.0,       0.0];
        // cb.mvp[1] = .[ 0.0,          2.0/(T-B),     0.0,       0.0];
        // cb.mvp[2] = .[ 0.0,          0.0,           0.5,       0.0];
        // cb.mvp[3] = .[ (R+L)/(L-R),  (T+B)/(B-T),   0.5,       1.0];

        cb.mvp[0][0] = 2.0/(R-L);
        cb.mvp[0][1] = 0.0;
        cb.mvp[0][2] = 0.0;
        cb.mvp[0][3] = 0.0;

        cb.mvp[1][0] = 0.0;
        cb.mvp[1][1] = 2.0/(T-B);
        cb.mvp[1][2] = 0.0;
        cb.mvp[1][3] = 0.0;

        cb.mvp[2][0] = 0.0;
        cb.mvp[2][1] = 0.0;
        cb.mvp[2][2] = 0.5;
        cb.mvp[2][3] = 0.0;

        cb.mvp[3][0] = (R+L)/(L-R);
        cb.mvp[3][1] = (T+B)/(B-T);
        cb.mvp[3][2] = 0.5;
        cb.mvp[3][3] = 1.0;
    }

    vp : D3D12_VIEWPORT;
    vp.Width    = draw_data.DisplaySize.x;
    vp.Height   = draw_data.DisplaySize.y;
    vp.MinDepth = 0.0;
    vp.MaxDepth = 1.0;
    vp.TopLeftX = 0.0;
    vp.TopLeftY = 0.0;
    vtable(ctx).RSSetViewports(ctx, 1, *vp);

    
    vb : D3D12_VERTEX_BUFFER_VIEW;
    stride :: size_of(ImGui.ImDrawVert);
    offset :: 0;
    vb_gpu := vtable(buffers.vertex_buffer).GetGPUVirtualAddress(buffers.vertex_buffer);
    vb.BufferLocation = vb_gpu + offset;
    vb.SizeInBytes    = cast(u32) buffers.vertex_buffer_count * stride;
    vb.StrideInBytes  = stride;
    vtable(ctx).IASetVertexBuffers(ctx, 0, 1, *vb);

    ib : D3D12_INDEX_BUFFER_VIEW;
    ib_gpu := vtable(buffers.index_buffer).GetGPUVirtualAddress(buffers.index_buffer);
    ib.BufferLocation = ib_gpu;
    ib.SizeInBytes    = cast(u32) buffers.index_buffer_size * size_of(ImGui.ImDrawIdx);
    ib.Format         = ifx size_of(ImGui.ImDrawIdx) == 2 then DXGI_FORMAT.R16_UINT else .R32_UINT;
    vtable(ctx).IASetIndexBuffer(ctx, *ib);

    vtable(ctx).IASetPrimitiveTopology(ctx, .TRIANGLELIST);
    vtable(ctx).SetPipelineState(ctx, d3d_pipeline);
    vtable(ctx).SetGraphicsRootSignature(ctx, d3d_root);
    vtable(ctx).SetGraphicsRoot32BitConstants(ctx, 0, size_of(Constant_Buffer) / 4, *cb, 0);

    blend_factor : [4] float;
    vtable(ctx).OMSetBlendFactor(ctx, *blend_factor);
}

create_fonts_texture :: () {
    // Build texture atlas
    io := ImGui.GetIO();
    using data := get_backend_data();
    tex_data   : *u8;
    tex_width  : u32;
    tex_height : u32;
    io.Fonts.GetTexDataAsRGBA32(io.Fonts, *tex_data, cast(*s32)*tex_width, cast(*s32)*tex_height);

    // Upload texture to graphics system
    {
        props : D3D12_HEAP_PROPERTIES = .{
            Type = .DEFAULT,
            CPUPageProperty = .UNKNOWN,
            MemoryPoolPreference = .UNKNOWN,
        };

        desc : D3D12_RESOURCE_DESC = .{
            Dimension        = .TEXTURE2D,
            Alignment        = 0,
            DepthOrArraySize = 1,
            MipLevels        = 1,
            Format           = .R8G8B8A8_UNORM,
            SampleDesc       = .{ Count = 1 },
            Layout           = .UNKNOWN,
            Flags            = .NONE,
        };
        desc.Width = cast(u64)tex_width;
        desc.Height =  cast(u32)tex_height;       
        
        tex_resource : *ID3D12Resource;
        check_hr(vtable(d3d_device).CreateCommittedResource(d3d_device, *props, .NONE, *desc, .COPY_DEST, null, *uid(ID3D12Resource_UUID), xx *tex_resource));


        upload_pitch : u32 = cast(u32) (tex_width * 4 + D3D12_TEXTURE_DATA_PITCH_ALIGNMENT - 1) & ~(D3D12_TEXTURE_DATA_PITCH_ALIGNMENT - 1);
        upload_size  : u32 = cast(u32) tex_height * upload_pitch;
        upload_desc : D3D12_RESOURCE_DESC = .{
            Dimension        = .BUFFER,
            Alignment        = 0,
            Height           = 1,
            DepthOrArraySize = 1,
            MipLevels        = 1,
            Format           = .UNKNOWN,
            SampleDesc       = .{ Count = 1 },
            Layout           = .ROW_MAJOR,
            Flags            = .NONE,
        };
        upload_desc.Width = upload_size;

        upload_props : D3D12_HEAP_PROPERTIES = .{
            Type = .UPLOAD,
            CPUPageProperty = .UNKNOWN,
            MemoryPoolPreference = .UNKNOWN,
        };

        upload_buffer : *ID3D12Resource;
        check_hr(vtable(d3d_device).CreateCommittedResource(d3d_device, *upload_props, .NONE, *upload_desc, .GENERIC_READ, null, *uid(ID3D12Resource_UUID), xx *upload_buffer));

        address : *u8;
        range : D3D12_RANGE;
        range.Begin = 0;
        range.End   = upload_size;

        check_hr(vtable(upload_buffer).Map(upload_buffer, 0, *range, xx *address));
        {
            for y : 0..tex_height-1 {
                src := tex_data + y * tex_width * 4;
                dst := address + cast(u32)y * upload_pitch;
                memcpy(dst, src, tex_width * 4);
            }
        }
        vtable(upload_buffer).Unmap(upload_buffer, 0, *range);

        src_loc : D3D12_TEXTURE_COPY_LOCATION;
        src_loc.pResource = upload_buffer;
        src_loc.Type = .PLACED_FOOTPRINT;
        src_loc.PlacedFootprint.Footprint.Format = .R8G8B8A8_UNORM;
        src_loc.PlacedFootprint.Footprint.Width = tex_width;
        src_loc.PlacedFootprint.Footprint.Height = tex_height;
        src_loc.PlacedFootprint.Footprint.Depth = 1;
        src_loc.PlacedFootprint.Footprint.RowPitch = upload_pitch;

        dst_loc : D3D12_TEXTURE_COPY_LOCATION;
        dst_loc.pResource = tex_resource;
        dst_loc.Type = .SUBRESOURCE_INDEX;
        dst_loc.SubresourceIndex = 0;

        barrier : D3D12_RESOURCE_BARRIER;
        barrier.Type = .TRANSITION;
        barrier.Flags = .NONE;
        barrier.Transition.pResource   = tex_resource;
        barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
        barrier.Transition.StateBefore = .COPY_DEST;
        barrier.Transition.StateAfter  = .PIXEL_SHADER_RESOURCE;

        fence : *ID3D12Fence;
        check_hr(vtable(d3d_device).CreateFence(d3d_device, 0, .NONE, *uid(ID3D12Fence_UUID), xx *fence));

        event := CreateEventW(null, 0, 0, null);
        assert(event != null);

        queue_desc : D3D12_COMMAND_QUEUE_DESC = .{
            Type     = .DIRECT,
            Flags    = .NONE,
            NodeMask = 1,
        };

        cmd_queue : *ID3D12CommandQueue;
        cmd_alloc : *ID3D12CommandAllocator;
        cmd_list  : *ID3D12GraphicsCommandList;
        check_hr(vtable(d3d_device).CreateCommandQueue(d3d_device, *queue_desc, *uid(ID3D12CommandQueue_UUID), xx *cmd_queue));
        check_hr(vtable(d3d_device).CreateCommandAllocator(d3d_device, .DIRECT, *uid(ID3D12CommandAllocator_UUID), xx *cmd_alloc));
        check_hr(vtable(d3d_device).CreateCommandList(d3d_device, 0, .DIRECT, cmd_alloc, null, *uid(ID3D12CommandList_UUID), xx *cmd_list));

        vtable(cmd_list).CopyTextureRegion(cmd_list, *dst_loc, 0, 0, 0, *src_loc, null);
        vtable(cmd_list).ResourceBarrier(cmd_list, 1, *barrier);

        check_hr(vtable(cmd_list).Close(cmd_list));

        vtable(cmd_queue).ExecuteCommandLists(cmd_queue, 1, xx *cmd_list);
        check_hr(vtable(cmd_queue).Signal(cmd_queue, fence, 1));
        
        vtable(fence).SetEventOnCompletion(fence, 1, event);
        WaitForSingleObject(event, INFINITE);

        safe_release(cmd_list);
        safe_release(cmd_alloc);
        safe_release(cmd_queue);
        CloseHandle(event);
        safe_release(fence);
        safe_release(upload_buffer);

        srv_desc : D3D12_SHADER_RESOURCE_VIEW_DESC;
        srv_desc.Format = .R8G8B8A8_UNORM;
        srv_desc.ViewDimension = .TEXTURE2D;
        srv_desc.Texture2D.MipLevels = desc.MipLevels;
        srv_desc.Texture2D.MostDetailedMip = 0;
        srv_desc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
        //srv_desc.Shader4ComponentMapping = 5768;
        vtable(d3d_device).CreateShaderResourceView(d3d_device, tex_resource, *srv_desc, font_cpu);
        safe_release(font_resource);
        font_resource = tex_resource;
    }

    io.Fonts.TexID = cast(*void)font_gpu.ptr;
}
#import "Basic";
#import "D3D12";
ImGui :: #import "ImGui";
#import "Math";
#import "Windows";
D3dcompiler :: #import "d3d_compiler"; //TODO: change to DXC