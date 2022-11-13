//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



D3D_RETURN_PARAMETER_INDEX :: -1;

D3D_SHADER_REQUIRES_DOUBLES :: 0x00000001;
D3D_SHADER_REQUIRES_EARLY_DEPTH_STENCIL :: 0x00000002;
D3D_SHADER_REQUIRES_UAVS_AT_EVERY_STAGE :: 0x00000004;
D3D_SHADER_REQUIRES_64_UAVS :: 0x00000008;
D3D_SHADER_REQUIRES_MINIMUM_PRECISION :: 0x00000010;
D3D_SHADER_REQUIRES_11_1_DOUBLE_EXTENSIONS :: 0x00000020;
D3D_SHADER_REQUIRES_11_1_SHADER_EXTENSIONS :: 0x00000040;
D3D_SHADER_REQUIRES_LEVEL_9_COMPARISON_FILTERING :: 0x00000080;
D3D_SHADER_REQUIRES_TILED_RESOURCES :: 0x00000100;
D3D_SHADER_REQUIRES_STENCIL_REF :: 0x00000200;
D3D_SHADER_REQUIRES_INNER_COVERAGE :: 0x00000400;
D3D_SHADER_REQUIRES_TYPED_UAV_LOAD_ADDITIONAL_FORMATS :: 0x00000800;
D3D_SHADER_REQUIRES_ROVS :: 0x00001000;
D3D_SHADER_REQUIRES_VIEWPORT_AND_RT_ARRAY_INDEX_FROM_ANY_SHADER_FEEDING_RASTERIZER :: 0x00002000;
D3D_SHADER_REQUIRES_WAVE_OPS :: 0x00004000;
D3D_SHADER_REQUIRES_INT64_OPS :: 0x00008000;
D3D_SHADER_REQUIRES_VIEW_ID :: 0x00010000;
D3D_SHADER_REQUIRES_BARYCENTRICS :: 0x00020000;
D3D_SHADER_REQUIRES_NATIVE_16BIT_OPS :: 0x00040000;
D3D_SHADER_REQUIRES_SHADING_RATE :: 0x00080000;
D3D_SHADER_REQUIRES_RAYTRACING_TIER_1_1 :: 0x00100000;
D3D_SHADER_REQUIRES_SAMPLER_FEEDBACK :: 0x00200000;
D3D_SHADER_REQUIRES_ATOMIC_INT64_ON_TYPED_RESOURCE :: 0x00400000;
D3D_SHADER_REQUIRES_ATOMIC_INT64_ON_GROUP_SHARED :: 0x00800000;
D3D_SHADER_REQUIRES_DERIVATIVES_IN_MESH_AND_AMPLIFICATION_SHADERS :: 0x01000000;
D3D_SHADER_REQUIRES_RESOURCE_DESCRIPTOR_HEAP_INDEXING :: 0x02000000;
D3D_SHADER_REQUIRES_SAMPLER_DESCRIPTOR_HEAP_INDEXING :: 0x04000000;
D3D_SHADER_REQUIRES_WAVE_MMA :: 0x08000000;
D3D_SHADER_REQUIRES_ATOMIC_INT64_ON_DESCRIPTOR_HEAP_RESOURCE :: 0x10000000;

DXC_CP_UTF8 :: 65001;
DXC_CP_UTF16 :: 1200;

DXC_CP_ACP :: 0;

DXC_HASHFLAG_INCLUDES_SOURCE :: 1;

IMalloc :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; imalloc_vtable: *IMalloc_VTable;
}
IMalloc_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Alloc: (this: *IMalloc, cb: SIZE_T) -> *void #cpp_method;
    Realloc: (this: *IMalloc, pv: *void, cb: SIZE_T) -> *void #cpp_method;
    Free: (this: *IMalloc, pv: *void) -> void #cpp_method;
    GetSize: (this: *IMalloc, pv: *void) -> SIZE_T #cpp_method;
    DidAlloc: (this: *IMalloc, pv: *void) -> s32 #cpp_method;
    HeapMinimize: (this: *IMalloc) -> void #cpp_method;
}
vtable :: (obj: *IMalloc) -> *IMalloc_VTable { return obj.imalloc_vtable; }


ISequentialStream :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; isequentialstream_vtable: *ISequentialStream_VTable;
}
ISequentialStream_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Read: (this: *ISequentialStream, pv: *void, cb: u32, pcbRead: *u32) -> HRESULT #cpp_method;
    Write: (this: *ISequentialStream, pv: *void, cb: u32, pcbWritten: *u32) -> HRESULT #cpp_method;
}
vtable :: (obj: *ISequentialStream) -> *ISequentialStream_VTable { return obj.isequentialstream_vtable; }


tagSTATSTG :: struct {
    pwcsName:          LPOLESTR;
    type:              u32;
    cbSize:            ULARGE_INTEGER;
    mtime:             FILETIME;
    ctime:             FILETIME;
    atime:             FILETIME;
    grfMode:           u32;
    grfLocksSupported: u32;
    clsid:             CLSID;
    grfStateBits:      u32;
    reserved:          u32;
}

STATSTG :: tagSTATSTG;

IStream :: struct {
    #as using isequentialstream: ISequentialStream;
    #place isequentialstream; istream_vtable: *IStream_VTable;
}
IStream_VTable :: struct #type_info_none {
    using isequentialstream: ISequentialStream_VTable;
    Seek: (this: *IStream, dlibMove: LARGE_INTEGER, dwOrigin: u32, plibNewPosition: *ULARGE_INTEGER) -> HRESULT #cpp_method;
    SetSize: (this: *IStream, libNewSize: ULARGE_INTEGER) -> HRESULT #cpp_method;
    CopyTo: (this: *IStream, pstm: *IStream, cb: ULARGE_INTEGER, pcbRead: *ULARGE_INTEGER, pcbWritten: *ULARGE_INTEGER) -> HRESULT #cpp_method;
    Commit: (this: *IStream, grfCommitFlags: u32) -> HRESULT #cpp_method;
    Revert: (this: *IStream) -> HRESULT #cpp_method;
    LockRegion: (this: *IStream, libOffset: ULARGE_INTEGER, cb: ULARGE_INTEGER, dwLockType: u32) -> HRESULT #cpp_method;
    UnlockRegion: (this: *IStream, libOffset: ULARGE_INTEGER, cb: ULARGE_INTEGER, dwLockType: u32) -> HRESULT #cpp_method;
    Stat: (this: *IStream, pstatstg: *STATSTG, grfStatFlag: u32) -> HRESULT #cpp_method;
    Clone: (this: *IStream, ppstm: **IStream) -> HRESULT #cpp_method;
}
vtable :: (obj: *IStream) -> *IStream_VTable { return obj.istream_vtable; }


