; ============================================================================
; func_01523E_unknown
; Region   : load_image
; Bytes    : file 0x01523E..0x0152C5  (135 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01523E  55                    PUSH   bp ; STACK_PUSH
01523F  8B EC                 MOV    bp, sp ; MOV
015241  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
015244  56                    PUSH   si ; STACK_PUSH
015245  57                    PUSH   di ; STACK_PUSH
015246  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
015249  F7 66 0A              MUL    word ptr [bp + 0xa] ; ARITH
01524C  8B C8                 MOV    cx, ax ; MOV
01524E  E3 5D                 JCXZ   0x152ad ; CJUMP
015250  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
015253  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
015256  8B 76 0C              MOV    si, word ptr [bp + 0xc] ; LOCAL_LOAD
015259  BF 66 47              MOV    di, 0x4766 ; CONST_LOAD
01525C  8B C6                 MOV    ax, si ; MOV
01525E  2D C6 46              SUB    ax, 0x46c6 ; ARITH
015261  03 F8                 ADD    di, ax ; ARITH
015263  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
015267  75 05                 JNE    0x1526e ; CJUMP
015269  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
01526C  74 05                 JE     0x15273 ; CJUMP
01526E  8B 45 02              MOV    ax, word ptr [di + 2] ; MOV
015271  EB 03                 JMP    0x15276 ; JUMP
015273  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
015276  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
015279  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
01527D  75 05                 JNE    0x15284 ; CJUMP
01527F  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
015282  74 2F                 JE     0x152b3 ; CJUMP
015284  8B 44 02              MOV    ax, word ptr [si + 2] ; MOV
015287  0B C0                 OR     ax, ax ; LOGIC
015289  74 28                 JE     0x152b3 ; CJUMP
01528B  3B C1                 CMP    ax, cx ; CMP
01528D  76 02                 JBE    0x15291 ; CJUMP
01528F  8B C1                 MOV    ax, cx ; MOV
015291  50                    PUSH   ax ; STACK_PUSH
015292  53                    PUSH   bx ; STACK_PUSH
015293  51                    PUSH   cx ; STACK_PUSH
015294  50                    PUSH   ax ; STACK_PUSH
015295  FF 34                 PUSH   word ptr [si] ; STACK_PUSH
015297  53                    PUSH   bx ; STACK_PUSH
015298  0E                    PUSH   cs ; STACK_PUSH
015299  E8 10 1D              CALL   0x16fac ; CALL_NEAR
01529C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
01529F  59                    POP    cx ; STACK_POP
0152A0  5B                    POP    bx ; STACK_POP
0152A1  58                    POP    ax ; STACK_POP
0152A2  2B C8                 SUB    cx, ax ; ARITH
0152A4  29 44 02              SUB    word ptr [si + 2], ax ; ARITH
0152A7  03 D8                 ADD    bx, ax ; ARITH
0152A9  01 04                 ADD    word ptr [si], ax ; ARITH
0152AB  EB 02                 JMP    0x152af ; JUMP
0152AD  EB 6C                 JMP    0x1531b ; JUMP
0152AF  E3 59                 JCXZ   0x1530a ; CJUMP
0152B1  EB C6                 JMP    0x15279 ; JUMP
0152B3  3B 4E FC              CMP    cx, word ptr [bp - 4] ; CMP
0152B6  72 2D                 JB     0x152e5 ; CJUMP
0152B8  33 D2                 XOR    dx, dx ; LOGIC
0152BA  8B C1                 MOV    ax, cx ; MOV
0152BC  F7 76 FC              DIV    word ptr [bp - 4] ; ARITH
0152BF  8B C1                 MOV    ax, cx ; MOV
0152C1  2B C2                 SUB    ax, dx ; ARITH
0152C3  53                    PUSH   bx ; STACK_PUSH
0152C4  51                    PUSH   cx ; STACK_PUSH
