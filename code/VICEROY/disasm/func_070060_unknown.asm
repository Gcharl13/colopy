; ============================================================================
; func_070060_unknown
; Region   : overlay
; Bytes    : file 0x070060..0x07020F  (431 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "CUSTOMIZ"  (auto-named via string xrefs)
; ============================================================================

070060  C8 12 03 00           ENTER  0x312, 0 ; PROLOGUE
070064  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
070069  8D 86 F0 FC           LEA    ax, [bp - 0x310] ; ADDR
07006D  16                    PUSH   ss ; STACK_PUSH
07006E  50                    PUSH   ax ; STACK_PUSH
07006F  2B C0                 SUB    ax, ax ; ARITH
070071  A3 0A A6              MOV    word ptr [0xa60a], ax ; GLOBAL_LOAD
070074  50                    PUSH   ax ; STACK_PUSH
070075  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
070079  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
07007D  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
070081  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
070085  68 22 20              PUSH   0x2022                       ; STRING: "CUSTOMIZ"
070088  9A 4E 04 1F 18        LCALL  0x181f, 0x44e ; THUNK -> 0x0000:0x000E (thunk @file 0x01AA3E type A) overlay @file 0x02590E
07008D  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
070090  0B C0                 OR     ax, ax ; LOGIC
070092  74 03                 JE     0x70097 ; CJUMP
070094  E9 13 02              JMP    0x702aa ; JUMP
070097  9A B6 03 1F 18        LCALL  0x181f, 0x3b6 ; THUNK -> 0x0262:0x0012 (thunk @file 0x01A9A6 type B) overlay @file 0x021D42
07009C  8D 86 F0 FC           LEA    ax, [bp - 0x310] ; ADDR
0700A0  16                    PUSH   ss ; STACK_PUSH
0700A1  50                    PUSH   ax ; STACK_PUSH
0700A2  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
0700A7  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
0700AB  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
0700AF  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
0700B3  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
0700B7  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0700BB  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0700BF  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0700C3  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0700C7  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0700CA  2B C0                 SUB    ax, ax ; ARITH
0700CC  99                    CDQ ; ARITH
0700CD  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
0700D0  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
0700D5  6A 00                 PUSH   0 ; STACK_PUSH
0700D7  68 40 01              PUSH   0x140 ; PUSH_CONST
0700DA  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0700DD  2B C0                 SUB    ax, ax ; ARITH
0700DF  99                    CDQ ; ARITH
0700E0  2B DB                 SUB    bx, bx ; ARITH
0700E2  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
0700E7  0E                    PUSH   cs ; STACK_PUSH
0700E8  E8 6A 0B              CALL   0x70c55 ; CALL_NEAR
0700EB  9A 7A 04 1F 18        LCALL  0x181f, 0x47a ; THUNK -> 0x0ACB:0x0030 (thunk @file 0x01AA6A type B) overlay @file 0x0318D2
0700F0  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
0700F5  2B C0                 SUB    ax, ax ; ARITH
0700F7  9A 66 04 1F 18        LCALL  0x181f, 0x466 ; THUNK -> 0x0ACB:0x0056 (thunk @file 0x01AA56 type B) overlay @file 0x0318F8
0700FC  A1 0A A6              MOV    ax, word ptr [0xa60a] ; GLOBAL_LOAD
0700FF  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
070102  9A F6 00 1F 18        LCALL  0x181f, 0xf6 ; THUNK -> 0x0AE7:0x0002 (thunk @file 0x01A6E6 type B) overlay @file 0x026FF2
070107  0B C0                 OR     ax, ax ; LOGIC
070109  74 31                 JE     0x7013c ; CJUMP
07010B  9A E0 03 1F 18        LCALL  0x181f, 0x3e0 ; THUNK -> 0x0AE7:0x0016 (thunk @file 0x01A9D0 type B) overlay @file 0x027006
070110  89 86 EE FC           MOV    word ptr [bp - 0x312], ax ; LOCAL_STORE
070114  3D 20 00              CMP    ax, 0x20 ; CMP
070117  75 03                 JNE    0x7011c ; CJUMP
070119  E9 9E 00              JMP    0x701ba ; JUMP
07011C  7E 03                 JLE    0x70121 ; CJUMP
07011E  E9 A9 00              JMP    0x701ca ; JUMP
070121  3D 1B 00              CMP    ax, 0x1b ; CMP
070124  75 03                 JNE    0x70129 ; CJUMP
070126  E9 81 01              JMP    0x702aa ; JUMP
070129  77 11                 JA     0x7013c ; CJUMP
07012B  2C 08                 SUB    al, 8 ; ARITH
07012D  74 29                 JE     0x70158 ; CJUMP
07012F  FE C8                 DEC    al ; ARITH
070131  74 5F                 JE     0x70192 ; CJUMP
070133  2C 04                 SUB    al, 4 ; ARITH
070135  75 05                 JNE    0x7013c ; CJUMP
070137  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
07013C  83 3E F0 07 00        CMP    word ptr [0x7f0], 0 ; CMP
070141  75 03                 JNE    0x70146 ; CJUMP
070143  E9 4C 01              JMP    0x70292 ; JUMP
070146  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
07014B  75 03                 JNE    0x70150 ; CJUMP
07014D  E9 42 01              JMP    0x70292 ; JUMP
070150  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
070155  E9 17 01              JMP    0x7026f ; JUMP
070158  A1 0A A6              MOV    ax, word ptr [0xa60a] ; GLOBAL_LOAD
07015B  05 03 00              ADD    ax, 3 ; ARITH
07015E  B9 04 00              MOV    cx, 4 ; MOV
070161  99                    CDQ ; ARITH
070162  F7 F9                 IDIV   cx ; ARITH
070164  89 16 0A A6           MOV    word ptr [0xa60a], dx ; GLOBAL_LOAD
070168  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
07016B  D1 E3                 SHL    bx, 1 ; LOGIC
07016D  FF B7 7E 1E           PUSH   word ptr [bx + 0x1e7e] ; PUSH_GLOBAL
070171  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
070174  0E                    PUSH   cs ; STACK_PUSH
070175  E8 D3 0A              CALL   0x70c4b ; CALL_NEAR
070178  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07017B  8B 1E 0A A6           MOV    bx, word ptr [0xa60a] ; GLOBAL_LOAD
07017F  D1 E3                 SHL    bx, 1 ; LOGIC
070181  FF B7 7E 1E           PUSH   word ptr [bx + 0x1e7e] ; PUSH_GLOBAL
070185  FF 36 0A A6           PUSH   word ptr [0xa60a] ; PUSH_GLOBAL
070189  0E                    PUSH   cs ; STACK_PUSH
07018A  E8 BE 0A              CALL   0x70c4b ; CALL_NEAR
07018D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
070190  EB AA                 JMP    0x7013c ; JUMP
070192  A1 0A A6              MOV    ax, word ptr [0xa60a] ; GLOBAL_LOAD
070195  40                    INC    ax ; ARITH
070196  EB C6                 JMP    0x7015e ; JUMP
070198  8B 1E 0A A6           MOV    bx, word ptr [0xa60a] ; GLOBAL_LOAD
07019C  D1 E3                 SHL    bx, 1 ; LOGIC
07019E  8B 87 7E 1E           MOV    ax, word ptr [bx + 0x1e7e] ; MOV
0701A2  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0701A5  40                    INC    ax ; ARITH
0701A6  40                    INC    ax ; ARITH
0701A7  B9 03 00              MOV    cx, 3 ; MOV
0701AA  99                    CDQ ; ARITH
0701AB  F7 F9                 IDIV   cx ; ARITH
0701AD  89 97 7E 1E           MOV    word ptr [bx + 0x1e7e], dx ; MOV
0701B1  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0701B4  FF 36 0A A6           PUSH   word ptr [0xa60a] ; PUSH_GLOBAL
0701B8  EB BA                 JMP    0x70174 ; JUMP
0701BA  8B 1E 0A A6           MOV    bx, word ptr [0xa60a] ; GLOBAL_LOAD
0701BE  D1 E3                 SHL    bx, 1 ; LOGIC
0701C0  8B 87 7E 1E           MOV    ax, word ptr [bx + 0x1e7e] ; MOV
0701C4  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0701C7  40                    INC    ax ; ARITH
0701C8  EB DD                 JMP    0x701a7 ; JUMP
0701CA  2D 48 01              SUB    ax, 0x148 ; ARITH
0701CD  74 C9                 JE     0x70198 ; CJUMP
0701CF  2D 03 00              SUB    ax, 3 ; ARITH
0701D2  74 84                 JE     0x70158 ; CJUMP
0701D4  48                    DEC    ax ; ARITH
0701D5  48                    DEC    ax ; ARITH
0701D6  74 BA                 JE     0x70192 ; CJUMP
0701D8  2D 03 00              SUB    ax, 3 ; ARITH
0701DB  74 DD                 JE     0x701ba ; CJUMP
0701DD  E9 5C FF              JMP    0x7013c ; JUMP
0701E0  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
0701E3  83 7E F0 03           CMP    word ptr [bp - 0x10], 3 ; CMP
0701E7  7C 03                 JL     0x701ec ; CJUMP
0701E9  E9 80 00              JMP    0x7026c ; JUMP
0701EC  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
0701EF  50                    PUSH   ax ; STACK_PUSH
0701F0  8D 4E F6              LEA    cx, [bp - 0xa] ; ADDR
0701F3  51                    PUSH   cx ; STACK_PUSH
0701F4  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
0701F7  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
0701FA  0E                    PUSH   cs ; STACK_PUSH
0701FB  E8 43 0A              CALL   0x70c41 ; CALL_NEAR
0701FE  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
070201  6A 30                 PUSH   0x30 ; PUSH_CONST
070203  6A 48                 PUSH   0x48 ; PUSH_CONST
070205  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
070208  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
07020B  9A                    DB     0x9A ; DATA_BYTE
07020C  CA                    DB     0xCA ; DATA_BYTE
07020D  03                    DB     0x03 ; DATA_BYTE
07020E  1F                    DB     0x1F ; DATA_BYTE
