; ============================================================================
; func_034829_unknown
; Region   : load_image
; Bytes    : file 0x034829..0x0348B2  (137 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034829  55                    PUSH   bp                           ; UNKNOWN
03482A  8B EC                 MOV    bp, sp                       ; UNKNOWN
03482C  6A 01                 PUSH   1                            ; UNKNOWN
03482E  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
034833  8B E5                 MOV    sp, bp                       ; UNKNOWN
034835  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
034839  74 04                 JE     0x3483f                      ; UNKNOWN
03483B  6A 0D                 PUSH   0xd                          ; UNKNOWN
03483D  EB 02                 JMP    0x34841                      ; UNKNOWN
03483F  6A 0E                 PUSH   0xe                          ; UNKNOWN
034841  0E                    PUSH   cs                           ; UNKNOWN
034842  E8 AE FF              CALL   0x347f3                      ; UNKNOWN
034845  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034848  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
03484B  D1 E3                 SHL    bx, 1                        ; UNKNOWN
03484D  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
034851  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
034856  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034859  6A 0C                 PUSH   0xc                          ; UNKNOWN
03485B  0E                    PUSH   cs                           ; UNKNOWN
03485C  E8 94 FF              CALL   0x347f3                      ; UNKNOWN
03485F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034862  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
034865  F7 6E 08              IMUL   word ptr [bp + 8]            ; UNKNOWN
034868  50                    PUSH   ax                           ; UNKNOWN
034869  9A BE 01 2B 3E        LCALL  0x3e2b, 0x1be                ; UNKNOWN
03486E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034871  FF 36 9B 3B           PUSH   word ptr [0x3b9b]            ; UNKNOWN
034875  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
03487A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03487D  1E                    PUSH   ds                           ; UNKNOWN
03487E  68 F1 1F              PUSH   0x1ff1                       ; UNKNOWN
034881  9A 86 01 2B 3E        LCALL  0x3e2b, 0x186                ; UNKNOWN
034886  83 C4 04              ADD    sp, 4                        ; UNKNOWN
034889  FF 36 9A 79           PUSH   word ptr [0x799a]            ; UNKNOWN
03488D  9A BE 05 5F 24        LCALL  0x245f, 0x5be                ; UNKNOWN
034892  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034895  9A 27 02 2B 3E        LCALL  0x3e2b, 0x227                ; UNKNOWN
03489A  1E                    PUSH   ds                           ; UNKNOWN
03489B  68 F3 1F              PUSH   0x1ff3                       ; UNKNOWN
03489E  9A 86 01 2B 3E        LCALL  0x3e2b, 0x186                ; UNKNOWN
0348A3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0348A6  6A 00                 PUSH   0                            ; UNKNOWN
0348A8  6A 00                 PUSH   0                            ; UNKNOWN
0348AA  6A 01                 PUSH   1                            ; UNKNOWN
0348AC  0E                    PUSH   cs                           ; UNKNOWN
0348AD  E8 23 FF              CALL   0x347d3                      ; UNKNOWN
0348B0  C9                    LEAVE                               ; UNKNOWN
0348B1  CB                    RETF                                ; UNKNOWN
