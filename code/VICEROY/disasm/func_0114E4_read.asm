; ============================================================================
; func_0114E4_unknown
; Region   : load_image
; Bytes    : file 0x0114E4..0x011561  (125 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0114E4  55                    PUSH   bp ; STACK_PUSH
0114E5  8B EC                 MOV    bp, sp ; MOV
0114E7  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
0114EA  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0114ED  3B 1E B9 27           CMP    bx, word ptr [0x27b9] ; CMP
0114F1  72 06                 JB     0x114f9 ; CJUMP
0114F3  F9                    STC ; FLAG
0114F4  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
0114F7  EB 68                 JMP    0x11561 ; JUMP
0114F9  33 C0                 XOR    ax, ax ; LOGIC
0114FB  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0114FE  E3 61                 JCXZ   0x11561 ; CJUMP
011500  F6 87 BB 27 02        TEST   byte ptr [bx + 0x27bb], 2 ; LOGIC
011505  75 5A                 JNE    0x11561 ; CJUMP
011507  81 3E 16 2B D6 D6     CMP    word ptr [0x2b16], 0xd6d6 ; CMP
01150D  75 04                 JNE    0x11513 ; CJUMP
01150F  FF 16 18 2B           CALL   word ptr [0x2b18] ; CALL_NEAR
011513  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
011516  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
011519  B4 3F                 MOV    ah, 0x3f ; CONST_LOAD
01151B  CD 21                 INT    0x21 ; SYS
01151D  73 04                 JAE    0x11523 ; CJUMP
01151F  B4 09                 MOV    ah, 9 ; MOV
011521  EB 3E                 JMP    0x11561 ; JUMP
011523  F6 87 BB 27 80        TEST   byte ptr [bx + 0x27bb], 0x80 ; LOGIC
011528  74 37                 JE     0x11561 ; CJUMP
01152A  80 A7 BB 27 FB        AND    byte ptr [bx + 0x27bb], 0xfb ; LOGIC
01152F  56                    PUSH   si ; STACK_PUSH
011530  57                    PUSH   di ; STACK_PUSH
011531  FC                    CLD ; FLAG
011532  8B F2                 MOV    si, dx ; MOV
011534  8B FA                 MOV    di, dx ; MOV
011536  8B C8                 MOV    cx, ax ; MOV
011538  E3 25                 JCXZ   0x1155f ; CJUMP
01153A  B4 0D                 MOV    ah, 0xd ; CONST_LOAD
01153C  80 3C 0A              CMP    byte ptr [si], 0xa ; CMP
01153F  75 05                 JNE    0x11546 ; CJUMP
011541  80 8F BB 27 04        OR     byte ptr [bx + 0x27bb], 4 ; LOGIC
011546  AC                    LODSB  al, byte ptr [si] ; STR
011547  3A C4                 CMP    al, ah ; CMP
011549  74 19                 JE     0x11564 ; CJUMP
01154B  3C 1A                 CMP    al, 0x1a ; CMP
01154D  75 07                 JNE    0x11556 ; CJUMP
01154F  80 8F BB 27 02        OR     byte ptr [bx + 0x27bb], 2 ; LOGIC
011554  EB 05                 JMP    0x1155b ; JUMP
011556  88 05                 MOV    byte ptr [di], al ; MOV
011558  47                    INC    di ; ARITH
011559  E2 EB                 LOOP   0x11546 ; CJUMP
01155B  8B C7                 MOV    ax, di ; MOV
01155D  2B C2                 SUB    ax, dx ; ARITH
01155F  5F                    POP    di ; STACK_POP
011560  5E                    POP    si ; STACK_POP
