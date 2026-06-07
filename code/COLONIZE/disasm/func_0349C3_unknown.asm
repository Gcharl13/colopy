; ============================================================================
; func_0349C3_unknown
; Region   : load_image
; Bytes    : file 0x0349C3..0x0349EE  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0349C3  55                    PUSH   bp                           ; UNKNOWN
0349C4  8B EC                 MOV    bp, sp                       ; UNKNOWN
0349C6  6A 01                 PUSH   1                            ; UNKNOWN
0349C8  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
0349CD  8B E5                 MOV    sp, bp                       ; UNKNOWN
0349CF  FF 36 9A 79           PUSH   word ptr [0x799a]            ; UNKNOWN
0349D3  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
0349D8  8B E5                 MOV    sp, bp                       ; UNKNOWN
0349DA  50                    PUSH   ax                           ; UNKNOWN
0349DB  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
0349E0  8B E5                 MOV    sp, bp                       ; UNKNOWN
0349E2  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0349E6  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
0349EA  2A FF                 SUB    bh, bh                       ; UNKNOWN
0349EC  8B C3                 MOV    ax, bx                       ; UNKNOWN
