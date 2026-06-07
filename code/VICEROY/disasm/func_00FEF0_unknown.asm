; ============================================================================
; func_00FEF0_unknown
; Region   : load_image
; Bytes    : file 0x00FEF0..0x00FEFB  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FEF0  55                    PUSH   bp ; STACK_PUSH
00FEF1  8B EC                 MOV    bp, sp ; MOV
00FEF3  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00FEF6  2D 20 00              SUB    ax, 0x20 ; ARITH
00FEF9  5D                    POP    bp ; STACK_POP
00FEFA  CB                    RETF ; RETURN
