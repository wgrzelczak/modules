// 
// Jai port of tinyddsloader (https://github.com/benikabocha/tinyddsloader sha1: a2ce2fd) - published on MIT License
// All credits to benikabocha (https://github.com/benikabocha/)
//

// TODO: Flip implementation

// Usage:
/*
    {
        file : DDSFile;
        Load(*file, path);
        defer Unload(*file);
        log("width = %, height = %, format = %, subresources_count = %, mips = %\n",
              file.m_width, file.m_height, file.m_format, file.m_arraySize, file.m_mipCount);
    }
*/
//

Result :: enum s32 {
    Success           :: 0;
    ErrorFileOpen     :: 1;
    ErrorRead         :: 2;
    ErrorMagicWord    :: 3;
    ErrorSize         :: 4;
    ErrorVerify       :: 5;
    ErrorNotSupported :: 6;
    ErrorInvalidData  :: 7;
}

DXGIFormat :: enum u32 {
    Unknown                    :: 0;
    R32G32B32A32_Typeless      :: 1;
    R32G32B32A32_Float         :: 2;
    R32G32B32A32_UInt          :: 3;
    R32G32B32A32_SInt          :: 4;
    R32G32B32_Typeless         :: 5;
    R32G32B32_Float            :: 6;
    R32G32B32_UInt             :: 7;
    R32G32B32_SInt             :: 8;
    R16G16B16A16_Typeless      :: 9;
    R16G16B16A16_Float         :: 10;
    R16G16B16A16_UNorm         :: 11;
    R16G16B16A16_UInt          :: 12;
    R16G16B16A16_SNorm         :: 13;
    R16G16B16A16_SInt          :: 14;
    R32G32_Typeless            :: 15;
    R32G32_Float               :: 16;
    R32G32_UInt                :: 17;
    R32G32_SInt                :: 18;
    R32G8X24_Typeless          :: 19;
    D32_Float_S8X24_UInt       :: 20;
    R32_Float_X8X24_Typeless   :: 21;
    X32_Typeless_G8X24_UInt    :: 22;
    R10G10B10A2_Typeless       :: 23;
    R10G10B10A2_UNorm          :: 24;
    R10G10B10A2_UInt           :: 25;
    R11G11B10_Float            :: 26;
    R8G8B8A8_Typeless          :: 27;
    R8G8B8A8_UNorm             :: 28;
    R8G8B8A8_UNorm_SRGB        :: 29;
    R8G8B8A8_UInt              :: 30;
    R8G8B8A8_SNorm             :: 31;
    R8G8B8A8_SInt              :: 32;
    R16G16_Typeless            :: 33;
    R16G16_Float               :: 34;
    R16G16_UNorm               :: 35;
    R16G16_UInt                :: 36;
    R16G16_SNorm               :: 37;
    R16G16_SInt                :: 38;
    R32_Typeless               :: 39;
    D32_Float                  :: 40;
    R32_Float                  :: 41;
    R32_UInt                   :: 42;
    R32_SInt                   :: 43;
    R24G8_Typeless             :: 44;
    D24_UNorm_S8_UInt          :: 45;
    R24_UNorm_X8_Typeless      :: 46;
    X24_Typeless_G8_UInt       :: 47;
    R8G8_Typeless              :: 48;
    R8G8_UNorm                 :: 49;
    R8G8_UInt                  :: 50;
    R8G8_SNorm                 :: 51;
    R8G8_SInt                  :: 52;
    R16_Typeless               :: 53;
    R16_Float                  :: 54;
    D16_UNorm                  :: 55;
    R16_UNorm                  :: 56;
    R16_UInt                   :: 57;
    R16_SNorm                  :: 58;
    R16_SInt                   :: 59;
    R8_Typeless                :: 60;
    R8_UNorm                   :: 61;
    R8_UInt                    :: 62;
    R8_SNorm                   :: 63;
    R8_SInt                    :: 64;
    A8_UNorm                   :: 65;
    R1_UNorm                   :: 66;
    R9G9B9E5_SHAREDEXP         :: 67;
    R8G8_B8G8_UNorm            :: 68;
    G8R8_G8B8_UNorm            :: 69;
    BC1_Typeless               :: 70;
    BC1_UNorm                  :: 71;
    BC1_UNorm_SRGB             :: 72;
    BC2_Typeless               :: 73;
    BC2_UNorm                  :: 74;
    BC2_UNorm_SRGB             :: 75;
    BC3_Typeless               :: 76;
    BC3_UNorm                  :: 77;
    BC3_UNorm_SRGB             :: 78;
    BC4_Typeless               :: 79;
    BC4_UNorm                  :: 80;
    BC4_SNorm                  :: 81;
    BC5_Typeless               :: 82;
    BC5_UNorm                  :: 83;
    BC5_SNorm                  :: 84;
    B5G6R5_UNorm               :: 85;
    B5G5R5A1_UNorm             :: 86;
    B8G8R8A8_UNorm             :: 87;
    B8G8R8X8_UNorm             :: 88;
    R10G10B10_XR_BIAS_A2_UNorm :: 89;
    B8G8R8A8_Typeless          :: 90;
    B8G8R8A8_UNorm_SRGB        :: 91;
    B8G8R8X8_Typeless          :: 92;
    B8G8R8X8_UNorm_SRGB        :: 93;
    BC6H_Typeless              :: 94;
    BC6H_UF16                  :: 95;
    BC6H_SF16                  :: 96;
    BC7_Typeless               :: 97;
    BC7_UNorm                  :: 98;
    BC7_UNorm_SRGB             :: 99;
    AYUV                       :: 100;
    Y410                       :: 101;
    Y416                       :: 102;
    NV12                       :: 103;
    P010                       :: 104;
    P016                       :: 105;
    YUV420_OPAQUE              :: 106;
    YUY2                       :: 107;
    Y210                       :: 108;
    Y216                       :: 109;
    NV11                       :: 110;
    AI44                       :: 111;
    IA44                       :: 112;
    P8                         :: 113;
    A8P8                       :: 114;
    B4G4R4A4_UNorm             :: 115;
    P208                       :: 130;
    V208                       :: 131;
    V408                       :: 132;
}

