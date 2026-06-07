; ============================================================================
; func_0559A0_unknown
; Region   : load_image
; Bytes    : file 0x0559A0..0x0559BD  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0559A0  55                    PUSH   bp                           ; UNKNOWN
0559A1  8B EC                 MOV    bp, sp                       ; UNKNOWN
0559A3  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0559A7  80 BF 85 88 00        CMP    byte ptr [bx - 0x777b], 0    ; UNKNOWN
0559AC  74 59                 JE     0x55a07                      ; UNKNOWN
0559AE  80 BF 88 88 0B        CMP    byte ptr [bx - 0x7778], 0xb  ; UNKNOWN
0559B3  75 52                 JNE    0x55a07                      ; UNKNOWN
0559B5  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
0559B9  2A FF                 SUB    bh, bh                       ; UNKNOWN
0559BB  8B C3                 MOV    ax, bx                       ; UNKNOWN
