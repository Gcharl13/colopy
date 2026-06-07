; ============================================================================
; func_0162B4_unknown
; Region   : load_image
; Bytes    : file 0x0162B4..0x01639C  (232 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0162B4  55                    PUSH   bp ; STACK_PUSH
0162B5  8B EC                 MOV    bp, sp ; MOV
0162B7  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
0162BA  57                    PUSH   di ; STACK_PUSH
0162BB  56                    PUSH   si ; STACK_PUSH
0162BC  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
0162BF  8A 07                 MOV    al, byte ptr [bx] ; MOV
0162C1  98                    CWDE ; ARITH
0162C2  3D 77 00              CMP    ax, 0x77 ; CMP
0162C5  74 45                 JE     0x1630c ; CJUMP
0162C7  77 08                 JA     0x162d1 ; CJUMP
0162C9  2C 61                 SUB    al, 0x61 ; ARITH
0162CB  74 49                 JE     0x16316 ; CJUMP
0162CD  2C 11                 SUB    al, 0x11 ; ARITH
0162CF  74 05                 JE     0x162d6 ; CJUMP
0162D1  2B C0                 SUB    ax, ax ; ARITH
0162D3  E9 C0 00              JMP    0x16396 ; JUMP
0162D6  2B F6                 SUB    si, si ; ARITH
0162D8  C6 46 FC 01           MOV    byte ptr [bp - 4], 1 ; LOCAL_STORE
0162DC  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0162E1  FF 46 08              INC    word ptr [bp + 8] ; ARITH
0162E4  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
0162E7  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
0162EA  74 5A                 JE     0x16346 ; CJUMP
0162EC  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0162F0  74 54                 JE     0x16346 ; CJUMP
0162F2  8A 07                 MOV    al, byte ptr [bx] ; MOV
0162F4  98                    CWDE ; ARITH
0162F5  3D 74 00              CMP    ax, 0x74 ; CMP
0162F8  74 34                 JE     0x1632e ; CJUMP
0162FA  77 08                 JA     0x16304 ; CJUMP
0162FC  2C 2B                 SUB    al, 0x2b ; ARITH
0162FE  74 1C                 JE     0x1631c ; CJUMP
016300  2C 37                 SUB    al, 0x37 ; ARITH
016302  74 36                 JE     0x1633a ; CJUMP
016304  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
016309  EB D6                 JMP    0x162e1 ; JUMP
01630B  90                    NOP ; NOP
01630C  BE 01 03              MOV    si, 0x301 ; CONST_LOAD
01630F  C6 46 FC 02           MOV    byte ptr [bp - 4], 2 ; LOCAL_STORE
016313  EB C7                 JMP    0x162dc ; JUMP
016315  90                    NOP ; NOP
016316  BE 09 01              MOV    si, 0x109 ; CONST_LOAD
016319  EB F4                 JMP    0x1630f ; JUMP
01631B  90                    NOP ; NOP
01631C  F7 C6 02 00           TEST   si, 2 ; LOGIC
016320  75 E2                 JNE    0x16304 ; CJUMP
016322  83 CE 02              OR     si, 2 ; LOGIC
016325  83 E6 FE              AND    si, 0xfffe ; LOGIC
016328  C6 46 FC 80           MOV    byte ptr [bp - 4], 0x80 ; LOCAL_STORE
01632C  EB B3                 JMP    0x162e1 ; JUMP
01632E  F7 C6 00 C0           TEST   si, 0xc000 ; LOGIC
016332  75 D0                 JNE    0x16304 ; CJUMP
016334  81 CE 00 40           OR     si, 0x4000 ; LOGIC
016338  EB A7                 JMP    0x162e1 ; JUMP
01633A  F7 C6 00 C0           TEST   si, 0xc000 ; LOGIC
01633E  75 C4                 JNE    0x16304 ; CJUMP
016340  81 CE 00 80           OR     si, 0x8000 ; LOGIC
016344  EB 9B                 JMP    0x162e1 ; JUMP
016346  B8 A4 01              MOV    ax, 0x1a4 ; CONST_LOAD
016349  50                    PUSH   ax ; STACK_PUSH
01634A  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
01634D  56                    PUSH   si ; STACK_PUSH
01634E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
016351  9A 22 22 88 13        LCALL  0x1388, 0x2222 ; LCALL
016356  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
016359  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
01635C  0B C0                 OR     ax, ax ; LOGIC
01635E  7D 03                 JGE    0x16363 ; CJUMP
016360  E9 6E FF              JMP    0x162d1 ; JUMP
016363  FF 06 70 48           INC    word ptr [0x4870] ; ARITH
016367  8B 7E 0C              MOV    di, word ptr [bp + 0xc] ; LOCAL_LOAD
01636A  8B C7                 MOV    ax, di ; MOV
01636C  2D C6 46              SUB    ax, 0x46c6 ; ARITH
01636F  05 66 47              ADD    ax, 0x4766 ; ARITH
016372  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
016375  8A 46 FC              MOV    al, byte ptr [bp - 4] ; LOCAL_LOAD
016378  88 45 06              MOV    byte ptr [di + 6], al ; MOV
01637B  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
01637E  C6 07 00              MOV    byte ptr [bx], 0 ; MOV
016381  2B C0                 SUB    ax, ax ; ARITH
016383  89 45 02              MOV    word ptr [di + 2], ax ; MOV
016386  89 47 04              MOV    word ptr [bx + 4], ax ; MOV
016389  89 05                 MOV    word ptr [di], ax ; MOV
01638B  89 45 04              MOV    word ptr [di + 4], ax ; MOV
01638E  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
016391  88 45 07              MOV    byte ptr [di + 7], al ; MOV
016394  8B C7                 MOV    ax, di ; MOV
016396  5E                    POP    si ; STACK_POP
016397  5F                    POP    di ; STACK_POP
016398  8B E5                 MOV    sp, bp ; MOV
01639A  5D                    POP    bp ; STACK_POP
01639B  CB                    RETF ; RETURN
