; ============================================================================
; func_0210F0_unknown
; Region   : load_image
; Bytes    : file 0x0210F0..0x0211F7  (263 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0210F0  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
0210F4  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
0210F9  1E                    PUSH   ds                           ; UNKNOWN
0210FA  68 A0 82              PUSH   0x82a0                       ; UNKNOWN
0210FD  1E                    PUSH   ds                           ; UNKNOWN
0210FE  68 A0 82              PUSH   0x82a0                       ; UNKNOWN
021101  1E                    PUSH   ds                           ; UNKNOWN
021102  68 04 0B              PUSH   0xb04                        ; UNKNOWN
021105  9A 57 00 3A 5B        LCALL  0x5b3a, 0x57                 ; UNKNOWN
02110A  1E                    PUSH   ds                           ; UNKNOWN
02110B  68 A0 82              PUSH   0x82a0                       ; UNKNOWN
02110E  8D 1E 9D 18           LEA    bx, [0x189d]                 ; UNKNOWN
021112  9A FC 00 E9 5A        LCALL  0x5ae9, 0xfc                 ; UNKNOWN
021117  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02111A  0B C0                 OR     ax, ax                       ; UNKNOWN
02111C  75 09                 JNE    0x21127                      ; UNKNOWN
02111E  C7 06 08 0B 01 00     MOV    word ptr [0xb08], 1          ; UNKNOWN
021124  E9 BD 00              JMP    0x211e4                      ; UNKNOWN
021127  50                    PUSH   ax                           ; UNKNOWN
021128  6A 01                 PUSH   1                            ; UNKNOWN
02112A  6A 04                 PUSH   4                            ; UNKNOWN
02112C  68 88 82              PUSH   0x8288                       ; UNKNOWN
02112F  9A D4 04 65 5F        LCALL  0x5f65, 0x4d4                ; UNKNOWN
021134  83 C4 08              ADD    sp, 8                        ; UNKNOWN
021137  0B C0                 OR     ax, ax                       ; UNKNOWN
021139  75 09                 JNE    0x21144                      ; UNKNOWN
02113B  C7 06 08 0B 02 00     MOV    word ptr [0xb08], 2          ; UNKNOWN
021141  E9 A0 00              JMP    0x211e4                      ; UNKNOWN
021144  A1 02 0B              MOV    ax, word ptr [0xb02]         ; UNKNOWN
021147  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02114A  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02114D  6A 01                 PUSH   1                            ; UNKNOWN
02114F  6A 02                 PUSH   2                            ; UNKNOWN
021151  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
021154  50                    PUSH   ax                           ; UNKNOWN
021155  9A D4 04 65 5F        LCALL  0x5f65, 0x4d4                ; UNKNOWN
02115A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02115D  0B C0                 OR     ax, ax                       ; UNKNOWN
02115F  74 DA                 JE     0x2113b                      ; UNKNOWN
021161  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
021164  F7 2E 88 82           IMUL   word ptr [0x8288]            ; UNKNOWN
021168  A3 F0 82              MOV    word ptr [0x82f0], ax        ; UNKNOWN
02116B  89 16 F2 82           MOV    word ptr [0x82f2], dx        ; UNKNOWN
02116F  83 3E 0A 0B 00        CMP    word ptr [0xb0a], 0          ; UNKNOWN
021174  75 66                 JNE    0x211dc                      ; UNKNOWN
021176  FF 36 0E 0B           PUSH   word ptr [0xb0e]             ; UNKNOWN
02117A  FF 36 0C 0B           PUSH   word ptr [0xb0c]             ; UNKNOWN
02117E  6A 00                 PUSH   0                            ; UNKNOWN
021180  6A 01                 PUSH   1                            ; UNKNOWN
021182  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
021185  9A 08 00 23 5B        LCALL  0x5b23, 8                    ; UNKNOWN
02118A  0B D0                 OR     dx, ax                       ; UNKNOWN
02118C  75 08                 JNE    0x21196                      ; UNKNOWN
02118E  C7 06 08 0B 04 00     MOV    word ptr [0xb08], 4          ; UNKNOWN
021194  EB 4E                 JMP    0x211e4                      ; UNKNOWN
021196  FF 36 12 0B           PUSH   word ptr [0xb12]             ; UNKNOWN
02119A  FF 36 10 0B           PUSH   word ptr [0xb10]             ; UNKNOWN
02119E  6A 00                 PUSH   0                            ; UNKNOWN
0211A0  6A 01                 PUSH   1                            ; UNKNOWN
0211A2  A1 F0 82              MOV    ax, word ptr [0x82f0]        ; UNKNOWN
0211A5  8B 16 F2 82           MOV    dx, word ptr [0x82f2]        ; UNKNOWN
0211A9  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0211AC  9A 08 00 23 5B        LCALL  0x5b23, 8                    ; UNKNOWN
0211B1  0B D0                 OR     dx, ax                       ; UNKNOWN
0211B3  75 08                 JNE    0x211bd                      ; UNKNOWN
0211B5  C7 06 08 0B 05 00     MOV    word ptr [0xb08], 5          ; UNKNOWN
0211BB  EB 27                 JMP    0x211e4                      ; UNKNOWN
0211BD  FF 36 16 0B           PUSH   word ptr [0xb16]             ; UNKNOWN
0211C1  FF 36 14 0B           PUSH   word ptr [0xb14]             ; UNKNOWN
0211C5  6A 00                 PUSH   0                            ; UNKNOWN
0211C7  6A 01                 PUSH   1                            ; UNKNOWN
0211C9  A1 F0 82              MOV    ax, word ptr [0x82f0]        ; UNKNOWN
0211CC  8B 16 F2 82           MOV    dx, word ptr [0x82f2]        ; UNKNOWN
0211D0  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0211D3  9A 08 00 23 5B        LCALL  0x5b23, 8                    ; UNKNOWN
0211D8  0B D0                 OR     dx, ax                       ; UNKNOWN
0211DA  74 D9                 JE     0x211b5                      ; UNKNOWN
0211DC  2B C0                 SUB    ax, ax                       ; UNKNOWN
0211DE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0211E1  A3 08 0B              MOV    word ptr [0xb08], ax         ; UNKNOWN
0211E4  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
0211E8  74 08                 JE     0x211f2                      ; UNKNOWN
0211EA  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
0211ED  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
0211F2  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0211F5  C9                    LEAVE                               ; UNKNOWN
0211F6  CB                    RETF                                ; UNKNOWN
