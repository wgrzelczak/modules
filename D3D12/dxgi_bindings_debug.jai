//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



DXGI_DEBUG_BINARY_VERSION :: 1;

DXGI_INFO_QUEUE_MESSAGE_ID_STRING_FROM_APPLICATION :: 0;

DXGI_INFO_QUEUE_DEFAULT_MESSAGE_COUNT_LIMIT :: 1024;

DXGI_DEBUG_RLO_FLAGS :: enum_flags u32 {
    SUMMARY         :: 0x1;
    DETAIL          :: 0x2;
    IGNORE_INTERNAL :: 0x4;
    ALL             :: 0x7;

    DXGI_DEBUG_RLO_SUMMARY         :: SUMMARY;
    DXGI_DEBUG_RLO_DETAIL          :: DETAIL;
    DXGI_DEBUG_RLO_IGNORE_INTERNAL :: IGNORE_INTERNAL;
    DXGI_DEBUG_RLO_ALL             :: ALL;
}

DXGI_DEBUG_ID :: GUID;

DXGI_INFO_QUEUE_MESSAGE_CATEGORY :: enum s32 {
    UNKNOWN               :: 0;
    MISCELLANEOUS         :: 1;
    INITIALIZATION        :: 2;
    CLEANUP               :: 3;
    COMPILATION           :: 4;
    STATE_CREATION        :: 5;
    STATE_SETTING         :: 6;
    STATE_GETTING         :: 7;
    RESOURCE_MANIPULATION :: 8;
    EXECUTION             :: 9;
    SHADER                :: 10;

    DXGI_INFO_QUEUE_MESSAGE_CATEGORY_UNKNOWN               :: UNKNOWN;
    DXGI_INFO_QUEUE_MESSAGE_CATEGORY_MISCELLANEOUS         :: MISCELLANEOUS;
    DXGI_INFO_QUEUE_MESSAGE_CATEGORY_INITIALIZATION        :: INITIALIZATION;
    DXGI_INFO_QUEUE_MESSAGE_CATEGORY_CLEANUP               :: CLEANUP;
    DXGI_INFO_QUEUE_MESSAGE_CATEGORY_COMPILATION           :: COMPILATION;
    DXGI_INFO_QUEUE_MESSAGE_CATEGORY_STATE_CREATION        :: STATE_CREATION;
    DXGI_INFO_QUEUE_MESSAGE_CATEGORY_STATE_SETTING         :: STATE_SETTING;
    DXGI_INFO_QUEUE_MESSAGE_CATEGORY_STATE_GETTING         :: STATE_GETTING;
    DXGI_INFO_QUEUE_MESSAGE_CATEGORY_RESOURCE_MANIPULATION :: RESOURCE_MANIPULATION;
    DXGI_INFO_QUEUE_MESSAGE_CATEGORY_EXECUTION             :: EXECUTION;
    DXGI_INFO_QUEUE_MESSAGE_CATEGORY_SHADER                :: SHADER;
}

DXGI_INFO_QUEUE_MESSAGE_SEVERITY :: enum s32 {
    CORRUPTION :: 0;
    ERROR      :: 1;
    WARNING    :: 2;
    INFO       :: 3;
    MESSAGE    :: 4;

    DXGI_INFO_QUEUE_MESSAGE_SEVERITY_CORRUPTION :: CORRUPTION;
    DXGI_INFO_QUEUE_MESSAGE_SEVERITY_ERROR      :: ERROR;
    DXGI_INFO_QUEUE_MESSAGE_SEVERITY_WARNING    :: WARNING;
    DXGI_INFO_QUEUE_MESSAGE_SEVERITY_INFO       :: INFO;
    DXGI_INFO_QUEUE_MESSAGE_SEVERITY_MESSAGE    :: MESSAGE;
}

DXGI_INFO_QUEUE_MESSAGE_ID :: s32;

DXGI_INFO_QUEUE_MESSAGE :: struct {
    Producer:              DXGI_DEBUG_ID;
    Category:              DXGI_INFO_QUEUE_MESSAGE_CATEGORY;
    Severity:              DXGI_INFO_QUEUE_MESSAGE_SEVERITY;
    ID:                    DXGI_INFO_QUEUE_MESSAGE_ID;

    pDescription:          *u8;
    DescriptionByteLength: SIZE_T;
}

DXGI_INFO_QUEUE_FILTER_DESC :: struct {
    NumCategories: u32;

    pCategoryList: *DXGI_INFO_QUEUE_MESSAGE_CATEGORY;
    NumSeverities: u32;

    pSeverityList: *DXGI_INFO_QUEUE_MESSAGE_SEVERITY;
    NumIDs:        u32;

    pIDList:       *DXGI_INFO_QUEUE_MESSAGE_ID;
}

DXGI_INFO_QUEUE_FILTER :: struct {
    AllowList: DXGI_INFO_QUEUE_FILTER_DESC;
    DenyList:  DXGI_INFO_QUEUE_FILTER_DESC;
}


