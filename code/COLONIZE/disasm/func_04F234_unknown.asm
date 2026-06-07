; ============================================================================
; func_04F234_unknown
; Region   : load_image
; Bytes    : file 0x04F234..0x04F3C8  (404 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04F234  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
04F238  56                    PUSH   si                           ; UNKNOWN
04F239  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
04F23E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04F242  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
04F246  2A E4                 SUB    ah, ah                       ; UNKNOWN
04F248  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04F24B  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
04F24F  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
04F252  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
04F256  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
04F259  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
04F25C  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
04F261  E9 3E 01              JMP    0x4f3a2                      ; UNKNOWN
04F264  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F267  D1 E0                 SHL    ax, 1                        ; UNKNOWN
04F269  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; UNKNOWN
04F26C  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
04F270  75 48                 JNE    0x4f2ba                      ; UNKNOWN
04F272  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F275  03 46 FA              ADD    ax, word ptr [bp - 6]        ; UNKNOWN
04F278  3B 46 F0              CMP    ax, word ptr [bp - 0x10]     ; UNKNOWN
04F27B  7C 3D                 JL     0x4f2ba                      ; UNKNOWN
04F27D  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
04F280  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
04F283  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
04F288  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F28B  83 F8 1A              CMP    ax, 0x1a                     ; UNKNOWN
04F28E  75 D4                 JNE    0x4f264                      ; UNKNOWN
04F290  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
04F293  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
04F296  9A 04 03 C9 33        LCALL  0x33c9, 0x304                ; UNKNOWN
04F29B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F29E  0B C0                 OR     ax, ax                       ; UNKNOWN
04F2A0  7C 05                 JL     0x4f2a7                      ; UNKNOWN
04F2A2  3B 46 EC              CMP    ax, word ptr [bp - 0x14]     ; UNKNOWN
04F2A5  75 BD                 JNE    0x4f264                      ; UNKNOWN
04F2A7  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
04F2AC  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
04F2AF  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04F2B2  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
04F2B5  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
04F2B8  EB AA                 JMP    0x4f264                      ; UNKNOWN
04F2BA  FF 46 F2              INC    word ptr [bp - 0xe]          ; UNKNOWN
04F2BD  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
04F2C1  75 16                 JNE    0x4f2d9                      ; UNKNOWN
04F2C3  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F2C6  03 46 FC              ADD    ax, word ptr [bp - 4]        ; UNKNOWN
04F2C9  3B 46 F2              CMP    ax, word ptr [bp - 0xe]      ; UNKNOWN
04F2CC  7E 0B                 JLE    0x4f2d9                      ; UNKNOWN
04F2CE  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
04F2D1  2B 46 FE              SUB    ax, word ptr [bp - 2]        ; UNKNOWN
04F2D4  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
04F2D7  EB 93                 JMP    0x4f26c                      ; UNKNOWN
04F2D9  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F2DC  03 46 FC              ADD    ax, word ptr [bp - 4]        ; UNKNOWN
04F2DF  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
04F2E2  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
04F2E5  2B 46 FE              SUB    ax, word ptr [bp - 2]        ; UNKNOWN
04F2E8  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
04F2EB  EB 49                 JMP    0x4f336                      ; UNKNOWN
04F2ED  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F2F0  03 46 FA              ADD    ax, word ptr [bp - 6]        ; UNKNOWN
04F2F3  3B 46 F0              CMP    ax, word ptr [bp - 0x10]     ; UNKNOWN
04F2F6  7C 44                 JL     0x4f33c                      ; UNKNOWN
04F2F8  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
04F2FB  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
04F2FE  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
04F303  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F306  83 F8 1A              CMP    ax, 0x1a                     ; UNKNOWN
04F309  75 28                 JNE    0x4f333                      ; UNKNOWN
04F30B  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
04F30E  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
04F311  9A 04 03 C9 33        LCALL  0x33c9, 0x304                ; UNKNOWN
04F316  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F319  0B C0                 OR     ax, ax                       ; UNKNOWN
04F31B  7C 05                 JL     0x4f322                      ; UNKNOWN
04F31D  3B 46 EC              CMP    ax, word ptr [bp - 0x14]     ; UNKNOWN
04F320  75 11                 JNE    0x4f333                      ; UNKNOWN
04F322  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
04F327  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
04F32A  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04F32D  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
04F330  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
04F333  FF 46 F0              INC    word ptr [bp - 0x10]         ; UNKNOWN
04F336  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
04F33A  74 B1                 JE     0x4f2ed                      ; UNKNOWN
04F33C  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04F33F  2B 46 FE              SUB    ax, word ptr [bp - 2]        ; UNKNOWN
04F342  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
04F345  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
04F348  2B 46 FE              SUB    ax, word ptr [bp - 2]        ; UNKNOWN
04F34B  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
04F34E  EB 49                 JMP    0x4f399                      ; UNKNOWN
04F350  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F353  03 46 FA              ADD    ax, word ptr [bp - 6]        ; UNKNOWN
04F356  3B 46 F0              CMP    ax, word ptr [bp - 0x10]     ; UNKNOWN
04F359  7C 44                 JL     0x4f39f                      ; UNKNOWN
04F35B  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
04F35E  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
04F361  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
04F366  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F369  83 F8 1A              CMP    ax, 0x1a                     ; UNKNOWN
04F36C  75 28                 JNE    0x4f396                      ; UNKNOWN
04F36E  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
04F371  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
04F374  9A 04 03 C9 33        LCALL  0x33c9, 0x304                ; UNKNOWN
04F379  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F37C  0B C0                 OR     ax, ax                       ; UNKNOWN
04F37E  7C 05                 JL     0x4f385                      ; UNKNOWN
04F380  3B 46 EC              CMP    ax, word ptr [bp - 0x14]     ; UNKNOWN
04F383  75 11                 JNE    0x4f396                      ; UNKNOWN
04F385  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
04F38A  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
04F38D  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04F390  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
04F393  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
04F396  FF 46 F0              INC    word ptr [bp - 0x10]         ; UNKNOWN
04F399  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
04F39D  74 B1                 JE     0x4f350                      ; UNKNOWN
04F39F  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
04F3A2  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
04F3A6  75 14                 JNE    0x4f3bc                      ; UNKNOWN
04F3A8  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F3AB  39 06 88 82           CMP    word ptr [0x8288], ax        ; UNKNOWN
04F3AF  7E 0B                 JLE    0x4f3bc                      ; UNKNOWN
04F3B1  2B 46 FC              SUB    ax, word ptr [bp - 4]        ; UNKNOWN
04F3B4  F7 D8                 NEG    ax                           ; UNKNOWN
04F3B6  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
04F3B9  E9 01 FF              JMP    0x4f2bd                      ; UNKNOWN
04F3BC  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
04F3C0  74 54                 JE     0x4f416                      ; UNKNOWN
04F3C2  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04F3C6  8B C3                 MOV    ax, bx                       ; UNKNOWN
