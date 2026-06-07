; ============================================================================
; func_075352_unknown
; Region   : overlay
; Bytes    : file 0x075352..0x075594  (578 bytes)
; Purpose  : King audience / endgame screen renderer  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; Tagged: "KINGLSS", "ENGLND", "FRANCE"  (auto-named via string xrefs)
; ============================================================================

075352  C8 20 03 00           ENTER  0x320, 0 ; PROLOGUE
075356  57                    PUSH   di ; STACK_PUSH
075357  56                    PUSH   si ; STACK_PUSH
075358  2B C0                 SUB    ax, ax ; ARITH
07535A  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
07535D  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
075360  A1 72 03              MOV    ax, word ptr [0x372] ; GLOBAL_LOAD
075363  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
075366  2B C0                 SUB    ax, ax ; ARITH
075368  A3 72 03              MOV    word ptr [0x372], ax ; GLOBAL_LOAD
07536B  A3 64 1F              MOV    word ptr [0x1f64], ax ; GLOBAL_LOAD
07536E  68 F2 22              PUSH   0x22f2                       ; STRING: "KINGLSS"
075371  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
075374  50                    PUSH   ax ; STACK_PUSH
075375  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
07537A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07537D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
075380  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
075383  16                    PUSH   ss ; STACK_PUSH
075384  50                    PUSH   ax ; STACK_PUSH
075385  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
07538A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
07538D  8D 86 E0 FC           LEA    ax, [bp - 0x320] ; ADDR
075391  16                    PUSH   ss ; STACK_PUSH
075392  50                    PUSH   ax ; STACK_PUSH
075393  6A 00                 PUSH   0 ; STACK_PUSH
075395  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075399  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
07539D  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
0753A1  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
0753A5  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
0753A8  50                    PUSH   ax ; STACK_PUSH
0753A9  9A 4E 04 1F 18        LCALL  0x181f, 0x44e ; THUNK -> 0x0000:0x000E (thunk @file 0x01AA3E type A) overlay @file 0x02590E
0753AE  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
0753B1  0B C0                 OR     ax, ax ; LOGIC
0753B3  74 03                 JE     0x753b8 ; CJUMP
0753B5  E9 AB 01              JMP    0x75563 ; JUMP
0753B8  A1 98 53              MOV    ax, word ptr [0x5398] ; GLOBAL_LOAD
0753BB  0B C0                 OR     ax, ax ; LOGIC
0753BD  74 0B                 JE     0x753ca ; CJUMP
0753BF  48                    DEC    ax ; ARITH
0753C0  74 0E                 JE     0x753d0 ; CJUMP
0753C2  48                    DEC    ax ; ARITH
0753C3  74 11                 JE     0x753d6 ; CJUMP
0753C5  48                    DEC    ax ; ARITH
0753C6  74 14                 JE     0x753dc ; CJUMP
0753C8  EB 21                 JMP    0x753eb ; JUMP
0753CA  68 FA 22              PUSH   0x22fa                       ; STRING: "ENGLND"
0753CD  EB 10                 JMP    0x753df ; JUMP
0753CF  90                    NOP ; NOP
0753D0  68 01 23              PUSH   0x2301                       ; STRING: "FRANCE"
0753D3  EB 0A                 JMP    0x753df ; JUMP
0753D5  90                    NOP ; NOP
0753D6  68 08 23              PUSH   0x2308                       ; STRING: "SPAIN"
0753D9  EB 04                 JMP    0x753df ; JUMP
0753DB  90                    NOP ; NOP
0753DC  68 0E 23              PUSH   0x230e                       ; STRING: "DUTCH"
0753DF  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
0753E2  50                    PUSH   ax ; STACK_PUSH
0753E3  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
0753E8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0753EB  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0753EE  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
0753F1  16                    PUSH   ss ; STACK_PUSH
0753F2  50                    PUSH   ax ; STACK_PUSH
0753F3  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
0753F8  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0753FB  9A DE 0F 1F 19        LCALL  0x191f, 0xfde ; THUNK -> 0x0000:0x0000 (thunk @file 0x01C5CE type A) overlay @file 0x025900
075400  8D 5E E0              LEA    bx, [bp - 0x20] ; ADDR
075403  2B C0                 SUB    ax, ax ; ARITH
075405  9A D0 0F 1F 19        LCALL  0x191f, 0xfd0 ; THUNK -> 0x0000:0x0054 (thunk @file 0x01C5C0 type A) overlay @file 0x025954
07540A  8B F0                 MOV    si, ax ; MOV
07540C  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
07540F  0B D0                 OR     dx, ax ; LOGIC
075411  74 1D                 JE     0x75430 ; CJUMP
075413  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
075416  50                    PUSH   ax ; STACK_PUSH
075417  56                    PUSH   si ; STACK_PUSH
075418  8E C0                 MOV    es, ax ; MOV
07541A  26 FF 74 48           PUSH   word ptr es:[si + 0x48] ; PUSH_GLOBAL
07541E  6A 64                 PUSH   0x64 ; PUSH_CONST
075420  26 8B 54 46           MOV    dx, word ptr es:[si + 0x46] ; MOV
075424  B8 01 00              MOV    ax, 1 ; MOV
075427  8D 1E 9E 83           LEA    bx, [0x839e] ; ADDR
07542B  9A F8 02 1F 18        LCALL  0x181f, 0x2f8 ; THUNK -> 0x0C56:0x0004 (thunk @file 0x01A8E8 type B)
075430  83 7E 06 01           CMP    word ptr [bp + 6], 1 ; CMP
075434  75 28                 JNE    0x7545e ; CJUMP
075436  83 7E 08 01           CMP    word ptr [bp + 8], 1 ; CMP
07543A  75 1C                 JNE    0x75458 ; CJUMP
07543C  68 14 23              PUSH   0x2314                       ; STRING: "KING1"
07543F  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
075442  50                    PUSH   ax ; STACK_PUSH
075443  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
075448  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07544B  6A 3E                 PUSH   0x3e ; PUSH_CONST
07544D  9A 8E 04 1F 18        LCALL  0x181f, 0x48e ; THUNK -> 0x029F:0x02CC (thunk @file 0x01AA7E type B) overlay @file 0x0222F4
075452  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
075455  EB 16                 JMP    0x7546d ; JUMP
075457  90                    NOP ; NOP
075458  68 1A 23              PUSH   0x231a                       ; STRING: "KINGLOSE"
07545B  EB 04                 JMP    0x75461 ; JUMP
07545D  90                    NOP ; NOP
07545E  68 23 23              PUSH   0x2323                       ; STRING: "KINGWIN"
075461  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
075464  50                    PUSH   ax ; STACK_PUSH
075465  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
07546A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07546D  9A DE 0F 1F 19        LCALL  0x191f, 0xfde ; THUNK -> 0x0000:0x0000 (thunk @file 0x01C5CE type A) overlay @file 0x025900
075472  8D 5E E0              LEA    bx, [bp - 0x20] ; ADDR
075475  2B C0                 SUB    ax, ax ; ARITH
075477  9A D0 0F 1F 19        LCALL  0x191f, 0xfd0 ; THUNK -> 0x0000:0x0054 (thunk @file 0x01C5C0 type A) overlay @file 0x025954
07547C  8B F0                 MOV    si, ax ; MOV
07547E  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
075481  0B D0                 OR     dx, ax ; LOGIC
075483  74 1D                 JE     0x754a2 ; CJUMP
075485  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
075488  50                    PUSH   ax ; STACK_PUSH
075489  56                    PUSH   si ; STACK_PUSH
07548A  8E C0                 MOV    es, ax ; MOV
07548C  26 FF 74 48           PUSH   word ptr es:[si + 0x48] ; PUSH_GLOBAL
075490  6A 64                 PUSH   0x64 ; PUSH_CONST
075492  26 8B 54 46           MOV    dx, word ptr es:[si + 0x46] ; MOV
075496  B8 01 00              MOV    ax, 1 ; MOV
075499  8D 1E 9E 83           LEA    bx, [0x839e] ; ADDR
07549D  9A F8 02 1F 18        LCALL  0x181f, 0x2f8 ; THUNK -> 0x0C56:0x0004 (thunk @file 0x01A8E8 type B)
0754A2  9A B6 03 1F 18        LCALL  0x181f, 0x3b6 ; THUNK -> 0x0262:0x0012 (thunk @file 0x01A9A6 type B) overlay @file 0x021D42
0754A7  8D 86 E0 FC           LEA    ax, [bp - 0x320] ; ADDR
0754AB  16                    PUSH   ss ; STACK_PUSH
0754AC  50                    PUSH   ax ; STACK_PUSH
0754AD  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
0754B2  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
0754B6  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
0754BA  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
0754BE  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
0754C2  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0754C6  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0754CA  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0754CE  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0754D2  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0754D5  2B C0                 SUB    ax, ax ; ARITH
0754D7  99                    CDQ ; ARITH
0754D8  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
0754DB  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
0754E0  6A 00                 PUSH   0 ; STACK_PUSH
0754E2  68 40 01              PUSH   0x140 ; PUSH_CONST
0754E5  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0754E8  2B C0                 SUB    ax, ax ; ARITH
0754EA  99                    CDQ ; ARITH
0754EB  2B DB                 SUB    bx, bx ; ARITH
0754ED  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
0754F2  8D 1E 2B 23           LEA    bx, [0x232b] ; ADDR
0754F6  9A 86 0A 1F 1A        LCALL  0x1a1f, 0xa86 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D076 type A) overlay @file 0x025900
0754FB  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
0754FE  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
075501  0B D0                 OR     dx, ax ; LOGIC
075503  74 05                 JE     0x7550a ; CJUMP
075505  8B 56 F6              MOV    dx, word ptr [bp - 0xa] ; LOCAL_LOAD
075508  EB 07                 JMP    0x75511 ; JUMP
07550A  A1 9E 08              MOV    ax, word ptr [0x89e] ; GLOBAL_LOAD
07550D  8B 16 A0 08           MOV    dx, word ptr [0x8a0] ; GLOBAL_LOAD
075511  A3 9E 1F              MOV    word ptr [0x1f9e], ax ; GLOBAL_LOAD
075514  89 16 A0 1F           MOV    word ptr [0x1fa0], dx ; GLOBAL_LOAD
075518  8B 36 4A 1F           MOV    si, word ptr [0x1f4a] ; GLOBAL_LOAD
07551C  8B 3E 50 1F           MOV    di, word ptr [0x1f50] ; GLOBAL_LOAD
075520  A1 52 1F              MOV    ax, word ptr [0x1f52] ; GLOBAL_LOAD
075523  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
075526  C7 06 4A 1F F2 00     MOV    word ptr [0x1f4a], 0xf2 ; GLOBAL_LOAD
07552C  C7 06 50 1F 2F 00     MOV    word ptr [0x1f50], 0x2f ; GLOBAL_LOAD
075532  C7 06 52 1F 00 00     MOV    word ptr [0x1f52], 0 ; GLOBAL_LOAD
075538  80 0E 56 1F 18        OR     byte ptr [0x1f56], 0x18 ; LOGIC
07553D  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
075540  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
075545  89 36 4A 1F           MOV    word ptr [0x1f4a], si ; GLOBAL_LOAD
075549  89 3E 50 1F           MOV    word ptr [0x1f50], di ; GLOBAL_LOAD
07554D  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
075550  A3 52 1F              MOV    word ptr [0x1f52], ax ; GLOBAL_LOAD
075553  9A B6 03 1F 18        LCALL  0x181f, 0x3b6 ; THUNK -> 0x0262:0x0012 (thunk @file 0x01A9A6 type B) overlay @file 0x021D42
075558  68 00 A0              PUSH   0xa000 ; PUSH_CONST
07555B  68 00 FC              PUSH   0xfc00 ; PUSH_CONST
07555E  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
075563  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
075566  0B 46 F4              OR     ax, word ptr [bp - 0xc] ; LOGIC
075569  74 0B                 JE     0x75576 ; CJUMP
07556B  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
07556E  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
075571  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
075576  A1 8A 26              MOV    ax, word ptr [0x268a] ; GLOBAL_LOAD
075579  8B 16 8C 26           MOV    dx, word ptr [0x268c] ; GLOBAL_LOAD
07557D  A3 9E 1F              MOV    word ptr [0x1f9e], ax ; GLOBAL_LOAD
075580  89 16 A0 1F           MOV    word ptr [0x1fa0], dx ; GLOBAL_LOAD
075584  C7 06 64 1F 01 00     MOV    word ptr [0x1f64], 1 ; GLOBAL_LOAD
07558A  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
07558D  A3 72 03              MOV    word ptr [0x372], ax ; GLOBAL_LOAD
075590  5E                    POP    si ; STACK_POP
075591  5F                    POP    di ; STACK_POP
075592  C9                    LEAVE ; EPILOGUE
075593  CB                    RETF ; RETURN
