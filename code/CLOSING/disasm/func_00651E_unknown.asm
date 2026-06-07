; ============================================================================
; func_00651E_unknown
; Region   : load_image
; Bytes    : file 0x00651E..0x0065D7  (185 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00651E  55                    PUSH   bp ; STACK_PUSH
00651F  8B EC                 MOV    bp, sp ; MOV
006521  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
006524  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
006527  3B 1E 57 40           CMP    bx, word ptr [0x4057] ; CMP
00652B  72 07                 JB     0x6534 ; CJUMP
00652D  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
006530  F9                    STC ; FLAG
006531  E9 35 EE              JMP    0x5369 ; JUMP
006534  81 3E B0 43 D6 D6     CMP    word ptr [0x43b0], 0xd6d6 ; CMP
00653A  75 04                 JNE    0x6540 ; CJUMP
00653C  FF 16 B2 43           CALL   word ptr [0x43b2] ; CALL_NEAR
006540  F6 87 59 40 20        TEST   byte ptr [bx + 0x4059], 0x20 ; LOGIC
006545  74 0B                 JE     0x6552 ; CJUMP
006547  B8 02 42              MOV    ax, 0x4202 ; CONST_LOAD
00654A  33 C9                 XOR    cx, cx ; LOGIC
00654C  8B D1                 MOV    dx, cx ; MOV
00654E  CD 21                 INT    0x21 ; SYS
006550  72 DF                 JB     0x6531 ; CJUMP
006552  F6 87 59 40 80        TEST   byte ptr [bx + 0x4059], 0x80 ; LOGIC
006557  74 70                 JE     0x65c9 ; CJUMP
006559  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00655C  1E                    PUSH   ds ; STACK_PUSH
00655D  07                    POP    es ; STACK_POP
00655E  33 C0                 XOR    ax, ax ; LOGIC
006560  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
006563  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
006566  FC                    CLD ; FLAG
006567  57                    PUSH   di ; STACK_PUSH
006568  56                    PUSH   si ; STACK_PUSH
006569  8B FA                 MOV    di, dx ; MOV
00656B  8B F2                 MOV    si, dx ; MOV
00656D  89 66 F8              MOV    word ptr [bp - 8], sp ; LOCAL_STORE
006570  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
006573  E3 3A                 JCXZ   0x65af ; CJUMP
006575  B0 0A                 MOV    al, 0xa ; CONST_LOAD
006577  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
006579  75 4C                 JNE    0x65c7 ; CJUMP
00657B  9A A0 27 7D 03        LCALL  0x37d, 0x27a0 ; LCALL
006580  3D A8 00              CMP    ax, 0xa8 ; CMP
006583  76 46                 JBE    0x65cb ; CJUMP
006585  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
006588  8B DC                 MOV    bx, sp ; MOV
00658A  BA 00 02              MOV    dx, 0x200 ; CONST_LOAD
00658D  3D 28 02              CMP    ax, 0x228 ; CMP
006590  73 03                 JAE    0x6595 ; CJUMP
006592  BA 80 00              MOV    dx, 0x80 ; CONST_LOAD
006595  2B E2                 SUB    sp, dx ; STACK_ALLOC
006597  8B D4                 MOV    dx, sp ; MOV
006599  8B FA                 MOV    di, dx ; MOV
00659B  16                    PUSH   ss ; STACK_PUSH
00659C  07                    POP    es ; STACK_POP
00659D  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0065A0  AC                    LODSB  al, byte ptr [si] ; STR
0065A1  3C 0A                 CMP    al, 0xa ; CMP
0065A3  74 0C                 JE     0x65b1 ; CJUMP
0065A5  3B FB                 CMP    di, bx ; CMP
0065A7  74 19                 JE     0x65c2 ; CJUMP
0065A9  AA                    STOSB  byte ptr es:[di], al ; STR
0065AA  E2 F4                 LOOP   0x65a0 ; CJUMP
0065AC  E8 23 00              CALL   0x65d2 ; CALL_NEAR
0065AF  EB 6B                 JMP    0x661c ; JUMP
0065B1  B0 0D                 MOV    al, 0xd ; CONST_LOAD
0065B3  3B FB                 CMP    di, bx ; CMP
0065B5  75 03                 JNE    0x65ba ; CJUMP
0065B7  E8 18 00              CALL   0x65d2 ; CALL_NEAR
0065BA  AA                    STOSB  byte ptr es:[di], al ; STR
0065BB  B0 0A                 MOV    al, 0xa ; CONST_LOAD
0065BD  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
0065C0  EB E3                 JMP    0x65a5 ; JUMP
0065C2  E8 0D 00              CALL   0x65d2 ; CALL_NEAR
0065C5  EB E2                 JMP    0x65a9 ; JUMP
0065C7  5E                    POP    si ; STACK_POP
0065C8  5F                    POP    di ; STACK_POP
0065C9  EB 5F                 JMP    0x662a ; JUMP
0065CB  B8 FC FF              MOV    ax, 0xfffc ; CONST_LOAD
0065CE  0E                    PUSH   cs ; STACK_PUSH
0065CF  E8 CE DF              CALL   0x45a0 ; CALL_NEAR
0065D2  50                    PUSH   ax ; STACK_PUSH
0065D3  53                    PUSH   bx ; STACK_PUSH
0065D4  51                    PUSH   cx ; STACK_PUSH
0065D5  8B CF                 MOV    cx, di ; MOV
