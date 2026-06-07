; ============================================================================
; func_0351A8_unknown
; Region   : load_image
; Bytes    : file 0x0351A8..0x03523C  (148 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0351A8  C8 64 00 00           ENTER  0x64, 0                      ; UNKNOWN
0351AC  57                    PUSH   di                           ; UNKNOWN
0351AD  56                    PUSH   si                           ; UNKNOWN
0351AE  C7 46 AC 01 00        MOV    word ptr [bp - 0x54], 1      ; UNKNOWN
0351B3  C7 46 AA 64 00        MOV    word ptr [bp - 0x56], 0x64   ; UNKNOWN
0351B8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0351BB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0351BE  9A 3A 32 5F 24        LCALL  0x245f, 0x323a               ; UNKNOWN
0351C3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0351C6  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
0351C9  0B C0                 OR     ax, ax                       ; UNKNOWN
0351CB  7D 47                 JGE    0x35214                      ; UNKNOWN
0351CD  83 3E A6 09 00        CMP    word ptr [0x9a6], 0          ; UNKNOWN
0351D2  75 03                 JNE    0x351d7                      ; UNKNOWN
0351D4  E9 61 04              JMP    0x35638                      ; UNKNOWN
0351D7  6A 01                 PUSH   1                            ; UNKNOWN
0351D9  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
0351DE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0351E1  6A 09                 PUSH   9                            ; UNKNOWN
0351E3  0E                    PUSH   cs                           ; UNKNOWN
0351E4  E8 0C F6              CALL   0x347f3                      ; UNKNOWN
0351E7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0351EA  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0351ED  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0351EF  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
0351F3  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
0351F8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0351FB  6A 0A                 PUSH   0xa                          ; UNKNOWN
0351FD  0E                    PUSH   cs                           ; UNKNOWN
0351FE  E8 F2 F5              CALL   0x347f3                      ; UNKNOWN
035201  83 C4 02              ADD    sp, 2                        ; UNKNOWN
035204  6A 00                 PUSH   0                            ; UNKNOWN
035206  6A 78                 PUSH   0x78                         ; UNKNOWN
035208  6A 03                 PUSH   3                            ; UNKNOWN
03520A  0E                    PUSH   cs                           ; UNKNOWN
03520B  E8 C5 F5              CALL   0x347d3                      ; UNKNOWN
03520E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
035211  E9 24 04              JMP    0x35638                      ; UNKNOWN
035214  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
035218  75 03                 JNE    0x3521d                      ; UNKNOWN
03521A  E9 AE 00              JMP    0x352cb                      ; UNKNOWN
03521D  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
035220  D1 E3                 SHL    bx, 1                        ; UNKNOWN
035222  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
035226  6A 00                 PUSH   0                            ; UNKNOWN
035228  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
03522D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
035230  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
035234  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
035238  2A FF                 SUB    bh, bh                       ; UNKNOWN
03523A  8B C3                 MOV    ax, bx                       ; UNKNOWN
