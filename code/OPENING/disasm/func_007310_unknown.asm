; ============================================================================
; func_007310_unknown
; Region   : load_image
; Bytes    : file 0x007310..0x007329  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007310  55                    PUSH   bp ; STACK_PUSH
007311  8B EC                 MOV    bp, sp ; MOV
007313  56                    PUSH   si ; STACK_PUSH
007314  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
007317  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
00731A  50                    PUSH   ax ; STACK_PUSH
00731B  9A 30 25 52 04        LCALL  0x452, 0x2530 ; LCALL
007320  59                    POP    cx ; STACK_POP
007321  8B DE                 MOV    bx, si ; MOV
007323  81 EB FE 43           SUB    bx, 0x43fe ; ARITH
007327  81                    DB     0x81 ; DATA_BYTE
007328  C3                    DB     0xC3 ; DATA_BYTE
