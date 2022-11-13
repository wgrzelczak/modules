//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



STB_RECT_PACK_VERSION :: 1;

STBRP__MAXVAL :: 0x7fffffff;

STBTT_MACSTYLE_DONTCARE :: 0;
STBTT_MACSTYLE_BOLD :: 1;
STBTT_MACSTYLE_ITALIC :: 2;
STBTT_MACSTYLE_UNDERSCORE :: 4;
STBTT_MACSTYLE_NONE :: 8;

STBTT_MAX_OVERSAMPLE :: 8;

STBTT_RASTERIZER_VERSION :: 2;

STBTT__OVER_MASK :: STBTT_MAX_OVERSAMPLE-1;

stbrp_coord :: s32;

stbrp_pack_rects :: (_context: *stbrp_context, rects: *stbrp_rect, num_rects: s32) -> s32 #foreign stb_tt;

stbrp_rect :: struct {
    id:         s32;

    w:          stbrp_coord;
    h:          stbrp_coord;

    x:          stbrp_coord;
    y:          stbrp_coord;
    was_packed: s32;
}

stbrp_init_target :: (_context: *stbrp_context, width: s32, height: s32, nodes: *stbrp_node, num_nodes: s32) -> void #foreign stb_tt;

stbrp_setup_allow_out_of_mem :: (_context: *stbrp_context, allow_out_of_mem: s32) -> void #foreign stb_tt;

stbrp_setup_heuristic :: (_context: *stbrp_context, heuristic: s32) -> void #foreign stb_tt;

STBRP_HEURISTIC_Skyline :: enum s32 {
    default       :: 0;
    BL_sortHeight :: 0;
    BF_sortHeight :: 1;

    STBRP_HEURISTIC_Skyline_default       :: default;
    STBRP_HEURISTIC_Skyline_BL_sortHeight :: BL_sortHeight;
    STBRP_HEURISTIC_Skyline_BF_sortHeight :: BF_sortHeight;
}

stbrp_node :: struct {
    x:    stbrp_coord;
    y:    stbrp_coord;
    next: *stbrp_node;
}

stbrp_context :: struct {
    width:       s32;
    height:      s32;
    align:       s32;
    init_mode:   s32;
    heuristic:   s32;
    num_nodes:   s32;
    active_head: *stbrp_node;
    free_head:   *stbrp_node;
    extra:       [2] stbrp_node;
}

anon_enum :: enum s32 {
    STBRP__INIT_skyline :: 1;
}

stbrp__findresult :: struct {
    x:         s32;
    y:         s32;
    prev_link: **stbrp_node;
}

stbtt_uint8 :: u8;
stbtt_int8 :: s8;
stbtt_uint16 :: u16;
stbtt_int16 :: s16;
stbtt_uint32 :: u32;
stbtt_int32 :: s32;

stbtt__check_size32 :: [1] u8;
stbtt__check_size16 :: [1] u8;

stbtt__buf :: struct {
    data:   *u8;
    cursor: s32;
    size:   s32;
}

stbtt_bakedchar :: struct {
    x0:       u16;
    y0:       u16;
    x1:       u16;
    y1:       u16;
    xoff:     float;
    yoff:     float;
    xadvance: float;
}

stbtt_BakeFontBitmap :: (data: *u8, offset: s32, pixel_height: float, pixels: *u8, pw: s32, ph: s32, first_char: s32, num_chars: s32, chardata: *stbtt_bakedchar) -> s32 #foreign stb_tt;

stbtt_aligned_quad :: struct {
    x0: float;
    y0: float;
    s0: float;
    t0: float;
    x1: float;
    y1: float;
    s1: float;
    t1: float;
}

stbtt_GetBakedQuad :: (chardata: *stbtt_bakedchar, pw: s32, ph: s32, char_index: s32, xpos: *float, ypos: *float, q: *stbtt_aligned_quad, opengl_fillrule: s32) -> void #foreign stb_tt;

