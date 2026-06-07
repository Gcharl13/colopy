; ============================================================================
; func_009194_unknown
; Region   : load_image
; Bytes    : file 0x009194..0x00939C  (520 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009194  C8 18 01 00           ENTER  0x118, 0                     ; UNKNOWN
009198  56                    PUSH   si                           ; UNKNOWN
009199  83 3E 66 00 00        CMP    word ptr [0x66], 0           ; UNKNOWN
00919E  75 03                 JNE    0x91a3                       ; UNKNOWN
0091A0  E9 F6 01              JMP    0x9399                       ; UNKNOWN
0091A3  80 3E 74 00 00        CMP    byte ptr [0x74], 0           ; UNKNOWN
0091A8  74 03                 JE     0x91ad                       ; UNKNOWN
0091AA  E9 EC 01              JMP    0x9399                       ; UNKNOWN
0091AD  6A 00                 PUSH   0                            ; UNKNOWN
0091AF  8D 86 7C FF           LEA    ax, [bp - 0x84]              ; UNKNOWN
0091B3  50                    PUSH   ax                           ; UNKNOWN
0091B4  6A 00                 PUSH   0                            ; UNKNOWN
0091B6  6A 00                 PUSH   0                            ; UNKNOWN
0091B8  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0091BB  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
0091BD  9A 5E 0E 65 5F        LCALL  0x5f65, 0xe5e                ; UNKNOWN
0091C2  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
0091C5  8D 86 7C FF           LEA    ax, [bp - 0x84]              ; UNKNOWN
0091C9  50                    PUSH   ax                           ; UNKNOWN
0091CA  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
0091CF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0091D2  89 86 7A FF           MOV    word ptr [bp - 0x86], ax     ; UNKNOWN
0091D6  3D 08 00              CMP    ax, 8                        ; UNKNOWN
0091D9  76 06                 JBE    0x91e1                       ; UNKNOWN
0091DB  C7 86 7A FF 08 00     MOV    word ptr [bp - 0x86], 8      ; UNKNOWN
0091E1  8B B6 7A FF           MOV    si, word ptr [bp - 0x86]     ; UNKNOWN
0091E5  C6 82 7C FF 00        MOV    byte ptr [bp + si - 0x84], 0 ; UNKNOWN
0091EA  68 81 00              PUSH   0x81                         ; UNKNOWN
0091ED  8D 86 7C FF           LEA    ax, [bp - 0x84]              ; UNKNOWN
0091F1  50                    PUSH   ax                           ; UNKNOWN
0091F2  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
0091F7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0091FA  8D 86 7C FF           LEA    ax, [bp - 0x84]              ; UNKNOWN
0091FE  50                    PUSH   ax                           ; UNKNOWN
0091FF  68 72 32              PUSH   0x3272                       ; UNKNOWN
009202  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
009207  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00920A  68 86 00              PUSH   0x86                         ; UNKNOWN
00920D  83 3E 68 00 FF        CMP    word ptr [0x68], -1          ; UNKNOWN
009212  75 06                 JNE    0x921a                       ; UNKNOWN
009214  A1 76 00              MOV    ax, word ptr [0x76]          ; UNKNOWN
009217  EB 04                 JMP    0x921d                       ; UNKNOWN
009219  90                    NOP                                 ; UNKNOWN
00921A  B8 72 32              MOV    ax, 0x3272                   ; UNKNOWN
00921D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
009220  50                    PUSH   ax                           ; UNKNOWN
009221  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
009226  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009229  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
00922C  0B C0                 OR     ax, ax                       ; UNKNOWN
00922E  75 1B                 JNE    0x924b                       ; UNKNOWN
009230  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
009233  68 88 00              PUSH   0x88                         ; UNKNOWN
009236  68 88 12              PUSH   0x1288                       ; UNKNOWN
009239  9A B8 03 65 5F        LCALL  0x5f65, 0x3b8                ; UNKNOWN
00923E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
009241  6A 01                 PUSH   1                            ; UNKNOWN
009243  9A D5 01 65 5F        LCALL  0x5f65, 0x1d5                ; UNKNOWN
009248  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00924B  8D 86 F6 FE           LEA    ax, [bp - 0x10a]             ; UNKNOWN
00924F  89 86 78 FF           MOV    word ptr [bp - 0x88], ax     ; UNKNOWN
009253  C7 86 76 FF 00 00     MOV    word ptr [bp - 0x8a], 0      ; UNKNOWN
009259  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
00925D  7E 40                 JLE    0x929f                       ; UNKNOWN
00925F  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
009262  89 86 EA FE           MOV    word ptr [bp - 0x116], ax    ; UNKNOWN
009266  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
009269  89 86 E8 FE           MOV    word ptr [bp - 0x118], ax    ; UNKNOWN
00926D  8B 9E EA FE           MOV    bx, word ptr [bp - 0x116]    ; UNKNOWN
009271  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
009273  68 9A 00              PUSH   0x9a                         ; UNKNOWN
009276  FF B6 78 FF           PUSH   word ptr [bp - 0x88]         ; UNKNOWN
00927A  9A CC 0A 65 5F        LCALL  0x5f65, 0xacc                ; UNKNOWN
00927F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
009282  01 86 78 FF           ADD    word ptr [bp - 0x88], ax     ; UNKNOWN
009286  8B 9E 78 FF           MOV    bx, word ptr [bp - 0x88]     ; UNKNOWN
00928A  C6 07 20              MOV    byte ptr [bx], 0x20          ; UNKNOWN
00928D  8D 47 01              LEA    ax, [bx + 1]                 ; UNKNOWN
009290  89 86 78 FF           MOV    word ptr [bp - 0x88], ax     ; UNKNOWN
009294  83 86 EA FE 02        ADD    word ptr [bp - 0x116], 2     ; UNKNOWN
009299  FF 8E E8 FE           DEC    word ptr [bp - 0x118]        ; UNKNOWN
00929D  75 CE                 JNE    0x926d                       ; UNKNOWN
00929F  8B 9E 78 FF           MOV    bx, word ptr [bp - 0x88]     ; UNKNOWN
0092A3  C6 47 FF 00           MOV    byte ptr [bx - 1], 0         ; UNKNOWN
0092A7  8D 86 F6 FE           LEA    ax, [bp - 0x10a]             ; UNKNOWN
0092AB  50                    PUSH   ax                           ; UNKNOWN
0092AC  68 9D 00              PUSH   0x9d                         ; UNKNOWN
0092AF  68 AA 00              PUSH   0xaa                         ; UNKNOWN
0092B2  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0092B5  9A B8 03 65 5F        LCALL  0x5f65, 0x3b8                ; UNKNOWN
0092BA  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0092BD  68 B3 00              PUSH   0xb3                         ; UNKNOWN
0092C0  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0092C3  9A B8 03 65 5F        LCALL  0x5f65, 0x3b8                ; UNKNOWN
0092C8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0092CB  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0092CE  9A 18 06 65 5F        LCALL  0x5f65, 0x618                ; UNKNOWN
0092D3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0092D6  A0 8F 12              MOV    al, byte ptr [0x128f]        ; UNKNOWN
0092D9  2A E4                 SUB    ah, ah                       ; UNKNOWN
0092DB  50                    PUSH   ax                           ; UNKNOWN
0092DC  9A 7C 0B 65 5F        LCALL  0x5f65, 0xb7c                ; UNKNOWN
0092E1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0092E4  A3 80 32              MOV    word ptr [0x3280], ax        ; UNKNOWN
0092E7  3D FF FF              CMP    ax, 0xffff                   ; UNKNOWN
0092EA  75 18                 JNE    0x9304                       ; UNKNOWN
0092EC  68 D5 00              PUSH   0xd5                         ; UNKNOWN
0092EF  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0092F2  9A B8 03 65 5F        LCALL  0x5f65, 0x3b8                ; UNKNOWN
0092F7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0092FA  6A 01                 PUSH   1                            ; UNKNOWN
0092FC  9A D5 01 65 5F        LCALL  0x5f65, 0x1d5                ; UNKNOWN
009301  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009304  A0 8F 12              MOV    al, byte ptr [0x128f]        ; UNKNOWN
009307  2A E4                 SUB    ah, ah                       ; UNKNOWN
009309  50                    PUSH   ax                           ; UNKNOWN
00930A  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
00930D  8A 47 07              MOV    al, byte ptr [bx + 7]        ; UNKNOWN
009310  50                    PUSH   ax                           ; UNKNOWN
009311  9A B4 0B 65 5F        LCALL  0x5f65, 0xbb4                ; UNKNOWN
009316  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009319  40                    INC    ax                           ; UNKNOWN
00931A  75 18                 JNE    0x9334                       ; UNKNOWN
00931C  68 E8 00              PUSH   0xe8                         ; UNKNOWN
00931F  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
009322  9A B8 03 65 5F        LCALL  0x5f65, 0x3b8                ; UNKNOWN
009327  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00932A  6A 01                 PUSH   1                            ; UNKNOWN
00932C  9A D5 01 65 5F        LCALL  0x5f65, 0x1d5                ; UNKNOWN
009331  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009334  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
009337  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
00933C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00933F  C6 06 74 00 01        MOV    byte ptr [0x74], 1           ; UNKNOWN
009344  8D 86 F0 FE           LEA    ax, [bp - 0x110]             ; UNKNOWN
009348  50                    PUSH   ax                           ; UNKNOWN
009349  9A 9E 11 65 5F        LCALL  0x5f65, 0x119e               ; UNKNOWN
00934E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009351  8D 86 EC FE           LEA    ax, [bp - 0x114]             ; UNKNOWN
009355  50                    PUSH   ax                           ; UNKNOWN
009356  9A B8 11 65 5F        LCALL  0x5f65, 0x11b8               ; UNKNOWN
00935B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00935E  8A 86 EE FE           MOV    al, byte ptr [bp - 0x112]    ; UNKNOWN
009362  2A E4                 SUB    ah, ah                       ; UNKNOWN
009364  50                    PUSH   ax                           ; UNKNOWN
009365  8A 86 ED FE           MOV    al, byte ptr [bp - 0x113]    ; UNKNOWN
009369  50                    PUSH   ax                           ; UNKNOWN
00936A  8A 86 EC FE           MOV    al, byte ptr [bp - 0x114]    ; UNKNOWN
00936E  50                    PUSH   ax                           ; UNKNOWN
00936F  8A 86 F0 FE           MOV    al, byte ptr [bp - 0x110]    ; UNKNOWN
009373  50                    PUSH   ax                           ; UNKNOWN
009374  8A 86 F1 FE           MOV    al, byte ptr [bp - 0x10f]    ; UNKNOWN
009378  50                    PUSH   ax                           ; UNKNOWN
009379  FF B6 F2 FE           PUSH   word ptr [bp - 0x10e]        ; UNKNOWN
00937D  68 FC 00              PUSH   0xfc                         ; UNKNOWN
009380  68 88 12              PUSH   0x1288                       ; UNKNOWN
009383  9A B8 03 65 5F        LCALL  0x5f65, 0x3b8                ; UNKNOWN
009388  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
00938B  68 00 00              PUSH   0                            ; UNKNOWN
00938E  68 9C 03              PUSH   0x39c                        ; UNKNOWN
009391  9A 2C 0E 65 5F        LCALL  0x5f65, 0xe2c                ; UNKNOWN
009396  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009399  5E                    POP    si                           ; UNKNOWN
00939A  C9                    LEAVE                               ; UNKNOWN
00939B  CB                    RETF                                ; UNKNOWN
