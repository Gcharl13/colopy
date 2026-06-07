; ============================================================================
; func_04C584_unknown
; Region   : load_image
; Bytes    : file 0x04C584..0x04C685  (257 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C584  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
04C588  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04C58B  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
04C590  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C593  6A 05                 PUSH   5                            ; UNKNOWN
04C595  0E                    PUSH   cs                           ; UNKNOWN
04C596  E8 C9 EB              CALL   0x4b162                      ; UNKNOWN
04C599  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C59C  68 90 00              PUSH   0x90                         ; UNKNOWN
04C59F  6A 05                 PUSH   5                            ; UNKNOWN
04C5A1  68 40 01              PUSH   0x140                        ; UNKNOWN
04C5A4  6A 00                 PUSH   0                            ; UNKNOWN
04C5A6  FF 36 5E 33           PUSH   word ptr [0x335e]            ; UNKNOWN
04C5AA  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04C5AF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C5B2  52                    PUSH   dx                           ; UNKNOWN
04C5B3  50                    PUSH   ax                           ; UNKNOWN
04C5B4  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04C5B9  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04C5BC  68 91 00              PUSH   0x91                         ; UNKNOWN
04C5BF  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04C5C3  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04C5C6  2A E4                 SUB    ah, ah                       ; UNKNOWN
04C5C8  83 C0 06              ADD    ax, 6                        ; UNKNOWN
04C5CB  50                    PUSH   ax                           ; UNKNOWN
04C5CC  68 40 01              PUSH   0x140                        ; UNKNOWN
04C5CF  6A 00                 PUSH   0                            ; UNKNOWN
04C5D1  FF 36 98 34           PUSH   word ptr [0x3498]            ; UNKNOWN
04C5D5  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04C5DA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C5DD  52                    PUSH   dx                           ; UNKNOWN
04C5DE  50                    PUSH   ax                           ; UNKNOWN
04C5DF  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04C5E4  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04C5E7  C7 46 FE 5A 00        MOV    word ptr [bp - 2], 0x5a      ; UNKNOWN
04C5EC  C7 46 FC 19 00        MOV    word ptr [bp - 4], 0x19      ; UNKNOWN
04C5F1  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04C5F5  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04C5F9  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04C5FD  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04C601  6A 77                 PUSH   0x77                         ; UNKNOWN
04C603  B8 57 00              MOV    ax, 0x57                     ; UNKNOWN
04C606  BA 19 00              MOV    dx, 0x19                     ; UNKNOWN
04C609  BB B2 00              MOV    bx, 0xb2                     ; UNKNOWN
04C60C  9A 04 00 7D 5A        LCALL  0x5a7d, 4                    ; UNKNOWN
04C611  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
04C616  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
04C61A  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
04C61E  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04C621  40                    INC    ax                           ; UNKNOWN
04C622  40                    INC    ax                           ; UNKNOWN
04C623  50                    PUSH   ax                           ; UNKNOWN
04C624  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
04C627  83 C0 17              ADD    ax, 0x17                     ; UNKNOWN
04C62A  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
04C62E  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
04C631  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
04C636  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04C63A  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04C63E  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04C642  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04C646  6A 77                 PUSH   0x77                         ; UNKNOWN
04C648  83 46 FE 0E           ADD    word ptr [bp - 2], 0xe       ; UNKNOWN
04C64C  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04C64F  83 E8 03              SUB    ax, 3                        ; UNKNOWN
04C652  BA 19 00              MOV    dx, 0x19                     ; UNKNOWN
04C655  BB B2 00              MOV    bx, 0xb2                     ; UNKNOWN
04C658  9A 04 00 7D 5A        LCALL  0x5a7d, 4                    ; UNKNOWN
04C65D  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
04C660  83 7E FA 10           CMP    word ptr [bp - 6], 0x10      ; UNKNOWN
04C664  7C B0                 JL     0x4c616                      ; UNKNOWN
04C666  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
04C66B  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04C66F  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04C673  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04C677  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04C67B  6A 77                 PUSH   0x77                         ; UNKNOWN
04C67D  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
04C680  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
04C683  83                    DB     0x83                         ; UNKNOWN (raw)
04C684  C3                    DB     0xC3                         ; UNKNOWN (raw)