stbtt_GetScaledFontVMetrics :: (fontdata: *u8, index: s32, size: float, ascent: *float, descent: *float, lineGap: *float) -> void #foreign stb_tt;

stbtt_packedchar :: struct {
    x0:       u16;
    y0:       u16;
    x1:       u16;
    y1:       u16;
    xoff:     float;
    yoff:     float;
    xadvance: float;
    xoff2:    float;
    yoff2:    float;
}

stbtt_PackBegin :: (spc: *stbtt_pack_context, pixels: *u8, width: s32, height: s32, stride_in_bytes: s32, padding: s32, alloc_context: *void) -> s32 #foreign stb_tt;

stbtt_PackEnd :: (spc: *stbtt_pack_context) -> void #foreign stb_tt;

stbtt_PackFontRange :: (spc: *stbtt_pack_context, fontdata: *u8, font_index: s32, font_size: float, first_unicode_char_in_range: s32, num_chars_in_range: s32, chardata_for_range: *stbtt_packedchar) -> s32 #foreign stb_tt;

stbtt_pack_range :: struct {
    font_size:                        float;
    first_unicode_codepoint_in_range: s32;
    array_of_unicode_codepoints:      *s32;
    num_chars:                        s32;
    chardata_for_range:               *stbtt_packedchar;
    h_oversample:                     u8;
    v_oversample:                     u8;
}

stbtt_PackFontRanges :: (spc: *stbtt_pack_context, fontdata: *u8, font_index: s32, ranges: *stbtt_pack_range, num_ranges: s32) -> s32 #foreign stb_tt;

stbtt_PackSetOversampling :: (spc: *stbtt_pack_context, h_oversample: u32, v_oversample: u32) -> void #foreign stb_tt;

stbtt_PackSetSkipMissingCodepoints :: (spc: *stbtt_pack_context, skip: s32) -> void #foreign stb_tt;

stbtt_GetPackedQuad :: (chardata: *stbtt_packedchar, pw: s32, ph: s32, char_index: s32, xpos: *float, ypos: *float, q: *stbtt_aligned_quad, align_to_integer: s32) -> void #foreign stb_tt;

stbtt_PackFontRangesGatherRects :: (spc: *stbtt_pack_context, info: *stbtt_fontinfo, ranges: *stbtt_pack_range, num_ranges: s32, rects: *stbrp_rect) -> s32 #foreign stb_tt;

stbtt_PackFontRangesPackRects :: (spc: *stbtt_pack_context, rects: *stbrp_rect, num_rects: s32) -> void #foreign stb_tt;

stbtt_PackFontRangesRenderIntoRects :: (spc: *stbtt_pack_context, info: *stbtt_fontinfo, ranges: *stbtt_pack_range, num_ranges: s32, rects: *stbrp_rect) -> s32 #foreign stb_tt;

stbtt_pack_context :: struct {
    user_allocator_context: *void;
    pack_info:              *void;
    width:                  s32;
    height:                 s32;
    stride_in_bytes:        s32;
    padding:                s32;
    skip_missing:           s32;
    h_oversample:           u32;
    v_oversample:           u32;
    pixels:                 *u8;
    nodes:                  *void;
}

stbtt_GetNumberOfFonts :: (data: *u8) -> s32 #foreign stb_tt;

stbtt_GetFontOffsetForIndex :: (data: *u8, index: s32) -> s32 #foreign stb_tt;

stbtt_fontinfo :: struct {
    userdata:         *void;
    data:             *u8;
    fontstart:        s32;

    numGlyphs:        s32;

    loca:             s32;
    head:             s32;
    glyf:             s32;
    hhea:             s32;
    hmtx:             s32;
    kern:             s32;
    gpos:             s32;
    svg:              s32;
    index_map:        s32;
    indexToLocFormat: s32;

    cff:              stbtt__buf;
    charstrings:      stbtt__buf;
    gsubrs:           stbtt__buf;
    subrs:            stbtt__buf;
    fontdicts:        stbtt__buf;
    fdselect:         stbtt__buf;
}

