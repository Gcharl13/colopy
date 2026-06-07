; ============================================================================
; func_00A192_unknown
; Region   : load_image
; Bytes    : file 0x00A192..0x00A1A2  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A192  55                    PUSH   bp ; STACK_PUSH
00A193  8B EC                 MOV    bp, sp ; MOV
00A195  68 62 06              PUSH   0x662 ; PUSH_CONST
00A198  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A19B  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A1A0  C9                    LEAVE ; EPILOGUE
00A1A1  CB                    RETF ; RETURN
