; ============================================================================
; func_04C227_unknown
; Region   : load_image
; Bytes    : file 0x04C227..0x04C4E5  (702 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C227  C8 20 01 00           ENTER  0x120, 0                     ; UNKNOWN
04C22B  57                    PUSH   di                           ; UNKNOWN
04C22C  56                    PUSH   si                           ; UNKNOWN
04C22D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04C230  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
04C235  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C238  6A 04                 PUSH   4                            ; UNKNOWN
04C23A  0E                    PUSH   cs                           ; UNKNOWN
04C23B  E8 24 EF              CALL   0x4b162                      ; UNKNOWN
04C23E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C241  68 90 00              PUSH   0x90                         ; UNKNOWN
04C244  6A 05                 PUSH   5                            ; UNKNOWN
04C246  68 40 01              PUSH   0x140                        ; UNKNOWN
04C249  6A 00                 PUSH   0                            ; UNKNOWN
04C24B  FF 36 5C 33           PUSH   word ptr [0x335c]            ; UNKNOWN
04C24F  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04C254  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C257  52                    PUSH   dx                           ; UNKNOWN
04C258  50                    PUSH   ax                           ; UNKNOWN
04C259  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04C25E  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04C261  68 91 00              PUSH   0x91                         ; UNKNOWN
04C264  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04C268  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04C26B  2A E4                 SUB    ah, ah                       ; UNKNOWN
04C26D  83 C0 06              ADD    ax, 6                        ; UNKNOWN
04C270  50                    PUSH   ax                           ; UNKNOWN
04C271  68 40 01              PUSH   0x140                        ; UNKNOWN
04C274  6A 00                 PUSH   0                            ; UNKNOWN
04C276  FF 36 6A 33           PUSH   word ptr [0x336a]            ; UNKNOWN
04C27A  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04C27F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C282  52                    PUSH   dx                           ; UNKNOWN
04C283  50                    PUSH   ax                           ; UNKNOWN
04C284  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04C289  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04C28C  C7 86 FA FE 02 00     MOV    word ptr [bp - 0x106], 2     ; UNKNOWN
04C292  C7 86 F8 FE 19 00     MOV    word ptr [bp - 0x108], 0x19  ; UNKNOWN
04C298  6A 3A                 PUSH   0x3a                         ; UNKNOWN
04C29A  6A 00                 PUSH   0                            ; UNKNOWN
04C29C  8D 86 3C FF           LEA    ax, [bp - 0xc4]              ; UNKNOWN
04C2A0  50                    PUSH   ax                           ; UNKNOWN
04C2A1  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
04C2A6  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04C2A9  C7 86 F2 FE 00 00     MOV    word ptr [bp - 0x10e], 0     ; UNKNOWN
04C2AF  8B B6 F2 FE           MOV    si, word ptr [bp - 0x10e]    ; UNKNOWN
04C2B3  D1 E6                 SHL    si, 1                        ; UNKNOWN
04C2B5  C7 42 C6 40 01        MOV    word ptr [bp + si - 0x3a], 0x140 ; UNKNOWN
04C2BA  C7 82 02 FF C8 00     MOV    word ptr [bp + si - 0xfe], 0xc8 ; UNKNOWN
04C2C0  FF 86 F2 FE           INC    word ptr [bp - 0x10e]        ; UNKNOWN
04C2C4  83 BE F2 FE 1D        CMP    word ptr [bp - 0x10e], 0x1d  ; UNKNOWN
04C2C9  7C E4                 JL     0x4c2af                      ; UNKNOWN
04C2CB  C7 86 F2 FE 00 00     MOV    word ptr [bp - 0x10e], 0     ; UNKNOWN
04C2D1  EB 30                 JMP    0x4c303                      ; UNKNOWN
04C2D3  FF 86 FC FE           INC    word ptr [bp - 0x104]        ; UNKNOWN
04C2D7  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
04C2DB  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
04C2DE  98                    CWDE                                ; UNKNOWN
04C2DF  3B 86 FC FE           CMP    ax, word ptr [bp - 0x104]    ; UNKNOWN
04C2E3  7E 1A                 JLE    0x4c2ff                      ; UNKNOWN
04C2E5  FF B6 FC FE           PUSH   word ptr [bp - 0x104]        ; UNKNOWN
04C2E9  9A 30 0E 5F 24        LCALL  0x245f, 0xe30                ; UNKNOWN
04C2EE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C2F1  8B F0                 MOV    si, ax                       ; UNKNOWN
04C2F3  89 B6 EC FE           MOV    word ptr [bp - 0x114], si    ; UNKNOWN
04C2F7  D1 E6                 SHL    si, 1                        ; UNKNOWN
04C2F9  FF 82 3C FF           INC    word ptr [bp + si - 0xc4]    ; UNKNOWN
04C2FD  EB D4                 JMP    0x4c2d3                      ; UNKNOWN
04C2FF  FF 86 F2 FE           INC    word ptr [bp - 0x10e]        ; UNKNOWN
04C303  8B 86 F2 FE           MOV    ax, word ptr [bp - 0x10e]    ; UNKNOWN
04C307  39 06 16 3E           CMP    word ptr [0x3e16], ax        ; UNKNOWN
04C30B  7E 1D                 JLE    0x4c32a                      ; UNKNOWN
04C30D  50                    PUSH   ax                           ; UNKNOWN
04C30E  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
04C313  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C316  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
04C319  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
04C31D  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
04C320  75 DD                 JNE    0x4c2ff                      ; UNKNOWN
04C322  C7 86 FC FE 00 00     MOV    word ptr [bp - 0x104], 0     ; UNKNOWN
04C328  EB AD                 JMP    0x4c2d7                      ; UNKNOWN
04C32A  C7 86 E6 FE 00 00     MOV    word ptr [bp - 0x11a], 0     ; UNKNOWN
04C330  EB 36                 JMP    0x4c368                      ; UNKNOWN
04C332  6B 9E E6 FE 1C        IMUL   bx, word ptr [bp - 0x11a], 0x1c ; UNKNOWN
04C337  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
04C33B  24 0F                 AND    al, 0xf                      ; UNKNOWN
04C33D  3A 46 06              CMP    al, byte ptr [bp + 6]        ; UNKNOWN
04C340  75 22                 JNE    0x4c364                      ; UNKNOWN
04C342  FF B6 E6 FE           PUSH   word ptr [bp - 0x11a]        ; UNKNOWN
04C346  9A D4 08 5F 24        LCALL  0x245f, 0x8d4                ; UNKNOWN
04C34B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C34E  0B C0                 OR     ax, ax                       ; UNKNOWN
04C350  74 12                 JE     0x4c364                      ; UNKNOWN
04C352  6B 9E E6 FE 1C        IMUL   bx, word ptr [bp - 0x11a], 0x1c ; UNKNOWN
04C357  8A 87 97 88           MOV    al, byte ptr [bx - 0x7769]   ; UNKNOWN
04C35B  98                    CWDE                                ; UNKNOWN
04C35C  8B F0                 MOV    si, ax                       ; UNKNOWN
04C35E  D1 E6                 SHL    si, 1                        ; UNKNOWN
04C360  FF 82 3C FF           INC    word ptr [bp + si - 0xc4]    ; UNKNOWN
04C364  FF 86 E6 FE           INC    word ptr [bp - 0x11a]        ; UNKNOWN
04C368  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
04C36B  39 86 E6 FE           CMP    word ptr [bp - 0x11a], ax    ; UNKNOWN
04C36F  7C C1                 JL     0x4c332                      ; UNKNOWN
04C371  8B 86 74 FF           MOV    ax, word ptr [bp - 0x8c]     ; UNKNOWN
04C375  01 86 62 FF           ADD    word ptr [bp - 0x9e], ax     ; UNKNOWN
04C379  8B 86 F8 FE           MOV    ax, word ptr [bp - 0x108]    ; UNKNOWN
04C37D  89 86 E4 FE           MOV    word ptr [bp - 0x11c], ax    ; UNKNOWN
04C381  8B 86 FA FE           MOV    ax, word ptr [bp - 0x106]    ; UNKNOWN
04C385  89 86 E8 FE           MOV    word ptr [bp - 0x118], ax    ; UNKNOWN
04C389  C7 86 EE FE 69 00     MOV    word ptr [bp - 0x112], 0x69  ; UNKNOWN
04C38F  C7 86 EA FE 12 00     MOV    word ptr [bp - 0x116], 0x12  ; UNKNOWN
04C395  2B C0                 SUB    ax, ax                       ; UNKNOWN
04C397  89 86 FE FE           MOV    word ptr [bp - 0x102], ax    ; UNKNOWN
04C39B  89 86 F6 FE           MOV    word ptr [bp - 0x10a], ax    ; UNKNOWN
04C39F  89 86 F2 FE           MOV    word ptr [bp - 0x10e], ax    ; UNKNOWN
04C3A3  E9 34 01              JMP    0x4c4da                      ; UNKNOWN
04C3A6  8B 86 F2 FE           MOV    ax, word ptr [bp - 0x10e]    ; UNKNOWN
04C3AA  89 86 E6 FE           MOV    word ptr [bp - 0x11a], ax    ; UNKNOWN
04C3AE  83 F8 13              CMP    ax, 0x13                     ; UNKNOWN
04C3B1  75 03                 JNE    0x4c3b6                      ; UNKNOWN
04C3B3  E9 20 01              JMP    0x4c4d6                      ; UNKNOWN
04C3B6  83 F8 17              CMP    ax, 0x17                     ; UNKNOWN
04C3B9  75 03                 JNE    0x4c3be                      ; UNKNOWN
04C3BB  E9 18 01              JMP    0x4c4d6                      ; UNKNOWN
04C3BE  83 F8 12              CMP    ax, 0x12                     ; UNKNOWN
04C3C1  75 03                 JNE    0x4c3c6                      ; UNKNOWN
04C3C3  E9 10 01              JMP    0x4c4d6                      ; UNKNOWN
04C3C6  83 F8 1C              CMP    ax, 0x1c                     ; UNKNOWN
04C3C9  75 06                 JNE    0x4c3d1                      ; UNKNOWN
04C3CB  C7 86 E6 FE 13 00     MOV    word ptr [bp - 0x11a], 0x13  ; UNKNOWN
04C3D1  8B 86 E4 FE           MOV    ax, word ptr [bp - 0x11c]    ; UNKNOWN
04C3D5  8B B6 E6 FE           MOV    si, word ptr [bp - 0x11a]    ; UNKNOWN
04C3D9  D1 E6                 SHL    si, 1                        ; UNKNOWN
04C3DB  89 82 02 FF           MOV    word ptr [bp + si - 0xfe], ax ; UNKNOWN
04C3DF  6A 03                 PUSH   3                            ; UNKNOWN
04C3E1  8B 86 E6 FE           MOV    ax, word ptr [bp - 0x11a]    ; UNKNOWN
04C3E5  9A 0C 00 76 1A        LCALL  0x1a76, 0xc                  ; UNKNOWN
04C3EA  8B 9E E4 FE           MOV    bx, word ptr [bp - 0x11c]    ; UNKNOWN
04C3EE  4B                    DEC    bx                           ; UNKNOWN
04C3EF  8B 96 E8 FE           MOV    dx, word ptr [bp - 0x118]    ; UNKNOWN
04C3F3  89 52 C6              MOV    word ptr [bp + si - 0x3a], dx ; UNKNOWN
04C3F6  8B FA                 MOV    di, dx                       ; UNKNOWN
04C3F8  9A 60 01 76 1A        LCALL  0x1a76, 0x160                ; UNKNOWN
04C3FD  C6 86 76 FF 00        MOV    byte ptr [bp - 0x8a], 0      ; UNKNOWN
04C402  8B 9E E6 FE           MOV    bx, word ptr [bp - 0x11a]    ; UNKNOWN
04C406  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
04C409  FF B7 35 38           PUSH   word ptr [bx + 0x3835]       ; UNKNOWN
04C40D  8D 86 76 FF           LEA    ax, [bp - 0x8a]              ; UNKNOWN
04C411  50                    PUSH   ax                           ; UNKNOWN
04C412  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04C417  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04C41A  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
04C41E  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
04C422  8D 86 76 FF           LEA    ax, [bp - 0x8a]              ; UNKNOWN
04C426  16                    PUSH   ss                           ; UNKNOWN
04C427  50                    PUSH   ax                           ; UNKNOWN
04C428  2B C0                 SUB    ax, ax                       ; UNKNOWN
04C42A  9A 0E 00 75 5B        LCALL  0x5b75, 0xe                  ; UNKNOWN
04C42F  48                    DEC    ax                           ; UNKNOWN
04C430  89 86 E2 FE           MOV    word ptr [bp - 0x11e], ax    ; UNKNOWN
04C434  68 92 00              PUSH   0x92                         ; UNKNOWN
04C437  8B 86 E4 FE           MOV    ax, word ptr [bp - 0x11c]    ; UNKNOWN
04C43B  40                    INC    ax                           ; UNKNOWN
04C43C  50                    PUSH   ax                           ; UNKNOWN
04C43D  8D 4D 0C              LEA    cx, [di + 0xc]               ; UNKNOWN
04C440  51                    PUSH   cx                           ; UNKNOWN
04C441  8D 8E 76 FF           LEA    cx, [bp - 0x8a]              ; UNKNOWN
04C445  16                    PUSH   ss                           ; UNKNOWN
04C446  51                    PUSH   cx                           ; UNKNOWN
04C447  89 86 E0 FE           MOV    word ptr [bp - 0x120], ax    ; UNKNOWN
04C44B  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04C450  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04C453  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04C457  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04C45A  2A E4                 SUB    ah, ah                       ; UNKNOWN
04C45C  03 86 E0 FE           ADD    ax, word ptr [bp - 0x120]    ; UNKNOWN
04C460  40                    INC    ax                           ; UNKNOWN
04C461  89 86 F0 FE           MOV    word ptr [bp - 0x110], ax    ; UNKNOWN
04C465  C6 86 76 FF 00        MOV    byte ptr [bp - 0x8a], 0      ; UNKNOWN
04C46A  FF B2 3C FF           PUSH   word ptr [bp + si - 0xc4]    ; UNKNOWN
04C46E  8D 86 76 FF           LEA    ax, [bp - 0x8a]              ; UNKNOWN
04C472  16                    PUSH   ss                           ; UNKNOWN
04C473  50                    PUSH   ax                           ; UNKNOWN
04C474  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
04C479  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04C47C  8D 45 27              LEA    ax, [di + 0x27]              ; UNKNOWN
04C47F  89 86 F4 FE           MOV    word ptr [bp - 0x10c], ax    ; UNKNOWN
04C483  6A 61                 PUSH   0x61                         ; UNKNOWN
04C485  FF B6 F0 FE           PUSH   word ptr [bp - 0x110]        ; UNKNOWN
04C489  50                    PUSH   ax                           ; UNKNOWN
04C48A  8D 86 76 FF           LEA    ax, [bp - 0x8a]              ; UNKNOWN
04C48E  16                    PUSH   ss                           ; UNKNOWN
04C48F  50                    PUSH   ax                           ; UNKNOWN
04C490  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04C495  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04C498  8B 86 EA FE           MOV    ax, word ptr [bp - 0x116]    ; UNKNOWN
04C49C  01 86 E4 FE           ADD    word ptr [bp - 0x11c], ax    ; UNKNOWN
04C4A0  83 BE F6 FE 01        CMP    word ptr [bp - 0x10a], 1     ; UNKNOWN
04C4A5  1B C0                 SBB    ax, ax                       ; UNKNOWN
04C4A7  40                    INC    ax                           ; UNKNOWN
04C4A8  83 C0 08              ADD    ax, 8                        ; UNKNOWN
04C4AB  FF 86 FE FE           INC    word ptr [bp - 0x102]        ; UNKNOWN
04C4AF  3B 86 FE FE           CMP    ax, word ptr [bp - 0x102]    ; UNKNOWN
04C4B3  7F 21                 JG     0x4c4d6                      ; UNKNOWN
04C4B5  83 BE F6 FE 02        CMP    word ptr [bp - 0x10a], 2     ; UNKNOWN
04C4BA  7D 1A                 JGE    0x4c4d6                      ; UNKNOWN
04C4BC  C7 86 FE FE 00 00     MOV    word ptr [bp - 0x102], 0     ; UNKNOWN
04C4C2  FF 86 F6 FE           INC    word ptr [bp - 0x10a]        ; UNKNOWN
04C4C6  8B 86 F8 FE           MOV    ax, word ptr [bp - 0x108]    ; UNKNOWN
04C4CA  89 86 E4 FE           MOV    word ptr [bp - 0x11c], ax    ; UNKNOWN
04C4CE  03 BE EE FE           ADD    di, word ptr [bp - 0x112]    ; UNKNOWN
04C4D2  89 BE E8 FE           MOV    word ptr [bp - 0x118], di    ; UNKNOWN
04C4D6  FF 86 F2 FE           INC    word ptr [bp - 0x10e]        ; UNKNOWN
04C4DA  83 BE F2 FE 1D        CMP    word ptr [bp - 0x10e], 0x1d  ; UNKNOWN
04C4DF  7D 03                 JGE    0x4c4e4                      ; UNKNOWN
04C4E1  E9 C2 FE              JMP    0x4c3a6                      ; UNKNOWN
04C4E4  6A                    DB     0x6A                         ; UNKNOWN (raw)