D3D12_SHADER_VERSION_TYPE :: enum s32 {
    PIXEL_SHADER          :: 0;
    VERTEX_SHADER         :: 1;
    GEOMETRY_SHADER       :: 2;

    HULL_SHADER           :: 3;
    DOMAIN_SHADER         :: 4;
    COMPUTE_SHADER        :: 5;

    LIBRARY               :: 6;

    RAY_GENERATION_SHADER :: 7;
    INTERSECTION_SHADER   :: 8;
    ANY_HIT_SHADER        :: 9;
    CLOSEST_HIT_SHADER    :: 10;
    MISS_SHADER           :: 11;
    CALLABLE_SHADER       :: 12;

    MESH_SHADER           :: 13;
    AMPLIFICATION_SHADER  :: 14;

    RESERVED0             :: 65520;

    D3D12_SHVER_PIXEL_SHADER          :: PIXEL_SHADER;
    D3D12_SHVER_VERTEX_SHADER         :: VERTEX_SHADER;
    D3D12_SHVER_GEOMETRY_SHADER       :: GEOMETRY_SHADER;

    D3D12_SHVER_HULL_SHADER           :: HULL_SHADER;
    D3D12_SHVER_DOMAIN_SHADER         :: DOMAIN_SHADER;
    D3D12_SHVER_COMPUTE_SHADER        :: COMPUTE_SHADER;

    D3D12_SHVER_LIBRARY               :: LIBRARY;

    D3D12_SHVER_RAY_GENERATION_SHADER :: RAY_GENERATION_SHADER;
    D3D12_SHVER_INTERSECTION_SHADER   :: INTERSECTION_SHADER;
    D3D12_SHVER_ANY_HIT_SHADER        :: ANY_HIT_SHADER;
    D3D12_SHVER_CLOSEST_HIT_SHADER    :: CLOSEST_HIT_SHADER;
    D3D12_SHVER_MISS_SHADER           :: MISS_SHADER;
    D3D12_SHVER_CALLABLE_SHADER       :: CALLABLE_SHADER;

    D3D12_SHVER_MESH_SHADER           :: MESH_SHADER;
    D3D12_SHVER_AMPLIFICATION_SHADER  :: AMPLIFICATION_SHADER;

    D3D12_SHVER_RESERVED0             :: RESERVED0;
}

D3D12_RESOURCE_RETURN_TYPE :: D3D_RESOURCE_RETURN_TYPE;

D3D12_CBUFFER_TYPE :: D3D_CBUFFER_TYPE;

D3D12_SIGNATURE_PARAMETER_DESC :: struct {
    SemanticName:    *u8; // Name of the semantic
    SemanticIndex:   u32; // Index of the semantic
    Register:        u32; // Number of member variables
    SystemValueType: D3D_NAME; // A predefined system value, or D3D_NAME_UNDEFINED if not applicable
    ComponentType:   D3D_REGISTER_COMPONENT_TYPE; // Scalar type (e.g. uint, float, etc.)
    // Mask to indicate which components of the register
    // are used (combination of D3D10_COMPONENT_MASK values)
    Mask:            u8;

    // Mask to indicate whether a given component is 
    // never written (if this is an output signature) or
    // always read (if this is an input signature).
    // (combination of D3D_MASK_* values)
    ReadWriteMask:   u8;

    Stream:          u32; // Stream index
    MinPrecision:    D3D_MIN_PRECISION; // Minimum desired interpolation precision
}

D3D12_SHADER_BUFFER_DESC :: struct {
    Name:      *u8; // Name of the constant buffer
    Type:      D3D_CBUFFER_TYPE; // Indicates type of buffer content
    Variables: u32; // Number of member variables
    Size:      u32; // Size of CB (in bytes)
    uFlags:    u32; // Buffer description flags
}

D3D12_SHADER_VARIABLE_DESC :: struct {
    Name:         *u8; // Name of the variable
    StartOffset:  u32; // Offset in constant buffer's backing store
    Size:         u32; // Size of variable (in bytes)
    uFlags:       u32; // Variable flags
    DefaultValue: *void; // Raw pointer to default value
    StartTexture: u32; // First texture index (or -1 if no textures used)
    TextureSize:  u32; // Number of texture slots possibly used.
    StartSampler: u32; // First sampler index (or -1 if no textures used)
    SamplerSize:  u32; // Number of sampler slots possibly used.
}

D3D12_SHADER_TYPE_DESC :: struct {
    Class:    D3D_SHADER_VARIABLE_CLASS; // Variable class (e.g. object, matrix, etc.)
    Type:     D3D_SHADER_VARIABLE_TYPE; // Variable type (e.g. float, sampler, etc.)
    Rows:     u32; // Number of rows (for matrices, 1 for other numeric, 0 if not applicable)
    Columns:  u32; // Number of columns (for vectors & matrices, 1 for other numeric, 0 if not applicable)
    Elements: u32; // Number of elements (0 if not an array)
    Members:  u32; // Number of members (0 if not a structure)
    Offset:   u32; // Offset from the start of structure (0 if not a structure member)
    Name:     *u8; // Name of type, can be NULL
}

D3D12_TESSELLATOR_DOMAIN :: D3D_TESSELLATOR_DOMAIN;

D3D12_TESSELLATOR_PARTITIONING :: D3D_TESSELLATOR_PARTITIONING;

D3D12_TESSELLATOR_OUTPUT_PRIMITIVE :: D3D_TESSELLATOR_OUTPUT_PRIMITIVE;

