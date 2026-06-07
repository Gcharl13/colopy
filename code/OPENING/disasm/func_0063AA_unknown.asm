; ============================================================================
; func_0063AA_unknown
; Region   : load_image
; Bytes    : file 0x0063AA..0x00643F  (149 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0063AA  55                    PUSH   bp ; STACK_PUSH
0063AB  8B EC                 MOV    bp, sp ; MOV
0063AD  56                    PUSH   si ; STACK_PUSH
0063AE  57                    PUSH   di ; STACK_PUSH
0063AF  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0063B2  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
0063B5  A8 83                 TEST   al, 0x83 ; LOGIC
0063B7  74 59                 JE     0x6412 ; CJUMP
0063B9  A8 40                 TEST   al, 0x40 ; LOGIC
0063BB  75 55                 JNE    0x6412 ; CJUMP
0063BD  A8 02                 TEST   al, 2 ; LOGIC
0063BF  75 42                 JNE    0x6403 ; CJUMP
0063C1  0C 01                 OR     al, 1 ; LOGIC
0063C3  88 44 06              MOV    byte ptr [si + 6], al ; MOV
0063C6  8B FE                 MOV    di, si ; MOV
0063C8  81 EF FE 43           SUB    di, 0x43fe ; ARITH
0063CC  81 C7 9E 44           ADD    di, 0x449e ; ARITH
0063D0  A8 0C                 TEST   al, 0xc ; LOGIC
0063D2  75 0A                 JNE    0x63de ; CJUMP
0063D4  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
0063D7  75 05                 JNE    0x63de ; CJUMP
0063D9  56                    PUSH   si ; STACK_PUSH
0063DA  E8 33 0F              CALL   0x7310 ; CALL_NEAR
0063DD  58                    POP    ax ; STACK_POP
0063DE  8B 44 04              MOV    ax, word ptr [si + 4] ; MOV
0063E1  89 04                 MOV    word ptr [si], ax ; MOV
0063E3  FF 75 02              PUSH   word ptr [di + 2] ; STACK_PUSH
0063E6  50                    PUSH   ax ; STACK_PUSH
0063E7  33 DB                 XOR    bx, bx ; LOGIC
0063E9  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
0063EC  53                    PUSH   bx ; STACK_PUSH
0063ED  0E                    PUSH   cs ; STACK_PUSH
0063EE  E8 93 08              CALL   0x6c84 ; CALL_NEAR
0063F1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0063F4  0B C0                 OR     ax, ax ; LOGIC
0063F6  74 11                 JE     0x6409 ; CJUMP
0063F8  3D FF FF              CMP    ax, 0xffff ; CMP
0063FB  75 1A                 JNE    0x6417 ; CJUMP
0063FD  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
006401  EB 0A                 JMP    0x640d ; JUMP
006403  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
006407  EB 09                 JMP    0x6412 ; JUMP
006409  80 4C 06 10           OR     byte ptr [si + 6], 0x10 ; LOGIC
00640D  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
006412  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
006415  EB 24                 JMP    0x643b ; JUMP
006417  8A BF AF 42           MOV    bh, byte ptr [bx + 0x42af] ; MOV
00641B  80 E7 82              AND    bh, 0x82 ; LOGIC
00641E  80 FF 82              CMP    bh, 0x82 ; CMP
006421  75 0B                 JNE    0x642e ; CJUMP
006423  8A 7C 06              MOV    bh, byte ptr [si + 6] ; MOV
006426  F6 C7 82              TEST   bh, 0x82 ; LOGIC
006429  75 03                 JNE    0x642e ; CJUMP
00642B  80 0D 20              OR     byte ptr [di], 0x20 ; LOGIC
00642E  48                    DEC    ax ; ARITH
00642F  89 44 02              MOV    word ptr [si + 2], ax ; MOV
006432  8B 1C                 MOV    bx, word ptr [si] ; MOV
006434  33 C0                 XOR    ax, ax ; LOGIC
006436  8A 07                 MOV    al, byte ptr [bx] ; MOV
006438  43                    INC    bx ; ARITH
006439  89 1C                 MOV    word ptr [si], bx ; MOV
00643B  5F                    POP    di ; STACK_POP
00643C  5E                    POP    si ; STACK_POP
00643D  5D                    POP    bp ; STACK_POP
00643E  CB                    RETF ; RETURN
