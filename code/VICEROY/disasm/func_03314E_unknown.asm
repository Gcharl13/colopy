; ============================================================================
; func_03314E_unknown
; Region   : overlay
; Bytes    : file 0x03314E..0x03315E  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03314E  C8 60 00 00           ENTER  0x60, 0 ; PROLOGUE
033152  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
033156  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
03315A  2A FF                 SUB    bh, bh ; ARITH
03315C  8B C3                 MOV    ax, bx ; MOV
