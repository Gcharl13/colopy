; ============================================================================
; func_002DD2_unknown
; Region   : load_image
; Bytes    : file 0x002DD2..0x002E0B  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002DD2  55                    PUSH   bp ; STACK_PUSH
002DD3  8B EC                 MOV    bp, sp ; MOV
002DD5  9A 19 01 5C 07        LCALL  0x75c, 0x119 ; LCALL
002DDA  0B C0                 OR     ax, ax ; LOGIC
002DDC  74 0E                 JE     0x2dec ; CJUMP
002DDE  6A 00                 PUSH   0 ; STACK_PUSH
002DE0  9A 04 00 6E 07        LCALL  0x76e, 4 ; LCALL
002DE5  8B E5                 MOV    sp, bp ; MOV
002DE7  9A 59 00 6E 07        LCALL  0x76e, 0x59 ; LCALL
002DEC  9A F3 01 1F 03        LCALL  0x31f, 0x1f3 ; LCALL
002DF1  6A 03                 PUSH   3 ; STACK_PUSH
002DF3  6A 00                 PUSH   0 ; STACK_PUSH
002DF5  9A 92 00 14 08        LCALL  0x814, 0x92 ; LCALL
002DFA  8B E5                 MOV    sp, bp ; MOV
002DFC  B8 03 00              MOV    ax, 3 ; MOV
002DFF  9A 0A 00 95 02        LCALL  0x295, 0xa ; LCALL
002E04  B8 03 00              MOV    ax, 3 ; MOV
002E07  CD 10                 INT    0x10 ; SYS
002E09  C9                    LEAVE ; EPILOGUE
002E0A  CB                    RETF ; RETURN
