; ============================================================================
; func_04736D_unknown
; Region   : load_image
; Bytes    : file 0x04736D..0x047436  (201 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04736D  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
047371  0E                    PUSH   cs                           ; UNKNOWN
047372  E8 7A FF              CALL   0x472ef                      ; UNKNOWN
047375  80 3E C6 0B 00        CMP    byte ptr [0xbc6], 0          ; UNKNOWN
04737A  75 03                 JNE    0x4737f                      ; UNKNOWN
04737C  E9 A7 00              JMP    0x47426                      ; UNKNOWN
04737F  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
047383  75 03                 JNE    0x47388                      ; UNKNOWN
047385  E9 9E 00              JMP    0x47426                      ; UNKNOWN
047388  83 3E D6 09 00        CMP    word ptr [0x9d6], 0          ; UNKNOWN
04738D  75 28                 JNE    0x473b7                      ; UNKNOWN
04738F  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
047393  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
047397  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04739B  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04739F  FF 36 E4 C5           PUSH   word ptr [0xc5e4]            ; UNKNOWN
0473A3  6A 22                 PUSH   0x22                         ; UNKNOWN
0473A5  A1 E6 C5              MOV    ax, word ptr [0xc5e6]        ; UNKNOWN
0473A8  8B 16 E8 C5           MOV    dx, word ptr [0xc5e8]        ; UNKNOWN
0473AC  8B 1E E2 C5           MOV    bx, word ptr [0xc5e2]        ; UNKNOWN
0473B0  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
0473B5  EB 3B                 JMP    0x473f2                      ; UNKNOWN
0473B7  6A 00                 PUSH   0                            ; UNKNOWN
0473B9  6A 00                 PUSH   0                            ; UNKNOWN
0473BB  FF 36 E4 C5           PUSH   word ptr [0xc5e4]            ; UNKNOWN
0473BF  FF 36 E2 C5           PUSH   word ptr [0xc5e2]            ; UNKNOWN
0473C3  FF 36 E8 C5           PUSH   word ptr [0xc5e8]            ; UNKNOWN
0473C7  FF 36 E6 C5           PUSH   word ptr [0xc5e6]            ; UNKNOWN
0473CB  8B 1E D6 09           MOV    bx, word ptr [0x9d6]         ; UNKNOWN
0473CF  FF 77 06              PUSH   word ptr [bx + 6]            ; UNKNOWN
0473D2  FF 77 04              PUSH   word ptr [bx + 4]            ; UNKNOWN
0473D5  FF 77 02              PUSH   word ptr [bx + 2]            ; UNKNOWN
0473D8  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
0473DA  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
0473DE  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
0473E2  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
0473E6  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
0473EA  9A 0C 00 B6 5A        LCALL  0x5ab6, 0xc                  ; UNKNOWN
0473EF  83 C4 1C              ADD    sp, 0x1c                     ; UNKNOWN
0473F2  FF 36 E8 C5           PUSH   word ptr [0xc5e8]            ; UNKNOWN
0473F6  FF 36 E2 C5           PUSH   word ptr [0xc5e2]            ; UNKNOWN
0473FA  FF 36 E4 C5           PUSH   word ptr [0xc5e4]            ; UNKNOWN
0473FE  A1 E6 C5              MOV    ax, word ptr [0xc5e6]        ; UNKNOWN
047401  8B 16 E8 C5           MOV    dx, word ptr [0xc5e8]        ; UNKNOWN
047405  8B D8                 MOV    bx, ax                       ; UNKNOWN
047407  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
04740C  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
047411  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
047414  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
047417  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
04741C  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
04741F  75 05                 JNE    0x47426                      ; UNKNOWN
047421  3B 56 FE              CMP    dx, word ptr [bp - 2]        ; UNKNOWN
047424  74 F1                 JE     0x47417                      ; UNKNOWN
047426  2A C0                 SUB    al, al                       ; UNKNOWN
047428  A2 C6 0B              MOV    byte ptr [0xbc6], al         ; UNKNOWN
04742B  A2 C7 0B              MOV    byte ptr [0xbc7], al         ; UNKNOWN
04742E  A2 C8 0B              MOV    byte ptr [0xbc8], al         ; UNKNOWN
047431  A2 EA C5              MOV    byte ptr [0xc5ea], al        ; UNKNOWN
047434  C9                    LEAVE                               ; UNKNOWN
047435  CB                    RETF                                ; UNKNOWN
