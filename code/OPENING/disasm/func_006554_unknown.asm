; ============================================================================
; func_006554_unknown
; Region   : load_image
; Bytes    : file 0x006554..0x0065C7  (115 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006554  55                    PUSH   bp ; STACK_PUSH
006555  8B EC                 MOV    bp, sp ; MOV
006557  56                    PUSH   si ; STACK_PUSH
006558  57                    PUSH   di ; STACK_PUSH
006559  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
00655C  BB 40 45              MOV    bx, 0x4540 ; CONST_LOAD
00655F  81 FE 06 44           CMP    si, 0x4406 ; CMP
006563  74 12                 JE     0x6577 ; CJUMP
006565  BB 42 45              MOV    bx, 0x4542 ; CONST_LOAD
006568  81 FE 0E 44           CMP    si, 0x440e ; CMP
00656C  74 09                 JE     0x6577 ; CJUMP
00656E  BB 44 45              MOV    bx, 0x4544 ; CONST_LOAD
006571  81 FE 1E 44           CMP    si, 0x441e ; CMP
006575  75 4A                 JNE    0x65c1 ; CJUMP
006577  8B FE                 MOV    di, si ; MOV
006579  81 EF FE 43           SUB    di, 0x43fe ; ARITH
00657D  81 C7 9E 44           ADD    di, 0x449e ; ARITH
006581  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
006585  75 3A                 JNE    0x65c1 ; CJUMP
006587  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
00658A  75 35                 JNE    0x65c1 ; CJUMP
00658C  8B 07                 MOV    ax, word ptr [bx] ; MOV
00658E  0B C0                 OR     ax, ax ; LOGIC
006590  74 1B                 JE     0x65ad ; CJUMP
006592  89 44 04              MOV    word ptr [si + 4], ax ; MOV
006595  89 04                 MOV    word ptr [si], ax ; MOV
006597  C7 44 02 00 02        MOV    word ptr [si + 2], 0x200 ; CONST_LOAD
00659C  C7 45 02 00 02        MOV    word ptr [di + 2], 0x200 ; CONST_LOAD
0065A1  80 4C 06 02           OR     byte ptr [si + 6], 2 ; LOGIC
0065A5  C6 05 11              MOV    byte ptr [di], 0x11 ; CONST_LOAD
0065A8  B8 01 00              MOV    ax, 1 ; MOV
0065AB  EB 16                 JMP    0x65c3 ; JUMP
0065AD  53                    PUSH   bx ; STACK_PUSH
0065AE  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
0065B1  50                    PUSH   ax ; STACK_PUSH
0065B2  9A 30 25 52 04        LCALL  0x452, 0x2530 ; LCALL
0065B7  5B                    POP    bx ; STACK_POP
0065B8  5B                    POP    bx ; STACK_POP
0065B9  0B C0                 OR     ax, ax ; LOGIC
0065BB  74 04                 JE     0x65c1 ; CJUMP
0065BD  89 07                 MOV    word ptr [bx], ax ; MOV
0065BF  EB D1                 JMP    0x6592 ; JUMP
0065C1  33 C0                 XOR    ax, ax ; LOGIC
0065C3  5F                    POP    di ; STACK_POP
0065C4  5E                    POP    si ; STACK_POP
0065C5  5D                    POP    bp ; STACK_POP
0065C6  C3                    RET ; RETURN
