; ============================================================================
; func_0755CC_unknown
; Region   : overlay
; Bytes    : file 0x0755CC..0x0756B7  (235 bytes)
; Purpose  : AMER2.MP map loader  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "AMER2.MP"  (auto-named via string xrefs)
; ============================================================================

0755CC  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
0755D0  56                    PUSH   si ; STACK_PUSH
0755D1  68 66 21              PUSH   0x2166                       ; STRING: "AMER2.MP"
0755D4  68 54 85              PUSH   0x8554 ; PUSH_CONST
0755D7  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
0755DC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0755DF  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0755E2  A3 88 53              MOV    word ptr [0x5388], ax ; GLOBAL_LOAD
0755E5  C7 06 82 53 00 C6     MOV    word ptr [0x5382], 0xc600 ; GLOBAL_LOAD
0755EB  C7 06 86 53 0E 00     MOV    word ptr [0x5386], 0xe ; GLOBAL_LOAD
0755F1  B8 01 00              MOV    ax, 1 ; MOV
0755F4  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0755F7  A3 A2 00              MOV    word ptr [0xa2], ax ; GLOBAL_LOAD
0755FA  A3 A0 00              MOV    word ptr [0xa0], ax ; GLOBAL_LOAD
0755FD  A3 A4 00              MOV    word ptr [0xa4], ax ; GLOBAL_LOAD
075600  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
075603  A3 A4 53              MOV    word ptr [0x53a4], ax ; GLOBAL_LOAD
075606  A3 D2 53              MOV    word ptr [0x53d2], ax ; GLOBAL_LOAD
075609  A3 D4 53              MOV    word ptr [0x53d4], ax ; GLOBAL_LOAD
07560C  A3 D6 53              MOV    word ptr [0x53d6], ax ; GLOBAL_LOAD
07560F  2B C0                 SUB    ax, ax ; ARITH
075611  A3 94 53              MOV    word ptr [0x5394], ax ; GLOBAL_LOAD
075614  A3 96 53              MOV    word ptr [0x5396], ax ; GLOBAL_LOAD
075617  A3 A0 53              MOV    word ptr [0x53a0], ax ; GLOBAL_LOAD
07561A  A3 A2 53              MOV    word ptr [0x53a2], ax ; GLOBAL_LOAD
07561D  A3 80 53              MOV    word ptr [0x5380], ax ; GLOBAL_LOAD
075620  A3 D0 53              MOV    word ptr [0x53d0], ax ; GLOBAL_LOAD
075623  A3 D8 53              MOV    word ptr [0x53d8], ax ; GLOBAL_LOAD
075626  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
075629  EB 0F                 JMP    0x7563a ; JUMP
07562B  90                    NOP ; NOP
07562C  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
07562F  D1 E3                 SHL    bx, 1 ; LOGIC
075631  C7 87 C8 53 FF FF     MOV    word ptr [bx + 0x53c8], 0xffff ; CONST_LOAD
075637  FF 46 F6              INC    word ptr [bp - 0xa] ; ARITH
07563A  83 7E F6 04           CMP    word ptr [bp - 0xa], 4 ; CMP
07563E  7C EC                 JL     0x7562c ; CJUMP
075640  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
075645  68 E8 03              PUSH   0x3e8 ; PUSH_CONST
075648  68 58 02              PUSH   0x258 ; PUSH_CONST
07564B  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
075650  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
075653  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
075656  D1 E3                 SHL    bx, 1 ; LOGIC
075658  89 87 EA 53           MOV    word ptr [bx + 0x53ea], ax ; MOV
07565C  FF 46 F6              INC    word ptr [bp - 0xa] ; ARITH
07565F  83 7E F6 10           CMP    word ptr [bp - 0xa], 0x10 ; CMP
075663  7C E0                 JL     0x75645 ; CJUMP
075665  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
07566A  2B C0                 SUB    ax, ax ; ARITH
07566C  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
07566F  D1 E3                 SHL    bx, 1 ; LOGIC
075671  89 87 DA 53           MOV    word ptr [bx + 0x53da], ax ; MOV
075675  89 87 E2 53           MOV    word ptr [bx + 0x53e2], ax ; MOV
075679  FF 46 F6              INC    word ptr [bp - 0xa] ; ARITH
07567C  83 7E F6 04           CMP    word ptr [bp - 0xa], 4 ; CMP
075680  7C E8                 JL     0x7566a ; CJUMP
075682  6A 04                 PUSH   4 ; STACK_PUSH
075684  50                    PUSH   ax ; STACK_PUSH
075685  68 0A 54              PUSH   0x540a ; PUSH_CONST
075688  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae ; LCALL
07568D  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
075690  0E                    PUSH   cs ; STACK_PUSH
075691  E8 F5 0C              CALL   0x76389 ; CALL_NEAR
075694  0B C0                 OR     ax, ax ; LOGIC
075696  74 03                 JE     0x7569b ; CJUMP
075698  E9 14 03              JMP    0x759af ; JUMP
07569B  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
07569E  2A E4                 SUB    ah, ah ; ARITH
0756A0  8B C8                 MOV    cx, ax ; MOV
0756A2  C1 E0 03              SHL    ax, 3 ; LOGIC
0756A5  05 0F 00              ADD    ax, 0xf ; ARITH
0756A8  A3 DA 53              MOV    word ptr [0x53da], ax ; GLOBAL_LOAD
0756AB  8B C1                 MOV    ax, cx ; MOV
0756AD  41                    INC    cx ; ARITH
0756AE  8B D1                 MOV    dx, cx ; MOV
0756B0  C1 E1 02              SHL    cx, 2 ; LOGIC
0756B3  03 CA                 ADD    cx, dx ; ARITH
0756B5  89                    DB     0x89 ; DATA_BYTE
0756B6  0E                    DB     0x0E ; DATA_BYTE
