; ============================================================================
; func_00546C_unknown
; Region   : load_image
; Bytes    : file 0x00546C..0x005554  (232 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00546C  55                    PUSH   bp ; STACK_PUSH
00546D  8B EC                 MOV    bp, sp ; MOV
00546F  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
005472  57                    PUSH   di ; STACK_PUSH
005473  56                    PUSH   si ; STACK_PUSH
005474  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
005477  8A 07                 MOV    al, byte ptr [bx] ; MOV
005479  98                    CWDE ; ARITH
00547A  3D 77 00              CMP    ax, 0x77 ; CMP
00547D  74 45                 JE     0x54c4 ; CJUMP
00547F  77 08                 JA     0x5489 ; CJUMP
005481  2C 61                 SUB    al, 0x61 ; ARITH
005483  74 49                 JE     0x54ce ; CJUMP
005485  2C 11                 SUB    al, 0x11 ; ARITH
005487  74 05                 JE     0x548e ; CJUMP
005489  2B C0                 SUB    ax, ax ; ARITH
00548B  E9 C0 00              JMP    0x554e ; JUMP
00548E  2B F6                 SUB    si, si ; ARITH
005490  C6 46 FC 01           MOV    byte ptr [bp - 4], 1 ; LOCAL_STORE
005494  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
005499  FF 46 08              INC    word ptr [bp + 8] ; ARITH
00549C  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00549F  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
0054A2  74 5A                 JE     0x54fe ; CJUMP
0054A4  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0054A8  74 54                 JE     0x54fe ; CJUMP
0054AA  8A 07                 MOV    al, byte ptr [bx] ; MOV
0054AC  98                    CWDE ; ARITH
0054AD  3D 74 00              CMP    ax, 0x74 ; CMP
0054B0  74 34                 JE     0x54e6 ; CJUMP
0054B2  77 08                 JA     0x54bc ; CJUMP
0054B4  2C 2B                 SUB    al, 0x2b ; ARITH
0054B6  74 1C                 JE     0x54d4 ; CJUMP
0054B8  2C 37                 SUB    al, 0x37 ; ARITH
0054BA  74 36                 JE     0x54f2 ; CJUMP
0054BC  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0054C1  EB D6                 JMP    0x5499 ; JUMP
0054C3  90                    NOP ; NOP
0054C4  BE 01 03              MOV    si, 0x301 ; CONST_LOAD
0054C7  C6 46 FC 02           MOV    byte ptr [bp - 4], 2 ; LOCAL_STORE
0054CB  EB C7                 JMP    0x5494 ; JUMP
0054CD  90                    NOP ; NOP
0054CE  BE 09 01              MOV    si, 0x109 ; CONST_LOAD
0054D1  EB F4                 JMP    0x54c7 ; JUMP
0054D3  90                    NOP ; NOP
0054D4  F7 C6 02 00           TEST   si, 2 ; LOGIC
0054D8  75 E2                 JNE    0x54bc ; CJUMP
0054DA  83 CE 02              OR     si, 2 ; LOGIC
0054DD  83 E6 FE              AND    si, 0xfffe ; LOGIC
0054E0  C6 46 FC 80           MOV    byte ptr [bp - 4], 0x80 ; LOCAL_STORE
0054E4  EB B3                 JMP    0x5499 ; JUMP
0054E6  F7 C6 00 C0           TEST   si, 0xc000 ; LOGIC
0054EA  75 D0                 JNE    0x54bc ; CJUMP
0054EC  81 CE 00 40           OR     si, 0x4000 ; LOGIC
0054F0  EB A7                 JMP    0x5499 ; JUMP
0054F2  F7 C6 00 C0           TEST   si, 0xc000 ; LOGIC
0054F6  75 C4                 JNE    0x54bc ; CJUMP
0054F8  81 CE 00 80           OR     si, 0x8000 ; LOGIC
0054FC  EB 9B                 JMP    0x5499 ; JUMP
0054FE  B8 A4 01              MOV    ax, 0x1a4 ; CONST_LOAD
005501  50                    PUSH   ax ; STACK_PUSH
005502  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
005505  56                    PUSH   si ; STACK_PUSH
005506  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005509  9A 92 21 7D 03        LCALL  0x37d, 0x2192 ; LCALL
00550E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
005511  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
005514  0B C0                 OR     ax, ax ; LOGIC
005516  7D 03                 JGE    0x551b ; CJUMP
005518  E9 6E FF              JMP    0x5489 ; JUMP
00551B  FF 06 5A 43           INC    word ptr [0x435a] ; ARITH
00551F  8B 7E 0C              MOV    di, word ptr [bp + 0xc] ; LOCAL_LOAD
005522  8B C7                 MOV    ax, di ; MOV
005524  2D A8 41              SUB    ax, 0x41a8 ; ARITH
005527  05 48 42              ADD    ax, 0x4248 ; ARITH
00552A  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00552D  8A 46 FC              MOV    al, byte ptr [bp - 4] ; LOCAL_LOAD
005530  88 45 06              MOV    byte ptr [di + 6], al ; MOV
005533  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
005536  C6 07 00              MOV    byte ptr [bx], 0 ; MOV
005539  2B C0                 SUB    ax, ax ; ARITH
00553B  89 45 02              MOV    word ptr [di + 2], ax ; MOV
00553E  89 47 04              MOV    word ptr [bx + 4], ax ; MOV
005541  89 05                 MOV    word ptr [di], ax ; MOV
005543  89 45 04              MOV    word ptr [di + 4], ax ; MOV
005546  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
005549  88 45 07              MOV    byte ptr [di + 7], al ; MOV
00554C  8B C7                 MOV    ax, di ; MOV
00554E  5E                    POP    si ; STACK_POP
00554F  5F                    POP    di ; STACK_POP
005550  8B E5                 MOV    sp, bp ; MOV
005552  5D                    POP    bp ; STACK_POP
005553  CB                    RETF ; RETURN