TextureDimension :: enum u32 {
    Unknown   :: 0;
    Texture1D :: 2;
    Texture2D :: 3;
    Texture3D :: 4;
}

ImageData :: struct {
    m_width:         u32;
    m_height:        u32;
    m_depth:         u32;
    m_mem:           *void;
    m_memPitch:      u32;
    m_memSlicePitch: u32;
}

DDSFile :: struct {
    Magic:        [4] u8 : .[#char "D", #char "D", #char "S", #char " "];
    
    m_dds:        [..] u8;
    m_imageDatas: [] ImageData;
    
    m_height:     u32;
    m_width:      u32;
    m_depth:      u32;
    m_mipCount:   u32;
    m_arraySize:  u32;
    m_format:     DXGIFormat;
    m_isCubemap:  bool;
    m_texDim:     TextureDimension;
}

IsCompressed :: (fmt : DXGIFormat) -> bool {
    if fmt == {
        case .BC1_Typeless; #through;
        case .BC1_UNorm; #through;
        case .BC1_UNorm_SRGB; #through;
        case .BC2_Typeless; #through;
        case .BC2_UNorm; #through;
        case .BC2_UNorm_SRGB; #through;
        case .BC3_Typeless; #through;
        case .BC3_UNorm; #through;
        case .BC3_UNorm_SRGB; #through;
        case .BC4_Typeless; #through;
        case .BC4_UNorm; #through;
        case .BC4_SNorm; #through;
        case .BC5_Typeless; #through;
        case .BC5_UNorm; #through;
        case .BC5_SNorm; #through;
        case .BC6H_Typeless; #through;
        case .BC6H_UF16; #through;
        case .BC6H_SF16; #through;
        case .BC7_Typeless; #through;
        case .BC7_UNorm; #through;
        case .BC7_UNorm_SRGB; #through;
        return true;
    }
    return false;
}
MakeFourCC :: ($str : string) -> u32 #expand {
    return (cast(u32)str[0]) | ((cast(u32)str[1]) << 8) | ((cast(u32)str[2]) << 16) | ((cast(u32)str[3]) << 24);
}
GetDXGIFormat :: (pf : PixelFormat) -> DXGIFormat {
    if pf.m_flags & .RGB {
        if pf.m_bitCount == {
            case 32; {
                if pf.m_RBitMask == 0x000000ff &&
                    pf.m_GBitMask == 0x0000ff00 &&
                    pf.m_BBitMask == 0x00ff0000 &&
                    pf.m_ABitMask == 0xff000000
                	return .R8G8B8A8_UNorm;
                if pf.m_RBitMask == 0x00ff0000 &&
                    pf.m_GBitMask == 0x0000ff00 &&
                    pf.m_BBitMask == 0x000000ff &&
                    pf.m_ABitMask == 0xff000000
                    return .B8G8R8A8_UNorm;
                if pf.m_RBitMask == 0x00ff0000 &&
                    pf.m_GBitMask == 0x0000ff00 &&
                    pf.m_BBitMask == 0x000000ff &&
                    pf.m_ABitMask == 0x00000000
                    return .B8G8R8X8_UNorm;
                if pf.m_RBitMask == 0x0000ffff &&
                    pf.m_GBitMask == 0xffff0000 &&
                    pf.m_BBitMask == 0x00000000 &&
                    pf.m_ABitMask == 0x00000000
                    return .R16G16_UNorm;
                if pf.m_RBitMask == 0xffffffff &&
                    pf.m_GBitMask == 0x00000000 &&
                    pf.m_BBitMask == 0x00000000 &&
                    pf.m_ABitMask == 0x00000000
                    return .R32_Float;
            }
            case 16; {
                if pf.m_RBitMask == 0x7c00 && pf.m_GBitMask == 0x03e0 &&
                    pf.m_BBitMask == 0x001f && pf.m_ABitMask == 0x8000
                	return .B5G5R5A1_UNorm;
                
            	if pf.m_RBitMask == 0xf800 && pf.m_GBitMask == 0x07e0 &&
                    pf.m_BBitMask == 0x001f && pf.m_ABitMask == 0x0000
                	return .B5G6R5_UNorm;
            	if pf.m_RBitMask == 0x0f00 && pf.m_GBitMask == 0x00f0 &&
                    pf.m_BBitMask == 0x000f && pf.m_ABitMask == 0xf000
                	return .B4G4R4A4_UNorm;
            }
        }
    } else if pf.m_flags & .Luminance {
        if 8 == pf.m_bitCount {
            if pf.m_RBitMask == 0x000000ff && pf.m_GBitMask == 0x00000000 &&
                pf.m_BBitMask == 0x00000000 && pf.m_ABitMask == 0x00000000
                return .R8_UNorm;
            if pf.m_RBitMask == 0x000000ff && pf.m_GBitMask == 0x0000ff00 &&
                pf.m_BBitMask == 0x00000000 && pf.m_ABitMask == 0x00000000
                return .R8G8_UNorm;
        }
        if 16 == pf.m_bitCount {
            if pf.m_RBitMask == 0x0000ffff && pf.m_GBitMask == 0x00000000 &&
                pf.m_BBitMask == 0x00000000 && pf.m_ABitMask == 0x00000000
                return .R16_UNorm;
            if pf.m_RBitMask == 0x000000ff && pf.m_GBitMask == 0x0000ff00 &&
                pf.m_BBitMask == 0x00000000 && pf.m_ABitMask == 0x00000000
                return .R8G8_UNorm;
        }
    } else if pf.m_flags & .Alpha {
        if 8 == pf.m_bitCount
            return .A8_UNorm;
    } else if pf.m_flags & .BumpDUDV {
        if 16 == pf.m_bitCount
            if pf.m_RBitMask == 0x00ff && pf.m_GBitMask == 0xff00 &&
            pf.m_BBitMask == 0x0000 && pf.m_ABitMask == 0x0000
            return .R8G8_SNorm;
        
        if 32 == pf.m_bitCount {
            if pf.m_RBitMask == 0x000000ff && pf.m_GBitMask == 0x0000ff00 &&
                pf.m_BBitMask == 0x00ff0000 && pf.m_ABitMask == 0xff000000
                return .R8G8B8A8_SNorm;
            
            if pf.m_RBitMask == 0x0000ffff && pf.m_GBitMask == 0xffff0000 &&
                pf.m_BBitMask == 0x00000000 && pf.m_ABitMask == 0x00000000
                return .R16G16_SNorm;
        }
	} else if pf.m_flags & .FourCC {
        if pf.m_fourCC == {
            case #run MakeFourCC("DXT1"); return .BC1_UNorm;
            case #run MakeFourCC("DXT3"); return .BC2_UNorm;
            case #run MakeFourCC("DXT4"); return .BC2_UNorm;
            case #run MakeFourCC("DXT5"); return .BC3_UNorm;
            case #run MakeFourCC("ATI1"); return .BC4_UNorm;
            case #run MakeFourCC("BC4U"); return .BC4_UNorm;
            case #run MakeFourCC("BC4S"); return .BC4_SNorm;
            case #run MakeFourCC("ATI2"); return .BC5_UNorm;
            case #run MakeFourCC("BC5U"); return .BC5_UNorm;
            case #run MakeFourCC("BC5S"); return .BC5_SNorm;
            case #run MakeFourCC("RGBG"); return .R8G8_B8G8_UNorm;
            case #run MakeFourCC("GRGB"); return .G8R8_G8B8_UNorm;
            case #run MakeFourCC("YUY2"); return .YUY2;
            
            case 36;                 return .R16G16B16A16_UNorm;
            case 110;                return .R16G16B16A16_SNorm;
            case 111;                return .R16_Float;
            case 112;                return .R16G16_Float;
            case 113;                return .R16G16B16A16_Float;
            case 114;                return .R32_Float;
            case 115;                return .R32G32_Float;
            case 116;                return .R32G32B32A32_Float;
        }
    }
    
    return .Unknown;
}
GetBitsPerPixel :: (fmt : DXGIFormat) -> u32 {
    if fmt == {
        case .R32G32B32A32_Typeless; #through;
        case .R32G32B32A32_Float; #through;
        case .R32G32B32A32_UInt; #through;
        case .R32G32B32A32_SInt;
        return 128;
        
        case .R32G32B32_Typeless; #through;
        case .R32G32B32_Float; #through;
        case .R32G32B32_UInt; #through;
        case .R32G32B32_SInt;
        return 96;
        
        case .R16G16B16A16_Typeless; #through;
        case .R16G16B16A16_Float; #through;
        case .R16G16B16A16_UNorm; #through;
        case .R16G16B16A16_UInt; #through;
        case .R16G16B16A16_SNorm; #through;
        case .R16G16B16A16_SInt; #through;
        case .R32G32_Typeless; #through;
        case .R32G32_Float; #through;
        case .R32G32_UInt; #through;
        case .R32G32_SInt; #through;
        case .R32G8X24_Typeless; #through;
        case .D32_Float_S8X24_UInt; #through;
        case .R32_Float_X8X24_Typeless; #through;
        case .X32_Typeless_G8X24_UInt; #through;
        case .Y416; #through;
        case .Y210; #through;
        case .Y216;
        return 64;
        
        case .R10G10B10A2_Typeless; #through;
        case .R10G10B10A2_UNorm; #through;
        case .R10G10B10A2_UInt; #through;
        case .R11G11B10_Float; #through;
        case .R8G8B8A8_Typeless; #through;
        case .R8G8B8A8_UNorm; #through;
        case .R8G8B8A8_UNorm_SRGB; #through;
        case .R8G8B8A8_UInt; #through;
        case .R8G8B8A8_SNorm; #through;
        case .R8G8B8A8_SInt; #through;
        case .R16G16_Typeless; #through;
        case .R16G16_Float; #through;
        case .R16G16_UNorm; #through;
        case .R16G16_UInt; #through;
        case .R16G16_SNorm; #through;
        case .R16G16_SInt; #through;
        case .R32_Typeless; #through;
        case .D32_Float; #through;
        case .R32_Float; #through;
        case .R32_UInt; #through;
        case .R32_SInt; #through;
        case .R24G8_Typeless; #through;
        case .D24_UNorm_S8_UInt; #through;
        case .R24_UNorm_X8_Typeless; #through;
        case .X24_Typeless_G8_UInt; #through;
        case .R9G9B9E5_SHAREDEXP; #through;
        case .R8G8_B8G8_UNorm; #through;
        case .G8R8_G8B8_UNorm; #through;
        case .B8G8R8A8_UNorm; #through;
        case .B8G8R8X8_UNorm; #through;
        case .R10G10B10_XR_BIAS_A2_UNorm; #through;
        case .B8G8R8A8_Typeless; #through;
        case .B8G8R8A8_UNorm_SRGB; #through;
        case .B8G8R8X8_Typeless; #through;
        case .B8G8R8X8_UNorm_SRGB; #through;
        case .AYUV; #through;
        case .Y410; #through;
        case .YUY2;
        return 32;
        
        case .P010; #through;
        case .P016;
        return 24;
        
        case .R8G8_Typeless; #through;
        case .R8G8_UNorm; #through;
        case .R8G8_UInt; #through;
        case .R8G8_SNorm; #through;
        case .R8G8_SInt; #through;
        case .R16_Typeless; #through;
        case .R16_Float; #through;
        case .D16_UNorm; #through;
        case .R16_UNorm; #through;
        case .R16_UInt; #through;
        case .R16_SNorm; #through;
        case .R16_SInt; #through;
        case .B5G6R5_UNorm; #through;
        case .B5G5R5A1_UNorm; #through;
        case .A8P8; #through;
        case .B4G4R4A4_UNorm;
        return 16;
        
        case .NV12; #through;
        case .YUV420_OPAQUE; #through;
        case .NV11;
        return 12;
        
        case .R8_Typeless; #through;
        case .R8_UNorm; #through;
        case .R8_UInt; #through;
        case .R8_SNorm; #through;
        case .R8_SInt; #through;
        case .A8_UNorm; #through;
        case .AI44; #through;
        case .IA44; #through;
        case .P8;
        return 8;
        
        case .R1_UNorm;
        return 1;
        
        case .BC1_Typeless; #through;
        case .BC1_UNorm; #through;
        case .BC1_UNorm_SRGB; #through;
        case .BC4_Typeless; #through;
        case .BC4_UNorm; #through;
        case .BC4_SNorm;
        return 4;
        
        case .BC2_Typeless; #through;
        case .BC2_UNorm; #through;
        case .BC2_UNorm_SRGB; #through;
        case .BC3_Typeless; #through;
        case .BC3_UNorm; #through;
        case .BC3_UNorm_SRGB; #through;
        case .BC5_Typeless; #through;
        case .BC5_UNorm; #through;
        case .BC5_SNorm; #through;
        case .BC6H_Typeless; #through;
        case .BC6H_UF16; #through;
        case .BC6H_SF16; #through;
        case .BC7_Typeless; #through;
        case .BC7_UNorm; #through;
        case .BC7_UNorm_SRGB;
        return 8;
    }
    return 0;
}