D3D12_SHADER_DESC :: struct {
    Version:                     u32; // Shader version
    Creator:                     *u8; // Creator string
    Flags:                       u32; // Shader compilation/parse flags

    ConstantBuffers:             u32; // Number of constant buffers
    BoundResources:              u32; // Number of bound resources
    InputParameters:             u32; // Number of parameters in the input signature
    OutputParameters:            u32; // Number of parameters in the output signature

    InstructionCount:            u32; // Number of emitted instructions
    TempRegisterCount:           u32; // Number of temporary registers used 
    TempArrayCount:              u32; // Number of temporary arrays used
    DefCount:                    u32; // Number of constant defines 
    DclCount:                    u32; // Number of declarations (input + output)
    TextureNormalInstructions:   u32; // Number of non-categorized texture instructions
    TextureLoadInstructions:     u32; // Number of texture load instructions
    TextureCompInstructions:     u32; // Number of texture comparison instructions
    TextureBiasInstructions:     u32; // Number of texture bias instructions
    TextureGradientInstructions: u32; // Number of texture gradient instructions
    FloatInstructionCount:       u32; // Number of floating point arithmetic instructions used
    IntInstructionCount:         u32; // Number of signed integer arithmetic instructions used
    UintInstructionCount:        u32; // Number of unsigned integer arithmetic instructions used
    StaticFlowControlCount:      u32; // Number of static flow control instructions used
    DynamicFlowControlCount:     u32; // Number of dynamic flow control instructions used
    MacroInstructionCount:       u32; // Number of macro instructions used
    ArrayInstructionCount:       u32; // Number of array instructions used
    CutInstructionCount:         u32; // Number of cut instructions used
    EmitInstructionCount:        u32; // Number of emit instructions used
    GSOutputTopology:            D3D_PRIMITIVE_TOPOLOGY; // Geometry shader output topology
    GSMaxOutputVertexCount:      u32; // Geometry shader maximum output vertex count
    InputPrimitive:              D3D_PRIMITIVE; // GS/HS input primitive
    PatchConstantParameters:     u32; // Number of parameters in the patch constant signature
    cGSInstanceCount:            u32; // Number of Geometry shader instances
    cControlPoints:              u32; // Number of control points in the HS->DS stage
    HSOutputPrimitive:           D3D_TESSELLATOR_OUTPUT_PRIMITIVE; // Primitive output by the tessellator
    HSPartitioning:              D3D_TESSELLATOR_PARTITIONING; // Partitioning mode of the tessellator
    TessellatorDomain:           D3D_TESSELLATOR_DOMAIN; // Domain of the tessellator (quad, tri, isoline)

    cBarrierInstructions:        u32; // Number of barrier instructions in a compute shader
    cInterlockedInstructions:    u32; // Number of interlocked instructions
    cTextureStoreInstructions:   u32; // Number of texture writes
}

D3D12_SHADER_INPUT_BIND_DESC :: struct {
    Name:       *u8; // Name of the resource
    Type:       D3D_SHADER_INPUT_TYPE; // Type of resource (e.g. texture, cbuffer, etc.)
    BindPoint:  u32; // Starting bind point
    BindCount:  u32; // Number of contiguous bind points (for arrays)

    uFlags:     u32; // Input binding flags
    ReturnType: D3D_RESOURCE_RETURN_TYPE; // Return type (if texture)
    Dimension:  D3D_SRV_DIMENSION; // Dimension (if texture)
    NumSamples: u32; // Number of samples (0 if not MS texture)
    Space:      u32; // Register space
    uID:        u32; // Range ID in the bytecode
}

D3D12_LIBRARY_DESC :: struct {
    Creator:       *u8; // The name of the originator of the library.
    Flags:         u32; // Compilation flags.
    FunctionCount: u32; // Number of functions exported from the library.
}

D3D12_FUNCTION_DESC :: struct {
    Version:                     u32; // Shader version
    Creator:                     *u8; // Creator string
    Flags:                       u32; // Shader compilation/parse flags

    ConstantBuffers:             u32; // Number of constant buffers
    BoundResources:              u32; // Number of bound resources

    InstructionCount:            u32; // Number of emitted instructions
    TempRegisterCount:           u32; // Number of temporary registers used 
    TempArrayCount:              u32; // Number of temporary arrays used
    DefCount:                    u32; // Number of constant defines 
    DclCount:                    u32; // Number of declarations (input + output)
    TextureNormalInstructions:   u32; // Number of non-categorized texture instructions
    TextureLoadInstructions:     u32; // Number of texture load instructions
    TextureCompInstructions:     u32; // Number of texture comparison instructions
    TextureBiasInstructions:     u32; // Number of texture bias instructions
    TextureGradientInstructions: u32; // Number of texture gradient instructions
    FloatInstructionCount:       u32; // Number of floating point arithmetic instructions used
    IntInstructionCount:         u32; // Number of signed integer arithmetic instructions used
    UintInstructionCount:        u32; // Number of unsigned integer arithmetic instructions used
    StaticFlowControlCount:      u32; // Number of static flow control instructions used
    DynamicFlowControlCount:     u32; // Number of dynamic flow control instructions used
    MacroInstructionCount:       u32; // Number of macro instructions used
    ArrayInstructionCount:       u32; // Number of array instructions used
    MovInstructionCount:         u32; // Number of mov instructions used
    MovcInstructionCount:        u32; // Number of movc instructions used
    ConversionInstructionCount:  u32; // Number of type conversion instructions used
    BitwiseInstructionCount:     u32; // Number of bitwise arithmetic instructions used
    MinFeatureLevel:             D3D_FEATURE_LEVEL; // Min target of the function byte code
    RequiredFeatureFlags:        u64; // Required feature flags

    Name:                        *u8; // Function name
    FunctionParameterCount:      s32; // Number of logical parameters in the function signature (not including return)
    HasReturn:                   BOOL; // TRUE, if function returns a value, false - it is a subroutine
    Has10Level9VertexShader:     BOOL; // TRUE, if there is a 10L9 VS blob
    Has10Level9PixelShader:      BOOL; // TRUE, if there is a 10L9 PS blob
}

D3D12_PARAMETER_DESC :: struct {
    Name:              *u8; // Parameter name.
    SemanticName:      *u8; // Parameter semantic name (+index).
    Type:              D3D_SHADER_VARIABLE_TYPE; // Element type.
    Class:             D3D_SHADER_VARIABLE_CLASS; // Scalar/Vector/Matrix.
    Rows:              u32; // Rows are for matrix parameters.
    Columns:           u32; // Components or Columns in matrix.
    InterpolationMode: D3D_INTERPOLATION_MODE; // Interpolation mode.
    Flags:             D3D_PARAMETER_FLAGS; // Parameter modifiers.

    FirstInRegister:   u32; // The first input register for this parameter.
    FirstInComponent:  u32; // The first input register component for this parameter.
    FirstOutRegister:  u32; // The first output register for this parameter.
    FirstOutComponent: u32; // The first output register component for this parameter.
}

