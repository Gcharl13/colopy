; ============================================================================
; func_005684_unknown
; Region   : load_image
; Bytes    : file 0x005684..0x00570B  (135 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005684  55                    PUSH   bp ; STACK_PUSH
005685  8B EC                 MOV    bp, sp ; MOV
005687  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
00568A  56                    PUSH   si ; STACK_PUSH
00568B  57                    PUSH   di ; STACK_PUSH
00568C  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00568F  F7 66 0A              MUL    word ptr [bp + 0xa] ; ARITH
005692  8B C8                 MOV    cx, ax ; MOV
005694  E3 5D                 JCXZ   0x56f3 ; CJUMP
005696  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
005699  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00569C  8B 76 0C              MOV    si, word ptr [bp + 0xc] ; LOCAL_LOAD
00569F  BF 9E 44              MOV    di, 0x449e ; CONST_LOAD
0056A2  8B C6                 MOV    ax, si ; MOV
0056A4  2D FE 43              SUB    ax, 0x43fe ; ARITH
0056A7  03 F8                 ADD    di, ax ; ARITH
0056A9  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
0056AD  75 05                 JNE    0x56b4 ; CJUMP
0056AF  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
0056B2  74 05                 JE     0x56b9 ; CJUMP
0056B4  8B 45 02              MOV    ax, word ptr [di + 2] ; MOV
0056B7  EB 03                 JMP    0x56bc ; JUMP
0056B9  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
0056BC  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0056BF  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
0056C3  75 05                 JNE    0x56ca ; CJUMP
0056C5  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
0056C8  74 2F                 JE     0x56f9 ; CJUMP
0056CA  8B 44 02              MOV    ax, word ptr [si + 2] ; MOV
0056CD  0B C0                 OR     ax, ax ; LOGIC
0056CF  74 28                 JE     0x56f9 ; CJUMP
0056D1  3B C1                 CMP    ax, cx ; CMP
0056D3  76 02                 JBE    0x56d7 ; CJUMP
0056D5  8B C1                 MOV    ax, cx ; MOV
0056D7  50                    PUSH   ax ; STACK_PUSH
0056D8  53                    PUSH   bx ; STACK_PUSH
0056D9  51                    PUSH   cx ; STACK_PUSH
0056DA  50                    PUSH   ax ; STACK_PUSH
0056DB  FF 34                 PUSH   word ptr [si] ; STACK_PUSH
0056DD  53                    PUSH   bx ; STACK_PUSH
0056DE  0E                    PUSH   cs ; STACK_PUSH
0056DF  E8 42 19              CALL   0x7024 ; CALL_NEAR
0056E2  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0056E5  59                    POP    cx ; STACK_POP
0056E6  5B                    POP    bx ; STACK_POP
0056E7  58                    POP    ax ; STACK_POP
0056E8  2B C8                 SUB    cx, ax ; ARITH
0056EA  29 44 02              SUB    word ptr [si + 2], ax ; ARITH
0056ED  03 D8                 ADD    bx, ax ; ARITH
0056EF  01 04                 ADD    word ptr [si], ax ; ARITH
0056F1  EB 02                 JMP    0x56f5 ; JUMP
0056F3  EB 6C                 JMP    0x5761 ; JUMP
0056F5  E3 59                 JCXZ   0x5750 ; CJUMP
0056F7  EB C6                 JMP    0x56bf ; JUMP
0056F9  3B 4E FC              CMP    cx, word ptr [bp - 4] ; CMP
0056FC  72 2D                 JB     0x572b ; CJUMP
0056FE  33 D2                 XOR    dx, dx ; LOGIC
005700  8B C1                 MOV    ax, cx ; MOV
005702  F7 76 FC              DIV    word ptr [bp - 4] ; ARITH
005705  8B C1                 MOV    ax, cx ; MOV
005707  2B C2                 SUB    ax, dx ; ARITH
005709  53                    PUSH   bx ; STACK_PUSH
00570A  51                    PUSH   cx ; STACK_PUSH
