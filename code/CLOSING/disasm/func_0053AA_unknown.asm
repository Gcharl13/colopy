; ============================================================================
; func_0053AA_unknown
; Region   : load_image
; Bytes    : file 0x0053AA..0x00543F  (149 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0053AA  55                    PUSH   bp ; STACK_PUSH
0053AB  8B EC                 MOV    bp, sp ; MOV
0053AD  56                    PUSH   si ; STACK_PUSH
0053AE  57                    PUSH   di ; STACK_PUSH
0053AF  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0053B2  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
0053B5  A8 83                 TEST   al, 0x83 ; LOGIC
0053B7  74 59                 JE     0x5412 ; CJUMP
0053B9  A8 40                 TEST   al, 0x40 ; LOGIC
0053BB  75 55                 JNE    0x5412 ; CJUMP
0053BD  A8 02                 TEST   al, 2 ; LOGIC
0053BF  75 42                 JNE    0x5403 ; CJUMP
0053C1  0C 01                 OR     al, 1 ; LOGIC
0053C3  88 44 06              MOV    byte ptr [si + 6], al ; MOV
0053C6  8B FE                 MOV    di, si ; MOV
0053C8  81 EF A8 41           SUB    di, 0x41a8 ; ARITH
0053CC  81 C7 48 42           ADD    di, 0x4248 ; ARITH
0053D0  A8 0C                 TEST   al, 0xc ; LOGIC
0053D2  75 0A                 JNE    0x53de ; CJUMP
0053D4  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
0053D7  75 05                 JNE    0x53de ; CJUMP
0053D9  56                    PUSH   si ; STACK_PUSH
0053DA  E8 41 0F              CALL   0x631e ; CALL_NEAR
0053DD  58                    POP    ax ; STACK_POP
0053DE  8B 44 04              MOV    ax, word ptr [si + 4] ; MOV
0053E1  89 04                 MOV    word ptr [si], ax ; MOV
0053E3  FF 75 02              PUSH   word ptr [di + 2] ; STACK_PUSH
0053E6  50                    PUSH   ax ; STACK_PUSH
0053E7  33 DB                 XOR    bx, bx ; LOGIC
0053E9  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
0053EC  53                    PUSH   bx ; STACK_PUSH
0053ED  0E                    PUSH   cs ; STACK_PUSH
0053EE  E8 93 08              CALL   0x5c84 ; CALL_NEAR
0053F1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0053F4  0B C0                 OR     ax, ax ; LOGIC
0053F6  74 11                 JE     0x5409 ; CJUMP
0053F8  3D FF FF              CMP    ax, 0xffff ; CMP
0053FB  75 1A                 JNE    0x5417 ; CJUMP
0053FD  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
005401  EB 0A                 JMP    0x540d ; JUMP
005403  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
005407  EB 09                 JMP    0x5412 ; JUMP
005409  80 4C 06 10           OR     byte ptr [si + 6], 0x10 ; LOGIC
00540D  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
005412  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
005415  EB 24                 JMP    0x543b ; JUMP
005417  8A BF 59 40           MOV    bh, byte ptr [bx + 0x4059] ; MOV
00541B  80 E7 82              AND    bh, 0x82 ; LOGIC
00541E  80 FF 82              CMP    bh, 0x82 ; CMP
005421  75 0B                 JNE    0x542e ; CJUMP
005423  8A 7C 06              MOV    bh, byte ptr [si + 6] ; MOV
005426  F6 C7 82              TEST   bh, 0x82 ; LOGIC
005429  75 03                 JNE    0x542e ; CJUMP
00542B  80 0D 20              OR     byte ptr [di], 0x20 ; LOGIC
00542E  48                    DEC    ax ; ARITH
00542F  89 44 02              MOV    word ptr [si + 2], ax ; MOV
005432  8B 1C                 MOV    bx, word ptr [si] ; MOV
005434  33 C0                 XOR    ax, ax ; LOGIC
005436  8A 07                 MOV    al, byte ptr [bx] ; MOV
005438  43                    INC    bx ; ARITH
005439  89 1C                 MOV    word ptr [si], bx ; MOV
00543B  5F                    POP    di ; STACK_POP
00543C  5E                    POP    si ; STACK_POP
00543D  5D                    POP    bp ; STACK_POP
00543E  CB                    RETF ; RETURN
