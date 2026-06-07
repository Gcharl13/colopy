; ============================================================================
; func_0404F9_unknown
; Region   : load_image
; Bytes    : file 0x0404F9..0x040513  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0404F9  55                    PUSH   bp                           ; UNKNOWN
0404FA  8B EC                 MOV    bp, sp                       ; UNKNOWN
0404FC  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0404FF  0B DB                 OR     bx, bx                       ; UNKNOWN
040501  7C 0E                 JL     0x40511                      ; UNKNOWN
040503  8A 4E 08              MOV    cl, byte ptr [bp + 8]        ; UNKNOWN
040506  B0 10                 MOV    al, 0x10                     ; UNKNOWN
040508  D2 E0                 SHL    al, cl                       ; UNKNOWN
04050A  6B DB 1C              IMUL   bx, bx, 0x1c                 ; UNKNOWN
04050D  08 87 83 88           OR     byte ptr [bx - 0x777d], al   ; UNKNOWN
040511  C9                    LEAVE                               ; UNKNOWN
040512  CB                    RETF                                ; UNKNOWN
