; ============================================================================
; func_006B3A_unknown
; Region   : load_image
; Bytes    : file 0x006B3A..0x006CA2  (360 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006B3A  55                    PUSH   bp ; STACK_PUSH
006B3B  8B EC                 MOV    bp, sp ; MOV
006B3D  83 EC 0C              SUB    sp, 0xc ; STACK_ALLOC
006B40  57                    PUSH   di ; STACK_PUSH
006B41  56                    PUSH   si ; STACK_PUSH
006B42  2B F6                 SUB    si, si ; ARITH
006B44  39 76 08              CMP    word ptr [bp + 8], si ; CMP
006B47  75 06                 JNE    0x6b4f ; CJUMP
006B49  A1 71 40              MOV    ax, word ptr [0x4071] ; GLOBAL_LOAD
006B4C  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
006B4F  39 76 08              CMP    word ptr [bp + 8], si ; CMP
006B52  74 27                 JE     0x6b7b ; CJUMP
006B54  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
006B57  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
006B5A  EB 11                 JMP    0x6b6d ; JUMP
006B5C  83 46 FA 02           ADD    word ptr [bp - 6], 2 ; ARITH
006B60  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
006B62  9A B0 06 7D 03        LCALL  0x37d, 0x6b0 ; LCALL
006B67  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006B6A  40                    INC    ax ; ARITH
006B6B  03 F0                 ADD    si, ax ; ARITH
006B6D  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
006B70  83 3F 00              CMP    word ptr [bx], 0 ; CMP
006B73  74 06                 JE     0x6b7b ; CJUMP
006B75  81 FE FF 7F           CMP    si, 0x7fff ; CMP
006B79  76 E1                 JBE    0x6b5c ; CJUMP
006B7B  83 3E AC 43 00        CMP    word ptr [0x43ac], 0 ; CMP
006B80  74 1E                 JE     0x6ba0 ; CJUMP
006B82  A1 57 40              MOV    ax, word ptr [0x4057] ; GLOBAL_LOAD
006B85  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
006B88  EB 03                 JMP    0x6b8d ; JUMP
006B8A  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
006B8D  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
006B91  74 12                 JE     0x6ba5 ; CJUMP
006B93  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
006B96  80 BF 58 40 00        CMP    byte ptr [bx + 0x4058], 0 ; CMP
006B9B  75 08                 JNE    0x6ba5 ; CJUMP
006B9D  EB EB                 JMP    0x6b8a ; JUMP
006B9F  90                    NOP ; NOP
006BA0  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
006BA5  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
006BA9  74 0A                 JE     0x6bb5 ; CJUMP
006BAB  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
006BAE  05 07 00              ADD    ax, 7 ; ARITH
006BB1  D1 E0                 SHL    ax, 1 ; LOGIC
006BB3  03 F0                 ADD    si, ax ; ARITH
006BB5  83 7E 10 00           CMP    word ptr [bp + 0x10], 0 ; CMP
006BB9  74 10                 JE     0x6bcb ; CJUMP
006BBB  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
006BBE  9A B0 06 7D 03        LCALL  0x37d, 0x6b0 ; LCALL
006BC3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006BC6  05 03 00              ADD    ax, 3 ; ARITH
006BC9  03 F0                 ADD    si, ax ; ARITH
006BCB  46                    INC    si ; ARITH
006BCC  89 76 F8              MOV    word ptr [bp - 8], si ; LOCAL_STORE
006BCF  81 FE FF 7F           CMP    si, 0x7fff ; CMP
006BD3  76 13                 JBE    0x6be8 ; CJUMP
006BD5  C7 06 4A 40 07 00     MOV    word ptr [0x404a], 7 ; GLOBAL_LOAD
006BDB  C7 06 55 40 0A 00     MOV    word ptr [0x4055], 0xa ; GLOBAL_LOAD
006BE1  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
006BE4  E9 C4 01              JMP    0x6dab ; JUMP
006BE7  90                    NOP ; NOP
006BE8  8B 36 9A 43           MOV    si, word ptr [0x439a] ; GLOBAL_LOAD
006BEC  C7 06 9A 43 10 00     MOV    word ptr [0x439a], 0x10 ; GLOBAL_LOAD
006BF2  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
006BF5  05 0F 00              ADD    ax, 0xf ; ARITH
006BF8  50                    PUSH   ax ; STACK_PUSH
006BF9  9A 8E 24 7D 03        LCALL  0x37d, 0x248e ; LCALL
006BFE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006C01  8B F8                 MOV    di, ax ; MOV
006C03  0B FF                 OR     di, di ; LOGIC
006C05  75 13                 JNE    0x6c1a ; CJUMP
006C07  C7 06 4A 40 0C 00     MOV    word ptr [0x404a], 0xc ; GLOBAL_LOAD
006C0D  C7 06 55 40 08 00     MOV    word ptr [0x4055], 8 ; GLOBAL_LOAD
006C13  89 36 9A 43           MOV    word ptr [0x439a], si ; GLOBAL_LOAD
006C17  EB C8                 JMP    0x6be1 ; JUMP
006C19  90                    NOP ; NOP
006C1A  89 36 9A 43           MOV    word ptr [0x439a], si ; GLOBAL_LOAD
006C1E  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
006C21  89 3F                 MOV    word ptr [bx], di ; MOV
006C23  05 0F 00              ADD    ax, 0xf ; ARITH
006C26  24 F0                 AND    al, 0xf0 ; LOGIC
006C28  8B F8                 MOV    di, ax ; MOV
006C2A  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
006C2D  89 3F                 MOV    word ptr [bx], di ; MOV
006C2F  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
006C33  74 2F                 JE     0x6c64 ; CJUMP
006C35  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
006C38  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
006C3B  EB 1F                 JMP    0x6c5c ; JUMP
006C3D  90                    NOP ; NOP
006C3E  2B C0                 SUB    ax, ax ; ARITH
006C40  50                    PUSH   ax ; STACK_PUSH
006C41  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
006C43  57                    PUSH   di ; STACK_PUSH
006C44  9A 52 06 7D 03        LCALL  0x37d, 0x652 ; LCALL
006C49  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006C4C  50                    PUSH   ax ; STACK_PUSH
006C4D  9A BA 09 7D 03        LCALL  0x37d, 0x9ba ; LCALL
006C52  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006C55  40                    INC    ax ; ARITH
006C56  8B F8                 MOV    di, ax ; MOV
006C58  83 46 FA 02           ADD    word ptr [bp - 6], 2 ; ARITH
006C5C  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
006C5F  83 3F 00              CMP    word ptr [bx], 0 ; CMP
006C62  75 DA                 JNE    0x6c3e ; CJUMP
006C64  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
006C68  74 49                 JE     0x6cb3 ; CJUMP
006C6A  2B C0                 SUB    ax, ax ; ARITH
006C6C  50                    PUSH   ax ; STACK_PUSH
006C6D  B8 2E 40              MOV    ax, 0x402e ; CONST_LOAD
006C70  50                    PUSH   ax ; STACK_PUSH
006C71  57                    PUSH   di ; STACK_PUSH
006C72  9A 52 06 7D 03        LCALL  0x37d, 0x652 ; LCALL
006C77  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006C7A  50                    PUSH   ax ; STACK_PUSH
006C7B  9A BA 09 7D 03        LCALL  0x37d, 0x9ba ; LCALL
006C80  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006C83  8B F8                 MOV    di, ax ; MOV
006C85  2B F6                 SUB    si, si ; ARITH
006C87  EB 1C                 JMP    0x6ca5 ; JUMP
006C89  90                    NOP ; NOP
006C8A  8A 84 59 40           MOV    al, byte ptr [si + 0x4059] ; MOV
006C8E  B1 04                 MOV    cl, 4 ; MOV
006C90  8B D0                 MOV    dx, ax ; MOV
006C92  D2 F8                 SAR    al, cl ; LOGIC
006C94  24 0F                 AND    al, 0xf ; LOGIC
006C96  04 41                 ADD    al, 0x41 ; ARITH
006C98  88 05                 MOV    byte ptr [di], al ; MOV
006C9A  47                    INC    di ; ARITH
006C9B  80 E2 0F              AND    dl, 0xf ; LOGIC
006C9E  80 C2 41              ADD    dl, 0x41 ; ARITH
006CA1  88                    DB     0x88 ; DATA_BYTE
