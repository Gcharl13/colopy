; ============================================================================
; func_00A1B2_unknown
; Region   : load_image
; Bytes    : file 0x00A1B2..0x00A1CC  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A1B2  55                    PUSH   bp ; STACK_PUSH
00A1B3  8B EC                 MOV    bp, sp ; MOV
00A1B5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A1B8  9A 6C 00 34 03        LCALL  0x334, 0x6c ; LCALL
00A1BD  8B E5                 MOV    sp, bp ; MOV
00A1BF  52                    PUSH   dx ; STACK_PUSH
00A1C0  50                    PUSH   ax ; STACK_PUSH
00A1C1  1E                    PUSH   ds ; STACK_PUSH
00A1C2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A1C5  9A 22 0E 88 13        LCALL  0x1388, 0xe22 ; LCALL
00A1CA  C9                    LEAVE ; EPILOGUE
00A1CB  CB                    RETF ; RETURN
