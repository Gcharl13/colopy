; ============================================================================
; func_02DEC4_unknown
; Region   : load_image
; Bytes    : file 0x02DEC4..0x02DEDC  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DEC4  55                    PUSH   bp                           ; UNKNOWN
02DEC5  8B EC                 MOV    bp, sp                       ; UNKNOWN
02DEC7  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
02DECB  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
02DECF  2A FF                 SUB    bh, bh                       ; UNKNOWN
02DED1  38 BF BF 0A           CMP    byte ptr [bx + 0xabf], bh    ; UNKNOWN
02DED5  7C 05                 JL     0x2dedc                      ; UNKNOWN
02DED7  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02DEDA  C9                    LEAVE                               ; UNKNOWN
02DEDB  CB                    RETF                                ; UNKNOWN