stbtt_InitFont :: (info: *stbtt_fontinfo, data: *u8, offset: s32) -> s32 #foreign stb_tt;

stbtt_FindGlyphIndex :: (info: *stbtt_fontinfo, unicode_codepoint: s32) -> s32 #foreign stb_tt;

stbtt_ScaleForPixelHeight :: (info: *stbtt_fontinfo, pixels: float) -> float #foreign stb_tt;

stbtt_ScaleForMappingEmToPixels :: (info: *stbtt_fontinfo, pixels: float) -> float #foreign stb_tt;

stbtt_GetFontVMetrics :: (info: *stbtt_fontinfo, ascent: *s32, descent: *s32, lineGap: *s32) -> void #foreign stb_tt;

stbtt_GetFontVMetricsOS2 :: (info: *stbtt_fontinfo, typoAscent: *s32, typoDescent: *s32, typoLineGap: *s32) -> s32 #foreign stb_tt;

stbtt_GetFontBoundingBox :: (info: *stbtt_fontinfo, x0: *s32, y0: *s32, x1: *s32, y1: *s32) -> void #foreign stb_tt;

stbtt_GetCodepointHMetrics :: (info: *stbtt_fontinfo, codepoint: s32, advanceWidth: *s32, leftSideBearing: *s32) -> void #foreign stb_tt;

stbtt_GetCodepointKernAdvance :: (info: *stbtt_fontinfo, ch1: s32, ch2: s32) -> s32 #foreign stb_tt;

stbtt_GetCodepointBox :: (info: *stbtt_fontinfo, codepoint: s32, x0: *s32, y0: *s32, x1: *s32, y1: *s32) -> s32 #foreign stb_tt;

stbtt_GetGlyphHMetrics :: (info: *stbtt_fontinfo, glyph_index: s32, advanceWidth: *s32, leftSideBearing: *s32) -> void #foreign stb_tt;

stbtt_GetGlyphKernAdvance :: (info: *stbtt_fontinfo, glyph1: s32, glyph2: s32) -> s32 #foreign stb_tt;

stbtt_GetGlyphBox :: (info: *stbtt_fontinfo, glyph_index: s32, x0: *s32, y0: *s32, x1: *s32, y1: *s32) -> s32 #foreign stb_tt;

stbtt_kerningentry :: struct {
    glyph1:  s32;
    glyph2:  s32;
    advance: s32;
}

stbtt_GetKerningTableLength :: (info: *stbtt_fontinfo) -> s32 #foreign stb_tt;

stbtt_GetKerningTable :: (info: *stbtt_fontinfo, table: *stbtt_kerningentry, table_length: s32) -> s32 #foreign stb_tt;

STBTT :: enum s32 {
    vmove  :: 1;
    vline  :: 2;
    vcurve :: 3;
    vcubic :: 4;

    STBTT_vmove  :: vmove;
    STBTT_vline  :: vline;
    STBTT_vcurve :: vcurve;
    STBTT_vcubic :: vcubic;
}

stbtt_vertex :: struct {
    x:       s16;
    y:       s16;
    cx:      s16;
    cy:      s16;
    cx1:     s16;
    cy1:     s16;
    type:    u8;
    padding: u8;
}

stbtt_IsGlyphEmpty :: (info: *stbtt_fontinfo, glyph_index: s32) -> s32 #foreign stb_tt;

stbtt_GetCodepointShape :: (info: *stbtt_fontinfo, unicode_codepoint: s32, vertices: **stbtt_vertex) -> s32 #foreign stb_tt;

stbtt_GetGlyphShape :: (info: *stbtt_fontinfo, glyph_index: s32, vertices: **stbtt_vertex) -> s32 #foreign stb_tt;

