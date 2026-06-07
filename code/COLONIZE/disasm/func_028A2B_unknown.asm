; ============================================================================
; func_028A2B_unknown
; Region   : load_image
; Bytes    : file 0x028A2B..0x028B9C  (369 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028A2B  C8 5C 00 00           ENTER  0x5c, 0                      ; UNKNOWN
028A2F  56                    PUSH   si                           ; UNKNOWN
028A30  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
028A35  C7 46 A6 00 00        MOV    word ptr [bp - 0x5a], 0      ; UNKNOWN
028A3A  2B C0                 SUB    ax, ax                       ; UNKNOWN
028A3C  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
028A3F  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
028A42  83 3E 18 3E 01        CMP    word ptr [0x3e18], 1         ; UNKNOWN
028A47  7D 12                 JGE    0x28a5b                      ; UNKNOWN
028A49  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
028A4D  8D 06 76 19           LEA    ax, [0x1976]                 ; UNKNOWN
028A51  2B D2                 SUB    dx, dx                       ; UNKNOWN
028A53  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
028A58  E9 28 01              JMP    0x28b83                      ; UNKNOWN
028A5B  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
028A5F  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
028A62  2B D2                 SUB    dx, dx                       ; UNKNOWN
028A64  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
028A69  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
028A6C  89 56 AA              MOV    word ptr [bp - 0x56], dx     ; UNKNOWN
028A6F  0B D0                 OR     dx, ax                       ; UNKNOWN
028A71  75 03                 JNE    0x28a76                      ; UNKNOWN
028A73  E9 0D 01              JMP    0x28b83                      ; UNKNOWN
028A76  C4 5E A8              LES    bx, ptr [bp - 0x58]          ; UNKNOWN
028A79  26 80 4F 0A 01        OR     byte ptr es:[bx + 0xa], 1    ; UNKNOWN
028A7E  26 C7 47 22 0A 00     MOV    word ptr es:[bx + 0x22], 0xa ; UNKNOWN
028A84  C7 46 A4 00 00        MOV    word ptr [bp - 0x5c], 0      ; UNKNOWN
028A89  EB 76                 JMP    0x28b01                      ; UNKNOWN
028A8B  2A C0                 SUB    al, al                       ; UNKNOWN
028A8D  C4 1E 8A 40           LES    bx, ptr [0x408a]             ; UNKNOWN
028A91  26 3A 47 20           CMP    al, byte ptr es:[bx + 0x20]  ; UNKNOWN
028A95  75 67                 JNE    0x28afe                      ; UNKNOWN
028A97  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
028A9B  8B 46 A4              MOV    ax, word ptr [bp - 0x5c]     ; UNKNOWN
028A9E  40                    INC    ax                           ; UNKNOWN
028A9F  50                    PUSH   ax                           ; UNKNOWN
028AA0  8D 4E AE              LEA    cx, [bp - 0x52]              ; UNKNOWN
028AA3  16                    PUSH   ss                           ; UNKNOWN
028AA4  51                    PUSH   cx                           ; UNKNOWN
028AA5  8B F0                 MOV    si, ax                       ; UNKNOWN
028AA7  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
028AAC  83 C4 06              ADD    sp, 6                        ; UNKNOWN
028AAF  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
028AB2  50                    PUSH   ax                           ; UNKNOWN
028AB3  9A 5D 00 13 24        LCALL  0x2413, 0x5d                 ; UNKNOWN
028AB8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
028ABB  FF 36 8C 40           PUSH   word ptr [0x408c]            ; UNKNOWN
028ABF  FF 36 8A 40           PUSH   word ptr [0x408a]            ; UNKNOWN
028AC3  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
028AC6  16                    PUSH   ss                           ; UNKNOWN
028AC7  50                    PUSH   ax                           ; UNKNOWN
028AC8  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
028ACD  83 C4 08              ADD    sp, 8                        ; UNKNOWN
028AD0  56                    PUSH   si                           ; UNKNOWN
028AD1  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
028AD4  16                    PUSH   ss                           ; UNKNOWN
028AD5  50                    PUSH   ax                           ; UNKNOWN
028AD6  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
028AD9  FF 76 A8              PUSH   word ptr [bp - 0x58]         ; UNKNOWN
028ADC  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
028AE1  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
028AE4  FF 46 A6              INC    word ptr [bp - 0x5a]         ; UNKNOWN
028AE7  8B 46 A4              MOV    ax, word ptr [bp - 0x5c]     ; UNKNOWN
028AEA  39 46 08              CMP    word ptr [bp + 8], ax        ; UNKNOWN
028AED  75 0F                 JNE    0x28afe                      ; UNKNOWN
028AEF  56                    PUSH   si                           ; UNKNOWN
028AF0  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
028AF3  FF 76 A8              PUSH   word ptr [bp - 0x58]         ; UNKNOWN
028AF6  9A C9 09 97 1B        LCALL  0x1b97, 0x9c9                ; UNKNOWN
028AFB  83 C4 06              ADD    sp, 6                        ; UNKNOWN
028AFE  FF 46 A4              INC    word ptr [bp - 0x5c]         ; UNKNOWN
028B01  8B 46 A4              MOV    ax, word ptr [bp - 0x5c]     ; UNKNOWN
028B04  39 06 18 3E           CMP    word ptr [0x3e18], ax        ; UNKNOWN
028B08  7E 1F                 JLE    0x28b29                      ; UNKNOWN
028B0A  50                    PUSH   ax                           ; UNKNOWN
028B0B  0E                    PUSH   cs                           ; UNKNOWN
028B0C  E8 95 F7              CALL   0x282a4                      ; UNKNOWN
028B0F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
028B12  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
028B16  75 03                 JNE    0x28b1b                      ; UNKNOWN
028B18  E9 7C FF              JMP    0x28a97                      ; UNKNOWN
028B1B  83 7E 06 02           CMP    word ptr [bp + 6], 2         ; UNKNOWN
028B1F  74 03                 JE     0x28b24                      ; UNKNOWN
028B21  E9 67 FF              JMP    0x28a8b                      ; UNKNOWN
028B24  B0 01                 MOV    al, 1                        ; UNKNOWN
028B26  E9 64 FF              JMP    0x28a8d                      ; UNKNOWN
028B29  83 7E A6 00           CMP    word ptr [bp - 0x5a], 0      ; UNKNOWN
028B2D  75 3E                 JNE    0x28b6d                      ; UNKNOWN
028B2F  83 7E 06 02           CMP    word ptr [bp + 6], 2         ; UNKNOWN
028B33  75 05                 JNE    0x28b3a                      ; UNKNOWN
028B35  B8 01 00              MOV    ax, 1                        ; UNKNOWN
028B38  EB 02                 JMP    0x28b3c                      ; UNKNOWN
028B3A  2B C0                 SUB    ax, ax                       ; UNKNOWN
028B3C  C4 1E 8A 40           LES    bx, ptr [0x408a]             ; UNKNOWN
028B40  26 8A 4F 20           MOV    cl, byte ptr es:[bx + 0x20]  ; UNKNOWN
028B44  2A ED                 SUB    ch, ch                       ; UNKNOWN
028B46  3B C1                 CMP    ax, cx                       ; UNKNOWN
028B48  75 05                 JNE    0x28b4f                      ; UNKNOWN
028B4A  BB 03 00              MOV    bx, 3                        ; UNKNOWN
028B4D  EB 03                 JMP    0x28b52                      ; UNKNOWN
028B4F  BB 04 00              MOV    bx, 4                        ; UNKNOWN
028B52  D1 E3                 SHL    bx, 1                        ; UNKNOWN
028B54  FF B7 D9 3B           PUSH   word ptr [bx + 0x3bd9]       ; UNKNOWN
028B58  6A 00                 PUSH   0                            ; UNKNOWN
028B5A  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
028B5F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
028B62  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
028B66  8D 06 80 19           LEA    ax, [0x1980]                 ; UNKNOWN
028B6A  E9 E4 FE              JMP    0x28a51                      ; UNKNOWN
028B6D  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
028B70  FF 76 A8              PUSH   word ptr [bp - 0x58]         ; UNKNOWN
028B73  9A 4A 25 97 1B        LCALL  0x1b97, 0x254a               ; UNKNOWN
028B78  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
028B7B  0B C0                 OR     ax, ax                       ; UNKNOWN
028B7D  7E 04                 JLE    0x28b83                      ; UNKNOWN
028B7F  48                    DEC    ax                           ; UNKNOWN
028B80  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
028B83  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
028B86  0B 46 A8              OR     ax, word ptr [bp - 0x58]     ; UNKNOWN
028B89  74 0B                 JE     0x28b96                      ; UNKNOWN
028B8B  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
028B8E  FF 76 A8              PUSH   word ptr [bp - 0x58]         ; UNKNOWN
028B91  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
028B96  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
028B99  5E                    POP    si                           ; UNKNOWN
028B9A  C9                    LEAVE                               ; UNKNOWN
028B9B  CB                    RETF                                ; UNKNOWN
