; ============================================================================
; func_01F709_unknown
; Region   : load_image
; Bytes    : file 0x01F709..0x01FB3D  (1076 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01F709  C8 56 00 00           ENTER  0x56, 0                      ; UNKNOWN
01F70D  56                    PUSH   si                           ; UNKNOWN
01F70E  A1 10 3E              MOV    ax, word ptr [0x3e10]        ; UNKNOWN
01F711  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
01F714  2B C0                 SUB    ax, ax                       ; UNKNOWN
01F716  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
01F719  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
01F71C  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
01F71F  EB 3F                 JMP    0x1f760                      ; UNKNOWN
01F721  50                    PUSH   ax                           ; UNKNOWN
01F722  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
01F727  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01F72A  8A 46 AA              MOV    al, byte ptr [bp - 0x56]     ; UNKNOWN
01F72D  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01F731  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
01F734  75 27                 JNE    0x1f75d                      ; UNKNOWN
01F736  F6 47 1C 40           TEST   byte ptr [bx + 0x1c], 0x40   ; UNKNOWN
01F73A  74 21                 JE     0x1f75d                      ; UNKNOWN
01F73C  83 7E DE 0A           CMP    word ptr [bp - 0x22], 0xa    ; UNKNOWN
01F740  7D 1B                 JGE    0x1f75d                      ; UNKNOWN
01F742  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
01F745  98                    CWDE                                ; UNKNOWN
01F746  8B 76 DE              MOV    si, word ptr [bp - 0x22]     ; UNKNOWN
01F749  D1 E6                 SHL    si, 1                        ; UNKNOWN
01F74B  89 42 BA              MOV    word ptr [bp + si - 0x46], ax ; UNKNOWN
01F74E  01 46 EA              ADD    word ptr [bp - 0x16], ax     ; UNKNOWN
01F751  8A 46 AC              MOV    al, byte ptr [bp - 0x54]     ; UNKNOWN
01F754  8B 76 DE              MOV    si, word ptr [bp - 0x22]     ; UNKNOWN
01F757  88 42 D2              MOV    byte ptr [bp + si - 0x2e], al ; UNKNOWN
01F75A  FF 46 DE              INC    word ptr [bp - 0x22]         ; UNKNOWN
01F75D  FF 46 AC              INC    word ptr [bp - 0x54]         ; UNKNOWN
01F760  8B 46 AC              MOV    ax, word ptr [bp - 0x54]     ; UNKNOWN
01F763  39 06 16 3E           CMP    word ptr [0x3e16], ax        ; UNKNOWN
01F767  7F B8                 JG     0x1f721                      ; UNKNOWN
01F769  83 7E DE 00           CMP    word ptr [bp - 0x22], 0      ; UNKNOWN
01F76D  75 03                 JNE    0x1f772                      ; UNKNOWN
01F76F  E9 C8 03              JMP    0x1fb3a                      ; UNKNOWN
01F772  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
01F775  6A 01                 PUSH   1                            ; UNKNOWN
01F777  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
01F77C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F77F  89 46 D0              MOV    word ptr [bp - 0x30], ax     ; UNKNOWN
01F782  C7 46 AC FF FF        MOV    word ptr [bp - 0x54], 0xffff ; UNKNOWN
01F787  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; UNKNOWN
01F78C  EB 27                 JMP    0x1f7b5                      ; UNKNOWN
01F78E  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; UNKNOWN
01F791  39 46 DC              CMP    word ptr [bp - 0x24], ax     ; UNKNOWN
01F794  7D 25                 JGE    0x1f7bb                      ; UNKNOWN
01F796  8B 76 DC              MOV    si, word ptr [bp - 0x24]     ; UNKNOWN
01F799  D1 E6                 SHL    si, 1                        ; UNKNOWN
01F79B  8B 42 BA              MOV    ax, word ptr [bp + si - 0x46] ; UNKNOWN
01F79E  29 46 D0              SUB    word ptr [bp - 0x30], ax     ; UNKNOWN
01F7A1  83 7E D0 00           CMP    word ptr [bp - 0x30], 0      ; UNKNOWN
01F7A5  7F 0B                 JG     0x1f7b2                      ; UNKNOWN
01F7A7  8B 76 DC              MOV    si, word ptr [bp - 0x24]     ; UNKNOWN
01F7AA  8A 42 D2              MOV    al, byte ptr [bp + si - 0x2e] ; UNKNOWN
01F7AD  2A E4                 SUB    ah, ah                       ; UNKNOWN
01F7AF  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
01F7B2  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
01F7B5  83 7E AC 00           CMP    word ptr [bp - 0x54], 0      ; UNKNOWN
01F7B9  7C D3                 JL     0x1f78e                      ; UNKNOWN
01F7BB  83 7E AC 00           CMP    word ptr [bp - 0x54], 0      ; UNKNOWN
01F7BF  7D 03                 JGE    0x1f7c4                      ; UNKNOWN
01F7C1  E9 76 03              JMP    0x1fb3a                      ; UNKNOWN
01F7C4  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
01F7C7  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
01F7CC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01F7CF  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01F7D3  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
01F7D6  2A E4                 SUB    ah, ah                       ; UNKNOWN
01F7D8  50                    PUSH   ax                           ; UNKNOWN
01F7D9  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
01F7DB  50                    PUSH   ax                           ; UNKNOWN
01F7DC  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
01F7E1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F7E4  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
01F7E7  2B C0                 SUB    ax, ax                       ; UNKNOWN
01F7E9  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
01F7EC  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
01F7EF  E9 27 01              JMP    0x1f919                      ; UNKNOWN
01F7F2  8B 5E E2              MOV    bx, word ptr [bp - 0x1e]     ; UNKNOWN
01F7F5  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
01F7F9  98                    CWDE                                ; UNKNOWN
01F7FA  8B 36 38 73           MOV    si, word ptr [0x7338]        ; UNKNOWN
01F7FE  8A 4C 01              MOV    cl, byte ptr [si + 1]        ; UNKNOWN
01F801  2A ED                 SUB    ch, ch                       ; UNKNOWN
01F803  03 C1                 ADD    ax, cx                       ; UNKNOWN
01F805  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
01F808  C7 46 F0 01 00        MOV    word ptr [bp - 0x10], 1      ; UNKNOWN
01F80D  50                    PUSH   ax                           ; UNKNOWN
01F80E  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
01F812  98                    CWDE                                ; UNKNOWN
01F813  8A 0C                 MOV    cl, byte ptr [si]            ; UNKNOWN
01F815  03 C1                 ADD    ax, cx                       ; UNKNOWN
01F817  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
01F81A  50                    PUSH   ax                           ; UNKNOWN
01F81B  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
01F820  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F823  0B C0                 OR     ax, ax                       ; UNKNOWN
01F825  75 03                 JNE    0x1f82a                      ; UNKNOWN
01F827  E9 EC 00              JMP    0x1f916                      ; UNKNOWN
01F82A  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
01F82D  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
01F830  9A BC 01 C9 33        LCALL  0x33c9, 0x1bc                ; UNKNOWN
01F835  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F838  FE C8                 DEC    al                           ; UNKNOWN
01F83A  74 03                 JE     0x1f83f                      ; UNKNOWN
01F83C  E9 D7 00              JMP    0x1f916                      ; UNKNOWN
01F83F  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
01F842  8B 56 EC              MOV    dx, word ptr [bp - 0x14]     ; UNKNOWN
01F845  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
01F84A  89 46 CE              MOV    word ptr [bp - 0x32], ax     ; UNKNOWN
01F84D  0B C0                 OR     ax, ax                       ; UNKNOWN
01F84F  7C 2E                 JL     0x1f87f                      ; UNKNOWN
01F851  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
01F854  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
01F858  24 0F                 AND    al, 0xf                      ; UNKNOWN
01F85A  3A 06 4A 3E           CMP    al, byte ptr [0x3e4a]        ; UNKNOWN
01F85E  75 1F                 JNE    0x1f87f                      ; UNKNOWN
01F860  6B 5E CE 1C           IMUL   bx, word ptr [bp - 0x32], 0x1c ; UNKNOWN
01F864  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
01F869  75 05                 JNE    0x1f870                      ; UNKNOWN
01F86B  81 6E F0 E7 03        SUB    word ptr [bp - 0x10], 0x3e7  ; UNKNOWN
01F870  8B 46 CE              MOV    ax, word ptr [bp - 0x32]     ; UNKNOWN
01F873  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
01F878  89 46 CE              MOV    word ptr [bp - 0x32], ax     ; UNKNOWN
01F87B  0B C0                 OR     ax, ax                       ; UNKNOWN
01F87D  7D E1                 JGE    0x1f860                      ; UNKNOWN
01F87F  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
01F883  7D 03                 JGE    0x1f888                      ; UNKNOWN
01F885  E9 8E 00              JMP    0x1f916                      ; UNKNOWN
01F888  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
01F88B  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
01F88E  9A 04 03 C9 33        LCALL  0x33c9, 0x304                ; UNKNOWN
01F893  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F896  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01F899  0B C0                 OR     ax, ax                       ; UNKNOWN
01F89B  7C 05                 JL     0x1f8a2                      ; UNKNOWN
01F89D  3B 46 AA              CMP    ax, word ptr [bp - 0x56]     ; UNKNOWN
01F8A0  75 74                 JNE    0x1f916                      ; UNKNOWN
01F8A2  C7 46 E0 00 00        MOV    word ptr [bp - 0x20], 0      ; UNKNOWN
01F8A7  8B 5E E0              MOV    bx, word ptr [bp - 0x20]     ; UNKNOWN
01F8AA  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
01F8AE  98                    CWDE                                ; UNKNOWN
01F8AF  03 46 EC              ADD    ax, word ptr [bp - 0x14]     ; UNKNOWN
01F8B2  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
01F8B5  50                    PUSH   ax                           ; UNKNOWN
01F8B6  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
01F8BA  98                    CWDE                                ; UNKNOWN
01F8BB  03 46 F2              ADD    ax, word ptr [bp - 0xe]      ; UNKNOWN
01F8BE  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01F8C1  50                    PUSH   ax                           ; UNKNOWN
01F8C2  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
01F8C7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F8CA  0B C0                 OR     ax, ax                       ; UNKNOWN
01F8CC  75 28                 JNE    0x1f8f6                      ; UNKNOWN
01F8CE  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01F8D1  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
01F8D4  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
01F8D9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F8DC  3B 46 E4              CMP    ax, word ptr [bp - 0x1c]     ; UNKNOWN
01F8DF  75 15                 JNE    0x1f8f6                      ; UNKNOWN
01F8E1  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01F8E4  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
01F8E7  9A D1 03 C9 33        LCALL  0x33c9, 0x3d1                ; UNKNOWN
01F8EC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F8EF  0B C0                 OR     ax, ax                       ; UNKNOWN
01F8F1  7D 03                 JGE    0x1f8f6                      ; UNKNOWN
01F8F3  FF 46 F0              INC    word ptr [bp - 0x10]         ; UNKNOWN
01F8F6  FF 46 E0              INC    word ptr [bp - 0x20]         ; UNKNOWN
01F8F9  83 7E E0 08           CMP    word ptr [bp - 0x20], 8      ; UNKNOWN
01F8FD  7C A8                 JL     0x1f8a7                      ; UNKNOWN
01F8FF  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
01F902  39 46 AE              CMP    word ptr [bp - 0x52], ax     ; UNKNOWN
01F905  7D 0F                 JGE    0x1f916                      ; UNKNOWN
01F907  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
01F90A  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
01F90D  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01F910  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
01F913  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
01F916  FF 46 E2              INC    word ptr [bp - 0x1e]         ; UNKNOWN
01F919  83 7E E2 08           CMP    word ptr [bp - 0x1e], 8      ; UNKNOWN
01F91D  7D 03                 JGE    0x1f922                      ; UNKNOWN
01F91F  E9 D0 FE              JMP    0x1f7f2                      ; UNKNOWN
01F922  83 7E AE 00           CMP    word ptr [bp - 0x52], 0      ; UNKNOWN
01F926  7F 03                 JG     0x1f92b                      ; UNKNOWN
01F928  E9 0F 02              JMP    0x1fb3a                      ; UNKNOWN
01F92B  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
01F92F  75 04                 JNE    0x1f935                      ; UNKNOWN
01F931  FF 0E 5E 3E           DEC    word ptr [0x3e5e]            ; UNKNOWN
01F935  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
01F938  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01F93B  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
01F93E  6A 12                 PUSH   0x12                         ; UNKNOWN
01F940  9A AE 06 B7 36        LCALL  0x36b7, 0x6ae                ; UNKNOWN
01F945  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01F948  89 46 CE              MOV    word ptr [bp - 0x32], ax     ; UNKNOWN
01F94B  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
01F94E  0B C0                 OR     ax, ax                       ; UNKNOWN
01F950  7D 03                 JGE    0x1f955                      ; UNKNOWN
01F952  E9 E5 01              JMP    0x1fb3a                      ; UNKNOWN
01F955  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
01F958  50                    PUSH   ax                           ; UNKNOWN
01F959  9A 89 09 B7 36        LCALL  0x36b7, 0x989                ; UNKNOWN
01F95E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F961  6A 00                 PUSH   0                            ; UNKNOWN
01F963  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
01F966  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01F969  9A 9C 02 0B 38        LCALL  0x380b, 0x29c                ; UNKNOWN
01F96E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01F971  A1 38 73              MOV    ax, word ptr [0x7338]        ; UNKNOWN
01F974  40                    INC    ax                           ; UNKNOWN
01F975  40                    INC    ax                           ; UNKNOWN
01F976  1E                    PUSH   ds                           ; UNKNOWN
01F977  50                    PUSH   ax                           ; UNKNOWN
01F978  6A 00                 PUSH   0                            ; UNKNOWN
01F97A  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
01F97F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01F982  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
01F986  75 30                 JNE    0x1f9b8                      ; UNKNOWN
01F988  6A 03                 PUSH   3                            ; UNKNOWN
01F98A  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
01F98F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01F992  FF 36 4C 3E           PUSH   word ptr [0x3e4c]            ; UNKNOWN
01F996  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
01F99B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01F99E  50                    PUSH   ax                           ; UNKNOWN
01F99F  6A 01                 PUSH   1                            ; UNKNOWN
01F9A1  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01F9A6  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F9A9  B8 3F 00              MOV    ax, 0x3f                     ; UNKNOWN
01F9AC  9A 0A 00 11 5D        LCALL  0x5d11, 0xa                  ; UNKNOWN
01F9B1  6A 01                 PUSH   1                            ; UNKNOWN
01F9B3  68 BE 17              PUSH   0x17be                       ; UNKNOWN
01F9B6  EB 1C                 JMP    0x1f9d4                      ; UNKNOWN
01F9B8  FF 36 4E 3E           PUSH   word ptr [0x3e4e]            ; UNKNOWN
01F9BC  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
01F9C1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01F9C4  50                    PUSH   ax                           ; UNKNOWN
01F9C5  6A 01                 PUSH   1                            ; UNKNOWN
01F9C7  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01F9CC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F9CF  6A 01                 PUSH   1                            ; UNKNOWN
01F9D1  68 C8 17              PUSH   0x17c8                       ; UNKNOWN
01F9D4  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
01F9D9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F9DC  C7 46 E8 01 00        MOV    word ptr [bp - 0x18], 1      ; UNKNOWN
01F9E1  C7 46 B2 06 00        MOV    word ptr [bp - 0x4e], 6      ; UNKNOWN
01F9E6  2B C0                 SUB    ax, ax                       ; UNKNOWN
01F9E8  89 46 B4              MOV    word ptr [bp - 0x4c], ax     ; UNKNOWN
01F9EB  89 46 B8              MOV    word ptr [bp - 0x48], ax     ; UNKNOWN
01F9EE  39 06 5C 3E           CMP    word ptr [0x3e5c], ax        ; UNKNOWN
01F9F2  74 0E                 JE     0x1fa02                      ; UNKNOWN
01F9F4  A1 5C 3E              MOV    ax, word ptr [0x3e5c]        ; UNKNOWN
01F9F7  83 F8 02              CMP    ax, 2                        ; UNKNOWN
01F9FA  7E 03                 JLE    0x1f9ff                      ; UNKNOWN
01F9FC  B8 02 00              MOV    ax, 2                        ; UNKNOWN
01F9FF  89 46 B4              MOV    word ptr [bp - 0x4c], ax     ; UNKNOWN
01FA02  83 3E 60 3E 00        CMP    word ptr [0x3e60], 0         ; UNKNOWN
01FA07  74 0E                 JE     0x1fa17                      ; UNKNOWN
01FA09  A1 60 3E              MOV    ax, word ptr [0x3e60]        ; UNKNOWN
01FA0C  83 F8 02              CMP    ax, 2                        ; UNKNOWN
01FA0F  7E 03                 JLE    0x1fa14                      ; UNKNOWN
01FA11  B8 02 00              MOV    ax, 2                        ; UNKNOWN
01FA14  89 46 B8              MOV    word ptr [bp - 0x48], ax     ; UNKNOWN
01FA17  8B 46 B4              MOV    ax, word ptr [bp - 0x4c]     ; UNKNOWN
01FA1A  03 46 B8              ADD    ax, word ptr [bp - 0x48]     ; UNKNOWN
01FA1D  29 46 B2              SUB    word ptr [bp - 0x4e], ax     ; UNKNOWN
01FA20  C7 46 B0 00 00        MOV    word ptr [bp - 0x50], 0      ; UNKNOWN
01FA25  E9 B0 00              JMP    0x1fad8                      ; UNKNOWN
01FA28  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
01FA2B  C6 87 97 88 15        MOV    byte ptr [bx - 0x7769], 0x15 ; UNKNOWN
01FA30  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
01FA33  FF 76 CE              PUSH   word ptr [bp - 0x32]         ; UNKNOWN
01FA36  9A 89 09 B7 36        LCALL  0x36b7, 0x989                ; UNKNOWN
01FA3B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01FA3E  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01FA42  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
01FA45  2A E4                 SUB    ah, ah                       ; UNKNOWN
01FA47  50                    PUSH   ax                           ; UNKNOWN
01FA48  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
01FA4A  50                    PUSH   ax                           ; UNKNOWN
01FA4B  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
01FA4E  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01FA51  6A FF                 PUSH   -1                           ; UNKNOWN
01FA53  68 C0 00              PUSH   0xc0                         ; UNKNOWN
01FA56  FF 76 CE              PUSH   word ptr [bp - 0x32]         ; UNKNOWN
01FA59  9A AC 0E 76 1A        LCALL  0x1a76, 0xeac                ; UNKNOWN
01FA5E  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
01FA61  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01FA65  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
01FA68  2A E4                 SUB    ah, ah                       ; UNKNOWN
01FA6A  50                    PUSH   ax                           ; UNKNOWN
01FA6B  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
01FA6D  50                    PUSH   ax                           ; UNKNOWN
01FA6E  FF 76 CE              PUSH   word ptr [bp - 0x32]         ; UNKNOWN
01FA71  9A 0A 04 B7 36        LCALL  0x36b7, 0x40a                ; UNKNOWN
01FA76  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01FA79  6A 01                 PUSH   1                            ; UNKNOWN
01FA7B  6A 05                 PUSH   5                            ; UNKNOWN
01FA7D  6A 05                 PUSH   5                            ; UNKNOWN
01FA7F  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01FA83  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
01FA86  2A E4                 SUB    ah, ah                       ; UNKNOWN
01FA88  48                    DEC    ax                           ; UNKNOWN
01FA89  48                    DEC    ax                           ; UNKNOWN
01FA8A  50                    PUSH   ax                           ; UNKNOWN
01FA8B  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
01FA8D  2A E4                 SUB    ah, ah                       ; UNKNOWN
01FA8F  48                    DEC    ax                           ; UNKNOWN
01FA90  48                    DEC    ax                           ; UNKNOWN
01FA91  50                    PUSH   ax                           ; UNKNOWN
01FA92  9A 0C 00 E4 35        LCALL  0x35e4, 0xc                  ; UNKNOWN
01FA97  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
01FA9A  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
01FA9E  75 09                 JNE    0x1faa9                      ; UNKNOWN
01FAA0  8B 5E B0              MOV    bx, word ptr [bp - 0x50]     ; UNKNOWN
01FAA3  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01FAA5  FF 8F 5A 3E           DEC    word ptr [bx + 0x3e5a]       ; UNKNOWN
01FAA9  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
01FAAC  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
01FAAF  39 46 DC              CMP    word ptr [bp - 0x24], ax     ; UNKNOWN
01FAB2  7D 21                 JGE    0x1fad5                      ; UNKNOWN
01FAB4  6A FE                 PUSH   -2                           ; UNKNOWN
01FAB6  6A FE                 PUSH   -2                           ; UNKNOWN
01FAB8  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
01FABB  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
01FABE  9A AE 06 B7 36        LCALL  0x36b7, 0x6ae                ; UNKNOWN
01FAC3  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01FAC6  89 46 CE              MOV    word ptr [bp - 0x32], ax     ; UNKNOWN
01FAC9  0B C0                 OR     ax, ax                       ; UNKNOWN
01FACB  7C 03                 JL     0x1fad0                      ; UNKNOWN
01FACD  E9 58 FF              JMP    0x1fa28                      ; UNKNOWN
01FAD0  C7 46 E8 00 00        MOV    word ptr [bp - 0x18], 0      ; UNKNOWN
01FAD5  FF 46 B0              INC    word ptr [bp - 0x50]         ; UNKNOWN
01FAD8  83 7E E8 00           CMP    word ptr [bp - 0x18], 0      ; UNKNOWN
01FADC  74 45                 JE     0x1fb23                      ; UNKNOWN
01FADE  83 7E B0 03           CMP    word ptr [bp - 0x50], 3      ; UNKNOWN
01FAE2  7F 3F                 JG     0x1fb23                      ; UNKNOWN
01FAE4  83 7E B0 02           CMP    word ptr [bp - 0x50], 2      ; UNKNOWN
01FAE8  74 EB                 JE     0x1fad5                      ; UNKNOWN
01FAEA  8B 76 B0              MOV    si, word ptr [bp - 0x50]     ; UNKNOWN
01FAED  D1 E6                 SHL    si, 1                        ; UNKNOWN
01FAEF  8B 42 B2              MOV    ax, word ptr [bp + si - 0x4e] ; UNKNOWN
01FAF2  3B 84 5A 3E           CMP    ax, word ptr [si + 0x3e5a]   ; UNKNOWN
01FAF6  7E 04                 JLE    0x1fafc                      ; UNKNOWN
01FAF8  8B 84 5A 3E           MOV    ax, word ptr [si + 0x3e5a]   ; UNKNOWN
01FAFC  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
01FAFF  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
01FB02  FF 76 B0              PUSH   word ptr [bp - 0x50]         ; UNKNOWN
01FB05  0E                    PUSH   cs                           ; UNKNOWN
01FB06  E8 B0 EB              CALL   0x1e6b9                      ; UNKNOWN
01FB09  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01FB0C  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01FB0F  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
01FB13  74 07                 JE     0x1fb1c                      ; UNKNOWN
01FB15  8B 84 A8 3E           MOV    ax, word ptr [si + 0x3ea8]   ; UNKNOWN
01FB19  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
01FB1C  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; UNKNOWN
01FB21  EB 89                 JMP    0x1faac                      ; UNKNOWN
01FB23  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
01FB27  74 11                 JE     0x1fb3a                      ; UNKNOWN
01FB29  83 7E E6 00           CMP    word ptr [bp - 0x1a], 0      ; UNKNOWN
01FB2D  7C 0B                 JL     0x1fb3a                      ; UNKNOWN
01FB2F  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
01FB32  9A 1C 08 B7 36        LCALL  0x36b7, 0x81c                ; UNKNOWN
01FB37  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01FB3A  5E                    POP    si                           ; UNKNOWN
01FB3B  C9                    LEAVE                               ; UNKNOWN
01FB3C  CB                    RETF                                ; UNKNOWN
