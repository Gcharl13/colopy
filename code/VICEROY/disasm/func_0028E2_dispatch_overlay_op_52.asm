; ============================================================================
; func_0028E2_unknown
; Region   : load_image
; Bytes    : file 0x0028E2..0x0028F2  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0028E2  55                    PUSH   bp ; STACK_PUSH
0028E3  8B EC                 MOV    bp, sp ; MOV
0028E5  68 52 00              PUSH   0x52 ; PUSH_CONST
0028E8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0028EB  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
0028F0  C9                    LEAVE ; EPILOGUE
0028F1  CB                    RETF ; RETURN
