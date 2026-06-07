; ============================================================================
; func_0425E4_unknown
; Region   : load_image
; Bytes    : file 0x0425E4..0x0426DB  (247 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0425E4  C8 00 03 00           ENTER  0x300, 0                     ; UNKNOWN
0425E8  8D 86 00 FD           LEA    ax, [bp - 0x300]             ; UNKNOWN
0425EC  16                    PUSH   ss                           ; UNKNOWN
0425ED  50                    PUSH   ax                           ; UNKNOWN
0425EE  2B C0                 SUB    ax, ax                       ; UNKNOWN
0425F0  A3 14 0C              MOV    word ptr [0xc14], ax         ; UNKNOWN
0425F3  50                    PUSH   ax                           ; UNKNOWN
0425F4  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
0425F8  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
0425FC  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
042600  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
042604  68 B0 27              PUSH   0x27b0                       ; UNKNOWN
042607  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
04260C  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
04260F  0B C0                 OR     ax, ax                       ; UNKNOWN
042611  74 03                 JE     0x42616                      ; UNKNOWN
042613  E9 AD 00              JMP    0x426c3                      ; UNKNOWN
042616  9A 1D 00 EF 21        LCALL  0x21ef, 0x1d                 ; UNKNOWN
04261B  8D 86 00 FD           LEA    ax, [bp - 0x300]             ; UNKNOWN
04261F  16                    PUSH   ss                           ; UNKNOWN
042620  50                    PUSH   ax                           ; UNKNOWN
042621  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
042626  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
04262A  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
04262E  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
042632  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
042636  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04263A  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04263E  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
042642  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
042646  68 C8 00              PUSH   0xc8                         ; UNKNOWN
042649  2B C0                 SUB    ax, ax                       ; UNKNOWN
04264B  99                    CDQ                                 ; UNKNOWN
04264C  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
04264F  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
042654  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
042658  7C 0F                 JL     0x42669                      ; UNKNOWN
04265A  6A 00                 PUSH   0                            ; UNKNOWN
04265C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04265F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
042662  0E                    PUSH   cs                           ; UNKNOWN
042663  E8 3A FD              CALL   0x423a0                      ; UNKNOWN
042666  83 C4 06              ADD    sp, 6                        ; UNKNOWN
042669  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04266C  0E                    PUSH   cs                           ; UNKNOWN
04266D  E8 D1 FE              CALL   0x42541                      ; UNKNOWN
042670  83 C4 02              ADD    sp, 2                        ; UNKNOWN
042673  6A 00                 PUSH   0                            ; UNKNOWN
042675  68 40 01              PUSH   0x140                        ; UNKNOWN
042678  68 C8 00              PUSH   0xc8                         ; UNKNOWN
04267B  2B C0                 SUB    ax, ax                       ; UNKNOWN
04267D  99                    CDQ                                 ; UNKNOWN
04267E  2B DB                 SUB    bx, bx                       ; UNKNOWN
042680  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
042685  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
042689  7C 23                 JL     0x426ae                      ; UNKNOWN
04268B  6A 01                 PUSH   1                            ; UNKNOWN
04268D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
042690  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
042693  0E                    PUSH   cs                           ; UNKNOWN
042694  E8 09 FD              CALL   0x423a0                      ; UNKNOWN
042697  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04269A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04269D  0E                    PUSH   cs                           ; UNKNOWN
04269E  E8 A0 FE              CALL   0x42541                      ; UNKNOWN
0426A1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0426A4  6A 08                 PUSH   8                            ; UNKNOWN
0426A6  9A 02 00 F1 44        LCALL  0x44f1, 2                    ; UNKNOWN
0426AB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0426AE  9A 6B 00 EF 21        LCALL  0x21ef, 0x6b                 ; UNKNOWN
0426B3  9A 1D 00 EF 21        LCALL  0x21ef, 0x1d                 ; UNKNOWN
0426B8  68 00 A0              PUSH   0xa000                       ; UNKNOWN
0426BB  68 00 FC              PUSH   0xfc00                       ; UNKNOWN
0426BE  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
0426C3  8A 26 FB 3D           MOV    ah, byte ptr [0x3dfb]        ; UNKNOWN
0426C7  25 00 01              AND    ax, 0x100                    ; UNKNOWN
0426CA  83 F8 01              CMP    ax, 1                        ; UNKNOWN
0426CD  1B C0                 SBB    ax, ax                       ; UNKNOWN
0426CF  F7 D8                 NEG    ax                           ; UNKNOWN
0426D1  A3 14 0C              MOV    word ptr [0xc14], ax         ; UNKNOWN
0426D4  9A C9 00 D0 21        LCALL  0x21d0, 0xc9                 ; UNKNOWN
0426D9  C9                    LEAVE                               ; UNKNOWN
0426DA  CB                    RETF                                ; UNKNOWN
