; ============================================================================
; func_038BAF_unknown
; Region   : load_image
; Bytes    : file 0x038BAF..0x038D59  (426 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

038BAF  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
038BB3  56                    PUSH   si                           ; UNKNOWN
038BB4  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
038BB9  74 03                 JE     0x38bbe                      ; UNKNOWN
038BBB  E9 C0 01              JMP    0x38d7e                      ; UNKNOWN
038BBE  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
038BC1  0E                    PUSH   cs                           ; UNKNOWN
038BC2  E8 5F A2              CALL   0x32e24                      ; UNKNOWN
038BC5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038BC8  FF 36 86 3E           PUSH   word ptr [0x3e86]            ; UNKNOWN
038BCC  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
038BD1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038BD4  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038BD8  80 27 DF              AND    byte ptr [bx], 0xdf          ; UNKNOWN
038BDB  6A FF                 PUSH   -1                           ; UNKNOWN
038BDD  6A 00                 PUSH   0                            ; UNKNOWN
038BDF  0E                    PUSH   cs                           ; UNKNOWN
038BE0  E8 98 A2              CALL   0x32e7b                      ; UNKNOWN
038BE3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038BE6  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
038BE9  50                    PUSH   ax                           ; UNKNOWN
038BEA  FF 36 9A 79           PUSH   word ptr [0x799a]            ; UNKNOWN
038BEE  0E                    PUSH   cs                           ; UNKNOWN
038BEF  E8 BD F9              CALL   0x385af                      ; UNKNOWN
038BF2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038BF5  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
038BF8  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038BFC  89 47 30              MOV    word ptr [bx + 0x30], ax     ; UNKNOWN
038BFF  8B 4E F6              MOV    cx, word ptr [bp - 0xa]      ; UNKNOWN
038C02  01 4F 2E              ADD    word ptr [bx + 0x2e], cx     ; UNKNOWN
038C05  8B 4F 2E              MOV    cx, word ptr [bx + 0x2e]     ; UNKNOWN
038C08  0B C9                 OR     cx, cx                       ; UNKNOWN
038C0A  7D 02                 JGE    0x38c0e                      ; UNKNOWN
038C0C  2B C9                 SUB    cx, cx                       ; UNKNOWN
038C0E  89 4F 2E              MOV    word ptr [bx + 0x2e], cx     ; UNKNOWN
038C11  3B C8                 CMP    cx, ax                       ; UNKNOWN
038C13  7F 03                 JG     0x38c18                      ; UNKNOWN
038C15  E9 5A 01              JMP    0x38d72                      ; UNKNOWN
038C18  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; UNKNOWN
038C1C  7D 26                 JGE    0x38c44                      ; UNKNOWN
038C1E  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34  ; UNKNOWN
038C22  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
038C27  75 1B                 JNE    0x38c44                      ; UNKNOWN
038C29  6A 02                 PUSH   2                            ; UNKNOWN
038C2B  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
038C30  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038C33  83 3E 1C 0F 00        CMP    word ptr [0xf1c], 0          ; UNKNOWN
038C38  75 0A                 JNE    0x38c44                      ; UNKNOWN
038C3A  6A 02                 PUSH   2                            ; UNKNOWN
038C3C  9A 11 03 28 1A        LCALL  0x1a28, 0x311                ; UNKNOWN
038C41  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038C44  6A 14                 PUSH   0x14                         ; UNKNOWN
038C46  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
038C49  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
038C4E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038C51  0B C0                 OR     ax, ax                       ; UNKNOWN
038C53  74 0E                 JE     0x38c63                      ; UNKNOWN
038C55  6A 01                 PUSH   1                            ; UNKNOWN
038C57  6A 00                 PUSH   0                            ; UNKNOWN
038C59  0E                    PUSH   cs                           ; UNKNOWN
038C5A  E8 C6 E9              CALL   0x37623                      ; UNKNOWN
038C5D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038C60  E9 D5 00              JMP    0x38d38                      ; UNKNOWN
038C63  6A 02                 PUSH   2                            ; UNKNOWN
038C65  2B C0                 SUB    ax, ax                       ; UNKNOWN
038C67  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038C6B  89 47 2E              MOV    word ptr [bx + 0x2e], ax     ; UNKNOWN
038C6E  50                    PUSH   ax                           ; UNKNOWN
038C6F  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
038C74  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038C77  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
038C7A  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038C7E  8B F0                 MOV    si, ax                       ; UNKNOWN
038C80  8A 40 02              MOV    al, byte ptr [bx + si + 2]   ; UNKNOWN
038C83  2A E4                 SUB    ah, ah                       ; UNKNOWN
038C85  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
038C88  A0 06 3E              MOV    al, byte ptr [0x3e06]        ; UNKNOWN
038C8B  83 E0 03              AND    ax, 3                        ; UNKNOWN
038C8E  83 F8 01              CMP    ax, 1                        ; UNKNOWN
038C91  1B C0                 SBB    ax, ax                       ; UNKNOWN
038C93  F7 D8                 NEG    ax                           ; UNKNOWN
038C95  50                    PUSH   ax                           ; UNKNOWN
038C96  0E                    PUSH   cs                           ; UNKNOWN
038C97  E8 DC E7              CALL   0x37476                      ; UNKNOWN
038C9A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038C9D  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038CA1  88 40 02              MOV    byte ptr [bx + si + 2], al   ; UNKNOWN
038CA4  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
038CA7  0E                    PUSH   cs                           ; UNKNOWN
038CA8  E8 89 A8              CALL   0x33534                      ; UNKNOWN
038CAB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038CAE  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
038CB1  0B C0                 OR     ax, ax                       ; UNKNOWN
038CB3  7D 03                 JGE    0x38cb8                      ; UNKNOWN
038CB5  E9 80 00              JMP    0x38d38                      ; UNKNOWN
038CB8  50                    PUSH   ax                           ; UNKNOWN
038CB9  9A 9E 03 B7 36        LCALL  0x36b7, 0x39e                ; UNKNOWN
038CBE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
038CC1  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; UNKNOWN
038CC5  7D 6A                 JGE    0x38d31                      ; UNKNOWN
038CC7  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34  ; UNKNOWN
038CCB  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
038CD0  75 5F                 JNE    0x38d31                      ; UNKNOWN
038CD2  83 7E FA 1C           CMP    word ptr [bp - 6], 0x1c      ; UNKNOWN
038CD6  75 05                 JNE    0x38cdd                      ; UNKNOWN
038CD8  C7 46 FA 13 00        MOV    word ptr [bp - 6], 0x13      ; UNKNOWN
038CDD  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
038CE0  D1 E3                 SHL    bx, 1                        ; UNKNOWN
038CE2  FF B7 E1 37           PUSH   word ptr [bx + 0x37e1]       ; UNKNOWN
038CE6  6A 00                 PUSH   0                            ; UNKNOWN
038CE8  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
038CED  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038CF0  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
038CF3  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
038CF6  FF B7 35 38           PUSH   word ptr [bx + 0x3835]       ; UNKNOWN
038CFA  6A 01                 PUSH   1                            ; UNKNOWN
038CFC  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
038D01  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038D04  6A 04                 PUSH   4                            ; UNKNOWN
038D06  68 B9 21              PUSH   0x21b9                       ; UNKNOWN
038D09  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
038D0E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038D11  F6 06 FA 3D 80        TEST   byte ptr [0x3dfa], 0x80      ; UNKNOWN
038D16  74 19                 JE     0x38d31                      ; UNKNOWN
038D18  F6 06 FF 3D 01        TEST   byte ptr [0x3dff], 1         ; UNKNOWN
038D1D  75 12                 JNE    0x38d31                      ; UNKNOWN
038D1F  6A 00                 PUSH   0                            ; UNKNOWN
038D21  68 C0 21              PUSH   0x21c0                       ; UNKNOWN
038D24  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
038D29  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038D2C  80 0E FF 3D 01        OR     byte ptr [0x3dff], 1         ; UNKNOWN
038D31  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
038D35  80 0F 40              OR     byte ptr [bx], 0x40          ; UNKNOWN
038D38  83 3E 9A 79 04        CMP    word ptr [0x799a], 4         ; UNKNOWN
038D3D  7D 33                 JGE    0x38d72                      ; UNKNOWN
038D3F  6B 1E 9A 79 34        IMUL   bx, word ptr [0x799a], 0x34  ; UNKNOWN
038D44  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
038D49  75 27                 JNE    0x38d72                      ; UNKNOWN
038D4B  6A 0E                 PUSH   0xe                          ; UNKNOWN
038D4D  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
038D50  8B D0                 MOV    dx, ax                       ; UNKNOWN
038D52  83 EA 14              SUB    dx, 0x14                     ; UNKNOWN
038D55  8B C2                 MOV    ax, dx                       ; UNKNOWN
038D57  9A                    DB     0x9A                         ; UNKNOWN (raw)
038D58  60                    DB     0x60                         ; UNKNOWN (raw)
