; ============================================================================
; func_034498_unknown
; Region   : load_image
; Bytes    : file 0x034498..0x034678  (480 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034498  C8 B6 00 00           ENTER  0xb6, 0                      ; UNKNOWN
03449C  57                    PUSH   di                           ; UNKNOWN
03449D  56                    PUSH   si                           ; UNKNOWN
03449E  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
0344A1  83 E0 01              AND    ax, 1                        ; UNKNOWN
0344A4  74 1B                 JE     0x344c1                      ; UNKNOWN
0344A6  C6 86 58 FF 00        MOV    byte ptr [bp - 0xa8], 0      ; UNKNOWN
0344AB  C7 86 56 FF 0F 00     MOV    word ptr [bp - 0xaa], 0xf    ; UNKNOWN
0344B1  C6 86 4E FF 30        MOV    byte ptr [bp - 0xb2], 0x30   ; UNKNOWN
0344B6  C6 46 FE 39           MOV    byte ptr [bp - 2], 0x39      ; UNKNOWN
0344BA  C6 86 50 FF 07        MOV    byte ptr [bp - 0xb0], 7      ; UNKNOWN
0344BF  EB 19                 JMP    0x344da                      ; UNKNOWN
0344C1  C6 86 58 FF 0F        MOV    byte ptr [bp - 0xa8], 0xf    ; UNKNOWN
0344C6  C7 86 56 FF FF FF     MOV    word ptr [bp - 0xaa], 0xffff ; UNKNOWN
0344CC  C6 86 4E FF 39        MOV    byte ptr [bp - 0xb2], 0x39   ; UNKNOWN
0344D1  C6 46 FE 30           MOV    byte ptr [bp - 2], 0x30      ; UNKNOWN
0344D5  C6 86 50 FF 0E        MOV    byte ptr [bp - 0xb0], 0xe    ; UNKNOWN
0344DA  8D 86 52 FF           LEA    ax, [bp - 0xae]              ; UNKNOWN
0344DE  50                    PUSH   ax                           ; UNKNOWN
0344DF  8D 8E 54 FF           LEA    cx, [bp - 0xac]              ; UNKNOWN
0344E3  51                    PUSH   cx                           ; UNKNOWN
0344E4  8D 56 FA              LEA    dx, [bp - 6]                 ; UNKNOWN
0344E7  52                    PUSH   dx                           ; UNKNOWN
0344E8  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
0344EB  E8 74 FF              CALL   0x34462                      ; UNKNOWN
0344EE  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0344F1  8B 86 54 FF           MOV    ax, word ptr [bp - 0xac]     ; UNKNOWN
0344F5  2B 46 FA              SUB    ax, word ptr [bp - 6]        ; UNKNOWN
0344F8  D1 F8                 SAR    ax, 1                        ; UNKNOWN
0344FA  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
0344FD  89 86 4C FF           MOV    word ptr [bp - 0xb4], ax     ; UNKNOWN
034501  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
034504  40                    INC    ax                           ; UNKNOWN
034505  40                    INC    ax                           ; UNKNOWN
034506  89 86 4A FF           MOV    word ptr [bp - 0xb6], ax     ; UNKNOWN
03450A  F6 46 0A 02           TEST   byte ptr [bp + 0xa], 2       ; UNKNOWN
03450E  74 03                 JE     0x34513                      ; UNKNOWN
034510  E9 DD 00              JMP    0x345f0                      ; UNKNOWN
034513  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
034517  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
03451B  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
03451F  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
034523  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
034526  50                    PUSH   ax                           ; UNKNOWN
034527  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03452A  8B 96 54 FF           MOV    dx, word ptr [bp - 0xac]     ; UNKNOWN
03452E  03 D0                 ADD    dx, ax                       ; UNKNOWN
034530  8B 9E 52 FF           MOV    bx, word ptr [bp - 0xae]     ; UNKNOWN
034534  03 5E 08              ADD    bx, word ptr [bp + 8]        ; UNKNOWN
034537  4B                    DEC    bx                           ; UNKNOWN
034538  4A                    DEC    dx                           ; UNKNOWN
034539  8B F0                 MOV    si, ax                       ; UNKNOWN
03453B  9A 0A 00 76 5A        LCALL  0x5a76, 0xa                  ; UNKNOWN
034540  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
034544  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
034548  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
03454C  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
034550  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
034553  50                    PUSH   ax                           ; UNKNOWN
034554  8B 86 54 FF           MOV    ax, word ptr [bp - 0xac]     ; UNKNOWN
034558  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
03455B  48                    DEC    ax                           ; UNKNOWN
03455C  8B 9E 52 FF           MOV    bx, word ptr [bp - 0xae]     ; UNKNOWN
034560  03 5E 08              ADD    bx, word ptr [bp + 8]        ; UNKNOWN
034563  4B                    DEC    bx                           ; UNKNOWN
034564  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
034567  8B FA                 MOV    di, dx                       ; UNKNOWN
034569  9A 04 00 7D 5A        LCALL  0x5a7d, 4                    ; UNKNOWN
03456E  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
034572  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
034576  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
03457A  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
03457E  8A 86 4E FF           MOV    al, byte ptr [bp - 0xb2]     ; UNKNOWN
034582  50                    PUSH   ax                           ; UNKNOWN
034583  8B DF                 MOV    bx, di                       ; UNKNOWN
034585  8B C6                 MOV    ax, si                       ; UNKNOWN
034587  8B 96 54 FF           MOV    dx, word ptr [bp - 0xac]     ; UNKNOWN
03458B  03 56 06              ADD    dx, word ptr [bp + 6]        ; UNKNOWN
03458E  4A                    DEC    dx                           ; UNKNOWN
03458F  9A 0A 00 76 5A        LCALL  0x5a76, 0xa                  ; UNKNOWN
034594  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
034598  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
03459C  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
0345A0  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
0345A4  8A 86 4E FF           MOV    al, byte ptr [bp - 0xb2]     ; UNKNOWN
0345A8  50                    PUSH   ax                           ; UNKNOWN
0345A9  8B C6                 MOV    ax, si                       ; UNKNOWN
0345AB  8B 9E 52 FF           MOV    bx, word ptr [bp - 0xae]     ; UNKNOWN
0345AF  03 5E 08              ADD    bx, word ptr [bp + 8]        ; UNKNOWN
0345B2  4B                    DEC    bx                           ; UNKNOWN
0345B3  8B D7                 MOV    dx, di                       ; UNKNOWN
0345B5  9A 04 00 7D 5A        LCALL  0x5a7d, 4                    ; UNKNOWN
0345BA  83 BE 56 FF 00        CMP    word ptr [bp - 0xaa], 0      ; UNKNOWN
0345BF  7C 2F                 JL     0x345f0                      ; UNKNOWN
0345C1  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
0345C5  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
0345C9  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
0345CD  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
0345D1  8B 86 52 FF           MOV    ax, word ptr [bp - 0xae]     ; UNKNOWN
0345D5  48                    DEC    ax                           ; UNKNOWN
0345D6  48                    DEC    ax                           ; UNKNOWN
0345D7  50                    PUSH   ax                           ; UNKNOWN
0345D8  8A 86 56 FF           MOV    al, byte ptr [bp - 0xaa]     ; UNKNOWN
0345DC  50                    PUSH   ax                           ; UNKNOWN
0345DD  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0345E0  40                    INC    ax                           ; UNKNOWN
0345E1  8B 9E 54 FF           MOV    bx, word ptr [bp - 0xac]     ; UNKNOWN
0345E5  4B                    DEC    bx                           ; UNKNOWN
0345E6  4B                    DEC    bx                           ; UNKNOWN
0345E7  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
0345EA  42                    INC    dx                           ; UNKNOWN
0345EB  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
0345F0  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
0345F3  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
0345F8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0345FB  52                    PUSH   dx                           ; UNKNOWN
0345FC  50                    PUSH   ax                           ; UNKNOWN
0345FD  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
034600  16                    PUSH   ss                           ; UNKNOWN
034601  50                    PUSH   ax                           ; UNKNOWN
034602  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
034607  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03460A  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
03460D  50                    PUSH   ax                           ; UNKNOWN
03460E  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
034613  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034616  0B C0                 OR     ax, ax                       ; UNKNOWN
034618  74 13                 JE     0x3462d                      ; UNKNOWN
03461A  8D 46 AB              LEA    ax, [bp - 0x55]              ; UNKNOWN
03461D  50                    PUSH   ax                           ; UNKNOWN
03461E  8D 86 5A FF           LEA    ax, [bp - 0xa6]              ; UNKNOWN
034622  50                    PUSH   ax                           ; UNKNOWN
034623  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
034628  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03462B  EB 05                 JMP    0x34632                      ; UNKNOWN
03462D  C6 86 5A FF 00        MOV    byte ptr [bp - 0xa6], 0      ; UNKNOWN
034632  C6 46 AB 00           MOV    byte ptr [bp - 0x55], 0      ; UNKNOWN
034636  8A 86 58 FF           MOV    al, byte ptr [bp - 0xa8]     ; UNKNOWN
03463A  2A E4                 SUB    ah, ah                       ; UNKNOWN
03463C  50                    PUSH   ax                           ; UNKNOWN
03463D  FF B6 4A FF           PUSH   word ptr [bp - 0xb6]         ; UNKNOWN
034641  8A 86 50 FF           MOV    al, byte ptr [bp - 0xb0]     ; UNKNOWN
034645  50                    PUSH   ax                           ; UNKNOWN
034646  FF B6 4A FF           PUSH   word ptr [bp - 0xb6]         ; UNKNOWN
03464A  FF B6 4C FF           PUSH   word ptr [bp - 0xb4]         ; UNKNOWN
03464E  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
034651  16                    PUSH   ss                           ; UNKNOWN
034652  50                    PUSH   ax                           ; UNKNOWN
034653  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
034658  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
03465B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03465E  50                    PUSH   ax                           ; UNKNOWN
03465F  8D 86 5A FF           LEA    ax, [bp - 0xa6]              ; UNKNOWN
034663  16                    PUSH   ss                           ; UNKNOWN
034664  50                    PUSH   ax                           ; UNKNOWN
034665  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
03466A  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
03466D  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
034670  8B 86 52 FF           MOV    ax, word ptr [bp - 0xae]     ; UNKNOWN
034674  5E                    POP    si                           ; UNKNOWN
034675  5F                    POP    di                           ; UNKNOWN
034676  C9                    LEAVE                               ; UNKNOWN
034677  C3                    RET                                 ; UNKNOWN
