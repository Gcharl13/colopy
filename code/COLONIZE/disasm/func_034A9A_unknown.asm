; ============================================================================
; func_034A9A_unknown
; Region   : load_image
; Bytes    : file 0x034A9A..0x034AB2  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034A9A  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
034A9E  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
034AA2  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
034AA6  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
034AAA  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
034AAE  2A FF                 SUB    bh, bh                       ; UNKNOWN
034AB0  8B C3                 MOV    ax, bx                       ; UNKNOWN
