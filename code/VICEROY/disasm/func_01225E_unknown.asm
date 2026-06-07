; ============================================================================
; func_01225E_unknown
; Region   : load_image
; Bytes    : file 0x01225E..0x0123C6  (360 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01225E  55                    PUSH   bp ; STACK_PUSH
01225F  8B EC                 MOV    bp, sp ; MOV
012261  83 EC 0C              SUB    sp, 0xc ; STACK_ALLOC
012264  57                    PUSH   di ; STACK_PUSH
012265  56                    PUSH   si ; STACK_PUSH
012266  2B F6                 SUB    si, si ; ARITH
012268  39 76 08              CMP    word ptr [bp + 8], si ; CMP
01226B  75 06                 JNE    0x12273 ; CJUMP
01226D  A1 D3 27              MOV    ax, word ptr [0x27d3] ; GLOBAL_LOAD
012270  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
012273  39 76 08              CMP    word ptr [bp + 8], si ; CMP
012276  74 27                 JE     0x1229f ; CJUMP
012278  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
01227B  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
01227E  EB 11                 JMP    0x12291 ; JUMP
012280  83 46 FA 02           ADD    word ptr [bp - 6], 2 ; ARITH
012284  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
012286  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
01228B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
01228E  40                    INC    ax ; ARITH
01228F  03 F0                 ADD    si, ax ; ARITH
012291  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
012294  83 3F 00              CMP    word ptr [bx], 0 ; CMP
012297  74 06                 JE     0x1229f ; CJUMP
012299  81 FE FF 7F           CMP    si, 0x7fff ; CMP
01229D  76 E1                 JBE    0x12280 ; CJUMP
01229F  83 3E 12 2B 00        CMP    word ptr [0x2b12], 0 ; CMP
0122A4  74 1E                 JE     0x122c4 ; CJUMP
0122A6  A1 B9 27              MOV    ax, word ptr [0x27b9] ; GLOBAL_LOAD
0122A9  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0122AC  EB 03                 JMP    0x122b1 ; JUMP
0122AE  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
0122B1  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0122B5  74 12                 JE     0x122c9 ; CJUMP
0122B7  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
0122BA  80 BF BA 27 00        CMP    byte ptr [bx + 0x27ba], 0 ; CMP
0122BF  75 08                 JNE    0x122c9 ; CJUMP
0122C1  EB EB                 JMP    0x122ae ; JUMP
0122C3  90                    NOP ; NOP
0122C4  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0122C9  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0122CD  74 0A                 JE     0x122d9 ; CJUMP
0122CF  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0122D2  05 07 00              ADD    ax, 7 ; ARITH
0122D5  D1 E0                 SHL    ax, 1 ; LOGIC
0122D7  03 F0                 ADD    si, ax ; ARITH
0122D9  83 7E 10 00           CMP    word ptr [bp + 0x10], 0 ; CMP
0122DD  74 10                 JE     0x122ef ; CJUMP
0122DF  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
0122E2  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
0122E7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0122EA  05 03 00              ADD    ax, 3 ; ARITH
0122ED  03 F0                 ADD    si, ax ; ARITH
0122EF  46                    INC    si ; ARITH
0122F0  89 76 F8              MOV    word ptr [bp - 8], si ; LOCAL_STORE
0122F3  81 FE FF 7F           CMP    si, 0x7fff ; CMP
0122F7  76 13                 JBE    0x1230c ; CJUMP
0122F9  C7 06 AC 27 07 00     MOV    word ptr [0x27ac], 7 ; GLOBAL_LOAD
0122FF  C7 06 B7 27 0A 00     MOV    word ptr [0x27b7], 0xa ; GLOBAL_LOAD
012305  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
012308  E9 C4 01              JMP    0x124cf ; JUMP
01230B  90                    NOP ; NOP
01230C  8B 36 B8 2A           MOV    si, word ptr [0x2ab8] ; GLOBAL_LOAD
012310  C7 06 B8 2A 10 00     MOV    word ptr [0x2ab8], 0x10 ; GLOBAL_LOAD
012316  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
012319  05 0F 00              ADD    ax, 0xf ; ARITH
01231C  50                    PUSH   ax ; STACK_PUSH
01231D  9A 16 29 1D 0D        LCALL  0xd1d, 0x2916 ; LCALL
012322  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
012325  8B F8                 MOV    di, ax ; MOV
012327  0B FF                 OR     di, di ; LOGIC
012329  75 13                 JNE    0x1233e ; CJUMP
01232B  C7 06 AC 27 0C 00     MOV    word ptr [0x27ac], 0xc ; GLOBAL_LOAD
012331  C7 06 B7 27 08 00     MOV    word ptr [0x27b7], 8 ; GLOBAL_LOAD
012337  89 36 B8 2A           MOV    word ptr [0x2ab8], si ; GLOBAL_LOAD
01233B  EB C8                 JMP    0x12305 ; JUMP
01233D  90                    NOP ; NOP
01233E  89 36 B8 2A           MOV    word ptr [0x2ab8], si ; GLOBAL_LOAD
012342  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
012345  89 3F                 MOV    word ptr [bx], di ; MOV
012347  05 0F 00              ADD    ax, 0xf ; ARITH
01234A  24 F0                 AND    al, 0xf0 ; LOGIC
01234C  8B F8                 MOV    di, ax ; MOV
01234E  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
012351  89 3F                 MOV    word ptr [bx], di ; MOV
012353  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
012357  74 2F                 JE     0x12388 ; CJUMP
012359  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
01235C  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
01235F  EB 1F                 JMP    0x12380 ; JUMP
012361  90                    NOP ; NOP
012362  2B C0                 SUB    ax, ax ; ARITH
012364  50                    PUSH   ax ; STACK_PUSH
012365  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
012367  57                    PUSH   di ; STACK_PUSH
012368  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
01236D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
012370  50                    PUSH   ax ; STACK_PUSH
012371  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
012376  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
012379  40                    INC    ax ; ARITH
01237A  8B F8                 MOV    di, ax ; MOV
01237C  83 46 FA 02           ADD    word ptr [bp - 6], 2 ; ARITH
012380  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
012383  83 3F 00              CMP    word ptr [bx], 0 ; CMP
012386  75 DA                 JNE    0x12362 ; CJUMP
012388  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
01238C  74 49                 JE     0x123d7 ; CJUMP
01238E  2B C0                 SUB    ax, ax ; ARITH
012390  50                    PUSH   ax ; STACK_PUSH
012391  B8 90 27              MOV    ax, 0x2790 ; CONST_LOAD
012394  50                    PUSH   ax ; STACK_PUSH
012395  57                    PUSH   di ; STACK_PUSH
012396  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
01239B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
01239E  50                    PUSH   ax ; STACK_PUSH
01239F  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
0123A4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0123A7  8B F8                 MOV    di, ax ; MOV
0123A9  2B F6                 SUB    si, si ; ARITH
0123AB  EB 1C                 JMP    0x123c9 ; JUMP
0123AD  90                    NOP ; NOP
0123AE  8A 84 BB 27           MOV    al, byte ptr [si + 0x27bb] ; MOV
0123B2  B1 04                 MOV    cl, 4 ; MOV
0123B4  8B D0                 MOV    dx, ax ; MOV
0123B6  D2 F8                 SAR    al, cl ; LOGIC
0123B8  24 0F                 AND    al, 0xf ; LOGIC
0123BA  04 41                 ADD    al, 0x41 ; ARITH
0123BC  88 05                 MOV    byte ptr [di], al ; MOV
0123BE  47                    INC    di ; ARITH
0123BF  80 E2 0F              AND    dl, 0xf ; LOGIC
0123C2  80 C2 41              ADD    dl, 0x41 ; ARITH
0123C5  88                    DB     0x88 ; DATA_BYTE
