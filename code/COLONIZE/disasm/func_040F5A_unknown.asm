; ============================================================================
; func_040F5A_unknown
; Region   : load_image
; Bytes    : file 0x040F5A..0x040FE9  (143 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040F5A  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
040F5E  57                    PUSH   di                           ; UNKNOWN
040F5F  56                    PUSH   si                           ; UNKNOWN
040F60  8B F0                 MOV    si, ax                       ; UNKNOWN
040F62  2B FF                 SUB    di, di                       ; UNKNOWN
040F64  0B F6                 OR     si, si                       ; UNKNOWN
040F66  7C 7B                 JL     0x40fe3                      ; UNKNOWN
040F68  39 36 14 3E           CMP    word ptr [0x3e14], si        ; UNKNOWN
040F6C  7E 75                 JLE    0x40fe3                      ; UNKNOWN
040F6E  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040F71  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
040F74  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
040F78  2A E4                 SUB    ah, ah                       ; UNKNOWN
040F7A  50                    PUSH   ax                           ; UNKNOWN
040F7B  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
040F7F  50                    PUSH   ax                           ; UNKNOWN
040F80  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
040F85  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040F88  0B C0                 OR     ax, ax                       ; UNKNOWN
040F8A  75 18                 JNE    0x40fa4                      ; UNKNOWN
040F8C  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
040F8F  80 BF 88 88 02        CMP    byte ptr [bx - 0x7778], 2    ; UNKNOWN
040F94  75 4D                 JNE    0x40fe3                      ; UNKNOWN
040F96  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
040F9A  24 0F                 AND    al, 0xf                      ; UNKNOWN
040F9C  2A 87 80 88           SUB    al, byte ptr [bx - 0x7780]   ; UNKNOWN
040FA0  3C 14                 CMP    al, 0x14                     ; UNKNOWN
040FA2  75 3F                 JNE    0x40fe3                      ; UNKNOWN
040FA4  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
040FA7  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
040FAB  24 0F                 AND    al, 0xf                      ; UNKNOWN
040FAD  3A 06 0C 3E           CMP    al, byte ptr [0x3e0c]        ; UNKNOWN
040FB1  75 30                 JNE    0x40fe3                      ; UNKNOWN
040FB3  80 BF 88 88 01        CMP    byte ptr [bx - 0x7778], 1    ; UNKNOWN
040FB8  74 29                 JE     0x40fe3                      ; UNKNOWN
040FBA  80 BF 88 88 06        CMP    byte ptr [bx - 0x7778], 6    ; UNKNOWN
040FBF  74 22                 JE     0x40fe3                      ; UNKNOWN
040FC1  F6 87 84 88 80        TEST   byte ptr [bx - 0x777c], 0x80 ; UNKNOWN
040FC6  74 07                 JE     0x40fcf                      ; UNKNOWN
040FC8  80 BF 82 88 0B        CMP    byte ptr [bx - 0x777e], 0xb  ; UNKNOWN
040FCD  75 14                 JNE    0x40fe3                      ; UNKNOWN
040FCF  56                    PUSH   si                           ; UNKNOWN
040FD0  0E                    PUSH   cs                           ; UNKNOWN
040FD1  E8 F0 F1              CALL   0x401c4                      ; UNKNOWN
040FD4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
040FD7  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
040FDA  38 87 85 88           CMP    byte ptr [bx - 0x777b], al   ; UNKNOWN
040FDE  73 03                 JAE    0x40fe3                      ; UNKNOWN
040FE0  BF 01 00              MOV    di, 1                        ; UNKNOWN
040FE3  8B C7                 MOV    ax, di                       ; UNKNOWN
040FE5  5E                    POP    si                           ; UNKNOWN
040FE6  5F                    POP    di                           ; UNKNOWN
040FE7  C9                    LEAVE                               ; UNKNOWN
040FE8  CB                    RETF                                ; UNKNOWN
