; ============================================================================
; func_0570EA_unknown
; Region   : load_image
; Bytes    : file 0x0570EA..0x05718F  (165 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0570EA  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
0570EE  56                    PUSH   si                           ; UNKNOWN
0570EF  C7 46 F0 FF FF        MOV    word ptr [bp - 0x10], 0xffff ; UNKNOWN
0570F4  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0570F9  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0       ; UNKNOWN
0570FE  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
057102  7C 5B                 JL     0x5715f                      ; UNKNOWN
057104  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
057107  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
05710A  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
05710D  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
057111  2A E4                 SUB    ah, ah                       ; UNKNOWN
057113  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
057116  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
05711A  2A ED                 SUB    ch, ch                       ; UNKNOWN
05711C  89 4E F8              MOV    word ptr [bp - 8], cx        ; UNKNOWN
05711F  51                    PUSH   cx                           ; UNKNOWN
057120  50                    PUSH   ax                           ; UNKNOWN
057121  9A 47 03 C9 33        LCALL  0x33c9, 0x347                ; UNKNOWN
057126  83 C4 04              ADD    sp, 4                        ; UNKNOWN
057129  0B C0                 OR     ax, ax                       ; UNKNOWN
05712B  7C 05                 JL     0x57132                      ; UNKNOWN
05712D  B8 01 00              MOV    ax, 1                        ; UNKNOWN
057130  EB 02                 JMP    0x57134                      ; UNKNOWN
057132  2B C0                 SUB    ax, ax                       ; UNKNOWN
057134  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
057137  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
05713A  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
05713D  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
057142  83 C4 04              ADD    sp, 4                        ; UNKNOWN
057145  0B C0                 OR     ax, ax                       ; UNKNOWN
057147  74 16                 JE     0x5715f                      ; UNKNOWN
057149  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
05714C  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
05714F  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
057154  83 C4 04              ADD    sp, 4                        ; UNKNOWN
057157  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
05715A  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
05715F  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
057162  9A 08 00 B7 36        LCALL  0x36b7, 8                    ; UNKNOWN
057167  EB 3F                 JMP    0x571a8                      ; UNKNOWN
057169  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
05716D  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
057171  24 0F                 AND    al, 0xf                      ; UNKNOWN
057173  3C 04                 CMP    al, 4                        ; UNKNOWN
057175  72 03                 JB     0x5717a                      ; UNKNOWN
057177  D1 66 EE              SHL    word ptr [bp - 0x12], 1      ; UNKNOWN
05717A  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
05717E  75 03                 JNE    0x57183                      ; UNKNOWN
057180  E9 82 00              JMP    0x57205                      ; UNKNOWN
057183  6B 5E F4 1C           IMUL   bx, word ptr [bp - 0xc], 0x1c ; UNKNOWN
057187  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
05718B  2A FF                 SUB    bh, bh                       ; UNKNOWN
05718D  8B C3                 MOV    ax, bx                       ; UNKNOWN
