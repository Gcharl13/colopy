; ============================================================================
; func_010B26_unknown
; Region   : load_image
; Bytes    : file 0x010B26..0x010BBB  (149 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010B26  55                    PUSH   bp ; STACK_PUSH
010B27  8B EC                 MOV    bp, sp ; MOV
010B29  56                    PUSH   si ; STACK_PUSH
010B2A  57                    PUSH   di ; STACK_PUSH
010B2B  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
010B2E  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
010B31  A8 83                 TEST   al, 0x83 ; LOGIC
010B33  74 59                 JE     0x10b8e ; CJUMP
010B35  A8 40                 TEST   al, 0x40 ; LOGIC
010B37  75 55                 JNE    0x10b8e ; CJUMP
010B39  A8 02                 TEST   al, 2 ; LOGIC
010B3B  75 42                 JNE    0x10b7f ; CJUMP
010B3D  0C 01                 OR     al, 1 ; LOGIC
010B3F  88 44 06              MOV    byte ptr [si + 6], al ; MOV
010B42  8B FE                 MOV    di, si ; MOV
010B44  81 EF 0E 29           SUB    di, 0x290e ; ARITH
010B48  81 C7 AE 29           ADD    di, 0x29ae ; ARITH
010B4C  A8 0C                 TEST   al, 0xc ; LOGIC
010B4E  75 0A                 JNE    0x10b5a ; CJUMP
010B50  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
010B53  75 05                 JNE    0x10b5a ; CJUMP
010B55  56                    PUSH   si ; STACK_PUSH
010B56  E8 79 11              CALL   0x11cd2 ; CALL_NEAR
010B59  58                    POP    ax ; STACK_POP
010B5A  8B 44 04              MOV    ax, word ptr [si + 4] ; MOV
010B5D  89 04                 MOV    word ptr [si], ax ; MOV
010B5F  FF 75 02              PUSH   word ptr [di + 2] ; STACK_PUSH
010B62  50                    PUSH   ax ; STACK_PUSH
010B63  33 DB                 XOR    bx, bx ; LOGIC
010B65  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
010B68  53                    PUSH   bx ; STACK_PUSH
010B69  0E                    PUSH   cs ; STACK_PUSH
010B6A  E8 77 09              CALL   0x114e4 ; CALL_NEAR
010B6D  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
010B70  0B C0                 OR     ax, ax ; LOGIC
010B72  74 11                 JE     0x10b85 ; CJUMP
010B74  3D FF FF              CMP    ax, 0xffff ; CMP
010B77  75 1A                 JNE    0x10b93 ; CJUMP
010B79  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
010B7D  EB 0A                 JMP    0x10b89 ; JUMP
010B7F  80 4C 06 20           OR     byte ptr [si + 6], 0x20 ; LOGIC
010B83  EB 09                 JMP    0x10b8e ; JUMP
010B85  80 4C 06 10           OR     byte ptr [si + 6], 0x10 ; LOGIC
010B89  C7 44 02 00 00        MOV    word ptr [si + 2], 0 ; MOV
010B8E  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
010B91  EB 24                 JMP    0x10bb7 ; JUMP
010B93  8A BF BB 27           MOV    bh, byte ptr [bx + 0x27bb] ; MOV
010B97  80 E7 82              AND    bh, 0x82 ; LOGIC
010B9A  80 FF 82              CMP    bh, 0x82 ; CMP
010B9D  75 0B                 JNE    0x10baa ; CJUMP
010B9F  8A 7C 06              MOV    bh, byte ptr [si + 6] ; MOV
010BA2  F6 C7 82              TEST   bh, 0x82 ; LOGIC
010BA5  75 03                 JNE    0x10baa ; CJUMP
010BA7  80 0D 20              OR     byte ptr [di], 0x20 ; LOGIC
010BAA  48                    DEC    ax ; ARITH
010BAB  89 44 02              MOV    word ptr [si + 2], ax ; MOV
010BAE  8B 1C                 MOV    bx, word ptr [si] ; MOV
010BB0  33 C0                 XOR    ax, ax ; LOGIC
010BB2  8A 07                 MOV    al, byte ptr [bx] ; MOV
010BB4  43                    INC    bx ; ARITH
010BB5  89 1C                 MOV    word ptr [si], bx ; MOV
010BB7  5F                    POP    di ; STACK_POP
010BB8  5E                    POP    si ; STACK_POP
010BB9  5D                    POP    bp ; STACK_POP
010BBA  CB                    RETF ; RETURN
