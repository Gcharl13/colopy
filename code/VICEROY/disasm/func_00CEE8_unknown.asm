; ============================================================================
; func_00CEE8_unknown
; Region   : load_image
; Bytes    : file 0x00CEE8..0x00CF12  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CEE8  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
00CEEC  06                    PUSH   es ; STACK_PUSH
00CEED  57                    PUSH   di ; STACK_PUSH
00CEEE  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
00CEF1  89 0E B2 05           MOV    word ptr [0x5b2], cx ; GLOBAL_LOAD
00CEF5  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00CEF8  89 16 B6 05           MOV    word ptr [0x5b6], dx ; GLOBAL_LOAD
00CEFC  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00CEFF  A3 B4 05              MOV    word ptr [0x5b4], ax ; GLOBAL_LOAD
00CF02  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
00CF05  A3 B8 05              MOV    word ptr [0x5b8], ax ; GLOBAL_LOAD
00CF08  9A 00 00 1C 0D        LCALL  0xd1c, 0 ; LCALL
00CF0D  89 3E C2 05           MOV    word ptr [0x5c2], di ; GLOBAL_LOAD
00CF11  89                    DB     0x89 ; DATA_BYTE
