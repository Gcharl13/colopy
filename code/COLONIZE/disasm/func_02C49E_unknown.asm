; ============================================================================
; func_02C49E_unknown
; Region   : load_image
; Bytes    : file 0x02C49E..0x02C56A  (204 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02C49E  C8 54 00 00           ENTER  0x54, 0                      ; UNKNOWN
02C4A2  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
02C4A6  FF 36 3A 34           PUSH   word ptr [0x343a]            ; UNKNOWN
02C4AA  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02C4AD  50                    PUSH   ax                           ; UNKNOWN
02C4AE  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02C4B3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02C4B6  68 FD 00              PUSH   0xfd                         ; UNKNOWN
02C4B9  68 FE 00              PUSH   0xfe                         ; UNKNOWN
02C4BC  6A 04                 PUSH   4                            ; UNKNOWN
02C4BE  68 40 01              PUSH   0x140                        ; UNKNOWN
02C4C1  6A 00                 PUSH   0                            ; UNKNOWN
02C4C3  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02C4C6  16                    PUSH   ss                           ; UNKNOWN
02C4C7  50                    PUSH   ax                           ; UNKNOWN
02C4C8  9A 36 04 13 24        LCALL  0x2413, 0x436                ; UNKNOWN
02C4CD  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
02C4D0  6A 00                 PUSH   0                            ; UNKNOWN
02C4D2  68 40 01              PUSH   0x140                        ; UNKNOWN
02C4D5  6A 10                 PUSH   0x10                         ; UNKNOWN
02C4D7  2B C0                 SUB    ax, ax                       ; UNKNOWN
02C4D9  99                    CDQ                                 ; UNKNOWN
02C4DA  2B DB                 SUB    bx, bx                       ; UNKNOWN
02C4DC  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
02C4E1  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
02C4E5  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02C4E8  50                    PUSH   ax                           ; UNKNOWN
02C4E9  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
02C4EE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02C4F1  FF 36 3C 34           PUSH   word ptr [0x343c]            ; UNKNOWN
02C4F5  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02C4F8  50                    PUSH   ax                           ; UNKNOWN
02C4F9  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02C4FE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02C501  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02C504  50                    PUSH   ax                           ; UNKNOWN
02C505  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
02C50A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02C50D  68 FE 00              PUSH   0xfe                         ; UNKNOWN
02C510  68 BE 00              PUSH   0xbe                         ; UNKNOWN
02C513  68 40 01              PUSH   0x140                        ; UNKNOWN
02C516  6A 00                 PUSH   0                            ; UNKNOWN
02C518  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02C51B  16                    PUSH   ss                           ; UNKNOWN
02C51C  50                    PUSH   ax                           ; UNKNOWN
02C51D  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
02C522  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
02C525  68 B7 00              PUSH   0xb7                         ; UNKNOWN
02C528  68 40 01              PUSH   0x140                        ; UNKNOWN
02C52B  6A 10                 PUSH   0x10                         ; UNKNOWN
02C52D  2B C0                 SUB    ax, ax                       ; UNKNOWN
02C52F  BA B7 00              MOV    dx, 0xb7                     ; UNKNOWN
02C532  2B DB                 SUB    bx, bx                       ; UNKNOWN
02C534  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
02C539  C7 46 AE 00 00        MOV    word ptr [bp - 0x52], 0      ; UNKNOWN
02C53E  EB 1B                 JMP    0x2c55b                      ; UNKNOWN
02C540  FF 46 AC              INC    word ptr [bp - 0x54]         ; UNKNOWN
02C543  83 7E AC 03           CMP    word ptr [bp - 0x54], 3      ; UNKNOWN
02C547  7D 0F                 JGE    0x2c558                      ; UNKNOWN
02C549  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
02C54C  FF 76 AE              PUSH   word ptr [bp - 0x52]         ; UNKNOWN
02C54F  0E                    PUSH   cs                           ; UNKNOWN
02C550  E8 D3 FD              CALL   0x2c326                      ; UNKNOWN
02C553  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02C556  EB E8                 JMP    0x2c540                      ; UNKNOWN
02C558  FF 46 AE              INC    word ptr [bp - 0x52]         ; UNKNOWN
02C55B  83 7E AE 04           CMP    word ptr [bp - 0x52], 4      ; UNKNOWN
02C55F  7D 07                 JGE    0x2c568                      ; UNKNOWN
02C561  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0      ; UNKNOWN
02C566  EB DB                 JMP    0x2c543                      ; UNKNOWN
02C568  C9                    LEAVE                               ; UNKNOWN
02C569  CB                    RETF                                ; UNKNOWN