Load :: (using dds_file : *DDSFile, filepath : string) -> Result {
    
    file, success := file_open(filepath);
    defer file_close(*file);
    
    if !success return .ErrorFileOpen;
    
    length := file_length(file);
    buffer := cast(*u8) alloc(length);
       
    success =  file_read(file, buffer, length);
    if !success return .ErrorRead;
    
    view : [] u8;
    view.data  = buffer;
    view.count = length;
    
    return Load(dds_file, view);
}

Load :: (using dds_file : *DDSFile, data : [] u8) -> Result {
    if data.count < 4 return .ErrorSize;
    
    if data[0] != Magic[0] return .ErrorMagicWord;
    if data[1] != Magic[1] return .ErrorMagicWord;
    if data[2] != Magic[2] return .ErrorMagicWord;
    if data[3] != Magic[3] return .ErrorMagicWord;
    
    
    if data.count < 4 + size_of(Header) return .ErrorSize;
    
    header := cast(*Header) (data.data + 4);
    if header.m_size != size_of(Header) || header.m_pixelFormat.m_size != size_of(PixelFormat)
        return .ErrorVerify;
    
    dxt10Header := false;
    if (header.m_pixelFormat.m_flags & .FourCC) && (header.m_pixelFormat.m_fourCC == MakeFourCC("DX10")) {
        if data.count < 4 + size_of(Header) + size_of(HeaderDXT10) return .ErrorSize;
        dxt10Header = true;
    }
    offset := 4 + size_of(Header);
    if dxt10Header offset += size_of(HeaderDXT10);
    
    m_height    = header.m_height;
    m_width     = header.m_width;
    m_texDim    = .Unknown;
    m_arraySize = 1;
    m_format    = .Unknown;
    m_isCubemap = false;
    m_mipCount  = header.m_mipMapCount;
    if m_mipCount == 0 m_mipCount = 1;
    
    if dxt10Header {
        dxt10Header := cast(*HeaderDXT10) header + size_of(Header);
        m_arraySize = dxt10Header.m_arraySize;
        if m_arraySize == 0 return .ErrorInvalidData;
        
        
        if dxt10Header.m_format == {
            case .AI44; #through;
            case .IA44; #through;
            case .P8;   #through;
            case .A8P8;
                return .ErrorNotSupported;
            case;
                if GetBitsPerPixel(dxt10Header.m_format) == 0 return .ErrorNotSupported;
        }
        
        m_format = dxt10Header.m_format;
        
        if dxt10Header.m_resourceDimension == {
            case .Texture1D;
            if header.m_flags & .Height && m_height != 1  return .ErrorInvalidData;
            m_height = 1;
            m_depth = 1;
            case .Texture2D;
            if dxt10Header.m_miscFlag & .TextureCube {
                m_arraySize *= 6;
                m_isCubemap = true;
            }
            m_depth = 1;
            case .Texture3D;
            if header.m_flags & .Volume == 0 return .ErrorInvalidData;
            if m_arraySize > 1               return .ErrorNotSupported;
            case;
            return .ErrorNotSupported;
        }
        
        m_texDim = dxt10Header.m_resourceDimension;
    } else {
        m_format = GetDXGIFormat(header.m_pixelFormat);
        if m_format == .Unknown return .ErrorNotSupported;
        
        if header.m_flags & .Volume {
            m_texDim = .Texture3D;
        } else {
            if header.m_caps2 != 0 {
                if header.m_caps2 & .CubemapAllFaces != 0 return .ErrorNotSupported;
                m_arraySize = 6;
                m_isCubemap = true;
            }
            
            m_depth = 1;
            m_texDim = .Texture2D;
        }
    }
    
    imageDatas : [..] ImageData;
    defer array_free(imageDatas);
    array_resize(*imageDatas, m_mipCount * m_arraySize);
    
    srcBits := data.data + offset;
    endBits := data.data + data.count;
    idx := 0;
    for j : 0..m_arraySize-1 {
        w := m_width;
        h := m_height;
        d := m_depth;
        for i : 0..m_mipCount-1 {
            numBytes, rowBytes, numRows := GetImageInfo(w, h, m_format);
            
            imageDatas[idx].m_width = w;
            imageDatas[idx].m_height = h;
            imageDatas[idx].m_depth = d;
            imageDatas[idx].m_mem = srcBits;
            imageDatas[idx].m_memPitch = rowBytes;
            imageDatas[idx].m_memSlicePitch = numBytes;
            idx += 1;
            
            if srcBits + (numBytes * d) > endBits
                return .ErrorInvalidData;
            
            srcBits += numBytes * d;
            w = max(w / 2, 1);
            h = max(h / 2, 1);
            d = max(d / 2, 1);
        }
    }
    
    Swap(*m_imageDatas.data,  *imageDatas.data);
    Swap(*m_imageDatas.count, *imageDatas.count);
    
    return .Success;
}

