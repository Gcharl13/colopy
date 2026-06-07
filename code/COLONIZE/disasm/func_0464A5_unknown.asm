; ============================================================================
; func_0464A5_unknown
; Region   : load_image
; Bytes    : file 0x0464A5..0x0465AD  (264 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0464A5  C8 9A 06 00           ENTER  0x69a, 0                     ; UNKNOWN
0464A9  49                    DEC    cx                           ; UNKNOWN
0464AA  22 83 C4 04           AND    al, byte ptr [bp + di + 0x4c4] ; UNKNOWN
0464AE  A8 40                 TEST   al, 0x40                     ; UNKNOWN
0464B0  75 15                 JNE    0x464c7                      ; UNKNOWN
0464B2  FF 76 C8              PUSH   word ptr [bp - 0x38]         ; UNKNOWN
0464B5  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0464B8  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
0464BD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0464C0  A8 40                 TEST   al, 0x40                     ; UNKNOWN
0464C2  75 03                 JNE    0x464c7                      ; UNKNOWN
0464C4  E9 C7 00              JMP    0x4658e                      ; UNKNOWN
0464C7  83 7E C8 04           CMP    word ptr [bp - 0x38], 4      ; UNKNOWN
0464CB  7D 48                 JGE    0x46515                      ; UNKNOWN
0464CD  6B 5E C8 34           IMUL   bx, word ptr [bp - 0x38], 0x34 ; UNKNOWN
0464D1  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
0464D6  75 3D                 JNE    0x46515                      ; UNKNOWN
0464D8  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0464DB  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
0464E0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0464E3  50                    PUSH   ax                           ; UNKNOWN
0464E4  6A 00                 PUSH   0                            ; UNKNOWN
0464E6  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
0464EB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0464EE  FF 76 C8              PUSH   word ptr [bp - 0x38]         ; UNKNOWN
0464F1  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
0464F6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0464F9  50                    PUSH   ax                           ; UNKNOWN
0464FA  6A 01                 PUSH   1                            ; UNKNOWN
0464FC  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
046501  83 C4 04              ADD    sp, 4                        ; UNKNOWN
046504  6A 04                 PUSH   4                            ; UNKNOWN
046506  9A 11 03 28 1A        LCALL  0x1a28, 0x311                ; UNKNOWN
04650B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04650E  6A 01                 PUSH   1                            ; UNKNOWN
046510  68 7F 28              PUSH   0x287f                       ; UNKNOWN
046513  EB 31                 JMP    0x46546                      ; UNKNOWN
046515  FF 76 C8              PUSH   word ptr [bp - 0x38]         ; UNKNOWN
046518  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
04651D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
046520  50                    PUSH   ax                           ; UNKNOWN
046521  6A 00                 PUSH   0                            ; UNKNOWN
046523  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
046528  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04652B  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04652E  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
046533  83 C4 02              ADD    sp, 2                        ; UNKNOWN
046536  50                    PUSH   ax                           ; UNKNOWN
046537  6A 01                 PUSH   1                            ; UNKNOWN
046539  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
04653E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
046541  6A 02                 PUSH   2                            ; UNKNOWN
046543  68 8B 28              PUSH   0x288b                       ; UNKNOWN
046546  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
04654B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04654E  83 7E C8 04           CMP    word ptr [bp - 0x38], 4      ; UNKNOWN
046552  7D 2A                 JGE    0x4657e                      ; UNKNOWN
046554  6B 5E C8 34           IMUL   bx, word ptr [bp - 0x38], 0x34 ; UNKNOWN
046558  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
04655D  75 1F                 JNE    0x4657e                      ; UNKNOWN
04655F  FF 76 C8              PUSH   word ptr [bp - 0x38]         ; UNKNOWN
046562  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
046565  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
04656A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04656D  A8 40                 TEST   al, 0x40                     ; UNKNOWN
04656F  74 0D                 JE     0x4657e                      ; UNKNOWN
046571  69 76 FE 3C 01        IMUL   si, word ptr [bp - 2], 0x13c ; UNKNOWN
046576  8B 5E C8              MOV    bx, word ptr [bp - 0x38]     ; UNKNOWN
046579  80 88 DE 74 02        OR     byte ptr [bx + si + 0x74de], 2 ; UNKNOWN
04657E  6A 40                 PUSH   0x40                         ; UNKNOWN
046580  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
046583  FF 76 C8              PUSH   word ptr [bp - 0x38]         ; UNKNOWN
046586  9A CE 00 49 22        LCALL  0x2249, 0xce                 ; UNKNOWN
04658B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04658E  69 76 C8 3C 01        IMUL   si, word ptr [bp - 0x38], 0x13c ; UNKNOWN
046593  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
046596  80 A0 DE 74 FE        AND    byte ptr [bx + si + 0x74de], 0xfe ; UNKNOWN
04659B  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04659F  80 BF 85 88 01        CMP    byte ptr [bx - 0x777b], 1    ; UNKNOWN
0465A4  1B C0                 SBB    ax, ax                       ; UNKNOWN
0465A6  F7 D8                 NEG    ax                           ; UNKNOWN
0465A8  89 46 CA              MOV    word ptr [bp - 0x36], ax     ; UNKNOWN
0465AB  83                    DB     0x83                         ; UNKNOWN (raw)
0465AC  7E                    DB     0x7E                         ; UNKNOWN (raw)
