; ============================================================================
; __aFlmul  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x010530 (50 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: MSC 6.0 32x32 truncated multiply
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x015A3C..0x015A6E  (50 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x010530)
; ============================================================================

015A3C  55                    PUSH   bp ; STACK_PUSH
015A3D  8B EC                 MOV    bp, sp ; MOV
015A3F  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
015A42  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
015A45  0B C8                 OR     cx, ax ; LOGIC
015A47  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
015A4A  75 09                 JNE    0x15a55 ; CJUMP
015A4C  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
015A4F  F7 E1                 MUL    cx ; ARITH
015A51  5D                    POP    bp ; STACK_POP
015A52  CA 08 00              RETF   8 ; RETURN
