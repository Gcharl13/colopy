; ============================================================================
; func_034A52_unknown
; Region   : load_image
; Bytes    : file 0x034A52..0x034A6A  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034A52  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
034A56  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
034A5A  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
034A5E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
034A62  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
034A66  2A FF                 SUB    bh, bh                       ; UNKNOWN
034A68  8B C3                 MOV    ax, bx                       ; UNKNOWN
