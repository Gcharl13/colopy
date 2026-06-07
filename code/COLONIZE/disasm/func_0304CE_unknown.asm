; ============================================================================
; func_0304CE_unknown
; Region   : load_image
; Bytes    : file 0x0304CE..0x0304F7  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0304CE  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0304D2  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0304D7  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0304DB  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
0304DD  2A E4                 SUB    ah, ah                       ; UNKNOWN
0304DF  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
0304E2  2A F6                 SUB    dh, dh                       ; UNKNOWN
0304E4  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
0304E9  EB 28                 JMP    0x30513                      ; UNKNOWN
0304EB  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c  ; UNKNOWN
0304EF  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
0304F3  2A FF                 SUB    bh, bh                       ; UNKNOWN
0304F5  8B C3                 MOV    ax, bx                       ; UNKNOWN
