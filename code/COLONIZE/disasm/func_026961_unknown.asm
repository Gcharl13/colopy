; ============================================================================
; func_026961_unknown
; Region   : load_image
; Bytes    : file 0x026961..0x026AF8  (407 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026961  C8 16 00 00           ENTER  0x16, 0                      ; UNKNOWN
026965  53                    PUSH   bx                           ; UNKNOWN
026966  52                    PUSH   dx                           ; UNKNOWN
026967  50                    PUSH   ax                           ; UNKNOWN
026968  56                    PUSH   si                           ; UNKNOWN
026969  C7 06 0A 0A 00 00     MOV    word ptr [0xa0a], 0          ; UNKNOWN
02696F  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
026972  26 8B 47 5E           MOV    ax, word ptr es:[bx + 0x5e]  ; UNKNOWN
026976  26 0B 47 5C           OR     ax, word ptr es:[bx + 0x5c]  ; UNKNOWN
02697A  75 03                 JNE    0x2697f                      ; UNKNOWN
02697C  E9 33 02              JMP    0x26bb2                      ; UNKNOWN
02697F  26 8B 47 5C           MOV    ax, word ptr es:[bx + 0x5c]  ; UNKNOWN
026983  26 8B 57 5E           MOV    dx, word ptr es:[bx + 0x5e]  ; UNKNOWN
026987  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
02698A  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
02698D  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
026990  26 8B 47 12           MOV    ax, word ptr es:[bx + 0x12]  ; UNKNOWN
026994  26 0B 47 10           OR     ax, word ptr es:[bx + 0x10]  ; UNKNOWN
026998  74 0A                 JE     0x269a4                      ; UNKNOWN
02699A  26 8B 47 10           MOV    ax, word ptr es:[bx + 0x10]  ; UNKNOWN
02699E  26 8B 57 12           MOV    dx, word ptr es:[bx + 0x12]  ; UNKNOWN
0269A2  EB E3                 JMP    0x26987                      ; UNKNOWN
0269A4  26 8B 47 02           MOV    ax, word ptr es:[bx + 2]     ; UNKNOWN
0269A8  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
0269AB  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
0269AE  26 8B 47 5C           MOV    ax, word ptr es:[bx + 0x5c]  ; UNKNOWN
0269B2  26 8B 57 5E           MOV    dx, word ptr es:[bx + 0x5e]  ; UNKNOWN
0269B6  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
0269B9  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
0269BC  26 8B 47 0A           MOV    ax, word ptr es:[bx + 0xa]   ; UNKNOWN
0269C0  8B C8                 MOV    cx, ax                       ; UNKNOWN
0269C2  83 E0 10              AND    ax, 0x10                     ; UNKNOWN
0269C5  83 F8 01              CMP    ax, 1                        ; UNKNOWN
0269C8  1B C0                 SBB    ax, ax                       ; UNKNOWN
0269CA  83 E0 03              AND    ax, 3                        ; UNKNOWN
0269CD  8B D0                 MOV    dx, ax                       ; UNKNOWN
0269CF  26 03 47 10           ADD    ax, word ptr es:[bx + 0x10]  ; UNKNOWN
0269D3  26 03 57 12           ADD    dx, word ptr es:[bx + 0x12]  ; UNKNOWN
0269D7  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
0269DA  26 03 47 48           ADD    ax, word ptr es:[bx + 0x48]  ; UNKNOWN
0269DE  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0269E1  26 03 57 46           ADD    dx, word ptr es:[bx + 0x46]  ; UNKNOWN
0269E5  F6 C1 02              TEST   cl, 2                        ; UNKNOWN
0269E8  74 07                 JE     0x269f1                      ; UNKNOWN
0269EA  C7 46 EE 10 00        MOV    word ptr [bp - 0x12], 0x10   ; UNKNOWN
0269EF  EB 1B                 JMP    0x26a0c                      ; UNKNOWN
0269F1  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
0269F4  26 8B 77 04           MOV    si, word ptr es:[bx + 4]     ; UNKNOWN
0269F8  8B C6                 MOV    ax, si                       ; UNKNOWN
0269FA  D1 E6                 SHL    si, 1                        ; UNKNOWN
0269FC  03 F0                 ADD    si, ax                       ; UNKNOWN
0269FE  C1 E6 02              SHL    si, 2                        ; UNKNOWN
026A01  26 C4 5F 0C           LES    bx, ptr es:[bx + 0xc]        ; UNKNOWN
026A05  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; UNKNOWN
026A09  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
026A0C  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
026A0F  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
026A12  26 2B 07              SUB    ax, word ptr es:[bx]         ; UNKNOWN
026A15  40                    INC    ax                           ; UNKNOWN
026A16  83 7E E6 00           CMP    word ptr [bp - 0x1a], 0      ; UNKNOWN
026A1A  74 47                 JE     0x26a63                      ; UNKNOWN
026A1C  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
026A20  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
026A24  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
026A28  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
026A2C  40                    INC    ax                           ; UNKNOWN
026A2D  40                    INC    ax                           ; UNKNOWN
026A2E  50                    PUSH   ax                           ; UNKNOWN
026A2F  8C C0                 MOV    ax, es                       ; UNKNOWN
026A31  C4 76 04              LES    si, ptr [bp + 4]             ; UNKNOWN
026A34  26 FF 74 10           PUSH   word ptr es:[si + 0x10]      ; UNKNOWN
026A38  26 FF 74 12           PUSH   word ptr es:[si + 0x12]      ; UNKNOWN
026A3C  26 FF 74 14           PUSH   word ptr es:[si + 0x14]      ; UNKNOWN
026A40  26 8A 4C 3C           MOV    cl, byte ptr es:[si + 0x3c]  ; UNKNOWN
026A44  51                    PUSH   cx                           ; UNKNOWN
026A45  26 8A 4C 3E           MOV    cl, byte ptr es:[si + 0x3e]  ; UNKNOWN
026A49  51                    PUSH   cx                           ; UNKNOWN
026A4A  6A 00                 PUSH   0                            ; UNKNOWN
026A4C  6A 00                 PUSH   0                            ; UNKNOWN
026A4E  8E C0                 MOV    es, ax                       ; UNKNOWN
026A50  26 8B 17              MOV    dx, word ptr es:[bx]         ; UNKNOWN
026A53  03 56 FC              ADD    dx, word ptr [bp - 4]        ; UNKNOWN
026A56  4A                    DEC    dx                           ; UNKNOWN
026A57  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
026A5A  48                    DEC    ax                           ; UNKNOWN
026A5B  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
026A5E  43                    INC    bx                           ; UNKNOWN
026A5F  43                    INC    bx                           ; UNKNOWN
026A60  E8 44 E2              CALL   0x24ca7                      ; UNKNOWN
026A63  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
026A66  0B 46 F4              OR     ax, word ptr [bp - 0xc]      ; UNKNOWN
026A69  75 03                 JNE    0x26a6e                      ; UNKNOWN
026A6B  E9 28 01              JMP    0x26b96                      ; UNKNOWN
026A6E  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
026A71  26 F6 47 0A 02        TEST   byte ptr es:[bx + 0xa], 2    ; UNKNOWN
026A76  74 1E                 JE     0x26a96                      ; UNKNOWN
026A78  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
026A7B  26 8B 07              MOV    ax, word ptr es:[bx]         ; UNKNOWN
026A7E  03 46 FC              ADD    ax, word ptr [bp - 4]        ; UNKNOWN
026A81  50                    PUSH   ax                           ; UNKNOWN
026A82  6A 10                 PUSH   0x10                         ; UNKNOWN
026A84  6A 64                 PUSH   0x64                         ; UNKNOWN
026A86  26 8B 47 04           MOV    ax, word ptr es:[bx + 4]     ; UNKNOWN
026A8A  2B D2                 SUB    dx, dx                       ; UNKNOWN
026A8C  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
026A8F  9A BD 01 76 1A        LCALL  0x1a76, 0x1bd                ; UNKNOWN
026A94  EB 22                 JMP    0x26ab8                      ; UNKNOWN
026A96  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
026A99  26 FF 77 0E           PUSH   word ptr es:[bx + 0xe]       ; UNKNOWN
026A9D  26 FF 77 0C           PUSH   word ptr es:[bx + 0xc]       ; UNKNOWN
026AA1  26 8B 07              MOV    ax, word ptr es:[bx]         ; UNKNOWN
026AA4  03 46 FC              ADD    ax, word ptr [bp - 4]        ; UNKNOWN
026AA7  50                    PUSH   ax                           ; UNKNOWN
026AA8  26 8B 47 04           MOV    ax, word ptr es:[bx + 4]     ; UNKNOWN
026AAC  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
026AB0  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
026AB3  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
026AB8  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
026ABB  8B 56 F6              MOV    dx, word ptr [bp - 0xa]      ; UNKNOWN
026ABE  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
026AC1  26 39 47 50           CMP    word ptr es:[bx + 0x50], ax  ; UNKNOWN
026AC5  75 50                 JNE    0x26b17                      ; UNKNOWN
026AC7  26 39 57 52           CMP    word ptr es:[bx + 0x52], dx  ; UNKNOWN
026ACB  75 4A                 JNE    0x26b17                      ; UNKNOWN
026ACD  83 7E E8 00           CMP    word ptr [bp - 0x18], 0      ; UNKNOWN
026AD1  74 44                 JE     0x26b17                      ; UNKNOWN
026AD3  26 F6 47 0A 80        TEST   byte ptr es:[bx + 0xa], 0x80 ; UNKNOWN
026AD8  74 3D                 JE     0x26b17                      ; UNKNOWN
026ADA  26 8B 4F 66           MOV    cx, word ptr es:[bx + 0x66]  ; UNKNOWN
026ADE  26 0B 4F 64           OR     cx, word ptr es:[bx + 0x64]  ; UNKNOWN
026AE2  74 33                 JE     0x26b17                      ; UNKNOWN
026AE4  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
026AE8  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
026AEC  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
026AF0  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
026AF4  8E C2                 MOV    es, dx                       ; UNKNOWN
026AF6  8B D8                 MOV    bx, ax                       ; UNKNOWN
