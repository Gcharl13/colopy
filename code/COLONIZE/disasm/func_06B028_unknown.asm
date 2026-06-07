; ============================================================================
; func_06B028_unknown
; Region   : load_image
; Bytes    : file 0x06B028..0x06B042  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B028  55                    PUSH   bp                           ; UNKNOWN
06B029  8B EC                 MOV    bp, sp                       ; UNKNOWN
06B02B  83 EC 04              SUB    sp, 4                        ; UNKNOWN
06B02E  32 FF                 XOR    bh, bh                       ; UNKNOWN
06B030  80 3E 40 12 03        CMP    byte ptr [0x1240], 3         ; UNKNOWN
06B035  72 03                 JB     0x6b03a                      ; UNKNOWN
06B037  8A 7E 0A              MOV    bh, byte ptr [bp + 0xa]      ; UNKNOWN
06B03A  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
06B03D  89 46 0A              MOV    word ptr [bp + 0xa], ax      ; UNKNOWN
06B040  EB 08                 JMP    0x6b04a                      ; UNKNOWN
