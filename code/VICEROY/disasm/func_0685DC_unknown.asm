; ============================================================================
; func_0685DC_unknown
; Region   : overlay
; Bytes    : file 0x0685DC..0x068674  (152 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0685DC  C8 28 00 00           ENTER  0x28, 0 ; PROLOGUE
0685E0  53                    PUSH   bx ; STACK_PUSH
0685E1  52                    PUSH   dx ; STACK_PUSH
0685E2  50                    PUSH   ax ; STACK_PUSH
0685E3  56                    PUSH   si ; STACK_PUSH
0685E4  C7 46 E2 00 00        MOV    word ptr [bp - 0x1e], 0 ; LOCAL_STORE
0685E9  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0685ED  7C 0F                 JL     0x685fe ; CJUMP
0685EF  8A 4E 06              MOV    cl, byte ptr [bp + 6] ; LOCAL_LOAD
0685F2  80 C1 04              ADD    cl, 4 ; ARITH
0685F5  B0 01                 MOV    al, 1 ; MOV
0685F7  D2 E0                 SHL    al, cl ; LOGIC
0685F9  A2 9E A8              MOV    byte ptr [0xa89e], al ; GLOBAL_LOAD
0685FC  EB 05                 JMP    0x68603 ; JUMP
0685FE  C6 06 9E A8 00        MOV    byte ptr [0xa89e], 0 ; GLOBAL_LOAD
068603  0E                    PUSH   cs ; STACK_PUSH
068604  E8 63 03              CALL   0x6896a ; CALL_NEAR
068607  8B 46 D2              MOV    ax, word ptr [bp - 0x2e] ; LOCAL_LOAD
06860A  39 06 04 88           CMP    word ptr [0x8804], ax ; CMP
06860E  7D 03                 JGE    0x68613 ; CJUMP
068610  E9 7F 02              JMP    0x68892 ; JUMP
068613  8B 46 D4              MOV    ax, word ptr [bp - 0x2c] ; LOCAL_LOAD
068616  39 06 06 88           CMP    word ptr [0x8806], ax ; CMP
06861A  7D 03                 JGE    0x6861f ; CJUMP
06861C  E9 73 02              JMP    0x68892 ; JUMP
06861F  8B 46 D6              MOV    ax, word ptr [bp - 0x2a] ; LOCAL_LOAD
068622  03 46 D2              ADD    ax, word ptr [bp - 0x2e] ; ARITH
068625  48                    DEC    ax ; ARITH
068626  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
068629  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
06862C  03 46 D4              ADD    ax, word ptr [bp - 0x2c] ; ARITH
06862F  48                    DEC    ax ; ARITH
068630  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
068633  8B 46 E4              MOV    ax, word ptr [bp - 0x1c] ; LOCAL_LOAD
068636  3B 06 04 88           CMP    ax, word ptr [0x8804] ; CMP
06863A  7E 03                 JLE    0x6863f ; CJUMP
06863C  A1 04 88              MOV    ax, word ptr [0x8804] ; GLOBAL_LOAD
06863F  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
068642  8B 4E D2              MOV    cx, word ptr [bp - 0x2e] ; LOCAL_LOAD
068645  3B 0E 28 83           CMP    cx, word ptr [0x8328] ; CMP
068649  7D 04                 JGE    0x6864f ; CJUMP
06864B  8B 0E 28 83           MOV    cx, word ptr [0x8328] ; GLOBAL_LOAD
06864F  89 4E D2              MOV    word ptr [bp - 0x2e], cx ; LOCAL_STORE
068652  A1 06 88              MOV    ax, word ptr [0x8806] ; GLOBAL_LOAD
068655  3B 46 DE              CMP    ax, word ptr [bp - 0x22] ; CMP
068658  7E 03                 JLE    0x6865d ; CJUMP
06865A  8B 46 DE              MOV    ax, word ptr [bp - 0x22] ; LOCAL_LOAD
06865D  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
068660  8B 56 D4              MOV    dx, word ptr [bp - 0x2c] ; LOCAL_LOAD
068663  3B 16 2E 83           CMP    dx, word ptr [0x832e] ; CMP
068667  7D 04                 JGE    0x6866d ; CJUMP
068669  8B 16 2E 83           MOV    dx, word ptr [0x832e] ; GLOBAL_LOAD
06866D  89 56 D4              MOV    word ptr [bp - 0x2c], dx ; LOCAL_STORE
068670  2B C2                 SUB    ax, dx ; ARITH
068672  40                    INC    ax ; ARITH
068673  89                    DB     0x89 ; DATA_BYTE
