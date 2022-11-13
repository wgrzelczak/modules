#load "dxc_bindings.jai";
#load "dxc_helpers.jai";

BSTR     :: *u16; //*WCHAR
LPOLESTR :: *u16; //*WCHAR
CLSID    :: IID;

CLSID_DxcCompiler            :: CLSID.{0x73e22d93, 0xe6ce, 0x47f3, .[0xb5, 0xbf, 0xf0, 0x66, 0x4f, 0x39, 0xc1, 0xb0]};
CLSID_DxcLinker              :: CLSID.{0xef6a8087, 0xb0ea, 0x4d56, .[0x9e, 0x45, 0xd0, 0x7e, 0x1a, 0x8b, 0x78, 0x6]};
CLSID_DxcDiaDataSource       :: CLSID.{0xcd1f6b73, 0x2ab0, 0x484d, .[0x8e, 0xdc, 0xeb, 0xe7, 0xa4, 0x3c, 0xa0, 0x9f]};
CLSID_DxcCompilerArgs        :: CLSID.{0x3e56ae82, 0x224d, 0x470f, .[0xa1, 0xa1, 0xfe, 0x30, 0x16, 0xee, 0x9f, 0x9d]};
CLSID_DxcLibrary             :: CLSID.{0x6245d6af, 0x66e0, 0x48fd, .[0x80, 0xb4, 0x4d, 0x27, 0x17, 0x96, 0x74, 0x8c]};
CLSID_DxcUtils               :: CLSID_DxcLibrary;
CLSID_DxcValidator           :: CLSID.{0x8ca3e215, 0xf728, 0x4cf3, .[0x8c, 0xdd, 0x88, 0xaf, 0x91, 0x75, 0x87, 0xa1]};
CLSID_DxcAssembler           :: CLSID.{0xd728db68, 0xf903, 0x4f80, .[0x94, 0xcd, 0xdc, 0xcf, 0x76, 0xec, 0x71, 0x51]};
CLSID_DxcContainerReflection :: CLSID.{0xb9f54489, 0x55b8, 0x400c, .[0xba, 0x3a, 0x16, 0x75, 0xe4, 0x72, 0x8b, 0x91]};
CLSID_DxcOptimizer           :: CLSID.{0xae2cd79f, 0xcc22, 0x453f, .[0x9b, 0x6b, 0xb1, 0x24, 0xe7, 0xa5, 0x20, 0x4c]};
CLSID_DxcContainerBuilder    :: CLSID.{0x94134294, 0x411f, 0x4574, .[0xb4, 0xd0, 0x87, 0x41, 0xe2, 0x52, 0x40, 0xd2]};
CLSID_DxcPdbUtils            :: CLSID.{0x54621dfb, 0xf2ce, 0x457e, .[0xae, 0x8c, 0xec, 0x35, 0x5f, 0xae, 0xec, 0x7c]};

IDxcBlob_UUID                :: "8BA5FB08-5195-40e2-AC58-0D989C3A0102";
IDxcBlobEncoding_UUID        :: "7241d424-2646-4191-97c0-98e96e42fc68";
IDxcBlobUtf16_UUID           :: "A3F84EAB-0FAA-497E-A39C-EE6ED60B2D84";
IDxcBlobUtf8_UUID            :: "3DA636C9-BA71-4024-A301-30CBF125305B";
IDxcIncludeHandler_UUID      :: "7f61fc7d-950d-467f-b3e3-3c02fb49187c";
IDxcCompilerArgs_UUID        :: "73EFFE2A-70DC-45F8-9690-EFF64C02429D";
IDxcLibrary_UUID             :: "e5204dc7-d18c-4c3c-bdfb-851673980fe7";
IDxcOperationResult_UUID     :: "CEDB484A-D4E9-445A-B991-CA21CA157DC2";
IDxcCompiler_UUID            :: "8c210bf3-011f-4422-8d70-6f9acb8db617";
IDxcCompiler2_UUID           :: "A005A9D9-B8BB-4594-B5C9-0E633BEC4D37";
IDxcLinker_UUID              :: "F1B5BE2A-62DD-4327-A1C2-42AC1E1E78E6";
IDxcUtils_UUID               :: "4605C4CB-2019-492A-ADA4-65F20BB7D67F";
IDxcResult_UUID              :: "58346CDA-DDE7-4497-9461-6F87AF5E0659";
IDxcExtraOutputs_UUID        :: "319b37a2-a5c2-494a-a5de-4801b2faf989";
IDxcCompiler3_UUID           :: "228B4687-5A6A-4730-900C-9702B2203F54";
IDxcValidator_UUID           :: "A6E82BD2-1FD7-4826-9811-2857E797F49A";
IDxcValidator2_UUID          :: "458e1fd1-b1b2-4750-a6e1-9c10f03bed92";
IDxcContainerBuilder_UUID    :: "334b1f50-2292-4b35-99a1-25588d8c17fe";
IDxcAssembler_UUID           :: "091f7a26-1c1f-4948-904b-e6e3a8a771d5";
IDxcContainerReflection_UUID :: "d2c21b26-8350-4bdc-976a-331ce6f4c54c";
IDxcOptimizerPass_UUID       :: "AE2CD79F-CC22-453F-9B6B-B124E7A5204C";
IDxcOptimizer_UUID           :: "25740E2E-9CBA-401B-9119-4FB42F39F270";
IDxcVersionInfo_UUID         :: "b04f5b50-2059-4f12-a8ff-a1e0cde1cc7e";
IDxcVersionInfo2_UUID        :: "fb6904c4-42f0-4b62-9c46-983af7da7c83";
IDxcVersionInfo3_UUID        :: "5e13e843-9d25-473c-9ad2-03b2d0b44b1e";
IDxcPdbUtils_UUID            :: "E6C9647E-9D6A-4C3B-B94C-524B5A6C343D";