stbtt_FreeShape :: (info: *stbtt_fontinfo, vertices: *stbtt_vertex) -> void #foreign stb_tt;

stbtt_FindSVGDoc :: (info: *stbtt_fontinfo, gl: s32) -> *u8 #foreign stb_tt;

stbtt_GetCodepointSVG :: (info: *stbtt_fontinfo, unicode_codepoint: s32, svg: **u8) -> s32 #foreign stb_tt;

stbtt_GetGlyphSVG :: (info: *stbtt_fontinfo, gl: s32, svg: **u8) -> s32 #foreign stb_tt;

stbtt_FreeBitmap :: (bitmap: *u8, userdata: *void) -> void #foreign stb_tt;

stbtt_GetCodepointBitmap :: (info: *stbtt_fontinfo, scale_x: float, scale_y: float, codepoint: s32, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stb_tt;

stbtt_GetCodepointBitmapSubpixel :: (info: *stbtt_fontinfo, scale_x: float, scale_y: float, shift_x: float, shift_y: float, codepoint: s32, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stb_tt;

stbtt_MakeCodepointBitmap :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, codepoint: s32) -> void #foreign stb_tt;

stbtt_MakeCodepointBitmapSubpixel :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, codepoint: s32) -> void #foreign stb_tt;

stbtt_MakeCodepointBitmapSubpixelPrefilter :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, oversample_x: s32, oversample_y: s32, sub_x: *float, sub_y: *float, codepoint: s32) -> void #foreign stb_tt;

stbtt_GetCodepointBitmapBox :: (font: *stbtt_fontinfo, codepoint: s32, scale_x: float, scale_y: float, ix0: *s32, iy0: *s32, ix1: *s32, iy1: *s32) -> void #foreign stb_tt;

stbtt_GetCodepointBitmapBoxSubpixel :: (font: *stbtt_fontinfo, codepoint: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, ix0: *s32, iy0: *s32, ix1: *s32, iy1: *s32) -> void #foreign stb_tt;

stbtt_GetGlyphBitmap :: (info: *stbtt_fontinfo, scale_x: float, scale_y: float, glyph: s32, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stb_tt;

stbtt_GetGlyphBitmapSubpixel :: (info: *stbtt_fontinfo, scale_x: float, scale_y: float, shift_x: float, shift_y: float, glyph: s32, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stb_tt;

stbtt_MakeGlyphBitmap :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, glyph: s32) -> void #foreign stb_tt;

stbtt_MakeGlyphBitmapSubpixel :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, glyph: s32) -> void #foreign stb_tt;

stbtt_MakeGlyphBitmapSubpixelPrefilter :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, oversample_x: s32, oversample_y: s32, sub_x: *float, sub_y: *float, glyph: s32) -> void #foreign stb_tt;

stbtt_GetGlyphBitmapBox :: (font: *stbtt_fontinfo, glyph: s32, scale_x: float, scale_y: float, ix0: *s32, iy0: *s32, ix1: *s32, iy1: *s32) -> void #foreign stb_tt;

stbtt_GetGlyphBitmapBoxSubpixel :: (font: *stbtt_fontinfo, glyph: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, ix0: *s32, iy0: *s32, ix1: *s32, iy1: *s32) -> void #foreign stb_tt;

stbtt__bitmap :: struct {
    w:      s32;
    h:      s32;
    stride: s32;
    pixels: *u8;
}

stbtt_Rasterize :: (result: *stbtt__bitmap, flatness_in_pixels: float, vertices: *stbtt_vertex, num_verts: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, x_off: s32, y_off: s32, invert: s32, userdata: *void) -> void #foreign stb_tt;

stbtt_FreeSDF :: (bitmap: *u8, userdata: *void) -> void #foreign stb_tt;

