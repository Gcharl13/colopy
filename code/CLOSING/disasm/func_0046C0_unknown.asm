; ============================================================================
; func_0046C0_unknown
; Region   : load_image
; Bytes    : file 0x0046C0..0x004747  (135 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0046C0  55                    PUSH   bp ; STACK_PUSH
0046C1  8B EC                 MOV    bp, sp ; MOV
0046C3  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
0046C6  56                    PUSH   si ; STACK_PUSH
0046C7  57                    PUSH   di ; STACK_PUSH
0046C8  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0046CB  F7 66 0A              MUL    word ptr [bp + 0xa] ; ARITH
0046CE  8B C8                 MOV    cx, ax ; MOV
0046D0  E3 5D                 JCXZ   0x472f ; CJUMP
0046D2  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0046D5  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0046D8  8B 76 0C              MOV    si, word ptr [bp + 0xc] ; LOCAL_LOAD
0046DB  BF 48 42              MOV    di, 0x4248 ; CONST_LOAD
0046DE  8B C6                 MOV    ax, si ; MOV
0046E0  2D A8 41              SUB    ax, 0x41a8 ; ARITH
0046E3  03 F8                 ADD    di, ax ; ARITH
0046E5  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
0046E9  75 05                 JNE    0x46f0 ; CJUMP
0046EB  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
0046EE  74 05                 JE     0x46f5 ; CJUMP
0046F0  8B 45 02              MOV    ax, word ptr [di + 2] ; MOV
0046F3  EB 03                 JMP    0x46f8 ; JUMP
0046F5  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
0046F8  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0046FB  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
0046FF  75 05                 JNE    0x4706 ; CJUMP
004701  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
004704  74 2F                 JE     0x4735 ; CJUMP
004706  8B 44 02              MOV    ax, word ptr [si + 2] ; MOV
004709  0B C0                 OR     ax, ax ; LOGIC
00470B  74 28                 JE     0x4735 ; CJUMP
00470D  3B C1                 CMP    ax, cx ; CMP
00470F  76 02                 JBE    0x4713 ; CJUMP
004711  8B C1                 MOV    ax, cx ; MOV
004713  50                    PUSH   ax ; STACK_PUSH
004714  53                    PUSH   bx ; STACK_PUSH
004715  51                    PUSH   cx ; STACK_PUSH
004716  50                    PUSH   ax ; STACK_PUSH
004717  FF 34                 PUSH   word ptr [si] ; STACK_PUSH
004719  53                    PUSH   bx ; STACK_PUSH
00471A  0E                    PUSH   cs ; STACK_PUSH
00471B  E8 06 19              CALL   0x6024 ; CALL_NEAR
00471E  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
004721  59                    POP    cx ; STACK_POP
004722  5B                    POP    bx ; STACK_POP
004723  58                    POP    ax ; STACK_POP
004724  2B C8                 SUB    cx, ax ; ARITH
004726  29 44 02              SUB    word ptr [si + 2], ax ; ARITH
004729  03 D8                 ADD    bx, ax ; ARITH
00472B  01 04                 ADD    word ptr [si], ax ; ARITH
00472D  EB 02                 JMP    0x4731 ; JUMP
00472F  EB 6C                 JMP    0x479d ; JUMP
004731  E3 59                 JCXZ   0x478c ; CJUMP
004733  EB C6                 JMP    0x46fb ; JUMP
004735  3B 4E FC              CMP    cx, word ptr [bp - 4] ; CMP
004738  72 2D                 JB     0x4767 ; CJUMP
00473A  33 D2                 XOR    dx, dx ; LOGIC
00473C  8B C1                 MOV    ax, cx ; MOV
00473E  F7 76 FC              DIV    word ptr [bp - 4] ; ARITH
004741  8B C1                 MOV    ax, cx ; MOV
004743  2B C2                 SUB    ax, dx ; ARITH
004745  53                    PUSH   bx ; STACK_PUSH
004746  51                    PUSH   cx ; STACK_PUSH
