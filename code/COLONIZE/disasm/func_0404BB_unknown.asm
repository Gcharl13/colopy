; ============================================================================
; func_0404BB_unknown
; Region   : load_image
; Bytes    : file 0x0404BB..0x0404CF  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0404BB  55                    PUSH   bp                           ; UNKNOWN
0404BC  8B EC                 MOV    bp, sp                       ; UNKNOWN
0404BE  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0404C1  0B DB                 OR     bx, bx                       ; UNKNOWN
0404C3  7C 08                 JL     0x404cd                      ; UNKNOWN
0404C5  6B DB 1C              IMUL   bx, bx, 0x1c                 ; UNKNOWN
0404C8  80 A7 83 88 0F        AND    byte ptr [bx - 0x777d], 0xf  ; UNKNOWN
0404CD  C9                    LEAVE                               ; UNKNOWN
0404CE  CB                    RETF                                ; UNKNOWN
