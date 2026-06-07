; ============================================================================
; func_016ACC_unknown
; Region   : load_image
; Bytes    : file 0x016ACC..0x016B49  (125 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016ACC  55                    PUSH   bp ; STACK_PUSH
016ACD  8B EC                 MOV    bp, sp ; MOV
016ACF  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
016AD2  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
016AD5  3B 1E 75 45           CMP    bx, word ptr [0x4575] ; CMP
016AD9  72 06                 JB     0x16ae1 ; CJUMP
016ADB  F9                    STC ; FLAG
016ADC  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
016ADF  EB 68                 JMP    0x16b49 ; JUMP
016AE1  33 C0                 XOR    ax, ax ; LOGIC
016AE3  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
016AE6  E3 61                 JCXZ   0x16b49 ; CJUMP
016AE8  F6 87 77 45 02        TEST   byte ptr [bx + 0x4577], 2 ; LOGIC
016AED  75 5A                 JNE    0x16b49 ; CJUMP
016AEF  81 3E 96 48 D6 D6     CMP    word ptr [0x4896], 0xd6d6 ; CMP
016AF5  75 04                 JNE    0x16afb ; CJUMP
016AF7  FF 16 98 48           CALL   word ptr [0x4898] ; CALL_NEAR
016AFB  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
016AFE  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
016B01  B4 3F                 MOV    ah, 0x3f ; CONST_LOAD
016B03  CD 21                 INT    0x21 ; SYS
016B05  73 04                 JAE    0x16b0b ; CJUMP
016B07  B4 09                 MOV    ah, 9 ; MOV
016B09  EB 3E                 JMP    0x16b49 ; JUMP
016B0B  F6 87 77 45 80        TEST   byte ptr [bx + 0x4577], 0x80 ; LOGIC
016B10  74 37                 JE     0x16b49 ; CJUMP
016B12  80 A7 77 45 FB        AND    byte ptr [bx + 0x4577], 0xfb ; LOGIC
016B17  56                    PUSH   si ; STACK_PUSH
016B18  57                    PUSH   di ; STACK_PUSH
016B19  FC                    CLD ; FLAG
016B1A  8B F2                 MOV    si, dx ; MOV
016B1C  8B FA                 MOV    di, dx ; MOV
016B1E  8B C8                 MOV    cx, ax ; MOV
016B20  E3 25                 JCXZ   0x16b47 ; CJUMP
016B22  B4 0D                 MOV    ah, 0xd ; CONST_LOAD
016B24  80 3C 0A              CMP    byte ptr [si], 0xa ; CMP
016B27  75 05                 JNE    0x16b2e ; CJUMP
016B29  80 8F 77 45 04        OR     byte ptr [bx + 0x4577], 4 ; LOGIC
016B2E  AC                    LODSB  al, byte ptr [si] ; STR
016B2F  3A C4                 CMP    al, ah ; CMP
016B31  74 19                 JE     0x16b4c ; CJUMP
016B33  3C 1A                 CMP    al, 0x1a ; CMP
016B35  75 07                 JNE    0x16b3e ; CJUMP
016B37  80 8F 77 45 02        OR     byte ptr [bx + 0x4577], 2 ; LOGIC
016B3C  EB 05                 JMP    0x16b43 ; JUMP
016B3E  88 05                 MOV    byte ptr [di], al ; MOV
016B40  47                    INC    di ; ARITH
016B41  E2 EB                 LOOP   0x16b2e ; CJUMP
016B43  8B C7                 MOV    ax, di ; MOV
016B45  2B C2                 SUB    ax, dx ; ARITH
016B47  5F                    POP    di ; STACK_POP
016B48  5E                    POP    si ; STACK_POP