// {E913C351-783D-48CA-A1D1-4F306284AD56}
ID3D12ShaderReflectionType :: struct {
    vtable: *ID3D12ShaderReflectionType_VTable;
}
ID3D12ShaderReflectionType_VTable :: struct #type_info_none {
    GetDesc: (this: *ID3D12ShaderReflectionType, pDesc: *D3D12_SHADER_TYPE_DESC) -> HRESULT #cpp_method;
    GetMemberTypeByIndex: (this: *ID3D12ShaderReflectionType, Index: u32) -> *ID3D12ShaderReflectionType #cpp_method;
    GetMemberTypeByName: (this: *ID3D12ShaderReflectionType, Name: *u8) -> *ID3D12ShaderReflectionType #cpp_method;
    GetMemberTypeName: (this: *ID3D12ShaderReflectionType, Index: u32) -> *u8 #cpp_method;
    IsEqual: (this: *ID3D12ShaderReflectionType, pType: *ID3D12ShaderReflectionType) -> HRESULT #cpp_method;
    GetSubType: (this: *ID3D12ShaderReflectionType) -> *ID3D12ShaderReflectionType #cpp_method;
    GetBaseClass: (this: *ID3D12ShaderReflectionType) -> *ID3D12ShaderReflectionType #cpp_method;
    GetNumInterfaces: (this: *ID3D12ShaderReflectionType) -> u32 #cpp_method;
    GetInterfaceByIndex: (this: *ID3D12ShaderReflectionType, uIndex: u32) -> *ID3D12ShaderReflectionType #cpp_method;
    IsOfType: (this: *ID3D12ShaderReflectionType, pType: *ID3D12ShaderReflectionType) -> HRESULT #cpp_method;
    ImplementsInterface: (this: *ID3D12ShaderReflectionType, pBase: *ID3D12ShaderReflectionType) -> HRESULT #cpp_method;
}
vtable :: (obj: *ID3D12ShaderReflectionType) -> *ID3D12ShaderReflectionType_VTable { return obj.vtable; }


// {8337A8A6-A216-444A-B2F4-314733A73AEA}
ID3D12ShaderReflectionVariable :: struct {
    vtable: *ID3D12ShaderReflectionVariable_VTable;
}
ID3D12ShaderReflectionVariable_VTable :: struct #type_info_none {
    GetDesc: (this: *ID3D12ShaderReflectionVariable, pDesc: *D3D12_SHADER_VARIABLE_DESC) -> HRESULT #cpp_method;
    GetType: (this: *ID3D12ShaderReflectionVariable) -> *ID3D12ShaderReflectionType #cpp_method;
    GetBuffer: (this: *ID3D12ShaderReflectionVariable) -> *ID3D12ShaderReflectionConstantBuffer #cpp_method;
    GetInterfaceSlot: (this: *ID3D12ShaderReflectionVariable, uArrayIndex: u32) -> u32 #cpp_method;
}
vtable :: (obj: *ID3D12ShaderReflectionVariable) -> *ID3D12ShaderReflectionVariable_VTable { return obj.vtable; }


// {C59598B4-48B3-4869-B9B1-B1618B14A8B7}
ID3D12ShaderReflectionConstantBuffer :: struct {
    vtable: *ID3D12ShaderReflectionConstantBuffer_VTable;
}
ID3D12ShaderReflectionConstantBuffer_VTable :: struct #type_info_none {
    GetDesc: (this: *ID3D12ShaderReflectionConstantBuffer, pDesc: *D3D12_SHADER_BUFFER_DESC) -> HRESULT #cpp_method;
    GetVariableByIndex: (this: *ID3D12ShaderReflectionConstantBuffer, Index: u32) -> *ID3D12ShaderReflectionVariable #cpp_method;
    GetVariableByName: (this: *ID3D12ShaderReflectionConstantBuffer, Name: *u8) -> *ID3D12ShaderReflectionVariable #cpp_method;
}
vtable :: (obj: *ID3D12ShaderReflectionConstantBuffer) -> *ID3D12ShaderReflectionConstantBuffer_VTable { return obj.vtable; }


// {5A58797D-A72C-478D-8BA2-EFC6B0EFE88E}
ID3D12ShaderReflection :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; id3d12shaderreflection_vtable: *ID3D12ShaderReflection_VTable;
}
ID3D12ShaderReflection_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetDesc: (this: *ID3D12ShaderReflection, pDesc: *D3D12_SHADER_DESC) -> HRESULT #cpp_method;
    GetConstantBufferByIndex: (this: *ID3D12ShaderReflection, Index: u32) -> *ID3D12ShaderReflectionConstantBuffer #cpp_method;
    GetConstantBufferByName: (this: *ID3D12ShaderReflection, Name: *u8) -> *ID3D12ShaderReflectionConstantBuffer #cpp_method;
    GetResourceBindingDesc: (this: *ID3D12ShaderReflection, ResourceIndex: u32, pDesc: *D3D12_SHADER_INPUT_BIND_DESC) -> HRESULT #cpp_method;
    GetInputParameterDesc: (this: *ID3D12ShaderReflection, ParameterIndex: u32, pDesc: *D3D12_SIGNATURE_PARAMETER_DESC) -> HRESULT #cpp_method;
    GetOutputParameterDesc: (this: *ID3D12ShaderReflection, ParameterIndex: u32, pDesc: *D3D12_SIGNATURE_PARAMETER_DESC) -> HRESULT #cpp_method;
    GetPatchConstantParameterDesc: (this: *ID3D12ShaderReflection, ParameterIndex: u32, pDesc: *D3D12_SIGNATURE_PARAMETER_DESC) -> HRESULT #cpp_method;
    GetVariableByName: (this: *ID3D12ShaderReflection, Name: *u8) -> *ID3D12ShaderReflectionVariable #cpp_method;
    GetResourceBindingDescByName: (this: *ID3D12ShaderReflection, Name: *u8, pDesc: *D3D12_SHADER_INPUT_BIND_DESC) -> HRESULT #cpp_method;
    GetMovInstructionCount: (this: *ID3D12ShaderReflection) -> u32 #cpp_method;
    GetMovcInstructionCount: (this: *ID3D12ShaderReflection) -> u32 #cpp_method;
    GetConversionInstructionCount: (this: *ID3D12ShaderReflection) -> u32 #cpp_method;
    GetBitwiseInstructionCount: (this: *ID3D12ShaderReflection) -> u32 #cpp_method;
    GetGSInputPrimitive: (this: *ID3D12ShaderReflection) -> D3D_PRIMITIVE #cpp_method;
    IsSampleFrequencyShader: (this: *ID3D12ShaderReflection) -> BOOL #cpp_method;
    GetNumInterfaceSlots: (this: *ID3D12ShaderReflection) -> u32 #cpp_method;
    GetMinFeatureLevel: (this: *ID3D12ShaderReflection, pLevel: *D3D_FEATURE_LEVEL) -> HRESULT #cpp_method;
    GetThreadGroupSize: (this: *ID3D12ShaderReflection, pSizeX: *u32, pSizeY: *u32, pSizeZ: *u32) -> u32 #cpp_method;
    GetRequiresFlags: (this: *ID3D12ShaderReflection) -> u64 #cpp_method;
}
vtable :: (obj: *ID3D12ShaderReflection) -> *ID3D12ShaderReflection_VTable { return obj.id3d12shaderreflection_vtable; }


