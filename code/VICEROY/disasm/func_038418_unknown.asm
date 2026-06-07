; ============================================================================
; func_038418_unknown
; Region   : overlay
; Bytes    : file 0x038418..0x0386D7  (703 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

038418  C8 20 01 00           ENTER  0x120, 0 ; PROLOGUE
03841C  57                    PUSH   di ; STACK_PUSH
03841D  56                    PUSH   si ; STACK_PUSH
03841E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
038421  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
038426  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038429  6A 04                 PUSH   4 ; STACK_PUSH
03842B  0E                    PUSH   cs ; STACK_PUSH
03842C  E8 24 1A              CALL   0x39e53 ; CALL_NEAR
03842F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038432  68 90 00              PUSH   0x90 ; PUSH_CONST
038435  6A 05                 PUSH   5 ; STACK_PUSH
038437  68 40 01              PUSH   0x140 ; PUSH_CONST
03843A  6A 00                 PUSH   0 ; STACK_PUSH
03843C  FF 36 1C 2E           PUSH   word ptr [0x2e1c] ; PUSH_GLOBAL
038440  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
038445  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038448  52                    PUSH   dx ; STACK_PUSH
038449  50                    PUSH   ax ; STACK_PUSH
03844A  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
03844F  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
038452  68 91 00              PUSH   0x91 ; PUSH_CONST
038455  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
038459  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
03845C  2A E4                 SUB    ah, ah ; ARITH
03845E  05 06 00              ADD    ax, 6 ; ARITH
038461  50                    PUSH   ax ; STACK_PUSH
038462  68 40 01              PUSH   0x140 ; PUSH_CONST
038465  6A 00                 PUSH   0 ; STACK_PUSH
038467  FF 36 2A 2E           PUSH   word ptr [0x2e2a] ; PUSH_GLOBAL
03846B  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
038470  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038473  52                    PUSH   dx ; STACK_PUSH
038474  50                    PUSH   ax ; STACK_PUSH
038475  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
03847A  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
03847D  C7 86 FA FE 02 00     MOV    word ptr [bp - 0x106], 2 ; LOCAL_STORE
038483  C7 86 F8 FE 19 00     MOV    word ptr [bp - 0x108], 0x19 ; LOCAL_STORE
038489  6A 3A                 PUSH   0x3a ; PUSH_CONST
03848B  6A 00                 PUSH   0 ; STACK_PUSH
03848D  8D 86 3C FF           LEA    ax, [bp - 0xc4] ; ADDR
038491  50                    PUSH   ax ; STACK_PUSH
038492  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae ; LCALL
038497  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03849A  C7 86 F2 FE 00 00     MOV    word ptr [bp - 0x10e], 0 ; LOCAL_STORE
0384A0  8B B6 F2 FE           MOV    si, word ptr [bp - 0x10e] ; LOCAL_LOAD
0384A4  D1 E6                 SHL    si, 1 ; LOGIC
0384A6  C7 42 C6 40 01        MOV    word ptr [bp + si - 0x3a], 0x140 ; LOCAL_STORE
0384AB  C7 82 02 FF C8 00     MOV    word ptr [bp + si - 0xfe], 0xc8 ; LOCAL_STORE
0384B1  FF 86 F2 FE           INC    word ptr [bp - 0x10e] ; ARITH
0384B5  83 BE F2 FE 1D        CMP    word ptr [bp - 0x10e], 0x1d ; CMP
0384BA  7C E4                 JL     0x384a0 ; CJUMP
0384BC  C7 86 F2 FE 00 00     MOV    word ptr [bp - 0x10e], 0 ; LOCAL_STORE
0384C2  EB 30                 JMP    0x384f4 ; JUMP
0384C4  FF 86 FC FE           INC    word ptr [bp - 0x104] ; ARITH
0384C8  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0384CC  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
0384CF  98                    CWDE ; ARITH
0384D0  3B 86 FC FE           CMP    ax, word ptr [bp - 0x104] ; CMP
0384D4  7E 1A                 JLE    0x384f0 ; CJUMP
0384D6  FF B6 FC FE           PUSH   word ptr [bp - 0x104] ; PUSH_GLOBAL
0384DA  9A 54 0C 1F 18        LCALL  0x181f, 0xc54 ; THUNK -> 0x05EB:0x0E52 (thunk @file 0x01B244 type B) overlay @file 0x027E42
0384DF  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0384E2  8B F0                 MOV    si, ax ; MOV
0384E4  89 B6 EC FE           MOV    word ptr [bp - 0x114], si ; LOCAL_STORE
0384E8  D1 E6                 SHL    si, 1 ; LOGIC
0384EA  FF 82 3C FF           INC    word ptr [bp + si - 0xc4] ; ARITH
0384EE  EB D4                 JMP    0x384c4 ; JUMP
0384F0  FF 86 F2 FE           INC    word ptr [bp - 0x10e] ; ARITH
0384F4  8B 86 F2 FE           MOV    ax, word ptr [bp - 0x10e] ; LOCAL_LOAD
0384F8  39 06 9E 53           CMP    word ptr [0x539e], ax ; CMP
0384FC  7E 1E                 JLE    0x3851c ; CJUMP
0384FE  50                    PUSH   ax ; STACK_PUSH
0384FF  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
038504  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038507  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
03850A  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03850E  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
038511  75 DD                 JNE    0x384f0 ; CJUMP
038513  C7 86 FC FE 00 00     MOV    word ptr [bp - 0x104], 0 ; LOCAL_STORE
038519  EB AD                 JMP    0x384c8 ; JUMP
03851B  90                    NOP ; NOP
03851C  C7 86 E6 FE 00 00     MOV    word ptr [bp - 0x11a], 0 ; LOCAL_STORE
038522  EB 36                 JMP    0x3855a ; JUMP
038524  6B 9E E6 FE 1C        IMUL   bx, word ptr [bp - 0x11a], 0x1c ; ARITH
038529  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
03852D  24 0F                 AND    al, 0xf ; LOGIC
03852F  3A 46 06              CMP    al, byte ptr [bp + 6] ; CMP
038532  75 22                 JNE    0x38556 ; CJUMP
038534  FF B6 E6 FE           PUSH   word ptr [bp - 0x11a] ; PUSH_GLOBAL
038538  9A 28 0B 1F 18        LCALL  0x181f, 0xb28 ; THUNK -> 0x05EB:0x08E6 (thunk @file 0x01B118 type B) overlay @file 0x0278D6
03853D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038540  0B C0                 OR     ax, ax ; LOGIC
038542  74 12                 JE     0x38556 ; CJUMP
038544  6B 9E E6 FE 1C        IMUL   bx, word ptr [bp - 0x11a], 0x1c ; ARITH
038549  8A 87 5B 31           MOV    al, byte ptr [bx + 0x315b] ; MOV
03854D  98                    CWDE ; ARITH
03854E  8B F0                 MOV    si, ax ; MOV
038550  D1 E6                 SHL    si, 1 ; LOGIC
038552  FF 82 3C FF           INC    word ptr [bp + si - 0xc4] ; ARITH
038556  FF 86 E6 FE           INC    word ptr [bp - 0x11a] ; ARITH
03855A  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
03855D  39 86 E6 FE           CMP    word ptr [bp - 0x11a], ax ; CMP
038561  7C C1                 JL     0x38524 ; CJUMP
038563  8B 86 74 FF           MOV    ax, word ptr [bp - 0x8c] ; LOCAL_LOAD
038567  01 86 62 FF           ADD    word ptr [bp - 0x9e], ax ; ARITH
03856B  8B 86 F8 FE           MOV    ax, word ptr [bp - 0x108] ; LOCAL_LOAD
03856F  89 86 E4 FE           MOV    word ptr [bp - 0x11c], ax ; LOCAL_STORE
038573  8B 86 FA FE           MOV    ax, word ptr [bp - 0x106] ; LOCAL_LOAD
038577  89 86 E8 FE           MOV    word ptr [bp - 0x118], ax ; LOCAL_STORE
03857B  C7 86 EE FE 69 00     MOV    word ptr [bp - 0x112], 0x69 ; LOCAL_STORE
038581  C7 86 EA FE 12 00     MOV    word ptr [bp - 0x116], 0x12 ; LOCAL_STORE
038587  2B C0                 SUB    ax, ax ; ARITH
038589  89 86 FE FE           MOV    word ptr [bp - 0x102], ax ; LOCAL_STORE
03858D  89 86 F6 FE           MOV    word ptr [bp - 0x10a], ax ; LOCAL_STORE
038591  89 86 F2 FE           MOV    word ptr [bp - 0x10e], ax ; LOCAL_STORE
038595  E9 34 01              JMP    0x386cc ; JUMP
038598  8B 86 F2 FE           MOV    ax, word ptr [bp - 0x10e] ; LOCAL_LOAD
03859C  89 86 E6 FE           MOV    word ptr [bp - 0x11a], ax ; LOCAL_STORE
0385A0  3D 13 00              CMP    ax, 0x13 ; CMP
0385A3  75 03                 JNE    0x385a8 ; CJUMP
0385A5  E9 20 01              JMP    0x386c8 ; JUMP
0385A8  3D 17 00              CMP    ax, 0x17 ; CMP
0385AB  75 03                 JNE    0x385b0 ; CJUMP
0385AD  E9 18 01              JMP    0x386c8 ; JUMP
0385B0  3D 12 00              CMP    ax, 0x12 ; CMP
0385B3  75 03                 JNE    0x385b8 ; CJUMP
0385B5  E9 10 01              JMP    0x386c8 ; JUMP
0385B8  3D 1C 00              CMP    ax, 0x1c ; CMP
0385BB  75 06                 JNE    0x385c3 ; CJUMP
0385BD  C7 86 E6 FE 13 00     MOV    word ptr [bp - 0x11a], 0x13 ; LOCAL_STORE
0385C3  8B 86 E4 FE           MOV    ax, word ptr [bp - 0x11c] ; LOCAL_LOAD
0385C7  8B B6 E6 FE           MOV    si, word ptr [bp - 0x11a] ; LOCAL_LOAD
0385CB  D1 E6                 SHL    si, 1 ; LOGIC
0385CD  89 82 02 FF           MOV    word ptr [bp + si - 0xfe], ax ; LOCAL_STORE
0385D1  6A 03                 PUSH   3 ; STACK_PUSH
0385D3  8B 86 E6 FE           MOV    ax, word ptr [bp - 0x11a] ; LOCAL_LOAD
0385D7  9A C6 02 1F 18        LCALL  0x181f, 0x2c6 ; THUNK -> 0x012B:0x0002 (thunk @file 0x01A8B6 type B) overlay @file 0x02356C
0385DC  8B 9E E4 FE           MOV    bx, word ptr [bp - 0x11c] ; LOCAL_LOAD
0385E0  4B                    DEC    bx ; ARITH
0385E1  8B 96 E8 FE           MOV    dx, word ptr [bp - 0x118] ; LOCAL_LOAD
0385E5  89 52 C6              MOV    word ptr [bp + si - 0x3a], dx ; LOCAL_STORE
0385E8  8B FA                 MOV    di, dx ; MOV
0385EA  9A 4A 02 1F 18        LCALL  0x181f, 0x24a ; THUNK -> 0x012B:0x015C (thunk @file 0x01A83A type B) overlay @file 0x0236C6
0385EF  C6 86 76 FF 00        MOV    byte ptr [bp - 0x8a], 0 ; LOCAL_STORE
0385F4  8B 9E E6 FE           MOV    bx, word ptr [bp - 0x11a] ; LOCAL_LOAD
0385F8  C1 E3 03              SHL    bx, 3 ; LOGIC
0385FB  FF B7 A4 8E           PUSH   word ptr [bx - 0x715c] ; PUSH_GLOBAL
0385FF  8D 86 76 FF           LEA    ax, [bp - 0x8a] ; ADDR
038603  50                    PUSH   ax ; STACK_PUSH
038604  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
038609  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03860C  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
038610  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
038614  8D 86 76 FF           LEA    ax, [bp - 0x8a] ; ADDR
038618  16                    PUSH   ss ; STACK_PUSH
038619  50                    PUSH   ax ; STACK_PUSH
03861A  2B C0                 SUB    ax, ax ; ARITH
03861C  9A 04 02 1F 18        LCALL  0x181f, 0x204 ; THUNK -> 0x0C2A:0x0006 (thunk @file 0x01A7F4 type B)
038621  48                    DEC    ax ; ARITH
038622  89 86 E2 FE           MOV    word ptr [bp - 0x11e], ax ; LOCAL_STORE
038626  68 92 00              PUSH   0x92 ; PUSH_CONST
038629  8B 86 E4 FE           MOV    ax, word ptr [bp - 0x11c] ; LOCAL_LOAD
03862D  40                    INC    ax ; ARITH
03862E  50                    PUSH   ax ; STACK_PUSH
03862F  8D 4D 0C              LEA    cx, [di + 0xc] ; ADDR
038632  51                    PUSH   cx ; STACK_PUSH
038633  8D 8E 76 FF           LEA    cx, [bp - 0x8a] ; ADDR
038637  16                    PUSH   ss ; STACK_PUSH
038638  51                    PUSH   cx ; STACK_PUSH
038639  89 86 E0 FE           MOV    word ptr [bp - 0x120], ax ; LOCAL_STORE
03863D  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
038642  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
038645  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
038649  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
03864C  2A E4                 SUB    ah, ah ; ARITH
03864E  03 86 E0 FE           ADD    ax, word ptr [bp - 0x120] ; ARITH
038652  40                    INC    ax ; ARITH
038653  89 86 F0 FE           MOV    word ptr [bp - 0x110], ax ; LOCAL_STORE
038657  C6 86 76 FF 00        MOV    byte ptr [bp - 0x8a], 0 ; LOCAL_STORE
03865C  FF B2 3C FF           PUSH   word ptr [bp + si - 0xc4] ; PUSH_GLOBAL
038660  8D 86 76 FF           LEA    ax, [bp - 0x8a] ; ADDR
038664  16                    PUSH   ss ; STACK_PUSH
038665  50                    PUSH   ax ; STACK_PUSH
038666  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
03866B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03866E  8D 45 27              LEA    ax, [di + 0x27] ; ADDR
038671  89 86 F4 FE           MOV    word ptr [bp - 0x10c], ax ; LOCAL_STORE
038675  6A 61                 PUSH   0x61 ; PUSH_CONST
038677  FF B6 F0 FE           PUSH   word ptr [bp - 0x110] ; PUSH_GLOBAL
03867B  50                    PUSH   ax ; STACK_PUSH
03867C  8D 86 76 FF           LEA    ax, [bp - 0x8a] ; ADDR
038680  16                    PUSH   ss ; STACK_PUSH
038681  50                    PUSH   ax ; STACK_PUSH
038682  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
038687  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
03868A  8B 86 EA FE           MOV    ax, word ptr [bp - 0x116] ; LOCAL_LOAD
03868E  01 86 E4 FE           ADD    word ptr [bp - 0x11c], ax ; ARITH
038692  83 BE F6 FE 01        CMP    word ptr [bp - 0x10a], 1 ; CMP
038697  1B C0                 SBB    ax, ax ; ARITH
038699  40                    INC    ax ; ARITH
03869A  05 08 00              ADD    ax, 8 ; ARITH
03869D  FF 86 FE FE           INC    word ptr [bp - 0x102] ; ARITH
0386A1  3B 86 FE FE           CMP    ax, word ptr [bp - 0x102] ; CMP
0386A5  7F 21                 JG     0x386c8 ; CJUMP
0386A7  83 BE F6 FE 02        CMP    word ptr [bp - 0x10a], 2 ; CMP
0386AC  7D 1A                 JGE    0x386c8 ; CJUMP
0386AE  C7 86 FE FE 00 00     MOV    word ptr [bp - 0x102], 0 ; LOCAL_STORE
0386B4  FF 86 F6 FE           INC    word ptr [bp - 0x10a] ; ARITH
0386B8  8B 86 F8 FE           MOV    ax, word ptr [bp - 0x108] ; LOCAL_LOAD
0386BC  89 86 E4 FE           MOV    word ptr [bp - 0x11c], ax ; LOCAL_STORE
0386C0  03 BE EE FE           ADD    di, word ptr [bp - 0x112] ; ARITH
0386C4  89 BE E8 FE           MOV    word ptr [bp - 0x118], di ; LOCAL_STORE
0386C8  FF 86 F2 FE           INC    word ptr [bp - 0x10e] ; ARITH
0386CC  83 BE F2 FE 1D        CMP    word ptr [bp - 0x10e], 0x1d ; CMP
0386D1  7D 03                 JGE    0x386d6 ; CJUMP
0386D3  E9 C2 FE              JMP    0x38598 ; JUMP
0386D6  6A                    DB     0x6A ; DATA_BYTE
