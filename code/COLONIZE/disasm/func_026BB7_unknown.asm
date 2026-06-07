; ============================================================================
; func_026BB7_unknown
; Region   : load_image
; Bytes    : file 0x026BB7..0x026DC9  (530 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026BB7  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
026BBB  57                    PUSH   di                           ; UNKNOWN
026BBC  56                    PUSH   si                           ; UNKNOWN
026BBD  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
026BC2  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
026BC5  0B 46 06              OR     ax, word ptr [bp + 6]        ; UNKNOWN
026BC8  74 05                 JE     0x26bcf                      ; UNKNOWN
026BCA  C7 46 F0 01 00        MOV    word ptr [bp - 0x10], 1      ; UNKNOWN
026BCF  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
026BD3  74 17                 JE     0x26bec                      ; UNKNOWN
026BD5  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026BD8  26 8B 47 10           MOV    ax, word ptr es:[bx + 0x10]  ; UNKNOWN
026BDC  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
026BDF  26 8B 47 12           MOV    ax, word ptr es:[bx + 0x12]  ; UNKNOWN
026BE3  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
026BE6  26 8B 47 14           MOV    ax, word ptr es:[bx + 0x14]  ; UNKNOWN
026BEA  EB 0F                 JMP    0x26bfb                      ; UNKNOWN
026BEC  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
026BEF  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
026BF2  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
026BF5  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
026BF8  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
026BFB  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
026BFE  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
026C01  0B 46 06              OR     ax, word ptr [bp + 6]        ; UNKNOWN
026C04  74 0D                 JE     0x26c13                      ; UNKNOWN
026C06  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026C09  26 F6 47 0A 10        TEST   byte ptr es:[bx + 0xa], 0x10 ; UNKNOWN
026C0E  74 03                 JE     0x26c13                      ; UNKNOWN
026C10  E9 EF 00              JMP    0x26d02                      ; UNKNOWN
026C13  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
026C17  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
026C1B  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
026C1F  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
026C23  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
026C26  03 46 0C              ADD    ax, word ptr [bp + 0xc]      ; UNKNOWN
026C29  8B C8                 MOV    cx, ax                       ; UNKNOWN
026C2B  48                    DEC    ax                           ; UNKNOWN
026C2C  50                    PUSH   ax                           ; UNKNOWN
026C2D  6A 00                 PUSH   0                            ; UNKNOWN
026C2F  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
026C32  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
026C35  03 D8                 ADD    bx, ax                       ; UNKNOWN
026C37  8B D3                 MOV    dx, bx                       ; UNKNOWN
026C39  8D 5F FF              LEA    bx, [bx - 1]                 ; UNKNOWN
026C3C  8B F2                 MOV    si, dx                       ; UNKNOWN
026C3E  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
026C41  8B F9                 MOV    di, cx                       ; UNKNOWN
026C43  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
026C48  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
026C4C  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
026C50  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
026C54  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
026C58  8D 45 FE              LEA    ax, [di - 2]                 ; UNKNOWN
026C5B  50                    PUSH   ax                           ; UNKNOWN
026C5C  A0 EC 09              MOV    al, byte ptr [0x9ec]         ; UNKNOWN
026C5F  50                    PUSH   ax                           ; UNKNOWN
026C60  8D 5C FE              LEA    bx, [si - 2]                 ; UNKNOWN
026C63  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
026C66  40                    INC    ax                           ; UNKNOWN
026C67  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
026C6A  42                    INC    dx                           ; UNKNOWN
026C6B  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
026C70  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
026C74  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
026C78  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
026C7C  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
026C80  A0 F0 09              MOV    al, byte ptr [0x9f0]         ; UNKNOWN
026C83  50                    PUSH   ax                           ; UNKNOWN
026C84  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
026C87  40                    INC    ax                           ; UNKNOWN
026C88  40                    INC    ax                           ; UNKNOWN
026C89  8D 5D FD              LEA    bx, [di - 3]                 ; UNKNOWN
026C8C  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
026C8F  42                    INC    dx                           ; UNKNOWN
026C90  42                    INC    dx                           ; UNKNOWN
026C91  8B F8                 MOV    di, ax                       ; UNKNOWN
026C93  89 56 EE              MOV    word ptr [bp - 0x12], dx     ; UNKNOWN
026C96  89 5E EC              MOV    word ptr [bp - 0x14], bx     ; UNKNOWN
026C99  9A 04 00 7D 5A        LCALL  0x5a7d, 4                    ; UNKNOWN
026C9E  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
026CA2  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
026CA6  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
026CAA  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
026CAE  A0 EE 09              MOV    al, byte ptr [0x9ee]         ; UNKNOWN
026CB1  50                    PUSH   ax                           ; UNKNOWN
026CB2  8D 44 FD              LEA    ax, [si - 3]                 ; UNKNOWN
026CB5  8B 56 EE              MOV    dx, word ptr [bp - 0x12]     ; UNKNOWN
026CB8  8B 5E EC              MOV    bx, word ptr [bp - 0x14]     ; UNKNOWN
026CBB  8B F0                 MOV    si, ax                       ; UNKNOWN
026CBD  9A 04 00 7D 5A        LCALL  0x5a7d, 4                    ; UNKNOWN
026CC2  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
026CC6  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
026CCA  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
026CCE  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
026CD2  A0 EE 09              MOV    al, byte ptr [0x9ee]         ; UNKNOWN
026CD5  50                    PUSH   ax                           ; UNKNOWN
026CD6  8B D6                 MOV    dx, si                       ; UNKNOWN
026CD8  8B C7                 MOV    ax, di                       ; UNKNOWN
026CDA  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
026CDD  9A 0A 00 76 5A        LCALL  0x5a76, 0xa                  ; UNKNOWN
026CE2  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
026CE6  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
026CEA  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
026CEE  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
026CF2  A0 F0 09              MOV    al, byte ptr [0x9f0]         ; UNKNOWN
026CF5  50                    PUSH   ax                           ; UNKNOWN
026CF6  8B C7                 MOV    ax, di                       ; UNKNOWN
026CF8  8B D6                 MOV    dx, si                       ; UNKNOWN
026CFA  8B 5E EC              MOV    bx, word ptr [bp - 0x14]     ; UNKNOWN
026CFD  9A 0A 00 76 5A        LCALL  0x5a76, 0xa                  ; UNKNOWN
026D02  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
026D06  74 14                 JE     0x26d1c                      ; UNKNOWN
026D08  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026D0B  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa]   ; UNKNOWN
026D0F  83 E0 10              AND    ax, 0x10                     ; UNKNOWN
026D12  83 F8 01              CMP    ax, 1                        ; UNKNOWN
026D15  1B C0                 SBB    ax, ax                       ; UNKNOWN
026D17  83 E0 03              AND    ax, 3                        ; UNKNOWN
026D1A  EB 03                 JMP    0x26d1f                      ; UNKNOWN
026D1C  B8 03 00              MOV    ax, 3                        ; UNKNOWN
026D1F  03 46 0A              ADD    ax, word ptr [bp + 0xa]      ; UNKNOWN
026D22  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
026D25  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
026D29  74 14                 JE     0x26d3f                      ; UNKNOWN
026D2B  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026D2E  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa]   ; UNKNOWN
026D32  83 E0 10              AND    ax, 0x10                     ; UNKNOWN
026D35  83 F8 01              CMP    ax, 1                        ; UNKNOWN
026D38  1B C0                 SBB    ax, ax                       ; UNKNOWN
026D3A  83 E0 03              AND    ax, 3                        ; UNKNOWN
026D3D  EB 03                 JMP    0x26d42                      ; UNKNOWN
026D3F  B8 03 00              MOV    ax, 3                        ; UNKNOWN
026D42  03 46 0C              ADD    ax, word ptr [bp + 0xc]      ; UNKNOWN
026D45  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
026D48  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
026D4C  74 14                 JE     0x26d62                      ; UNKNOWN
026D4E  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026D51  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa]   ; UNKNOWN
026D55  83 E0 10              AND    ax, 0x10                     ; UNKNOWN
026D58  83 F8 01              CMP    ax, 1                        ; UNKNOWN
026D5B  1B C0                 SBB    ax, ax                       ; UNKNOWN
026D5D  83 E0 03              AND    ax, 3                        ; UNKNOWN
026D60  EB 03                 JMP    0x26d65                      ; UNKNOWN
026D62  B8 03 00              MOV    ax, 3                        ; UNKNOWN
026D65  D1 E0                 SHL    ax, 1                        ; UNKNOWN
026D67  2B 46 0E              SUB    ax, word ptr [bp + 0xe]      ; UNKNOWN
026D6A  F7 D8                 NEG    ax                           ; UNKNOWN
026D6C  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
026D6F  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
026D73  74 14                 JE     0x26d89                      ; UNKNOWN
026D75  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026D78  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa]   ; UNKNOWN
026D7C  83 E0 10              AND    ax, 0x10                     ; UNKNOWN
026D7F  83 F8 01              CMP    ax, 1                        ; UNKNOWN
026D82  1B C0                 SBB    ax, ax                       ; UNKNOWN
026D84  83 E0 03              AND    ax, 3                        ; UNKNOWN
026D87  EB 03                 JMP    0x26d8c                      ; UNKNOWN
026D89  B8 03 00              MOV    ax, 3                        ; UNKNOWN
026D8C  D1 E0                 SHL    ax, 1                        ; UNKNOWN
026D8E  2B 46 10              SUB    ax, word ptr [bp + 0x10]     ; UNKNOWN
026D91  F7 D8                 NEG    ax                           ; UNKNOWN
026D93  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
026D97  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
026D9B  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
026D9F  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
026DA3  50                    PUSH   ax                           ; UNKNOWN
026DA4  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
026DA7  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
026DAA  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
026DAD  A0 E4 09              MOV    al, byte ptr [0x9e4]         ; UNKNOWN
026DB0  50                    PUSH   ax                           ; UNKNOWN
026DB1  A0 E6 09              MOV    al, byte ptr [0x9e6]         ; UNKNOWN
026DB4  50                    PUSH   ax                           ; UNKNOWN
026DB5  6A 00                 PUSH   0                            ; UNKNOWN
026DB7  6A 00                 PUSH   0                            ; UNKNOWN
026DB9  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
026DBC  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
026DBF  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
026DC2  E8 E2 DE              CALL   0x24ca7                      ; UNKNOWN
026DC5  5E                    POP    si                           ; UNKNOWN
026DC6  5F                    POP    di                           ; UNKNOWN
026DC7  C9                    LEAVE                               ; UNKNOWN
026DC8  CB                    RETF                                ; UNKNOWN