// {8E349D19-54DB-4A56-9DC9-119D87BDB804}
ID3D12LibraryReflection :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; id3d12libraryreflection_vtable: *ID3D12LibraryReflection_VTable;
}
ID3D12LibraryReflection_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetDesc: (this: *ID3D12LibraryReflection, pDesc: *D3D12_LIBRARY_DESC) -> HRESULT #cpp_method;
    GetFunctionByIndex: (this: *ID3D12LibraryReflection, FunctionIndex: s32) -> *ID3D12FunctionReflection #cpp_method;
}
vtable :: (obj: *ID3D12LibraryReflection) -> *ID3D12LibraryReflection_VTable { return obj.id3d12libraryreflection_vtable; }


// {1108795C-2772-4BA9-B2A8-D464DC7E2799}
ID3D12FunctionReflection :: struct {
    vtable: *ID3D12FunctionReflection_VTable;
}
ID3D12FunctionReflection_VTable :: struct #type_info_none {
    GetDesc: (this: *ID3D12FunctionReflection, pDesc: *D3D12_FUNCTION_DESC) -> HRESULT #cpp_method;
    GetConstantBufferByIndex: (this: *ID3D12FunctionReflection, BufferIndex: u32) -> *ID3D12ShaderReflectionConstantBuffer #cpp_method;
    GetConstantBufferByName: (this: *ID3D12FunctionReflection, Name: *u8) -> *ID3D12ShaderReflectionConstantBuffer #cpp_method;
    GetResourceBindingDesc: (this: *ID3D12FunctionReflection, ResourceIndex: u32, pDesc: *D3D12_SHADER_INPUT_BIND_DESC) -> HRESULT #cpp_method;
    GetVariableByName: (this: *ID3D12FunctionReflection, Name: *u8) -> *ID3D12ShaderReflectionVariable #cpp_method;
    GetResourceBindingDescByName: (this: *ID3D12FunctionReflection, Name: *u8, pDesc: *D3D12_SHADER_INPUT_BIND_DESC) -> HRESULT #cpp_method;
    GetFunctionParameter: (this: *ID3D12FunctionReflection, ParameterIndex: s32) -> *ID3D12FunctionParameterReflection #cpp_method;
}
vtable :: (obj: *ID3D12FunctionReflection) -> *ID3D12FunctionReflection_VTable { return obj.vtable; }


// {EC25F42D-7006-4F2B-B33E-02CC3375733F}
ID3D12FunctionParameterReflection :: struct {
    vtable: *ID3D12FunctionParameterReflection_VTable;
}
ID3D12FunctionParameterReflection_VTable :: struct #type_info_none {
    GetDesc: (this: *ID3D12FunctionParameterReflection, pDesc: *D3D12_PARAMETER_DESC) -> HRESULT #cpp_method;
}
vtable :: (obj: *ID3D12FunctionParameterReflection) -> *ID3D12FunctionParameterReflection_VTable { return obj.vtable; }


DxcCreateInstanceProc :: #type (rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #c_call;

DxcCreateInstance2Proc :: #type (pMalloc: *IMalloc, rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #c_call;

/// <summary>
/// Creates a single uninitialized object of the class associated with a specified CLSID.
/// </summary>
/// <param name="rclsid">
/// The CLSID associated with the data and code that will be used to create the object.
/// </param>
/// <param name="riid">
/// A reference to the identifier of the interface to be used to communicate
/// with the object.
/// </param>
/// <param name="ppv">
/// Address of pointer variable that receives the interface pointer requested
/// in riid. Upon successful return, *ppv contains the requested interface
/// pointer. Upon failure, *ppv contains NULL.</param>
/// <remarks>
/// While this function is similar to CoCreateInstance, there is no COM involvement.
/// </remarks>
DxcCreateInstance :: (rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #foreign dxcompiler;
DxcCreateInstance :: (rclsid: IID, riid: IID, ppv: **void) -> HRESULT #no_context {
    return DxcCreateInstance(*rclsid, *riid, ppv);
}

DxcCreateInstance2 :: (pMalloc: *IMalloc, rclsid: *IID, riid: *IID, ppv: **void) -> HRESULT #foreign dxcompiler;
DxcCreateInstance2 :: (pMalloc: *IMalloc, rclsid: IID, riid: IID, ppv: **void) -> HRESULT #no_context {
    return DxcCreateInstance2(pMalloc, *rclsid, *riid, ppv);
}

// Hash digest type for ShaderHash
DxcShaderHash :: struct {
    Flags:      u32; // DXC_HASHFLAG_*
    HashDigest: [16] u8;
}

// IDxcBlob is an alias of ID3D10Blob and ID3DBlob
IDxcBlob :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcblob_vtable: *IDxcBlob_VTable;
}
IDxcBlob_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetBufferPointer: (this: *IDxcBlob) -> *void #cpp_method;
    GetBufferSize: (this: *IDxcBlob) -> SIZE_T #cpp_method;
}
vtable :: (obj: *IDxcBlob) -> *IDxcBlob_VTable { return obj.idxcblob_vtable; }


IDxcBlobEncoding :: struct {
    #as using idxcblob: IDxcBlob;
    #place idxcblob; idxcblobencoding_vtable: *IDxcBlobEncoding_VTable;
}
IDxcBlobEncoding_VTable :: struct #type_info_none {
    using idxcblob: IDxcBlob_VTable;
    GetEncoding: (this: *IDxcBlobEncoding, pKnown: *BOOL, pCodePage: *u32) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcBlobEncoding) -> *IDxcBlobEncoding_VTable { return obj.idxcblobencoding_vtable; }


// The API will use this interface for output name strings
IDxcBlobUtf16 :: struct {
    #as using idxcblobencoding: IDxcBlobEncoding;
    #place idxcblobencoding; idxcblobutf16_vtable: *IDxcBlobUtf16_VTable;
}
IDxcBlobUtf16_VTable :: struct #type_info_none {
    using idxcblobencoding: IDxcBlobEncoding_VTable;
    GetStringPointer: (this: *IDxcBlobUtf16) -> *s16 #cpp_method;
    GetStringLength: (this: *IDxcBlobUtf16) -> SIZE_T #cpp_method;
}
vtable :: (obj: *IDxcBlobUtf16) -> *IDxcBlobUtf16_VTable { return obj.idxcblobutf16_vtable; }


IDxcBlobUtf8 :: struct {
    #as using idxcblobencoding: IDxcBlobEncoding;
    #place idxcblobencoding; idxcblobutf8_vtable: *IDxcBlobUtf8_VTable;
}
IDxcBlobUtf8_VTable :: struct #type_info_none {
    using idxcblobencoding: IDxcBlobEncoding_VTable;
    GetStringPointer: (this: *IDxcBlobUtf8) -> *u8 #cpp_method;
    GetStringLength: (this: *IDxcBlobUtf8) -> SIZE_T #cpp_method;
}
vtable :: (obj: *IDxcBlobUtf8) -> *IDxcBlobUtf8_VTable { return obj.idxcblobutf8_vtable; }


