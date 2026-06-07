; ============================================================================
; func_00646C_unknown
; Region   : load_image
; Bytes    : file 0x00646C..0x006554  (232 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00646C  55                    PUSH   bp ; STACK_PUSH
00646D  8B EC                 MOV    bp, sp ; MOV
00646F  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
006472  57                    PUSH   di ; STACK_PUSH
006473  56                    PUSH   si ; STACK_PUSH
006474  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
006477  8A 07                 MOV    al, byte ptr [bx] ; MOV
006479  98                    CWDE ; ARITH
00647A  3D 77 00              CMP    ax, 0x77 ; CMP
00647D  74 45                 JE     0x64c4 ; CJUMP
00647F  77 08                 JA     0x6489 ; CJUMP
006481  2C 61                 SUB    al, 0x61 ; ARITH
006483  74 49                 JE     0x64ce ; CJUMP
006485  2C 11                 SUB    al, 0x11 ; ARITH
006487  74 05                 JE     0x648e ; CJUMP
006489  2B C0                 SUB    ax, ax ; ARITH
00648B  E9 C0 00              JMP    0x654e ; JUMP
00648E  2B F6                 SUB    si, si ; ARITH
006490  C6 46 FC 01           MOV    byte ptr [bp - 4], 1 ; LOCAL_STORE
006494  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
006499  FF 46 08              INC    word ptr [bp + 8] ; ARITH
00649C  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00649F  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
0064A2  74 5A                 JE     0x64fe ; CJUMP
0064A4  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0064A8  74 54                 JE     0x64fe ; CJUMP
0064AA  8A 07                 MOV    al, byte ptr [bx] ; MOV
0064AC  98                    CWDE ; ARITH
0064AD  3D 74 00              CMP    ax, 0x74 ; CMP
0064B0  74 34                 JE     0x64e6 ; CJUMP
0064B2  77 08                 JA     0x64bc ; CJUMP
0064B4  2C 2B                 SUB    al, 0x2b ; ARITH
0064B6  74 1C                 JE     0x64d4 ; CJUMP
0064B8  2C 37                 SUB    al, 0x37 ; ARITH
0064BA  74 36                 JE     0x64f2 ; CJUMP
0064BC  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0064C1  EB D6                 JMP    0x6499 ; JUMP
0064C3  90                    NOP ; NOP
0064C4  BE 01 03              MOV    si, 0x301 ; CONST_LOAD
0064C7  C6 46 FC 02           MOV    byte ptr [bp - 4], 2 ; LOCAL_STORE
0064CB  EB C7                 JMP    0x6494 ; JUMP
0064CD  90                    NOP ; NOP
0064CE  BE 09 01              MOV    si, 0x109 ; CONST_LOAD
0064D1  EB F4                 JMP    0x64c7 ; JUMP
0064D3  90                    NOP ; NOP
0064D4  F7 C6 02 00           TEST   si, 2 ; LOGIC
0064D8  75 E2                 JNE    0x64bc ; CJUMP
0064DA  83 CE 02              OR     si, 2 ; LOGIC
0064DD  83 E6 FE              AND    si, 0xfffe ; LOGIC
0064E0  C6 46 FC 80           MOV    byte ptr [bp - 4], 0x80 ; LOCAL_STORE
0064E4  EB B3                 JMP    0x6499 ; JUMP
0064E6  F7 C6 00 C0           TEST   si, 0xc000 ; LOGIC
0064EA  75 D0                 JNE    0x64bc ; CJUMP
0064EC  81 CE 00 40           OR     si, 0x4000 ; LOGIC
0064F0  EB A7                 JMP    0x6499 ; JUMP
0064F2  F7 C6 00 C0           TEST   si, 0xc000 ; LOGIC
0064F6  75 C4                 JNE    0x64bc ; CJUMP
0064F8  81 CE 00 80           OR     si, 0x8000 ; LOGIC
0064FC  EB 9B                 JMP    0x6499 ; JUMP
0064FE  B8 A4 01              MOV    ax, 0x1a4 ; CONST_LOAD
006501  50                    PUSH   ax ; STACK_PUSH
006502  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
006505  56                    PUSH   si ; STACK_PUSH
006506  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
006509  9A 34 22 52 04        LCALL  0x452, 0x2234 ; LCALL
00650E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
006511  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
006514  0B C0                 OR     ax, ax ; LOGIC
006516  7D 03                 JGE    0x651b ; CJUMP
006518  E9 6E FF              JMP    0x6489 ; JUMP
00651B  FF 06 B0 45           INC    word ptr [0x45b0] ; ARITH
00651F  8B 7E 0C              MOV    di, word ptr [bp + 0xc] ; LOCAL_LOAD
006522  8B C7                 MOV    ax, di ; MOV
006524  2D FE 43              SUB    ax, 0x43fe ; ARITH
006527  05 9E 44              ADD    ax, 0x449e ; ARITH
00652A  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00652D  8A 46 FC              MOV    al, byte ptr [bp - 4] ; LOCAL_LOAD
006530  88 45 06              MOV    byte ptr [di + 6], al ; MOV
006533  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
006536  C6 07 00              MOV    byte ptr [bx], 0 ; MOV
006539  2B C0                 SUB    ax, ax ; ARITH
00653B  89 45 02              MOV    word ptr [di + 2], ax ; MOV
00653E  89 47 04              MOV    word ptr [bx + 4], ax ; MOV
006541  89 05                 MOV    word ptr [di], ax ; MOV
006543  89 45 04              MOV    word ptr [di + 4], ax ; MOV
006546  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
006549  88 45 07              MOV    byte ptr [di + 7], al ; MOV
00654C  8B C7                 MOV    ax, di ; MOV
00654E  5E                    POP    si ; STACK_POP
00654F  5F                    POP    di ; STACK_POP
006550  8B E5                 MOV    sp, bp ; MOV
006552  5D                    POP    bp ; STACK_POP
006553  CB                    RETF ; RETURN
