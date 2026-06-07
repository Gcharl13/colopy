; ============================================================================
; func_00A0D0_unknown
; Region   : load_image
; Bytes    : file 0x00A0D0..0x00A0E0  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A0D0  55                    PUSH   bp ; STACK_PUSH
00A0D1  8B EC                 MOV    bp, sp ; MOV
00A0D3  68 4A 06              PUSH   0x64a ; PUSH_CONST
00A0D6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A0D9  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A0DE  C9                    LEAVE ; EPILOGUE
00A0DF  CB                    RETF ; RETURN