IDxcIncludeHandler :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcincludehandler_vtable: *IDxcIncludeHandler_VTable;
}
IDxcIncludeHandler_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    LoadSource: (this: *IDxcIncludeHandler, pFilename: *s16, ppIncludeSource: **IDxcBlob) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcIncludeHandler) -> *IDxcIncludeHandler_VTable { return obj.idxcincludehandler_vtable; }


// Structure for supplying bytes or text input to Dxc APIs.
// Use Encoding = 0 for non-text bytes, ANSI text, or unknown with BOM.
DxcBuffer :: struct {
    Ptr:      *void;
    Size:     SIZE_T;
    Encoding: u32;
}

// Structure for supplying bytes or text input to Dxc APIs.
// Use Encoding = 0 for non-text bytes, ANSI text, or unknown with BOM.
DxcText :: DxcBuffer;

DxcDefine :: struct {
    Name:  *s16;
    Value: *s16;
}

IDxcCompilerArgs :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxccompilerargs_vtable: *IDxcCompilerArgs_VTable;
}
IDxcCompilerArgs_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetArguments: (this: *IDxcCompilerArgs) -> **s16 #cpp_method;
    GetCount: (this: *IDxcCompilerArgs) -> u32 #cpp_method;
    AddArguments: (this: *IDxcCompilerArgs, pArguments: **s16, argCount: u32) -> HRESULT #cpp_method;
    AddArgumentsUTF8: (this: *IDxcCompilerArgs, pArguments: **u8, argCount: u32) -> HRESULT #cpp_method;
    AddDefines: (this: *IDxcCompilerArgs, pDefines: *DxcDefine, defineCount: u32) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcCompilerArgs) -> *IDxcCompilerArgs_VTable { return obj.idxccompilerargs_vtable; }


