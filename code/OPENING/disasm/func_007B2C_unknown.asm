; ============================================================================
; func_007B2C_unknown
; Region   : load_image
; Bytes    : file 0x007B2C..0x007C94  (360 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007B2C  55                    PUSH   bp ; STACK_PUSH
007B2D  8B EC                 MOV    bp, sp ; MOV
007B2F  83 EC 0C              SUB    sp, 0xc ; STACK_ALLOC
007B32  57                    PUSH   di ; STACK_PUSH
007B33  56                    PUSH   si ; STACK_PUSH
007B34  2B F6                 SUB    si, si ; ARITH
007B36  39 76 08              CMP    word ptr [bp + 8], si ; CMP
007B39  75 06                 JNE    0x7b41 ; CJUMP
007B3B  A1 C7 42              MOV    ax, word ptr [0x42c7] ; GLOBAL_LOAD
007B3E  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
007B41  39 76 08              CMP    word ptr [bp + 8], si ; CMP
007B44  74 27                 JE     0x7b6d ; CJUMP
007B46  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
007B49  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
007B4C  EB 11                 JMP    0x7b5f ; JUMP
007B4E  83 46 FA 02           ADD    word ptr [bp - 6], 2 ; ARITH
007B52  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
007B54  9A 24 07 52 04        LCALL  0x452, 0x724 ; LCALL
007B59  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007B5C  40                    INC    ax ; ARITH
007B5D  03 F0                 ADD    si, ax ; ARITH
007B5F  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
007B62  83 3F 00              CMP    word ptr [bx], 0 ; CMP
007B65  74 06                 JE     0x7b6d ; CJUMP
007B67  81 FE FF 7F           CMP    si, 0x7fff ; CMP
007B6B  76 E1                 JBE    0x7b4e ; CJUMP
007B6D  83 3E 02 46 00        CMP    word ptr [0x4602], 0 ; CMP
007B72  74 1E                 JE     0x7b92 ; CJUMP
007B74  A1 AD 42              MOV    ax, word ptr [0x42ad] ; GLOBAL_LOAD
007B77  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
007B7A  EB 03                 JMP    0x7b7f ; JUMP
007B7C  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
007B7F  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
007B83  74 12                 JE     0x7b97 ; CJUMP
007B85  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
007B88  80 BF AE 42 00        CMP    byte ptr [bx + 0x42ae], 0 ; CMP
007B8D  75 08                 JNE    0x7b97 ; CJUMP
007B8F  EB EB                 JMP    0x7b7c ; JUMP
007B91  90                    NOP ; NOP
007B92  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
007B97  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
007B9B  74 0A                 JE     0x7ba7 ; CJUMP
007B9D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
007BA0  05 07 00              ADD    ax, 7 ; ARITH
007BA3  D1 E0                 SHL    ax, 1 ; LOGIC
007BA5  03 F0                 ADD    si, ax ; ARITH
007BA7  83 7E 10 00           CMP    word ptr [bp + 0x10], 0 ; CMP
007BAB  74 10                 JE     0x7bbd ; CJUMP
007BAD  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
007BB0  9A 24 07 52 04        LCALL  0x452, 0x724 ; LCALL
007BB5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007BB8  05 03 00              ADD    ax, 3 ; ARITH
007BBB  03 F0                 ADD    si, ax ; ARITH
007BBD  46                    INC    si ; ARITH
007BBE  89 76 F8              MOV    word ptr [bp - 8], si ; LOCAL_STORE
007BC1  81 FE FF 7F           CMP    si, 0x7fff ; CMP
007BC5  76 13                 JBE    0x7bda ; CJUMP
007BC7  C7 06 A0 42 07 00     MOV    word ptr [0x42a0], 7 ; GLOBAL_LOAD
007BCD  C7 06 AB 42 0A 00     MOV    word ptr [0x42ab], 0xa ; GLOBAL_LOAD
007BD3  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
007BD6  E9 C4 01              JMP    0x7d9d ; JUMP
007BD9  90                    NOP ; NOP
007BDA  8B 36 F0 45           MOV    si, word ptr [0x45f0] ; GLOBAL_LOAD
007BDE  C7 06 F0 45 10 00     MOV    word ptr [0x45f0], 0x10 ; GLOBAL_LOAD
007BE4  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
007BE7  05 0F 00              ADD    ax, 0xf ; ARITH
007BEA  50                    PUSH   ax ; STACK_PUSH
007BEB  9A 30 25 52 04        LCALL  0x452, 0x2530 ; LCALL
007BF0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007BF3  8B F8                 MOV    di, ax ; MOV
007BF5  0B FF                 OR     di, di ; LOGIC
007BF7  75 13                 JNE    0x7c0c ; CJUMP
007BF9  C7 06 A0 42 0C 00     MOV    word ptr [0x42a0], 0xc ; GLOBAL_LOAD
007BFF  C7 06 AB 42 08 00     MOV    word ptr [0x42ab], 8 ; GLOBAL_LOAD
007C05  89 36 F0 45           MOV    word ptr [0x45f0], si ; GLOBAL_LOAD
007C09  EB C8                 JMP    0x7bd3 ; JUMP
007C0B  90                    NOP ; NOP
007C0C  89 36 F0 45           MOV    word ptr [0x45f0], si ; GLOBAL_LOAD
007C10  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
007C13  89 3F                 MOV    word ptr [bx], di ; MOV
007C15  05 0F 00              ADD    ax, 0xf ; ARITH
007C18  24 F0                 AND    al, 0xf0 ; LOGIC
007C1A  8B F8                 MOV    di, ax ; MOV
007C1C  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
007C1F  89 3F                 MOV    word ptr [bx], di ; MOV
007C21  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
007C25  74 2F                 JE     0x7c56 ; CJUMP
007C27  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
007C2A  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
007C2D  EB 1F                 JMP    0x7c4e ; JUMP
007C2F  90                    NOP ; NOP
007C30  2B C0                 SUB    ax, ax ; ARITH
007C32  50                    PUSH   ax ; STACK_PUSH
007C33  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
007C35  57                    PUSH   di ; STACK_PUSH
007C36  9A C6 06 52 04        LCALL  0x452, 0x6c6 ; LCALL
007C3B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007C3E  50                    PUSH   ax ; STACK_PUSH
007C3F  9A 2E 0A 52 04        LCALL  0x452, 0xa2e ; LCALL
007C44  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007C47  40                    INC    ax ; ARITH
007C48  8B F8                 MOV    di, ax ; MOV
007C4A  83 46 FA 02           ADD    word ptr [bp - 6], 2 ; ARITH
007C4E  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
007C51  83 3F 00              CMP    word ptr [bx], 0 ; CMP
007C54  75 DA                 JNE    0x7c30 ; CJUMP
007C56  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
007C5A  74 49                 JE     0x7ca5 ; CJUMP
007C5C  2B C0                 SUB    ax, ax ; ARITH
007C5E  50                    PUSH   ax ; STACK_PUSH
007C5F  B8 84 42              MOV    ax, 0x4284 ; CONST_LOAD
007C62  50                    PUSH   ax ; STACK_PUSH
007C63  57                    PUSH   di ; STACK_PUSH
007C64  9A C6 06 52 04        LCALL  0x452, 0x6c6 ; LCALL
007C69  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007C6C  50                    PUSH   ax ; STACK_PUSH
007C6D  9A 2E 0A 52 04        LCALL  0x452, 0xa2e ; LCALL
007C72  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007C75  8B F8                 MOV    di, ax ; MOV
007C77  2B F6                 SUB    si, si ; ARITH
007C79  EB 1C                 JMP    0x7c97 ; JUMP
007C7B  90                    NOP ; NOP
007C7C  8A 84 AF 42           MOV    al, byte ptr [si + 0x42af] ; MOV
007C80  B1 04                 MOV    cl, 4 ; MOV
007C82  8B D0                 MOV    dx, ax ; MOV
007C84  D2 F8                 SAR    al, cl ; LOGIC
007C86  24 0F                 AND    al, 0xf ; LOGIC
007C88  04 41                 ADD    al, 0x41 ; ARITH
007C8A  88 05                 MOV    byte ptr [di], al ; MOV
007C8C  47                    INC    di ; ARITH
007C8D  80 E2 0F              AND    dl, 0xf ; LOGIC
007C90  80 C2 41              ADD    dl, 0x41 ; ARITH
007C93  88                    DB     0x88 ; DATA_BYTE
