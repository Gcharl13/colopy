; ============================================================================
; func_00C0AE_unknown
; Region   : load_image
; Bytes    : file 0x00C0AE..0x00C0D0  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C0AE  55                    PUSH   bp ; STACK_PUSH
00C0AF  8B EC                 MOV    bp, sp ; MOV
00C0B1  6A 01                 PUSH   1 ; STACK_PUSH
00C0B3  9A B4 00 09 00        LCALL  9, 0xb4 ; LCALL
00C0B8  8B E5                 MOV    sp, bp ; MOV
00C0BA  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00C0BD  0E                    PUSH   cs ; STACK_PUSH
00C0BE  E8 D9 FF              CALL   0xc09a ; CALL_NEAR
00C0C1  8B E5                 MOV    sp, bp ; MOV
00C0C3  6A 00                 PUSH   0 ; STACK_PUSH
00C0C5  6A 78                 PUSH   0x78 ; PUSH_CONST
00C0C7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00C0CA  0E                    PUSH   cs ; STACK_PUSH
00C0CB  E8 AC FF              CALL   0xc07a ; CALL_NEAR
00C0CE  C9                    LEAVE ; EPILOGUE
00C0CF  CB                    RETF ; RETURN
