; ============================================================================
; func_015322_unknown
; Region   : load_image
; Bytes    : file 0x015322..0x0153C5  (163 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015322  55                    PUSH   bp ; STACK_PUSH
015323  8B EC                 MOV    bp, sp ; MOV
015325  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
015328  56                    PUSH   si ; STACK_PUSH
015329  57                    PUSH   di ; STACK_PUSH
01532A  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
01532D  F7 66 0A              MUL    word ptr [bp + 0xa] ; ARITH
015330  8B C8                 MOV    cx, ax ; MOV
015332  E3 5D                 JCXZ   0x15391 ; CJUMP
015334  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
015337  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
01533A  8B 76 0C              MOV    si, word ptr [bp + 0xc] ; LOCAL_LOAD
01533D  BF 66 47              MOV    di, 0x4766 ; CONST_LOAD
015340  8B C6                 MOV    ax, si ; MOV
015342  2D C6 46              SUB    ax, 0x46c6 ; ARITH
015345  03 F8                 ADD    di, ax ; ARITH
015347  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
01534B  75 05                 JNE    0x15352 ; CJUMP
01534D  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
015350  74 05                 JE     0x15357 ; CJUMP
015352  8B 45 02              MOV    ax, word ptr [di + 2] ; MOV
015355  EB 03                 JMP    0x1535a ; JUMP
015357  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
01535A  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
01535D  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
015361  75 05                 JNE    0x15368 ; CJUMP
015363  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
015366  74 32                 JE     0x1539a ; CJUMP
015368  8B 44 02              MOV    ax, word ptr [si + 2] ; MOV
01536B  0B C0                 OR     ax, ax ; LOGIC
01536D  74 2B                 JE     0x1539a ; CJUMP
01536F  3B C1                 CMP    ax, cx ; CMP
015371  76 02                 JBE    0x15375 ; CJUMP
015373  8B C1                 MOV    ax, cx ; MOV
015375  50                    PUSH   ax ; STACK_PUSH
015376  53                    PUSH   bx ; STACK_PUSH
015377  51                    PUSH   cx ; STACK_PUSH
015378  50                    PUSH   ax ; STACK_PUSH
015379  53                    PUSH   bx ; STACK_PUSH
01537A  FF 34                 PUSH   word ptr [si] ; STACK_PUSH
01537C  0E                    PUSH   cs ; STACK_PUSH
01537D  E8 2C 1C              CALL   0x16fac ; CALL_NEAR
015380  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
015383  59                    POP    cx ; STACK_POP
015384  5B                    POP    bx ; STACK_POP
015385  58                    POP    ax ; STACK_POP
015386  2B C8                 SUB    cx, ax ; ARITH
015388  29 44 02              SUB    word ptr [si + 2], ax ; ARITH
01538B  03 D8                 ADD    bx, ax ; ARITH
01538D  01 04                 ADD    word ptr [si], ax ; ARITH
01538F  EB 03                 JMP    0x15394 ; JUMP
015391  E9 8D 00              JMP    0x15421 ; JUMP
015394  0B C9                 OR     cx, cx ; LOGIC
015396  75 C5                 JNE    0x1535d ; CJUMP
015398  EB 76                 JMP    0x15410 ; JUMP
01539A  3B 4E FC              CMP    cx, word ptr [bp - 4] ; CMP
01539D  72 48                 JB     0x153e7 ; CJUMP
01539F  F6 44 06 08           TEST   byte ptr [si + 6], 8 ; LOGIC
0153A3  75 05                 JNE    0x153aa ; CJUMP
0153A5  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
0153A8  74 0E                 JE     0x153b8 ; CJUMP
0153AA  53                    PUSH   bx ; STACK_PUSH
0153AB  51                    PUSH   cx ; STACK_PUSH
0153AC  56                    PUSH   si ; STACK_PUSH
0153AD  0E                    PUSH   cs ; STACK_PUSH
0153AE  E8 9D 10              CALL   0x1644e ; CALL_NEAR
0153B1  5A                    POP    dx ; STACK_POP
0153B2  59                    POP    cx ; STACK_POP
0153B3  5B                    POP    bx ; STACK_POP
0153B4  0B C0                 OR     ax, ax ; LOGIC
0153B6  75 58                 JNE    0x15410 ; CJUMP
0153B8  33 D2                 XOR    dx, dx ; LOGIC
0153BA  8B C1                 MOV    ax, cx ; MOV
0153BC  F7 76 FC              DIV    word ptr [bp - 4] ; ARITH
0153BF  8B C1                 MOV    ax, cx ; MOV
0153C1  2B C2                 SUB    ax, dx ; ARITH
0153C3  50                    PUSH   ax ; STACK_PUSH
0153C4  53                    PUSH   bx ; STACK_PUSH
