; ============================================================================
; func_0321B4_unknown
; Region   : overlay
; Bytes    : file 0x0321B4..0x0321CC  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0321B4  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0321B8  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
0321BC  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
0321C0  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
0321C4  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
0321C8  2A FF                 SUB    bh, bh ; ARITH
0321CA  8B C3                 MOV    ax, bx ; MOV
