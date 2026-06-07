; ============================================================================
; func_00E702_unknown
; Region   : load_image
; Bytes    : file 0x00E702..0x00E717  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E702  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00E706  52                    PUSH   dx ; STACK_PUSH
00E707  50                    PUSH   ax ; STACK_PUSH
00E708  57                    PUSH   di ; STACK_PUSH
00E709  56                    PUSH   si ; STACK_PUSH
00E70A  8B C8                 MOV    cx, ax ; MOV
00E70C  D1 E0                 SHL    ax, 1 ; LOGIC
00E70E  03 C1                 ADD    ax, cx ; ARITH
00E710  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00E713  8B C2                 MOV    ax, dx ; MOV
00E715  D1 E2                 SHL    dx, 1 ; LOGIC