// NOTE: IDxcUtils replaces IDxcLibrary
IDxcLibrary :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxclibrary_vtable: *IDxcLibrary_VTable;
}
IDxcLibrary_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    SetMalloc: (this: *IDxcLibrary, pMalloc: *IMalloc) -> HRESULT #cpp_method;
    CreateBlobFromBlob: (this: *IDxcLibrary, pBlob: *IDxcBlob, offset: u32, length: u32, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    CreateBlobFromFile: (this: *IDxcLibrary, pFileName: *s16, codePage: *u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlobWithEncodingFromPinned: (this: *IDxcLibrary, pText: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlobWithEncodingOnHeapCopy: (this: *IDxcLibrary, pText: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlobWithEncodingOnMalloc: (this: *IDxcLibrary, pText: *void, pIMalloc: *IMalloc, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateIncludeHandler: (this: *IDxcLibrary, ppResult: **IDxcIncludeHandler) -> HRESULT #cpp_method;
    CreateStreamFromBlobReadOnly: (this: *IDxcLibrary, pBlob: *IDxcBlob, ppStream: **IStream) -> HRESULT #cpp_method;
    GetBlobAsUtf8: (this: *IDxcLibrary, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    GetBlobAsUtf16: (this: *IDxcLibrary, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcLibrary) -> *IDxcLibrary_VTable { return obj.idxclibrary_vtable; }


// NOTE: IDxcResult replaces IDxcOperationResult
IDxcOperationResult :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcoperationresult_vtable: *IDxcOperationResult_VTable;
}
IDxcOperationResult_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetStatus: (this: *IDxcOperationResult, pStatus: *HRESULT) -> HRESULT #cpp_method;
    GetResult: (this: *IDxcOperationResult, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    GetErrorBuffer: (this: *IDxcOperationResult, ppErrors: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcOperationResult) -> *IDxcOperationResult_VTable { return obj.idxcoperationresult_vtable; }


// NOTE: IDxcCompiler3 replaces IDxcCompiler and IDxcCompiler2
IDxcCompiler :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxccompiler_vtable: *IDxcCompiler_VTable;
}
IDxcCompiler_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Compile: (this: *IDxcCompiler, pSource: *IDxcBlob, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
    Preprocess: (this: *IDxcCompiler, pSource: *IDxcBlob, pSourceName: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
    Disassemble: (this: *IDxcCompiler, pSource: *IDxcBlob, ppDisassembly: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcCompiler) -> *IDxcCompiler_VTable { return obj.idxccompiler_vtable; }


// NOTE: IDxcCompiler3 replaces IDxcCompiler and IDxcCompiler2
IDxcCompiler2 :: struct {
    #as using idxccompiler: IDxcCompiler;
    #place idxccompiler; idxccompiler2_vtable: *IDxcCompiler2_VTable;
}
IDxcCompiler2_VTable :: struct #type_info_none {
    using idxccompiler: IDxcCompiler_VTable;
    CompileWithDebug: (this: *IDxcCompiler2, pSource: *IDxcBlob, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, pIncludeHandler: *IDxcIncludeHandler, ppResult: **IDxcOperationResult, ppDebugBlobName: **s16, ppDebugBlob: **IDxcBlob) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcCompiler2) -> *IDxcCompiler2_VTable { return obj.idxccompiler2_vtable; }


IDxcLinker :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxclinker_vtable: *IDxcLinker_VTable;
}
IDxcLinker_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    RegisterLibrary: (this: *IDxcLinker, pLibName: *s16, pLib: *IDxcBlob) -> HRESULT #cpp_method;
    Link: (this: *IDxcLinker, pEntryName: *s16, pTargetProfile: *s16, pLibNames: **s16, libCount: u32, pArguments: **s16, argCount: u32, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcLinker) -> *IDxcLinker_VTable { return obj.idxclinker_vtable; }


// NOTE: IDxcUtils replaces IDxcLibrary
IDxcUtils :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcutils_vtable: *IDxcUtils_VTable;
}
IDxcUtils_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    CreateBlobFromBlob: (this: *IDxcUtils, pBlob: *IDxcBlob, offset: u32, length: u32, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    CreateBlobFromPinned: (this: *IDxcUtils, pData: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    MoveToBlob: (this: *IDxcUtils, pData: *void, pIMalloc: *IMalloc, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateBlob: (this: *IDxcUtils, pData: *void, size: u32, codePage: u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    LoadFile: (this: *IDxcUtils, pFileName: *s16, pCodePage: *u32, pBlobEncoding: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    CreateReadOnlyStreamFromBlob: (this: *IDxcUtils, pBlob: *IDxcBlob, ppStream: **IStream) -> HRESULT #cpp_method;
    CreateDefaultIncludeHandler: (this: *IDxcUtils, ppResult: **IDxcIncludeHandler) -> HRESULT #cpp_method;
    GetBlobAsUtf8: (this: *IDxcUtils, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobUtf8) -> HRESULT #cpp_method;
    GetBlobAsUtf16: (this: *IDxcUtils, pBlob: *IDxcBlob, pBlobEncoding: **IDxcBlobUtf16) -> HRESULT #cpp_method;
    GetDxilContainerPart: (this: *IDxcUtils, pShader: *DxcBuffer, DxcPart: u32, ppPartData: **void, pPartSizeInBytes: *u32) -> HRESULT #cpp_method;
    CreateReflection: (this: *IDxcUtils, pData: *DxcBuffer, iid: *IID, ppvReflection: **void) -> HRESULT #cpp_method;
    BuildArguments: (this: *IDxcUtils, pSourceName: *s16, pEntryPoint: *s16, pTargetProfile: *s16, pArguments: **s16, argCount: u32, pDefines: *DxcDefine, defineCount: u32, ppArgs: **IDxcCompilerArgs) -> HRESULT #cpp_method;
    GetPDBContents: (this: *IDxcUtils, pPDBBlob: *IDxcBlob, ppHash: **IDxcBlob, ppContainer: **IDxcBlob) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcUtils) -> *IDxcUtils_VTable { return obj.idxcutils_vtable; }


// For use with IDxcResult::[Has|Get]Output dxcOutKind argument
// Note: text outputs returned from version 2 APIs are UTF-8 or UTF-16 based on -encoding option
DXC_OUT_KIND :: enum s32 {
    NONE           :: 0;
    OBJECT         :: 1;
    ERRORS         :: 2;
    PDB            :: 3;
    SHADER_HASH    :: 4;
    DISASSEMBLY    :: 5;
    HLSL           :: 6;
    TEXT           :: 7;
    REFLECTION     :: 8;
    ROOT_SIGNATURE :: 9;
    EXTRA_OUTPUTS  :: 10;

    FORCE_DWORD    :: -1;

    DXC_OUT_NONE           :: NONE;
    DXC_OUT_OBJECT         :: OBJECT;
    DXC_OUT_ERRORS         :: ERRORS;
    DXC_OUT_PDB            :: PDB;
    DXC_OUT_SHADER_HASH    :: SHADER_HASH;
    DXC_OUT_DISASSEMBLY    :: DISASSEMBLY;
    DXC_OUT_HLSL           :: HLSL;
    DXC_OUT_TEXT           :: TEXT;
    DXC_OUT_REFLECTION     :: REFLECTION;
    DXC_OUT_ROOT_SIGNATURE :: ROOT_SIGNATURE;
    DXC_OUT_EXTRA_OUTPUTS  :: EXTRA_OUTPUTS;

    DXC_OUT_FORCE_DWORD    :: FORCE_DWORD;
}

IDxcResult :: struct {
    #as using idxcoperationresult: IDxcOperationResult;
    #place idxcoperationresult; idxcresult_vtable: *IDxcResult_VTable;
}
IDxcResult_VTable :: struct #type_info_none {
    using idxcoperationresult: IDxcOperationResult_VTable;
    HasOutput: (this: *IDxcResult, dxcOutKind: DXC_OUT_KIND) -> BOOL #cpp_method;
    GetOutput: (this: *IDxcResult, dxcOutKind: DXC_OUT_KIND, iid: *IID, ppvObject: **void, ppOutputName: **IDxcBlobUtf16) -> HRESULT #cpp_method;
    GetNumOutputs: (this: *IDxcResult) -> u32 #cpp_method;
    GetOutputByIndex: (this: *IDxcResult, Index: u32) -> DXC_OUT_KIND #cpp_method;
    PrimaryOutput: (this: *IDxcResult) -> DXC_OUT_KIND #cpp_method;
}
vtable :: (obj: *IDxcResult) -> *IDxcResult_VTable { return obj.idxcresult_vtable; }


IDxcExtraOutputs :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcextraoutputs_vtable: *IDxcExtraOutputs_VTable;
}
IDxcExtraOutputs_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetOutputCount: (this: *IDxcExtraOutputs) -> u32 #cpp_method;
    GetOutput: (this: *IDxcExtraOutputs, uIndex: u32, iid: *IID, ppvObject: **void, ppOutputType: **IDxcBlobUtf16, ppOutputName: **IDxcBlobUtf16) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcExtraOutputs) -> *IDxcExtraOutputs_VTable { return obj.idxcextraoutputs_vtable; }


IDxcCompiler3 :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxccompiler3_vtable: *IDxcCompiler3_VTable;
}
IDxcCompiler3_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Compile: (this: *IDxcCompiler3, pSource: *DxcBuffer, pArguments: **s16, argCount: u32, pIncludeHandler: *IDxcIncludeHandler, riid: *IID, ppResult: **void) -> HRESULT #cpp_method;
    Disassemble: (this: *IDxcCompiler3, pObject: *DxcBuffer, riid: *IID, ppResult: **void) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcCompiler3) -> *IDxcCompiler3_VTable { return obj.idxccompiler3_vtable; }


IDxcValidator :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcvalidator_vtable: *IDxcValidator_VTable;
}
IDxcValidator_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Validate: (this: *IDxcValidator, pShader: *IDxcBlob, Flags: u32, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcValidator) -> *IDxcValidator_VTable { return obj.idxcvalidator_vtable; }


IDxcValidator2 :: struct {
    #as using idxcvalidator: IDxcValidator;
    #place idxcvalidator; idxcvalidator2_vtable: *IDxcValidator2_VTable;
}
IDxcValidator2_VTable :: struct #type_info_none {
    using idxcvalidator: IDxcValidator_VTable;
    ValidateWithDebug: (this: *IDxcValidator2, pShader: *IDxcBlob, Flags: u32, pOptDebugBitcode: *DxcBuffer, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcValidator2) -> *IDxcValidator2_VTable { return obj.idxcvalidator2_vtable; }


IDxcContainerBuilder :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxccontainerbuilder_vtable: *IDxcContainerBuilder_VTable;
}
IDxcContainerBuilder_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Load: (this: *IDxcContainerBuilder, pDxilContainerHeader: *IDxcBlob) -> HRESULT #cpp_method;
    AddPart: (this: *IDxcContainerBuilder, fourCC: u32, pSource: *IDxcBlob) -> HRESULT #cpp_method;
    RemovePart: (this: *IDxcContainerBuilder, fourCC: u32) -> HRESULT #cpp_method;
    SerializeContainer: (this: *IDxcContainerBuilder, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcContainerBuilder) -> *IDxcContainerBuilder_VTable { return obj.idxccontainerbuilder_vtable; }


IDxcAssembler :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcassembler_vtable: *IDxcAssembler_VTable;
}
IDxcAssembler_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    AssembleToContainer: (this: *IDxcAssembler, pShader: *IDxcBlob, ppResult: **IDxcOperationResult) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcAssembler) -> *IDxcAssembler_VTable { return obj.idxcassembler_vtable; }


