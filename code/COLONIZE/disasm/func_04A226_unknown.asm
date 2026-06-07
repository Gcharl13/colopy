; ============================================================================
; func_04A226_unknown
; Region   : load_image
; Bytes    : file 0x04A226..0x04A457  (561 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04A226  C8 6A 00 00           ENTER  0x6a, 0                      ; UNKNOWN
04A22A  56                    PUSH   si                           ; UNKNOWN
04A22B  0E                    PUSH   cs                           ; UNKNOWN
04A22C  E8 0E EC              CALL   0x48e3d                      ; UNKNOWN
04A22F  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
04A232  2A E4                 SUB    ah, ah                       ; UNKNOWN
04A234  50                    PUSH   ax                           ; UNKNOWN
04A235  6A 05                 PUSH   5                            ; UNKNOWN
04A237  68 40 01              PUSH   0x140                        ; UNKNOWN
04A23A  2B C0                 SUB    ax, ax                       ; UNKNOWN
04A23C  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
04A23F  50                    PUSH   ax                           ; UNKNOWN
04A240  FF 36 D2 33           PUSH   word ptr [0x33d2]            ; UNKNOWN
04A244  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04A249  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04A24C  52                    PUSH   dx                           ; UNKNOWN
04A24D  50                    PUSH   ax                           ; UNKNOWN
04A24E  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04A253  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04A256  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04A25A  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04A25D  2A E4                 SUB    ah, ah                       ; UNKNOWN
04A25F  83 C0 07              ADD    ax, 7                        ; UNKNOWN
04A262  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
04A265  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0      ; UNKNOWN
04A269  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04A26C  50                    PUSH   ax                           ; UNKNOWN
04A26D  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
04A272  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04A275  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04A278  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
04A27B  FF B7 33 38           PUSH   word ptr [bx + 0x3833]       ; UNKNOWN
04A27F  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04A282  50                    PUSH   ax                           ; UNKNOWN
04A283  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04A288  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04A28B  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04A28E  50                    PUSH   ax                           ; UNKNOWN
04A28F  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
04A294  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04A297  6A 03                 PUSH   3                            ; UNKNOWN
04A299  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04A29C  50                    PUSH   ax                           ; UNKNOWN
04A29D  0E                    PUSH   cs                           ; UNKNOWN
04A29E  E8 15 EB              CALL   0x48db6                      ; UNKNOWN
04A2A1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04A2A4  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04A2A7  50                    PUSH   ax                           ; UNKNOWN
04A2A8  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
04A2AD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04A2B0  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
04A2B3  2A E4                 SUB    ah, ah                       ; UNKNOWN
04A2B5  50                    PUSH   ax                           ; UNKNOWN
04A2B6  FF 76 A6              PUSH   word ptr [bp - 0x5a]         ; UNKNOWN
04A2B9  68 40 01              PUSH   0x140                        ; UNKNOWN
04A2BC  6A 00                 PUSH   0                            ; UNKNOWN
04A2BE  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04A2C1  16                    PUSH   ss                           ; UNKNOWN
04A2C2  50                    PUSH   ax                           ; UNKNOWN
04A2C3  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04A2C8  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04A2CB  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04A2CF  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04A2D2  2A E4                 SUB    ah, ah                       ; UNKNOWN
04A2D4  40                    INC    ax                           ; UNKNOWN
04A2D5  40                    INC    ax                           ; UNKNOWN
04A2D6  01 46 A6              ADD    word ptr [bp - 0x5a], ax     ; UNKNOWN
04A2D9  FF 46 A6              INC    word ptr [bp - 0x5a]         ; UNKNOWN
04A2DC  C7 46 A8 0A 00        MOV    word ptr [bp - 0x58], 0xa    ; UNKNOWN
04A2E1  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04A2E4  9A D7 0A 5F 24        LCALL  0x245f, 0xad7                ; UNKNOWN
04A2E9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04A2EC  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04A2EF  0B C0                 OR     ax, ax                       ; UNKNOWN
04A2F1  7D 04                 JGE    0x4a2f7                      ; UNKNOWN
04A2F3  83 46 A6 0B           ADD    word ptr [bp - 0x5a], 0xb    ; UNKNOWN
04A2F7  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
04A2FA  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
04A2FD  2B C0                 SUB    ax, ax                       ; UNKNOWN
04A2FF  89 46 96              MOV    word ptr [bp - 0x6a], ax     ; UNKNOWN
04A302  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
04A305  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
04A308  7C 24                 JL     0x4a32e                      ; UNKNOWN
04A30A  C7 46 A4 01 00        MOV    word ptr [bp - 0x5c], 1      ; UNKNOWN
04A30F  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
04A312  8B C6                 MOV    ax, si                       ; UNKNOWN
04A314  D1 E6                 SHL    si, 1                        ; UNKNOWN
04A316  03 F0                 ADD    si, ax                       ; UNKNOWN
04A318  C1 E6 02              SHL    si, 2                        ; UNKNOWN
04A31B  C4 1E 74 09           LES    bx, ptr [0x974]              ; UNKNOWN
04A31F  26 8B 40 4C           MOV    ax, word ptr es:[bx + si + 0x4c] ; UNKNOWN
04A323  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
04A326  D1 F8                 SAR    ax, 1                        ; UNKNOWN
04A328  83 E8 07              SUB    ax, 7                        ; UNKNOWN
04A32B  89 46 96              MOV    word ptr [bp - 0x6a], ax     ; UNKNOWN
04A32E  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04A331  83 C0 52              ADD    ax, 0x52                     ; UNKNOWN
04A334  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
04A337  83 7E 06 1B           CMP    word ptr [bp + 6], 0x1b      ; UNKNOWN
04A33B  75 05                 JNE    0x4a342                      ; UNKNOWN
04A33D  C7 46 A0 43 00        MOV    word ptr [bp - 0x60], 0x43   ; UNKNOWN
04A342  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
04A346  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
04A34A  8B 46 96              MOV    ax, word ptr [bp - 0x6a]     ; UNKNOWN
04A34D  03 46 A6              ADD    ax, word ptr [bp - 0x5a]     ; UNKNOWN
04A350  50                    PUSH   ax                           ; UNKNOWN
04A351  8B F0                 MOV    si, ax                       ; UNKNOWN
04A353  8B 46 A0              MOV    ax, word ptr [bp - 0x60]     ; UNKNOWN
04A356  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
04A35A  8B 56 98              MOV    dx, word ptr [bp - 0x68]     ; UNKNOWN
04A35D  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
04A362  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0      ; UNKNOWN
04A366  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04A369  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
04A36C  FF B7 35 38           PUSH   word ptr [bx + 0x3835]       ; UNKNOWN
04A370  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04A373  50                    PUSH   ax                           ; UNKNOWN
04A374  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04A379  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04A37C  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
04A37F  2A E4                 SUB    ah, ah                       ; UNKNOWN
04A381  50                    PUSH   ax                           ; UNKNOWN
04A382  8D 44 06              LEA    ax, [si + 6]                 ; UNKNOWN
04A385  50                    PUSH   ax                           ; UNKNOWN
04A386  83 46 98 0E           ADD    word ptr [bp - 0x68], 0xe    ; UNKNOWN
04A38A  FF 76 98              PUSH   word ptr [bp - 0x68]         ; UNKNOWN
04A38D  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04A390  16                    PUSH   ss                           ; UNKNOWN
04A391  50                    PUSH   ax                           ; UNKNOWN
04A392  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04A397  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04A39A  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
04A39D  83 46 98 18           ADD    word ptr [bp - 0x68], 0x18   ; UNKNOWN
04A3A1  8B 46 98              MOV    ax, word ptr [bp - 0x68]     ; UNKNOWN
04A3A4  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
04A3A7  8B 4E A6              MOV    cx, word ptr [bp - 0x5a]     ; UNKNOWN
04A3AA  89 4E 9E              MOV    word ptr [bp - 0x62], cx     ; UNKNOWN
04A3AD  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04A3B0  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
04A3B4  7D 03                 JGE    0x4a3b9                      ; UNKNOWN
04A3B6  E9 AD 00              JMP    0x4a466                      ; UNKNOWN
04A3B9  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
04A3BE  E9 A5 00              JMP    0x4a466                      ; UNKNOWN
04A3C1  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
04A3C4  8B C6                 MOV    ax, si                       ; UNKNOWN
04A3C6  D1 E6                 SHL    si, 1                        ; UNKNOWN
04A3C8  03 F0                 ADD    si, ax                       ; UNKNOWN
04A3CA  C1 E6 02              SHL    si, 2                        ; UNKNOWN
04A3CD  C4 1E 74 09           LES    bx, ptr [0x974]              ; UNKNOWN
04A3D1  26 8B 40 4C           MOV    ax, word ptr es:[bx + si + 0x4c] ; UNKNOWN
04A3D5  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
04A3D8  D1 F8                 SAR    ax, 1                        ; UNKNOWN
04A3DA  83 E8 07              SUB    ax, 7                        ; UNKNOWN
04A3DD  89 46 96              MOV    word ptr [bp - 0x6a], ax     ; UNKNOWN
04A3E0  06                    PUSH   es                           ; UNKNOWN
04A3E1  53                    PUSH   bx                           ; UNKNOWN
04A3E2  FF 76 A6              PUSH   word ptr [bp - 0x5a]         ; UNKNOWN
04A3E5  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04A3E8  40                    INC    ax                           ; UNKNOWN
04A3E9  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
04A3ED  8B 56 A2              MOV    dx, word ptr [bp - 0x5e]     ; UNKNOWN
04A3F0  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
04A3F5  C4 1E 74 09           LES    bx, ptr [0x974]              ; UNKNOWN
04A3F9  26 8B 40 4A           MOV    ax, word ptr es:[bx + si + 0x4a] ; UNKNOWN
04A3FD  03 46 A2              ADD    ax, word ptr [bp - 0x5e]     ; UNKNOWN
04A400  83 C0 03              ADD    ax, 3                        ; UNKNOWN
04A403  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
04A406  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0      ; UNKNOWN
04A40A  FF B4 13 39           PUSH   word ptr [si + 0x3913]       ; UNKNOWN
04A40E  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04A411  50                    PUSH   ax                           ; UNKNOWN
04A412  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04A417  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04A41A  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
04A41D  2A E4                 SUB    ah, ah                       ; UNKNOWN
04A41F  50                    PUSH   ax                           ; UNKNOWN
04A420  8B 46 96              MOV    ax, word ptr [bp - 0x6a]     ; UNKNOWN
04A423  03 46 A6              ADD    ax, word ptr [bp - 0x5a]     ; UNKNOWN
04A426  83 C0 06              ADD    ax, 6                        ; UNKNOWN
04A429  50                    PUSH   ax                           ; UNKNOWN
04A42A  FF 76 98              PUSH   word ptr [bp - 0x68]         ; UNKNOWN
04A42D  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04A430  16                    PUSH   ss                           ; UNKNOWN
04A431  50                    PUSH   ax                           ; UNKNOWN
04A432  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04A437  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04A43A  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
04A43D  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
04A441  7D 06                 JGE    0x4a449                      ; UNKNOWN
04A443  83 C0 18              ADD    ax, 0x18                     ; UNKNOWN
04A446  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04A449  8B 46 9A              MOV    ax, word ptr [bp - 0x66]     ; UNKNOWN
04A44C  83 C0 04              ADD    ax, 4                        ; UNKNOWN
04A44F  01 46 A6              ADD    word ptr [bp - 0x5a], ax     ; UNKNOWN
04A452  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
04A455  8B C3                 MOV    ax, bx                       ; UNKNOWN