IDXGIInfoQueue_UUID :: "D67441C7-672A-476f-9E82-CD55B44949CE";
IDXGIInfoQueue :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxgiinfoqueue_vtable: *IDXGIInfoQueue_VTable;
}
IDXGIInfoQueue_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    SetMessageCountLimit: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, MessageCountLimit: u64) -> HRESULT #cpp_method;
    ClearStoredMessages: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> void #cpp_method;
    GetMessageA: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, MessageIndex: u64, pMessage: *DXGI_INFO_QUEUE_MESSAGE, pMessageByteLength: *SIZE_T) -> HRESULT #cpp_method;
    GetNumStoredMessagesAllowedByRetrievalFilters: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> u64 #cpp_method;
    GetNumStoredMessages: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> u64 #cpp_method;
    GetNumMessagesDiscardedByMessageCountLimit: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> u64 #cpp_method;
    GetMessageCountLimit: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> u64 #cpp_method;
    GetNumMessagesAllowedByStorageFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> u64 #cpp_method;
    GetNumMessagesDeniedByStorageFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> u64 #cpp_method;
    AddStorageFilterEntries: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, pFilter: *DXGI_INFO_QUEUE_FILTER) -> HRESULT #cpp_method;
    GetStorageFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, pFilter: *DXGI_INFO_QUEUE_FILTER, pFilterByteLength: *SIZE_T) -> HRESULT #cpp_method;
    ClearStorageFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> void #cpp_method;
    PushEmptyStorageFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> HRESULT #cpp_method;
    PushDenyAllStorageFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> HRESULT #cpp_method;
    PushCopyOfStorageFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> HRESULT #cpp_method;
    PushStorageFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, pFilter: *DXGI_INFO_QUEUE_FILTER) -> HRESULT #cpp_method;
    PopStorageFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> void #cpp_method;
    GetStorageFilterStackSize: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> u32 #cpp_method;
    AddRetrievalFilterEntries: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, pFilter: *DXGI_INFO_QUEUE_FILTER) -> HRESULT #cpp_method;
    GetRetrievalFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, pFilter: *DXGI_INFO_QUEUE_FILTER, pFilterByteLength: *SIZE_T) -> HRESULT #cpp_method;
    ClearRetrievalFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> void #cpp_method;
    PushEmptyRetrievalFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> HRESULT #cpp_method;
    PushDenyAllRetrievalFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> HRESULT #cpp_method;
    PushCopyOfRetrievalFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> HRESULT #cpp_method;
    PushRetrievalFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, pFilter: *DXGI_INFO_QUEUE_FILTER) -> HRESULT #cpp_method;
    PopRetrievalFilter: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> void #cpp_method;
    GetRetrievalFilterStackSize: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> u32 #cpp_method;
    AddMessage: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, Category: DXGI_INFO_QUEUE_MESSAGE_CATEGORY, Severity: DXGI_INFO_QUEUE_MESSAGE_SEVERITY, ID: DXGI_INFO_QUEUE_MESSAGE_ID, pDescription: *u8) -> HRESULT #cpp_method;
    AddApplicationMessage: (this: *IDXGIInfoQueue, Severity: DXGI_INFO_QUEUE_MESSAGE_SEVERITY, pDescription: *u8) -> HRESULT #cpp_method;
    SetBreakOnCategory: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, Category: DXGI_INFO_QUEUE_MESSAGE_CATEGORY, bEnable: BOOL) -> HRESULT #cpp_method;
    SetBreakOnSeverity: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, Severity: DXGI_INFO_QUEUE_MESSAGE_SEVERITY, bEnable: BOOL) -> HRESULT #cpp_method;
    SetBreakOnID: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, ID: DXGI_INFO_QUEUE_MESSAGE_ID, bEnable: BOOL) -> HRESULT #cpp_method;
    GetBreakOnCategory: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, Category: DXGI_INFO_QUEUE_MESSAGE_CATEGORY) -> BOOL #cpp_method;
    GetBreakOnSeverity: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, Severity: DXGI_INFO_QUEUE_MESSAGE_SEVERITY) -> BOOL #cpp_method;
    GetBreakOnID: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, ID: DXGI_INFO_QUEUE_MESSAGE_ID) -> BOOL #cpp_method;
    SetMuteDebugOutput: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID, bMute: BOOL) -> void #cpp_method;
    GetMuteDebugOutput: (this: *IDXGIInfoQueue, Producer: DXGI_DEBUG_ID) -> BOOL #cpp_method;
}
vtable :: (obj: *IDXGIInfoQueue) -> *IDXGIInfoQueue_VTable { return obj.idxgiinfoqueue_vtable; }



IDXGIDebug_UUID :: "119E7452-DE9E-40fe-8806-88F90C12B441";
IDXGIDebug :: struct {
    #as using iunknown: IUnknown;
    #place iunknown; idxgidebug_vtable: *IDXGIDebug_VTable;
}
IDXGIDebug_VTable :: struct #type_info_none {
    using iunknown: IUnknown_VTable;
    ReportLiveObjects: (this: *IDXGIDebug, apiid: GUID, flags: DXGI_DEBUG_RLO_FLAGS) -> HRESULT #cpp_method;
}
vtable :: (obj: *IDXGIDebug) -> *IDXGIDebug_VTable { return obj.idxgidebug_vtable; }



IDXGIDebug1_UUID :: "c5a05f0c-16f2-4adf-9f4d-a8c4d58ac550";
IDXGIDebug1 :: struct {
    #as using idxgidebug: IDXGIDebug;
    #place idxgidebug; idxgidebug1_vtable: *IDXGIDebug1_VTable;
}
IDXGIDebug1_VTable :: struct #type_info_none {
    using idxgidebug: IDXGIDebug_VTable;
    EnableLeakTrackingForThread: (this: *IDXGIDebug1) -> void #cpp_method;
    DisableLeakTrackingForThread: (this: *IDXGIDebug1) -> void #cpp_method;
    IsLeakTrackingEnabledForThread: (this: *IDXGIDebug1) -> BOOL #cpp_method;
}
vtable :: (obj: *IDXGIDebug1) -> *IDXGIDebug1_VTable { return obj.idxgidebug1_vtable; }


#scope_file

