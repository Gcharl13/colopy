; ============================================================================
; func_0336BE_unknown
; Region   : load_image
; Bytes    : file 0x0336BE..0x033778  (186 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0336BE  C8 64 00 00           ENTER  0x64, 0                      ; UNKNOWN
0336C2  56                    PUSH   si                           ; UNKNOWN
0336C3  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
0336C7  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0336CA  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0336CC  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
0336D0  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0336D3  50                    PUSH   ax                           ; UNKNOWN
0336D4  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
0336D9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0336DC  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0336DF  50                    PUSH   ax                           ; UNKNOWN
0336E0  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
0336E5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0336E8  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0336EB  50                    PUSH   ax                           ; UNKNOWN
0336EC  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
0336F1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0336F4  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0336F7  0E                    PUSH   cs                           ; UNKNOWN
0336F8  E8 0C FD              CALL   0x33407                      ; UNKNOWN
0336FB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0336FE  0B C0                 OR     ax, ax                       ; UNKNOWN
033700  74 12                 JE     0x33714                      ; UNKNOWN
033702  FF 36 00 34           PUSH   word ptr [0x3400]            ; UNKNOWN
033706  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033709  50                    PUSH   ax                           ; UNKNOWN
03370A  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
03370F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
033712  EB 74                 JMP    0x33788                      ; UNKNOWN
033714  FF 36 F4 33           PUSH   word ptr [0x33f4]            ; UNKNOWN
033718  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03371B  50                    PUSH   ax                           ; UNKNOWN
03371C  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
033721  83 C4 04              ADD    sp, 4                        ; UNKNOWN
033724  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033727  50                    PUSH   ax                           ; UNKNOWN
033728  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
03372D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033730  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
033733  0E                    PUSH   cs                           ; UNKNOWN
033734  E8 2C F7              CALL   0x32e63                      ; UNKNOWN
033737  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03373A  50                    PUSH   ax                           ; UNKNOWN
03373B  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03373E  16                    PUSH   ss                           ; UNKNOWN
03373F  50                    PUSH   ax                           ; UNKNOWN
033740  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
033745  83 C4 06              ADD    sp, 6                        ; UNKNOWN
033748  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03374B  50                    PUSH   ax                           ; UNKNOWN
03374C  9A 3D 00 13 24        LCALL  0x2413, 0x3d                 ; UNKNOWN
033751  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033754  FF 36 F2 33           PUSH   word ptr [0x33f2]            ; UNKNOWN
033758  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03375B  50                    PUSH   ax                           ; UNKNOWN
03375C  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
033761  83 C4 04              ADD    sp, 4                        ; UNKNOWN
033764  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033767  50                    PUSH   ax                           ; UNKNOWN
033768  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
03376D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033770  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
033773  0E                    PUSH   cs                           ; UNKNOWN
033774  E8 C2 F6              CALL   0x32e39                      ; UNKNOWN
033777  83                    DB     0x83                         ; UNKNOWN (raw)
