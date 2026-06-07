; ============================================================================
; func_005C84_unknown
; Region   : load_image
; Bytes    : file 0x005C84..0x005D01  (125 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005C84  55                    PUSH   bp ; STACK_PUSH
005C85  8B EC                 MOV    bp, sp ; MOV
005C87  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
005C8A  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
005C8D  3B 1E 57 40           CMP    bx, word ptr [0x4057] ; CMP
005C91  72 06                 JB     0x5c99 ; CJUMP
005C93  F9                    STC ; FLAG
005C94  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
005C97  EB 68                 JMP    0x5d01 ; JUMP
005C99  33 C0                 XOR    ax, ax ; LOGIC
005C9B  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
005C9E  E3 61                 JCXZ   0x5d01 ; CJUMP
005CA0  F6 87 59 40 02        TEST   byte ptr [bx + 0x4059], 2 ; LOGIC
005CA5  75 5A                 JNE    0x5d01 ; CJUMP
005CA7  81 3E B0 43 D6 D6     CMP    word ptr [0x43b0], 0xd6d6 ; CMP
005CAD  75 04                 JNE    0x5cb3 ; CJUMP
005CAF  FF 16 B2 43           CALL   word ptr [0x43b2] ; CALL_NEAR
005CB3  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
005CB6  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
005CB9  B4 3F                 MOV    ah, 0x3f ; CONST_LOAD
005CBB  CD 21                 INT    0x21 ; SYS
005CBD  73 04                 JAE    0x5cc3 ; CJUMP
005CBF  B4 09                 MOV    ah, 9 ; MOV
005CC1  EB 3E                 JMP    0x5d01 ; JUMP
005CC3  F6 87 59 40 80        TEST   byte ptr [bx + 0x4059], 0x80 ; LOGIC
005CC8  74 37                 JE     0x5d01 ; CJUMP
005CCA  80 A7 59 40 FB        AND    byte ptr [bx + 0x4059], 0xfb ; LOGIC
005CCF  56                    PUSH   si ; STACK_PUSH
005CD0  57                    PUSH   di ; STACK_PUSH
005CD1  FC                    CLD ; FLAG
005CD2  8B F2                 MOV    si, dx ; MOV
005CD4  8B FA                 MOV    di, dx ; MOV
005CD6  8B C8                 MOV    cx, ax ; MOV
005CD8  E3 25                 JCXZ   0x5cff ; CJUMP
005CDA  B4 0D                 MOV    ah, 0xd ; CONST_LOAD
005CDC  80 3C 0A              CMP    byte ptr [si], 0xa ; CMP
005CDF  75 05                 JNE    0x5ce6 ; CJUMP
005CE1  80 8F 59 40 04        OR     byte ptr [bx + 0x4059], 4 ; LOGIC
005CE6  AC                    LODSB  al, byte ptr [si] ; STR
005CE7  3A C4                 CMP    al, ah ; CMP
005CE9  74 19                 JE     0x5d04 ; CJUMP
005CEB  3C 1A                 CMP    al, 0x1a ; CMP
005CED  75 07                 JNE    0x5cf6 ; CJUMP
005CEF  80 8F 59 40 02        OR     byte ptr [bx + 0x4059], 2 ; LOGIC
005CF4  EB 05                 JMP    0x5cfb ; JUMP
005CF6  88 05                 MOV    byte ptr [di], al ; MOV
005CF8  47                    INC    di ; ARITH
005CF9  E2 EB                 LOOP   0x5ce6 ; CJUMP
005CFB  8B C7                 MOV    ax, di ; MOV
005CFD  2B C2                 SUB    ax, dx ; ARITH
005CFF  5F                    POP    di ; STACK_POP
005D00  5E                    POP    si ; STACK_POP