Unload :: (using dds_file : *DDSFile) {
    array_free(m_dds);
    array_free(m_imageDatas);
}

GetImageData :: (using dds_file : *DDSFile, mipIdx : u32 = 0, arrayIdx : u32 = 0) -> *ImageData {
    if mipIdx < m_mipCount && arrayIdx < m_arraySize {
        return *m_imageDatas[m_mipCount * arrayIdx + mipIdx];
    }
    return null;
}

Flip :: (using dds_file : *DDSFile) -> bool {
    //@Incomplete
    return false;
}



#scope_file
GetImageInfo :: (w : u32, h : u32, fmt : DXGIFormat) -> outNumBytes : u32, outRowBytes : u32, outNumRows : u32 {
    numBytes :u32= 0;
    rowBytes :u32= 0;
    numRows  :u32= 0;
    
    bc     := false;
    packed := false;
    planar := false;
    bpe    :u32= 0;
    
    if fmt == {
        case .BC1_Typeless; #through;
        case .BC1_UNorm; #through;
        case .BC1_UNorm_SRGB; #through;
        case .BC4_Typeless; #through;
        case .BC4_UNorm; #through;
        case .BC4_SNorm;
        bc = true;
        bpe = 8;
        
        case .BC2_Typeless; #through;
        case .BC2_UNorm; #through;
        case .BC2_UNorm_SRGB; #through;
        case .BC3_Typeless; #through;
        case .BC3_UNorm; #through;
        case .BC3_UNorm_SRGB; #through;
        case .BC5_Typeless; #through;
        case .BC5_UNorm; #through;
        case .BC5_SNorm; #through;
        case .BC6H_Typeless; #through;
        case .BC6H_UF16; #through;
        case .BC6H_SF16; #through;
        case .BC7_Typeless; #through;
        case .BC7_UNorm; #through;
        case .BC7_UNorm_SRGB;
        bc = true;
        bpe = 16;
        
        case .R8G8_B8G8_UNorm; #through;
        case .G8R8_G8B8_UNorm; #through;
        case .YUY2;
        packed = true;
        bpe = 4;
        
        case .Y210; #through;
        case .Y216;
        packed = true;
        bpe = 8;
        
        case .NV12; #through;
        case .YUV420_OPAQUE;
        planar = true;
        bpe = 2;
        
        case .P010; #through;
        case .P016;
        planar = true;
        bpe = 4;
    }
    
    if bc {
        numBlocksWide :u32= 0;
        numBlocksHigh :u32= 0;
        if w > 0 numBlocksWide = max((w + 3) / 4, 1);
        if h > 0 numBlocksHigh = max((h + 3) / 4, 1);
        rowBytes = numBlocksWide * bpe;
        numRows  = numBlocksHigh;
        numBytes = rowBytes * numBlocksHigh;
    } else if packed {
        rowBytes = ((w + 1) >> 1) * bpe;
        numRows  = h;
        numBytes = rowBytes * h;
    } else if (fmt == .NV11) {
        rowBytes = ((w + 3) >> 2) * 4;
        numRows  = h * 2;
        numBytes = rowBytes + numRows;
    } else if planar {
        rowBytes = ((w + 1) >> 1) * bpe;
        numBytes = (rowBytes * h) + ((rowBytes * h + 1) >> 1);
        numRows  = h + ((h + 1) >> 1);
    } else {
        bpp     := GetBitsPerPixel(fmt);
        rowBytes = (w * bpp + 7) / 8;
        numRows  = h;
        numBytes = rowBytes * h;
    }
    
    return numBytes, rowBytes, numRows;
}
/*
bool FlipImage(ImageData& imageData);
bool FlipCompressedImage(ImageData& imageData);
void FlipCompressedImageBC1(ImageData& imageData);
void FlipCompressedImageBC2(ImageData& imageData);
void FlipCompressedImageBC3(ImageData& imageData);
void FlipCompressedImageBC4(ImageData& imageData);
void FlipCompressedImageBC5(ImageData& imageData);
*/


