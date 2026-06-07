; ============================================================================
; func_007510_unknown
; Region   : load_image
; Bytes    : file 0x007510..0x0075C9  (185 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007510  55                    PUSH   bp ; STACK_PUSH
007511  8B EC                 MOV    bp, sp ; MOV
007513  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
007516  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
007519  3B 1E AD 42           CMP    bx, word ptr [0x42ad] ; CMP
00751D  72 07                 JB     0x7526 ; CJUMP
00751F  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
007522  F9                    STC ; FLAG
007523  E9 43 EE              JMP    0x6369 ; JUMP
007526  81 3E 06 46 D6 D6     CMP    word ptr [0x4606], 0xd6d6 ; CMP
00752C  75 04                 JNE    0x7532 ; CJUMP
00752E  FF 16 08 46           CALL   word ptr [0x4608] ; CALL_NEAR
007532  F6 87 AF 42 20        TEST   byte ptr [bx + 0x42af], 0x20 ; LOGIC
007537  74 0B                 JE     0x7544 ; CJUMP
007539  B8 02 42              MOV    ax, 0x4202 ; CONST_LOAD
00753C  33 C9                 XOR    cx, cx ; LOGIC
00753E  8B D1                 MOV    dx, cx ; MOV
007540  CD 21                 INT    0x21 ; SYS
007542  72 DF                 JB     0x7523 ; CJUMP
007544  F6 87 AF 42 80        TEST   byte ptr [bx + 0x42af], 0x80 ; LOGIC
007549  74 70                 JE     0x75bb ; CJUMP
00754B  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00754E  1E                    PUSH   ds ; STACK_PUSH
00754F  07                    POP    es ; STACK_POP
007550  33 C0                 XOR    ax, ax ; LOGIC
007552  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
007555  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
007558  FC                    CLD ; FLAG
007559  57                    PUSH   di ; STACK_PUSH
00755A  56                    PUSH   si ; STACK_PUSH
00755B  8B FA                 MOV    di, dx ; MOV
00755D  8B F2                 MOV    si, dx ; MOV
00755F  89 66 F8              MOV    word ptr [bp - 8], sp ; LOCAL_STORE
007562  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
007565  E3 3A                 JCXZ   0x75a1 ; CJUMP
007567  B0 0A                 MOV    al, 0xa ; CONST_LOAD
007569  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
00756B  75 4C                 JNE    0x75b9 ; CJUMP
00756D  9A 42 28 52 04        LCALL  0x452, 0x2842 ; LCALL
007572  3D A8 00              CMP    ax, 0xa8 ; CMP
007575  76 46                 JBE    0x75bd ; CJUMP
007577  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
00757A  8B DC                 MOV    bx, sp ; MOV
00757C  BA 00 02              MOV    dx, 0x200 ; CONST_LOAD
00757F  3D 28 02              CMP    ax, 0x228 ; CMP
007582  73 03                 JAE    0x7587 ; CJUMP
007584  BA 80 00              MOV    dx, 0x80 ; CONST_LOAD
007587  2B E2                 SUB    sp, dx ; STACK_ALLOC
007589  8B D4                 MOV    dx, sp ; MOV
00758B  8B FA                 MOV    di, dx ; MOV
00758D  16                    PUSH   ss ; STACK_PUSH
00758E  07                    POP    es ; STACK_POP
00758F  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
007592  AC                    LODSB  al, byte ptr [si] ; STR
007593  3C 0A                 CMP    al, 0xa ; CMP
007595  74 0C                 JE     0x75a3 ; CJUMP
007597  3B FB                 CMP    di, bx ; CMP
007599  74 19                 JE     0x75b4 ; CJUMP
00759B  AA                    STOSB  byte ptr es:[di], al ; STR
00759C  E2 F4                 LOOP   0x7592 ; CJUMP
00759E  E8 23 00              CALL   0x75c4 ; CALL_NEAR
0075A1  EB 6B                 JMP    0x760e ; JUMP
0075A3  B0 0D                 MOV    al, 0xd ; CONST_LOAD
0075A5  3B FB                 CMP    di, bx ; CMP
0075A7  75 03                 JNE    0x75ac ; CJUMP
0075A9  E8 18 00              CALL   0x75c4 ; CALL_NEAR
0075AC  AA                    STOSB  byte ptr es:[di], al ; STR
0075AD  B0 0A                 MOV    al, 0xa ; CONST_LOAD
0075AF  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
0075B2  EB E3                 JMP    0x7597 ; JUMP
0075B4  E8 0D 00              CALL   0x75c4 ; CALL_NEAR
0075B7  EB E2                 JMP    0x759b ; JUMP
0075B9  5E                    POP    si ; STACK_POP
0075BA  5F                    POP    di ; STACK_POP
0075BB  EB 5F                 JMP    0x761c ; JUMP
0075BD  B8 FC FF              MOV    ax, 0xfffc ; CONST_LOAD
0075C0  0E                    PUSH   cs ; STACK_PUSH
0075C1  E8 38 DF              CALL   0x54fc ; CALL_NEAR
0075C4  50                    PUSH   ax ; STACK_PUSH
0075C5  53                    PUSH   bx ; STACK_PUSH
0075C6  51                    PUSH   cx ; STACK_PUSH
0075C7  8B CF                 MOV    cx, di ; MOV
