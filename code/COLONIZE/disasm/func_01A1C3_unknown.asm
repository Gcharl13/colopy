; ============================================================================
; func_01A1C3_unknown
; Region   : load_image
; Bytes    : file 0x01A1C3..0x01A27A  (183 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01A1C3  C8 48 01 00           ENTER  0x148, 0                     ; UNKNOWN
01A1C7  56                    PUSH   si                           ; UNKNOWN
01A1C8  2B C0                 SUB    ax, ax                       ; UNKNOWN
01A1CA  89 86 D4 FE           MOV    word ptr [bp - 0x12c], ax    ; UNKNOWN
01A1CE  89 86 14 FF           MOV    word ptr [bp - 0xec], ax     ; UNKNOWN
01A1D2  89 86 0E FF           MOV    word ptr [bp - 0xf2], ax     ; UNKNOWN
01A1D6  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01A1DA  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
01A1DD  8B C8                 MOV    cx, ax                       ; UNKNOWN
01A1DF  98                    CWDE                                ; UNKNOWN
01A1E0  3B 06 44 73           CMP    ax, word ptr [0x7344]        ; UNKNOWN
01A1E4  7F 0F                 JG     0x1a1f5                      ; UNKNOWN
01A1E6  80 F9 20              CMP    cl, 0x20                     ; UNKNOWN
01A1E9  7C 0A                 JL     0x1a1f5                      ; UNKNOWN
01A1EB  B8 01 00              MOV    ax, 1                        ; UNKNOWN
01A1EE  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
01A1F1  89 86 D4 FE           MOV    word ptr [bp - 0x12c], ax    ; UNKNOWN
01A1F5  C7 86 38 FF 01 00     MOV    word ptr [bp - 0xc8], 1      ; UNKNOWN
01A1FB  FF 36 44 73           PUSH   word ptr [0x7344]            ; UNKNOWN
01A1FF  9A 30 0E 5F 24        LCALL  0x245f, 0xe30                ; UNKNOWN
01A204  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01A207  50                    PUSH   ax                           ; UNKNOWN
01A208  9A 08 00 5F 24        LCALL  0x245f, 8                    ; UNKNOWN
01A20D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01A210  0B C0                 OR     ax, ax                       ; UNKNOWN
01A212  75 04                 JNE    0x1a218                      ; UNKNOWN
01A214  89 86 38 FF           MOV    word ptr [bp - 0xc8], ax     ; UNKNOWN
01A218  C7 06 01 09 00 00     MOV    word ptr [0x901], 0          ; UNKNOWN
01A21E  0E                    PUSH   cs                           ; UNKNOWN
01A21F  E8 40 F8              CALL   0x19a62                      ; UNKNOWN
01A222  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
01A226  74 0E                 JE     0x1a236                      ; UNKNOWN
01A228  C7 86 08 FF 13 00     MOV    word ptr [bp - 0xf8], 0x13   ; UNKNOWN
01A22E  C7 86 BC FE 06 00     MOV    word ptr [bp - 0x144], 6     ; UNKNOWN
01A234  EB 0C                 JMP    0x1a242                      ; UNKNOWN
01A236  C7 86 08 FF 00 00     MOV    word ptr [bp - 0xf8], 0      ; UNKNOWN
01A23C  C7 86 BC FE 19 00     MOV    word ptr [bp - 0x144], 0x19  ; UNKNOWN
01A242  FF 36 44 73           PUSH   word ptr [0x7344]            ; UNKNOWN
01A246  9A F7 0D 5F 24        LCALL  0x245f, 0xdf7                ; UNKNOWN
01A24B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01A24E  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
01A251  83 F8 12              CMP    ax, 0x12                     ; UNKNOWN
01A254  75 05                 JNE    0x1a25b                      ; UNKNOWN
01A256  B8 01 00              MOV    ax, 1                        ; UNKNOWN
01A259  EB 02                 JMP    0x1a25d                      ; UNKNOWN
01A25B  2B C0                 SUB    ax, ax                       ; UNKNOWN
01A25D  89 86 12 FF           MOV    word ptr [bp - 0xee], ax     ; UNKNOWN
01A261  6A 20                 PUSH   0x20                         ; UNKNOWN
01A263  6A 00                 PUSH   0                            ; UNKNOWN
01A265  8D 86 6C FF           LEA    ax, [bp - 0x94]              ; UNKNOWN
01A269  50                    PUSH   ax                           ; UNKNOWN
01A26A  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
01A26F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01A272  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
01A275  8D 86 C2 FE           LEA    ax, [bp - 0x13e]             ; UNKNOWN
01A279  50                    PUSH   ax                           ; UNKNOWN