stbtt_GetGlyphSDF :: (info: *stbtt_fontinfo, scale: float, glyph: s32, padding: s32, onedge_value: u8, pixel_dist_scale: float, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stb_tt;

stbtt_GetCodepointSDF :: (info: *stbtt_fontinfo, scale: float, codepoint: s32, padding: s32, onedge_value: u8, pixel_dist_scale: float, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stb_tt;

stbtt_FindMatchingFont :: (fontdata: *u8, name: *u8, flags: s32) -> s32 #foreign stb_tt;

stbtt_CompareUTF8toUTF16_bigendian :: (s1: *u8, len1: s32, s2: *u8, len2: s32) -> s32 #foreign stb_tt;

stbtt_GetFontNameString :: (font: *stbtt_fontinfo, length: *s32, platformID: s32, encodingID: s32, languageID: s32, nameID: s32) -> *u8 #foreign stb_tt;

STBTT_PLATFORM_ID :: enum s32 {
    UNICODE   :: 0;
    MAC       :: 1;
    ISO       :: 2;
    MICROSOFT :: 3;

    STBTT_PLATFORM_ID_UNICODE   :: UNICODE;
    STBTT_PLATFORM_ID_MAC       :: MAC;
    STBTT_PLATFORM_ID_ISO       :: ISO;
    STBTT_PLATFORM_ID_MICROSOFT :: MICROSOFT;
}

STBTT_UNICODE_EID :: enum s32 {
    UNICODE_1_0      :: 0;
    UNICODE_1_1      :: 1;
    ISO_10646        :: 2;
    UNICODE_2_0_BMP  :: 3;
    UNICODE_2_0_FULL :: 4;

    STBTT_UNICODE_EID_UNICODE_1_0      :: UNICODE_1_0;
    STBTT_UNICODE_EID_UNICODE_1_1      :: UNICODE_1_1;
    STBTT_UNICODE_EID_ISO_10646        :: ISO_10646;
    STBTT_UNICODE_EID_UNICODE_2_0_BMP  :: UNICODE_2_0_BMP;
    STBTT_UNICODE_EID_UNICODE_2_0_FULL :: UNICODE_2_0_FULL;
}

STBTT_MS_EID :: enum s32 {
    SYMBOL       :: 0;
    UNICODE_BMP  :: 1;
    SHIFTJIS     :: 2;
    UNICODE_FULL :: 10;

    STBTT_MS_EID_SYMBOL       :: SYMBOL;
    STBTT_MS_EID_UNICODE_BMP  :: UNICODE_BMP;
    STBTT_MS_EID_SHIFTJIS     :: SHIFTJIS;
    STBTT_MS_EID_UNICODE_FULL :: UNICODE_FULL;
}

STBTT_MAC_EID :: enum s32 {
    ROMAN        :: 0;
    ARABIC       :: 4;
    JAPANESE     :: 1;
    HEBREW       :: 5;
    CHINESE_TRAD :: 2;
    GREEK        :: 6;
    KOREAN       :: 3;
    RUSSIAN      :: 7;

    STBTT_MAC_EID_ROMAN        :: ROMAN;
    STBTT_MAC_EID_ARABIC       :: ARABIC;
    STBTT_MAC_EID_JAPANESE     :: JAPANESE;
    STBTT_MAC_EID_HEBREW       :: HEBREW;
    STBTT_MAC_EID_CHINESE_TRAD :: CHINESE_TRAD;
    STBTT_MAC_EID_GREEK        :: GREEK;
    STBTT_MAC_EID_KOREAN       :: KOREAN;
    STBTT_MAC_EID_RUSSIAN      :: RUSSIAN;
}

STBTT_MS_LANG :: enum s32 {
    ENGLISH  :: 1033;
    ITALIAN  :: 1040;
    CHINESE  :: 2052;
    JAPANESE :: 1041;
    DUTCH    :: 1043;
    KOREAN   :: 1042;
    FRENCH   :: 1036;
    RUSSIAN  :: 1049;
    GERMAN   :: 1031;
    SPANISH  :: 1033;
    HEBREW   :: 1037;
    SWEDISH  :: 1053;

    STBTT_MS_LANG_ENGLISH  :: ENGLISH;
    STBTT_MS_LANG_ITALIAN  :: ITALIAN;
    STBTT_MS_LANG_CHINESE  :: CHINESE;
    STBTT_MS_LANG_JAPANESE :: JAPANESE;
    STBTT_MS_LANG_DUTCH    :: DUTCH;
    STBTT_MS_LANG_KOREAN   :: KOREAN;
    STBTT_MS_LANG_FRENCH   :: FRENCH;
    STBTT_MS_LANG_RUSSIAN  :: RUSSIAN;
    STBTT_MS_LANG_GERMAN   :: GERMAN;
    STBTT_MS_LANG_SPANISH  :: SPANISH;
    STBTT_MS_LANG_HEBREW   :: HEBREW;
    STBTT_MS_LANG_SWEDISH  :: SWEDISH;
}

STBTT_MAC_LANG :: enum s32 {
    ENGLISH            :: 0;
    JAPANESE           :: 11;
    ARABIC             :: 12;
    KOREAN             :: 23;
    DUTCH              :: 4;
    RUSSIAN            :: 32;
    FRENCH             :: 1;
    SPANISH            :: 6;
    GERMAN             :: 2;
    SWEDISH            :: 5;
    HEBREW             :: 10;
    CHINESE_SIMPLIFIED :: 33;
    ITALIAN            :: 3;
    CHINESE_TRAD       :: 19;

    STBTT_MAC_LANG_ENGLISH            :: ENGLISH;
    STBTT_MAC_LANG_JAPANESE           :: JAPANESE;
    STBTT_MAC_LANG_ARABIC             :: ARABIC;
    STBTT_MAC_LANG_KOREAN             :: KOREAN;
    STBTT_MAC_LANG_DUTCH              :: DUTCH;
    STBTT_MAC_LANG_RUSSIAN            :: RUSSIAN;
    STBTT_MAC_LANG_FRENCH             :: FRENCH;
    STBTT_MAC_LANG_SPANISH            :: SPANISH;
    STBTT_MAC_LANG_GERMAN             :: GERMAN;
    STBTT_MAC_LANG_SWEDISH            :: SWEDISH;
    STBTT_MAC_LANG_HEBREW             :: HEBREW;
    STBTT_MAC_LANG_CHINESE_SIMPLIFIED :: CHINESE_SIMPLIFIED;
    STBTT_MAC_LANG_ITALIAN            :: ITALIAN;
    STBTT_MAC_LANG_CHINESE_TRAD       :: CHINESE_TRAD;
}

stbtt__test_oversample_pow2 :: [1] s32;

stbtt__csctx :: struct {
    bounds:       s32;
    started:      s32;
    first_x:      float;
    first_y:      float;
    x:            float;
    y:            float;
    min_x:        stbtt_int32;
    max_x:        stbtt_int32;
    min_y:        stbtt_int32;
    max_y:        stbtt_int32;

    pvertices:    *stbtt_vertex;
    num_vertices: s32;
}

stbtt__hheap_chunk :: struct {
    next: *stbtt__hheap_chunk;
}

stbtt__hheap :: struct {
    head:                        *stbtt__hheap_chunk;
    first_free:                  *void;
    num_remaining_in_head_chunk: s32;
}

stbtt__edge :: struct {
    x0:     float;
    y0:     float;
    x1:     float;
    y1:     float;
    invert: s32;
}

stbtt__active_edge :: struct {
    next:      *stbtt__active_edge;

    fx:        float;
    fdx:       float;
    fdy:       float;
    direction: float;
    sy:        float;
    ey:        float;
}

stbtt__point :: struct {
    x: float;
    y: float;
}

#scope_file

stb_tt :: #foreign_library,no_dll "./stb_tt";