IDxcContainerReflection :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxccontainerreflection_vtable: *IDxcContainerReflection_VTable;
}
IDxcContainerReflection_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Load: (this: *IDxcContainerReflection, pContainer: *IDxcBlob) -> HRESULT #cpp_method;
    GetPartCount: (this: *IDxcContainerReflection, pResult: *u32) -> HRESULT #cpp_method;
    GetPartKind: (this: *IDxcContainerReflection, idx: u32, pResult: *u32) -> HRESULT #cpp_method;
    GetPartContent: (this: *IDxcContainerReflection, idx: u32, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    FindFirstPartKind: (this: *IDxcContainerReflection, kind: u32, pResult: *u32) -> HRESULT #cpp_method;
    GetPartReflection: (this: *IDxcContainerReflection, idx: u32, iid: *IID, ppvObject: **void) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcContainerReflection) -> *IDxcContainerReflection_VTable { return obj.idxccontainerreflection_vtable; }


IDxcOptimizerPass :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcoptimizerpass_vtable: *IDxcOptimizerPass_VTable;
}
IDxcOptimizerPass_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetOptionName: (this: *IDxcOptimizerPass, ppResult: **s16) -> HRESULT #cpp_method;
    GetDescription: (this: *IDxcOptimizerPass, ppResult: **s16) -> HRESULT #cpp_method;
    GetOptionArgCount: (this: *IDxcOptimizerPass, pCount: *u32) -> HRESULT #cpp_method;
    GetOptionArgName: (this: *IDxcOptimizerPass, argIndex: u32, ppResult: **s16) -> HRESULT #cpp_method;
    GetOptionArgDescription: (this: *IDxcOptimizerPass, argIndex: u32, ppResult: **s16) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcOptimizerPass) -> *IDxcOptimizerPass_VTable { return obj.idxcoptimizerpass_vtable; }


IDxcOptimizer :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcoptimizer_vtable: *IDxcOptimizer_VTable;
}
IDxcOptimizer_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetAvailablePassCount: (this: *IDxcOptimizer, pCount: *u32) -> HRESULT #cpp_method;
    GetAvailablePass: (this: *IDxcOptimizer, index: u32, ppResult: **IDxcOptimizerPass) -> HRESULT #cpp_method;
    RunOptimizer: (this: *IDxcOptimizer, pBlob: *IDxcBlob, ppOptions: **s16, optionCount: u32, pOutputModule: **IDxcBlob, ppOutputText: **IDxcBlobEncoding) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcOptimizer) -> *IDxcOptimizer_VTable { return obj.idxcoptimizer_vtable; }


IDxcVersionInfo :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcversioninfo_vtable: *IDxcVersionInfo_VTable;
}
IDxcVersionInfo_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetVersion: (this: *IDxcVersionInfo, pMajor: *u32, pMinor: *u32) -> HRESULT #cpp_method;
    GetFlags: (this: *IDxcVersionInfo, pFlags: *u32) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcVersionInfo) -> *IDxcVersionInfo_VTable { return obj.idxcversioninfo_vtable; }


IDxcVersionInfo2 :: struct {
    #as using idxcversioninfo: IDxcVersionInfo;
    #place idxcversioninfo; idxcversioninfo2_vtable: *IDxcVersionInfo2_VTable;
}
IDxcVersionInfo2_VTable :: struct #type_info_none {
    using idxcversioninfo: IDxcVersionInfo_VTable;
    GetCommitInfo: (this: *IDxcVersionInfo2, pCommitCount: *u32, pCommitHash: **u8) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcVersionInfo2) -> *IDxcVersionInfo2_VTable { return obj.idxcversioninfo2_vtable; }


IDxcVersionInfo3 :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcversioninfo3_vtable: *IDxcVersionInfo3_VTable;
}
IDxcVersionInfo3_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    GetCustomVersionString: (this: *IDxcVersionInfo3, pVersionString: **u8) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcVersionInfo3) -> *IDxcVersionInfo3_VTable { return obj.idxcversioninfo3_vtable; }


DxcArgPair :: struct {
    pName:  *s16;
    pValue: *s16;
}

IDxcPdbUtils :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxcpdbutils_vtable: *IDxcPdbUtils_VTable;
}
IDxcPdbUtils_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    Load: (this: *IDxcPdbUtils, pPdbOrDxil: *IDxcBlob) -> HRESULT #cpp_method;
    GetSourceCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetSource: (this: *IDxcPdbUtils, uIndex: u32, ppResult: **IDxcBlobEncoding) -> HRESULT #cpp_method;
    GetSourceName: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetFlagCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetFlag: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetArgCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetArg: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetArgPairCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetArgPair: (this: *IDxcPdbUtils, uIndex: u32, pName: *BSTR, pValue: *BSTR) -> HRESULT #cpp_method;
    GetDefineCount: (this: *IDxcPdbUtils, pCount: *u32) -> HRESULT #cpp_method;
    GetDefine: (this: *IDxcPdbUtils, uIndex: u32, pResult: *BSTR) -> HRESULT #cpp_method;
    GetTargetProfile: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    GetEntryPoint: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    GetMainFileName: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    GetHash: (this: *IDxcPdbUtils, ppResult: **IDxcBlob) -> HRESULT #cpp_method;
    GetName: (this: *IDxcPdbUtils, pResult: *BSTR) -> HRESULT #cpp_method;
    IsFullPDB: (this: *IDxcPdbUtils) -> BOOL #cpp_method;
    GetFullPDB: (this: *IDxcPdbUtils, ppFullPDB: **IDxcBlob) -> HRESULT #cpp_method;
    GetVersionInfo: (this: *IDxcPdbUtils, ppVersionInfo: **IDxcVersionInfo) -> HRESULT #cpp_method;
    SetCompiler: (this: *IDxcPdbUtils, pCompiler: *IDxcCompiler3) -> HRESULT #cpp_method;
    CompileForFullPDB: (this: *IDxcPdbUtils, ppResult: **IDxcResult) -> HRESULT #cpp_method;
    OverrideArgs: (this: *IDxcPdbUtils, pArgPairs: *DxcArgPair, uNumArgPairs: u32) -> HRESULT #cpp_method;
    OverrideRootSignature: (this: *IDxcPdbUtils, pRootSignature: *s16) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDxcPdbUtils) -> *IDxcPdbUtils_VTable { return obj.idxcpdbutils_vtable; }


#scope_file

dxcompiler :: #foreign_library,no_dll "dxc_src/lib/x64/dxcompiler";
