; ============================================================================
; func_047580_unknown
; Region   : load_image
; Bytes    : file 0x047580..0x0476B6  (310 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

047580  C8 54 00 00           ENTER  0x54, 0                      ; UNKNOWN
047584  80 3E C6 0B 00        CMP    byte ptr [0xbc6], 0          ; UNKNOWN
047589  75 0B                 JNE    0x47596                      ; UNKNOWN
04758B  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
04758E  0B 46 08              OR     ax, word ptr [bp + 8]        ; UNKNOWN
047591  75 03                 JNE    0x47596                      ; UNKNOWN
047593  E9 1E 01              JMP    0x476b4                      ; UNKNOWN
047596  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04759A  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04759E  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
0475A2  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
0475A6  A1 E4 C5              MOV    ax, word ptr [0xc5e4]        ; UNKNOWN
0475A9  03 06 E8 C5           ADD    ax, word ptr [0xc5e8]        ; UNKNOWN
0475AD  50                    PUSH   ax                           ; UNKNOWN
0475AE  6A 00                 PUSH   0                            ; UNKNOWN
0475B0  A1 E6 C5              MOV    ax, word ptr [0xc5e6]        ; UNKNOWN
0475B3  8B 1E E2 C5           MOV    bx, word ptr [0xc5e2]        ; UNKNOWN
0475B7  03 D8                 ADD    bx, ax                       ; UNKNOWN
0475B9  48                    DEC    ax                           ; UNKNOWN
0475BA  8B 16 E8 C5           MOV    dx, word ptr [0xc5e8]        ; UNKNOWN
0475BE  4A                    DEC    dx                           ; UNKNOWN
0475BF  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
0475C4  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
0475C7  50                    PUSH   ax                           ; UNKNOWN
0475C8  8D 4E FC              LEA    cx, [bp - 4]                 ; UNKNOWN
0475CB  51                    PUSH   cx                           ; UNKNOWN
0475CC  8A 0E C8 0B           MOV    cl, byte ptr [0xbc8]         ; UNKNOWN
0475D0  2A ED                 SUB    ch, ch                       ; UNKNOWN
0475D2  51                    PUSH   cx                           ; UNKNOWN
0475D3  0E                    PUSH   cs                           ; UNKNOWN
0475D4  E8 E7 FC              CALL   0x472be                      ; UNKNOWN
0475D7  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0475DA  83 7E FE 22           CMP    word ptr [bp - 2], 0x22      ; UNKNOWN
0475DE  75 44                 JNE    0x47624                      ; UNKNOWN
0475E0  83 3E D6 09 00        CMP    word ptr [0x9d6], 0          ; UNKNOWN
0475E5  74 3D                 JE     0x47624                      ; UNKNOWN
0475E7  6A 00                 PUSH   0                            ; UNKNOWN
0475E9  6A 00                 PUSH   0                            ; UNKNOWN
0475EB  FF 36 E4 C5           PUSH   word ptr [0xc5e4]            ; UNKNOWN
0475EF  FF 36 E2 C5           PUSH   word ptr [0xc5e2]            ; UNKNOWN
0475F3  FF 36 E8 C5           PUSH   word ptr [0xc5e8]            ; UNKNOWN
0475F7  FF 36 E6 C5           PUSH   word ptr [0xc5e6]            ; UNKNOWN
0475FB  8B 1E D6 09           MOV    bx, word ptr [0x9d6]         ; UNKNOWN
0475FF  FF 77 06              PUSH   word ptr [bx + 6]            ; UNKNOWN
047602  FF 77 04              PUSH   word ptr [bx + 4]            ; UNKNOWN
047605  FF 77 02              PUSH   word ptr [bx + 2]            ; UNKNOWN
047608  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
04760A  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04760E  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
047612  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
047616  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04761A  9A 0C 00 B6 5A        LCALL  0x5ab6, 0xc                  ; UNKNOWN
04761F  83 C4 1C              ADD    sp, 0x1c                     ; UNKNOWN
047622  EB 28                 JMP    0x4764c                      ; UNKNOWN
047624  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
047628  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04762C  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
047630  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
047634  FF 36 E4 C5           PUSH   word ptr [0xc5e4]            ; UNKNOWN
047638  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
04763B  50                    PUSH   ax                           ; UNKNOWN
04763C  A1 E6 C5              MOV    ax, word ptr [0xc5e6]        ; UNKNOWN
04763F  8B 16 E8 C5           MOV    dx, word ptr [0xc5e8]        ; UNKNOWN
047643  8B 1E E2 C5           MOV    bx, word ptr [0xc5e2]        ; UNKNOWN
047647  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
04764C  80 3E C6 0B 00        CMP    byte ptr [0xbc6], 0          ; UNKNOWN
047651  74 11                 JE     0x47664                      ; UNKNOWN
047653  68 EA C5              PUSH   0xc5ea                       ; UNKNOWN
047656  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
047659  50                    PUSH   ax                           ; UNKNOWN
04765A  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
04765F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047662  EB 13                 JMP    0x47677                      ; UNKNOWN
047664  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
047667  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04766A  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04766D  16                    PUSH   ss                           ; UNKNOWN
04766E  50                    PUSH   ax                           ; UNKNOWN
04766F  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
047674  83 C4 08              ADD    sp, 8                        ; UNKNOWN
047677  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
04767A  A1 E8 C5              MOV    ax, word ptr [0xc5e8]        ; UNKNOWN
04767D  40                    INC    ax                           ; UNKNOWN
04767E  50                    PUSH   ax                           ; UNKNOWN
04767F  FF 36 E2 C5           PUSH   word ptr [0xc5e2]            ; UNKNOWN
047683  FF 36 E6 C5           PUSH   word ptr [0xc5e6]            ; UNKNOWN
047687  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
04768A  16                    PUSH   ss                           ; UNKNOWN
04768B  50                    PUSH   ax                           ; UNKNOWN
04768C  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
047691  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
047694  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
047698  74 1A                 JE     0x476b4                      ; UNKNOWN
04769A  FF 36 E8 C5           PUSH   word ptr [0xc5e8]            ; UNKNOWN
04769E  FF 36 E2 C5           PUSH   word ptr [0xc5e2]            ; UNKNOWN
0476A2  FF 36 E4 C5           PUSH   word ptr [0xc5e4]            ; UNKNOWN
0476A6  A1 E6 C5              MOV    ax, word ptr [0xc5e6]        ; UNKNOWN
0476A9  8B 16 E8 C5           MOV    dx, word ptr [0xc5e8]        ; UNKNOWN
0476AD  8B D8                 MOV    bx, ax                       ; UNKNOWN
0476AF  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
0476B4  C9                    LEAVE                               ; UNKNOWN
0476B5  CB                    RETF                                ; UNKNOWN
