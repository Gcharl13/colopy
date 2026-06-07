; ============================================================================
; func_0115CE_unknown
; Region   : load_image
; Bytes    : file 0x0115CE..0x011687  (185 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0115CE  55                    PUSH   bp ; STACK_PUSH
0115CF  8B EC                 MOV    bp, sp ; MOV
0115D1  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
0115D4  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0115D7  3B 1E B9 27           CMP    bx, word ptr [0x27b9] ; CMP
0115DB  72 07                 JB     0x115e4 ; CJUMP
0115DD  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
0115E0  F9                    STC ; FLAG
0115E1  E9 01 F5              JMP    0x10ae5 ; JUMP
0115E4  81 3E 16 2B D6 D6     CMP    word ptr [0x2b16], 0xd6d6 ; CMP
0115EA  75 04                 JNE    0x115f0 ; CJUMP
0115EC  FF 16 18 2B           CALL   word ptr [0x2b18] ; CALL_NEAR
0115F0  F6 87 BB 27 20        TEST   byte ptr [bx + 0x27bb], 0x20 ; LOGIC
0115F5  74 0B                 JE     0x11602 ; CJUMP
0115F7  B8 02 42              MOV    ax, 0x4202 ; CONST_LOAD
0115FA  33 C9                 XOR    cx, cx ; LOGIC
0115FC  8B D1                 MOV    dx, cx ; MOV
0115FE  CD 21                 INT    0x21 ; SYS
011600  72 DF                 JB     0x115e1 ; CJUMP
011602  F6 87 BB 27 80        TEST   byte ptr [bx + 0x27bb], 0x80 ; LOGIC
011607  74 70                 JE     0x11679 ; CJUMP
011609  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
01160C  1E                    PUSH   ds ; STACK_PUSH
01160D  07                    POP    es ; STACK_POP
01160E  33 C0                 XOR    ax, ax ; LOGIC
011610  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
011613  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
011616  FC                    CLD ; FLAG
011617  57                    PUSH   di ; STACK_PUSH
011618  56                    PUSH   si ; STACK_PUSH
011619  8B FA                 MOV    di, dx ; MOV
01161B  8B F2                 MOV    si, dx ; MOV
01161D  89 66 F8              MOV    word ptr [bp - 8], sp ; LOCAL_STORE
011620  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
011623  E3 3A                 JCXZ   0x1165f ; CJUMP
011625  B0 0A                 MOV    al, 0xa ; CONST_LOAD
011627  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
011629  75 4C                 JNE    0x11677 ; CJUMP
01162B  9A 02 29 1D 0D        LCALL  0xd1d, 0x2902 ; LCALL
011630  3D A8 00              CMP    ax, 0xa8 ; CMP
011633  76 46                 JBE    0x1167b ; CJUMP
011635  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
011638  8B DC                 MOV    bx, sp ; MOV
01163A  BA 00 02              MOV    dx, 0x200 ; CONST_LOAD
01163D  3D 28 02              CMP    ax, 0x228 ; CMP
011640  73 03                 JAE    0x11645 ; CJUMP
011642  BA 80 00              MOV    dx, 0x80 ; CONST_LOAD
011645  2B E2                 SUB    sp, dx ; STACK_ALLOC
011647  8B D4                 MOV    dx, sp ; MOV
011649  8B FA                 MOV    di, dx ; MOV
01164B  16                    PUSH   ss ; STACK_PUSH
01164C  07                    POP    es ; STACK_POP
01164D  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
011650  AC                    LODSB  al, byte ptr [si] ; STR
011651  3C 0A                 CMP    al, 0xa ; CMP
011653  74 0C                 JE     0x11661 ; CJUMP
011655  3B FB                 CMP    di, bx ; CMP
011657  74 19                 JE     0x11672 ; CJUMP
011659  AA                    STOSB  byte ptr es:[di], al ; STR
01165A  E2 F4                 LOOP   0x11650 ; CJUMP
01165C  E8 23 00              CALL   0x11682 ; CALL_NEAR
01165F  EB 6B                 JMP    0x116cc ; JUMP
011661  B0 0D                 MOV    al, 0xd ; CONST_LOAD
011663  3B FB                 CMP    di, bx ; CMP
011665  75 03                 JNE    0x1166a ; CJUMP
011667  E8 18 00              CALL   0x11682 ; CALL_NEAR
01166A  AA                    STOSB  byte ptr es:[di], al ; STR
01166B  B0 0A                 MOV    al, 0xa ; CONST_LOAD
01166D  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
011670  EB E3                 JMP    0x11655 ; JUMP
011672  E8 0D 00              CALL   0x11682 ; CALL_NEAR
011675  EB E2                 JMP    0x11659 ; JUMP
011677  5E                    POP    si ; STACK_POP
011678  5F                    POP    di ; STACK_POP
011679  EB 5F                 JMP    0x116da ; JUMP
01167B  B8 FC FF              MOV    ax, 0xfffc ; CONST_LOAD
01167E  0E                    PUSH   cs ; STACK_PUSH
01167F  E8 1E E3              CALL   0xf9a0 ; CALL_NEAR
011682  50                    PUSH   ax ; STACK_PUSH
011683  53                    PUSH   bx ; STACK_PUSH
011684  51                    PUSH   cx ; STACK_PUSH
011685  8B CF                 MOV    cx, di ; MOV