HeaderFlagBits :: enum u32 {
    Height     :: 0x00000002;
    Width      :: 0x00000004;
    Texture    :: 0x00001007;
    Mipmap     :: 0x00020000;
    Volume     :: 0x00800000;
    Pitch      :: 0x00000008;
    LinearSize :: 0x00080000;
}

HeaderCaps2FlagBits :: enum u32 {
    CubemapPositiveX :: 0x00000600;
    CubemapNegativeX :: 0x00000a00;
    CubemapPositiveY :: 0x00001200;
    CubemapNegativeY :: 0x00002200;
    CubemapPositiveZ :: 0x00004200;
    CubemapNegativeZ :: 0x00008200;
    CubemapAllFaces  :: HeaderCaps2FlagBits.CubemapPositiveX | .CubemapNegativeX |
        .CubemapPositiveY | .CubemapNegativeY |
        .CubemapPositiveZ | .CubemapNegativeZ;
    Volume           :: 0x00200000;
}

PixelFormatFlagBits :: enum u32 {
    FourCC      :: 0x00000004;
    RGB         :: 0x00000040;
    RGBA        :: 0x00000041;
    Luminance   :: 0x00020000;
    LuminanceA  :: 0x00020001;
    AlphaPixels :: 0x00000001;
    Alpha       :: 0x00000002;
    Palette8    :: 0x00000020;
    Palette8A   :: 0x00000021;
    BumpDUDV    :: 0x00080000;
}

