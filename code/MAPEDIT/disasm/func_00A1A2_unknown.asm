; ============================================================================
; func_00A1A2_unknown
; Region   : load_image
; Bytes    : file 0x00A1A2..0x00A1B2  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A1A2  55                    PUSH   bp ; STACK_PUSH
00A1A3  8B EC                 MOV    bp, sp ; MOV
00A1A5  68 64 06              PUSH   0x664 ; PUSH_CONST
00A1A8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A1AB  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A1B0  C9                    LEAVE ; EPILOGUE
00A1B1  CB                    RETF ; RETURN
