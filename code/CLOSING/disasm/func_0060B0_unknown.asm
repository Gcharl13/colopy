; ============================================================================
; func_0060B0_unknown
; Region   : load_image
; Bytes    : file 0x0060B0..0x006205  (341 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0060B0  55                    PUSH   bp ; STACK_PUSH
0060B1  8B EC                 MOV    bp, sp ; MOV
0060B3  83 EC 06              SUB    sp, 6 ; STACK_ALLOC
0060B6  57                    PUSH   di ; STACK_PUSH
0060B7  56                    PUSH   si ; STACK_PUSH
0060B8  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
0060BD  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0060C0  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0060C3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0060C6  9A 8E 26 7D 03        LCALL  0x37d, 0x268e ; LCALL
0060CB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0060CE  83 3E 4A 40 02        CMP    word ptr [0x404a], 2 ; CMP
0060D3  74 03                 JE     0x60d8 ; CJUMP
0060D5  E9 13 01              JMP    0x61eb ; JUMP
0060D8  B8 5C 00              MOV    ax, 0x5c ; CONST_LOAD
0060DB  50                    PUSH   ax ; STACK_PUSH
0060DC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0060DF  9A BA 09 7D 03        LCALL  0x37d, 0x9ba ; LCALL
0060E4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0060E7  0B C0                 OR     ax, ax ; LOGIC
0060E9  74 03                 JE     0x60ee ; CJUMP
0060EB  E9 FD 00              JMP    0x61eb ; JUMP
0060EE  B8 2F 00              MOV    ax, 0x2f ; CONST_LOAD
0060F1  50                    PUSH   ax ; STACK_PUSH
0060F2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0060F5  9A BA 09 7D 03        LCALL  0x37d, 0x9ba ; LCALL
0060FA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0060FD  0B C0                 OR     ax, ax ; LOGIC
0060FF  74 03                 JE     0x6104 ; CJUMP
006101  E9 E7 00              JMP    0x61eb ; JUMP
006104  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
006107  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
00610A  74 09                 JE     0x6115 ; CJUMP
00610C  80 7F 01 3A           CMP    byte ptr [bx + 1], 0x3a ; CMP
006110  75 03                 JNE    0x6115 ; CJUMP
006112  E9 D6 00              JMP    0x61eb ; JUMP
006115  B8 52 43              MOV    ax, 0x4352 ; CONST_LOAD
006118  50                    PUSH   ax ; STACK_PUSH
006119  9A 9A 24 7D 03        LCALL  0x37d, 0x249a ; LCALL
00611E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006121  8B F0                 MOV    si, ax ; MOV
006123  0B F6                 OR     si, si ; LOGIC
006125  75 03                 JNE    0x612a ; CJUMP
006127  E9 C1 00              JMP    0x61eb ; JUMP
00612A  B8 04 01              MOV    ax, 0x104 ; CONST_LOAD
00612D  50                    PUSH   ax ; STACK_PUSH
00612E  9A 8E 24 7D 03        LCALL  0x37d, 0x248e ; LCALL
006133  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006136  8B F8                 MOV    di, ax ; MOV
006138  89 7E FC              MOV    word ptr [bp - 4], di ; LOCAL_STORE
00613B  0B FF                 OR     di, di ; LOGIC
00613D  75 03                 JNE    0x6142 ; CJUMP
00613F  E9 A9 00              JMP    0x61eb ; JUMP
006142  EB 15                 JMP    0x6159 ; JUMP
006144  80 3C 3B              CMP    byte ptr [si], 0x3b ; CMP
006147  74 15                 JE     0x615e ; CJUMP
006149  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00614C  05 02 01              ADD    ax, 0x102 ; ARITH
00614F  3B C7                 CMP    ax, di ; CMP
006151  76 0B                 JBE    0x615e ; CJUMP
006153  8A 04                 MOV    al, byte ptr [si] ; MOV
006155  88 05                 MOV    byte ptr [di], al ; MOV
006157  46                    INC    si ; ARITH
006158  47                    INC    di ; ARITH
006159  80 3C 00              CMP    byte ptr [si], 0 ; CMP
00615C  75 E6                 JNE    0x6144 ; CJUMP
00615E  C6 05 00              MOV    byte ptr [di], 0 ; MOV
006161  4F                    DEC    di ; ARITH
006162  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
006165  8B 7E FC              MOV    di, word ptr [bp - 4] ; LOCAL_LOAD
006168  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
00616B  80 3F 5C              CMP    byte ptr [bx], 0x5c ; CMP
00616E  74 12                 JE     0x6182 ; CJUMP
006170  80 3F 2F              CMP    byte ptr [bx], 0x2f ; CMP
006173  74 0D                 JE     0x6182 ; CJUMP
006175  B8 57 43              MOV    ax, 0x4357 ; CONST_LOAD
006178  50                    PUSH   ax ; STACK_PUSH
006179  57                    PUSH   di ; STACK_PUSH
00617A  9A 12 06 7D 03        LCALL  0x37d, 0x612 ; LCALL
00617F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006182  57                    PUSH   di ; STACK_PUSH
006183  9A B0 06 7D 03        LCALL  0x37d, 0x6b0 ; LCALL
006188  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00618B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00618E  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
006191  9A B0 06 7D 03        LCALL  0x37d, 0x6b0 ; LCALL
006196  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006199  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
00619C  3D 04 01              CMP    ax, 0x104 ; CMP
00619F  73 4A                 JAE    0x61eb ; CJUMP
0061A1  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0061A4  57                    PUSH   di ; STACK_PUSH
0061A5  9A 12 06 7D 03        LCALL  0x37d, 0x612 ; LCALL
0061AA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0061AD  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0061B0  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0061B3  57                    PUSH   di ; STACK_PUSH
0061B4  9A 8E 26 7D 03        LCALL  0x37d, 0x268e ; LCALL
0061B9  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0061BC  83 3E 4A 40 02        CMP    word ptr [0x404a], 2 ; CMP
0061C1  74 16                 JE     0x61d9 ; CJUMP
0061C3  80 3D 5C              CMP    byte ptr [di], 0x5c ; CMP
0061C6  74 05                 JE     0x61cd ; CJUMP
0061C8  80 3D 2F              CMP    byte ptr [di], 0x2f ; CMP
0061CB  75 1E                 JNE    0x61eb ; CJUMP
0061CD  80 7D 01 5C           CMP    byte ptr [di + 1], 0x5c ; CMP
0061D1  74 06                 JE     0x61d9 ; CJUMP
0061D3  80 7D 01 2F           CMP    byte ptr [di + 1], 0x2f ; CMP
0061D7  75 12                 JNE    0x61eb ; CJUMP
0061D9  80 3C 00              CMP    byte ptr [si], 0 ; CMP
0061DC  74 0D                 JE     0x61eb ; CJUMP
0061DE  89 76 FA              MOV    word ptr [bp - 6], si ; LOCAL_STORE
0061E1  46                    INC    si ; ARITH
0061E2  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
0061E6  74 03                 JE     0x61eb ; CJUMP
0061E8  E9 6E FF              JMP    0x6159 ; JUMP
0061EB  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
0061EF  74 0B                 JE     0x61fc ; CJUMP
0061F1  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
0061F4  9A 94 24 7D 03        LCALL  0x37d, 0x2494 ; LCALL
0061F9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0061FC  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0061FF  5E                    POP    si ; STACK_POP
006200  5F                    POP    di ; STACK_POP
006201  8B E5                 MOV    sp, bp ; MOV
006203  5D                    POP    bp ; STACK_POP
006204  CB                    RETF ; RETURN