PixelFormat :: struct {
    m_size:     u32;
    m_flags:    PixelFormatFlagBits;
    m_fourCC:   u32;
    m_bitCount: u32;
    m_RBitMask: u32;
    m_GBitMask: u32;
    m_BBitMask: u32;
    m_ABitMask: u32;
}

Header :: struct {
    m_size:             u32;
    m_flags:            HeaderFlagBits;
    m_height:           u32;
    m_width:            u32;
    m_pitchOrLinerSize: u32;
    m_depth:            u32;
    m_mipMapCount:      u32;
    m_reserved1:        [11] u32;
    m_pixelFormat:      PixelFormat;
    m_caps:             u32;
    m_caps2:            HeaderCaps2FlagBits;
    m_caps3:            u32;
    m_caps4:            u32;
    m_reserved2:        u32;
}

DXT10MiscFlagBits :: enum u32 {
    TextureCube :: 4;
}

HeaderDXT10 :: struct {
    m_format:            DXGIFormat;
    m_resourceDimension: TextureDimension;
    m_miscFlag:          DXT10MiscFlagBits;
    m_arraySize:         u32;
    m_miscFlag2:         u32;
}

BC1Block :: struct {
    m_color0: u16;
    m_color1: u16;
    m_row0:   u8;
    m_row1:   u8;
    m_row2:   u8;
    m_row3:   u8;
}

