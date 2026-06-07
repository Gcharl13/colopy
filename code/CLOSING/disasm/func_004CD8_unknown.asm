; ============================================================================
; __aFlmul  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x010530 (50 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: MSC 6.0 32x32 truncated multiply
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x004CD8..0x004D0A  (50 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x010530)
; ============================================================================

004CD8  55                    PUSH   bp ; STACK_PUSH
004CD9  8B EC                 MOV    bp, sp ; MOV
004CDB  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
004CDE  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
004CE1  0B C8                 OR     cx, ax ; LOGIC
004CE3  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
004CE6  75 09                 JNE    0x4cf1 ; CJUMP
004CE8  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
004CEB  F7 E1                 MUL    cx ; ARITH
004CED  5D                    POP    bp ; STACK_POP
004CEE  CA 08 00              RETF   8 ; RETURN
