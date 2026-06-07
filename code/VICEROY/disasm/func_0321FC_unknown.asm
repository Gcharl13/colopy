; ============================================================================
; func_0321FC_unknown
; Region   : overlay
; Bytes    : file 0x0321FC..0x032214  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0321FC  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
032200  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
032204  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
032208  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
03220C  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
032210  2A FF                 SUB    bh, bh ; ARITH
032212  8B C3                 MOV    ax, bx ; MOV