BC2Block :: struct {
    m_alphaRow0: u16;
    m_alphaRow1: u16;
    m_alphaRow2: u16;
    m_alphaRow3: u16;
    m_color0:    u16;
    m_color1:    u16;
    m_row0:      u8;
    m_row1:      u8;
    m_row2:      u8;
    m_row3:      u8;
}

BC3Block :: struct {
    m_alpha0:  u8;
    m_alpha1:  u8;
    m_alphaR0: u8;
    m_alphaR1: u8;
    m_alphaR2: u8;
    m_alphaR3: u8;
    m_alphaR4: u8;
    m_alphaR5: u8;
    m_color0:  u16;
    m_color1:  u16;
    m_row0:    u8;
    m_row1:    u8;
    m_row2:    u8;
    m_row3:    u8;
}

BC4Block :: struct {
    m_red0:  u8;
    m_red1:  u8;
    m_redR0: u8;
    m_redR1: u8;
    m_redR2: u8;
    m_redR3: u8;
    m_redR4: u8;
    m_redR5: u8;
}

BC5Block :: struct {
    m_red0:    u8;
    m_red1:    u8;
    m_redR0:   u8;
    m_redR1:   u8;
    m_redR2:   u8;
    m_redR3:   u8;
    m_redR4:   u8;
    m_redR5:   u8;
    m_green0:  u8;
    m_green1:  u8;
    m_greenR0: u8;
    m_greenR1: u8;
    m_greenR2: u8;
    m_greenR3: u8;
    m_greenR4: u8;
    m_greenR5: u8;
}

#import "Basic";
#import "File";