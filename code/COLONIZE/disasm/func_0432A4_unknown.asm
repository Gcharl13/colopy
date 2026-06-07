; ============================================================================
; func_0432A4_unknown
; Region   : load_image
; Bytes    : file 0x0432A4..0x043324  (128 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0432A4  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0432A8  56                    PUSH   si                           ; UNKNOWN
0432A9  83 3E 08 3E 00        CMP    word ptr [0x3e08], 0         ; UNKNOWN
0432AE  75 74                 JNE    0x43324                      ; UNKNOWN
0432B0  83 3E 9E 09 00        CMP    word ptr [0x99e], 0          ; UNKNOWN
0432B5  75 6D                 JNE    0x43324                      ; UNKNOWN
0432B7  80 3E A0 09 00        CMP    byte ptr [0x9a0], 0          ; UNKNOWN
0432BC  75 66                 JNE    0x43324                      ; UNKNOWN
0432BE  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
0432C3  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
0432C6  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
0432CA  24 0F                 AND    al, 0xf                      ; UNKNOWN
0432CC  3C 04                 CMP    al, 4                        ; UNKNOWN
0432CE  73 54                 JAE    0x43324                      ; UNKNOWN
0432D0  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
0432D4  24 0F                 AND    al, 0xf                      ; UNKNOWN
0432D6  2A E4                 SUB    ah, ah                       ; UNKNOWN
0432D8  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
0432DB  38 A7 B7 C0           CMP    byte ptr [bx - 0x3f49], ah   ; UNKNOWN
0432DF  75 43                 JNE    0x43324                      ; UNKNOWN
0432E1  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
0432E4  9A 0C 13 B7 36        LCALL  0x36b7, 0x130c               ; UNKNOWN
0432E9  0B C0                 OR     ax, ax                       ; UNKNOWN
0432EB  74 37                 JE     0x43324                      ; UNKNOWN
0432ED  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0432F0  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
0432F3  89 5E FC              MOV    word ptr [bp - 4], bx        ; UNKNOWN
0432F6  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0432FA  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
0432FF  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
043302  38 87 80 88           CMP    byte ptr [bx - 0x7780], al   ; UNKNOWN
043306  75 1C                 JNE    0x43324                      ; UNKNOWN
043308  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
04330B  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
04330F  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
043312  38 87 81 88           CMP    byte ptr [bx - 0x777f], al   ; UNKNOWN
043316  75 0C                 JNE    0x43324                      ; UNKNOWN
043318  6A 01                 PUSH   1                            ; UNKNOWN
04331A  0E                    PUSH   cs                           ; UNKNOWN
04331B  E8 54 FF              CALL   0x43272                      ; UNKNOWN
04331E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
043321  5E                    POP    si                           ; UNKNOWN
043322  C9                    LEAVE                               ; UNKNOWN
043323  CB                    RETF                                ; UNKNOWN
