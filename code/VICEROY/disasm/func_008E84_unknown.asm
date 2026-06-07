; ============================================================================
; func_008E84_unknown
; Region   : load_image
; Bytes    : file 0x008E84..0x008EFC  (120 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008E84  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
008E88  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
008E8B  D1 E3                 SHL    bx, 1 ; LOGIC
008E8D  8B 87 C8 8D           MOV    ax, word ptr [bx - 0x7238] ; MOV
008E91  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
008E94  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
008E97  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
008E9A  0E                    PUSH   cs ; STACK_PUSH
008E9B  E8 FE FE              CALL   0x8d9c ; CALL_NEAR
008E9E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
008EA1  50                    PUSH   ax ; STACK_PUSH
008EA2  0E                    PUSH   cs ; STACK_PUSH
008EA3  E8 A8 F7              CALL   0x864e ; CALL_NEAR
008EA6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
008EA9  3D 02 00              CMP    ax, 2 ; CMP
008EAC  7E 0E                 JLE    0x8ebc ; CJUMP
008EAE  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
008EB1  D1 E0                 SHL    ax, 1 ; LOGIC
008EB3  B9 03 00              MOV    cx, 3 ; MOV
008EB6  99                    CDQ ; ARITH
008EB7  F7 F9                 IDIV   cx ; ARITH
008EB9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
008EBC  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
008EBF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
008EC2  0E                    PUSH   cs ; STACK_PUSH
008EC3  E8 80 FF              CALL   0x8e46 ; CALL_NEAR
008EC6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
008EC9  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
008ECC  D1 E3                 SHL    bx, 1 ; LOGIC
008ECE  83 BF 5A 8E 00        CMP    word ptr [bx - 0x71a6], 0 ; CMP
008ED3  74 2B                 JE     0x8f00 ; CJUMP
008ED5  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
008ED8  39 46 FA              CMP    word ptr [bp - 6], ax ; CMP
008EDB  74 23                 JE     0x8f00 ; CJUMP
008EDD  39 87 5A 8E           CMP    word ptr [bx - 0x71a6], ax ; CMP
008EE1  75 05                 JNE    0x8ee8 ; CJUMP
008EE3  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
008EE6  EB 14                 JMP    0x8efc ; JUMP
008EE8  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
008EEB  D1 E3                 SHL    bx, 1 ; LOGIC
008EED  8B 87 5A 8E           MOV    ax, word ptr [bx - 0x71a6] ; MOV
008EF1  8B C8                 MOV    cx, ax ; MOV
008EF3  D1 E0                 SHL    ax, 1 ; LOGIC
008EF5  03 C1                 ADD    ax, cx ; ARITH
008EF7  99                    CDQ ; ARITH
008EF8  2B C2                 SUB    ax, dx ; ARITH
008EFA  D1 F8                 SAR    ax, 1 ; LOGIC
