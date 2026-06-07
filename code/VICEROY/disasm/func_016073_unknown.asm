; ============================================================================
; func_016073_unknown
; Region   : load_image
; Bytes    : file 0x016073..0x016086  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016073  55                    PUSH   bp ; STACK_PUSH
016074  8B EC                 MOV    bp, sp ; MOV
016076  8E D8                 MOV    ds, ax ; MOV
016078  E8 AC 00              CALL   0x16127 ; CALL_NEAR
01607B  26 F7 06 00 00 06 00  TEST   word ptr es:[0], 6 ; LOGIC
016082  74 E4                 JE     0x16068 ; CJUMP
016084  8C C3                 MOV    bx, es ; MOV
