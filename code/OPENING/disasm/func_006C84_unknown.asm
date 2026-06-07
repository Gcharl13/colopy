; ============================================================================
; func_006C84_unknown
; Region   : load_image
; Bytes    : file 0x006C84..0x006D01  (125 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006C84  55                    PUSH   bp ; STACK_PUSH
006C85  8B EC                 MOV    bp, sp ; MOV
006C87  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
006C8A  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
006C8D  3B 1E AD 42           CMP    bx, word ptr [0x42ad] ; CMP
006C91  72 06                 JB     0x6c99 ; CJUMP
006C93  F9                    STC ; FLAG
006C94  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
006C97  EB 68                 JMP    0x6d01 ; JUMP
006C99  33 C0                 XOR    ax, ax ; LOGIC
006C9B  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
006C9E  E3 61                 JCXZ   0x6d01 ; CJUMP
006CA0  F6 87 AF 42 02        TEST   byte ptr [bx + 0x42af], 2 ; LOGIC
006CA5  75 5A                 JNE    0x6d01 ; CJUMP
006CA7  81 3E 06 46 D6 D6     CMP    word ptr [0x4606], 0xd6d6 ; CMP
006CAD  75 04                 JNE    0x6cb3 ; CJUMP
006CAF  FF 16 08 46           CALL   word ptr [0x4608] ; CALL_NEAR
006CB3  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
006CB6  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
006CB9  B4 3F                 MOV    ah, 0x3f ; CONST_LOAD
006CBB  CD 21                 INT    0x21 ; SYS
006CBD  73 04                 JAE    0x6cc3 ; CJUMP
006CBF  B4 09                 MOV    ah, 9 ; MOV
006CC1  EB 3E                 JMP    0x6d01 ; JUMP
006CC3  F6 87 AF 42 80        TEST   byte ptr [bx + 0x42af], 0x80 ; LOGIC
006CC8  74 37                 JE     0x6d01 ; CJUMP
006CCA  80 A7 AF 42 FB        AND    byte ptr [bx + 0x42af], 0xfb ; LOGIC
006CCF  56                    PUSH   si ; STACK_PUSH
006CD0  57                    PUSH   di ; STACK_PUSH
006CD1  FC                    CLD ; FLAG
006CD2  8B F2                 MOV    si, dx ; MOV
006CD4  8B FA                 MOV    di, dx ; MOV
006CD6  8B C8                 MOV    cx, ax ; MOV
006CD8  E3 25                 JCXZ   0x6cff ; CJUMP
006CDA  B4 0D                 MOV    ah, 0xd ; CONST_LOAD
006CDC  80 3C 0A              CMP    byte ptr [si], 0xa ; CMP
006CDF  75 05                 JNE    0x6ce6 ; CJUMP
006CE1  80 8F AF 42 04        OR     byte ptr [bx + 0x42af], 4 ; LOGIC
006CE6  AC                    LODSB  al, byte ptr [si] ; STR
006CE7  3A C4                 CMP    al, ah ; CMP
006CE9  74 19                 JE     0x6d04 ; CJUMP
006CEB  3C 1A                 CMP    al, 0x1a ; CMP
006CED  75 07                 JNE    0x6cf6 ; CJUMP
006CEF  80 8F AF 42 02        OR     byte ptr [bx + 0x42af], 2 ; LOGIC
006CF4  EB 05                 JMP    0x6cfb ; JUMP
006CF6  88 05                 MOV    byte ptr [di], al ; MOV
006CF8  47                    INC    di ; ARITH
006CF9  E2 EB                 LOOP   0x6ce6 ; CJUMP
006CFB  8B C7                 MOV    ax, di ; MOV
006CFD  2B C2                 SUB    ax, dx ; ARITH
006CFF  5F                    POP    di ; STACK_POP
006D00  5E                    POP    si ; STACK_POP
