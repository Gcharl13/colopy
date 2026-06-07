; ============================================================================
; func_003193_unknown
; Region   : load_image
; Bytes    : file 0x003193..0x0033E9  (598 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003193  C8 B8 01 00           ENTER  0x1b8, 0 ; PROLOGUE
003197  2B 06 E0 2C           SUB    ax, word ptr [0x2ce0] ; ARITH
00319B  F7 6E 06              IMUL   word ptr [bp + 6] ; ARITH
00319E  2B C1                 SUB    ax, cx ; ARITH
0031A0  03 46 DA              ADD    ax, word ptr [bp - 0x26] ; ARITH
0031A3  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0031A6  3B 46 E0              CMP    ax, word ptr [bp - 0x20] ; CMP
0031A9  7D 1B                 JGE    0x31c6 ; CJUMP
0031AB  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0031AF  7E 05                 JLE    0x31b6 ; CJUMP
0031B1  FF 4E 06              DEC    word ptr [bp + 6] ; ARITH
0031B4  EB 10                 JMP    0x31c6 ; JUMP
0031B6  0B C9                 OR     cx, cx ; LOGIC
0031B8  7E 06                 JLE    0x31c0 ; CJUMP
0031BA  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
0031BD  EB 07                 JMP    0x31c6 ; JUMP
0031BF  90                    NOP ; NOP
0031C0  8B 46 E0              MOV    ax, word ptr [bp - 0x20] ; LOCAL_LOAD
0031C3  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0031C6  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
0031C9  39 46 E0              CMP    word ptr [bp - 0x20], ax ; CMP
0031CC  7F B3                 JG     0x3181 ; CJUMP
0031CE  83 7E F6 00           CMP    word ptr [bp - 0xa], 0 ; CMP
0031D2  74 1B                 JE     0x31ef ; CJUMP
0031D4  99                    CDQ ; ARITH
0031D5  F7 7E F6              IDIV   word ptr [bp - 0xa] ; ARITH
0031D8  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
0031DB  0B C0                 OR     ax, ax ; LOGIC
0031DD  75 10                 JNE    0x31ef ; CJUMP
0031DF  FF 46 E4              INC    word ptr [bp - 0x1c] ; ARITH
0031E2  8A 4E E4              MOV    cl, byte ptr [bp - 0x1c] ; LOCAL_LOAD
0031E5  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
0031E8  D3 F8                 SAR    ax, cl ; LOGIC
0031EA  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
0031ED  7F F0                 JG     0x31df ; CJUMP
0031EF  C7 46 EA 00 00        MOV    word ptr [bp - 0x16], 0 ; LOCAL_STORE
0031F4  E9 AF 01              JMP    0x33a6 ; JUMP
0031F7  90                    NOP ; NOP
0031F8  C7 46 E2 01 00        MOV    word ptr [bp - 0x1e], 1 ; LOCAL_STORE
0031FD  8A 4E E4              MOV    cl, byte ptr [bp - 0x1c] ; LOCAL_LOAD
003200  8B 5E EA              MOV    bx, word ptr [bp - 0x16] ; LOCAL_LOAD
003203  D1 E3                 SHL    bx, 1 ; LOGIC
003205  8B 87 CE 2C           MOV    ax, word ptr [bx + 0x2cce] ; MOV
003209  2B 87 E2 2C           SUB    ax, word ptr [bx + 0x2ce2] ; ARITH
00320D  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
003210  D3 F8                 SAR    ax, cl ; LOGIC
003212  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
003215  8B 46 D6              MOV    ax, word ptr [bp - 0x2a] ; LOCAL_LOAD
003218  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
00321B  C7 46 E8 FF FF        MOV    word ptr [bp - 0x18], 0xffff ; LOCAL_STORE
003220  C7 46 EC 00 00        MOV    word ptr [bp - 0x14], 0 ; LOCAL_STORE
003225  EB 75                 JMP    0x329c ; JUMP
003227  90                    NOP ; NOP
003228  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
00322C  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
003230  FF 76 D8              PUSH   word ptr [bp - 0x28] ; PUSH_GLOBAL
003233  8B 5E EA              MOV    bx, word ptr [bp - 0x16] ; LOCAL_LOAD
003236  D1 E3                 SHL    bx, 1 ; LOGIC
003238  8B 87 F4 2C           MOV    ax, word ptr [bx + 0x2cf4] ; MOV
00323C  80 E4 0F              AND    ah, 0xf ; LOGIC
00323F  8B F3                 MOV    si, bx ; MOV
003241  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
003245  8B 56 D6              MOV    dx, word ptr [bp - 0x2a] ; LOCAL_LOAD
003248  9A 0A 00 36 0C        LCALL  0xc36, 0xa ; LCALL
00324D  8B 84 F4 2C           MOV    ax, word ptr [si + 0x2cf4] ; MOV
003251  8B C8                 MOV    cx, ax ; MOV
003253  F6 C4 80              TEST   ah, 0x80 ; LOGIC
003256  75 0D                 JNE    0x3265 ; CJUMP
003258  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
00325B  39 46 EC              CMP    word ptr [bp - 0x14], ax ; CMP
00325E  7C 1F                 JL     0x327f ; CJUMP
003260  F6 C5 40              TEST   ch, 0x40 ; LOGIC
003263  75 1A                 JNE    0x327f ; CJUMP
003265  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
003269  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
00326D  FF 76 D8              PUSH   word ptr [bp - 0x28] ; PUSH_GLOBAL
003270  B8 38 00              MOV    ax, 0x38 ; CONST_LOAD
003273  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
003277  8B 56 D6              MOV    dx, word ptr [bp - 0x2a] ; LOCAL_LOAD
00327A  9A 0A 00 36 0C        LCALL  0xc36, 0xa ; LCALL
00327F  8A 4E E4              MOV    cl, byte ptr [bp - 0x1c] ; LOCAL_LOAD
003282  8B 5E EA              MOV    bx, word ptr [bp - 0x16] ; LOCAL_LOAD
003285  D1 E3                 SHL    bx, 1 ; LOGIC
003287  8B 87 CE 2C           MOV    ax, word ptr [bx + 0x2cce] ; MOV
00328B  D3 F8                 SAR    ax, cl ; LOGIC
00328D  48                    DEC    ax ; ARITH
00328E  3B 46 EC              CMP    ax, word ptr [bp - 0x14] ; CMP
003291  7E 06                 JLE    0x3299 ; CJUMP
003293  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
003296  01 46 D6              ADD    word ptr [bp - 0x2a], ax ; ARITH
003299  FF 46 EC              INC    word ptr [bp - 0x14] ; ARITH
00329C  8A 4E E4              MOV    cl, byte ptr [bp - 0x1c] ; LOCAL_LOAD
00329F  8B 5E EA              MOV    bx, word ptr [bp - 0x16] ; LOCAL_LOAD
0032A2  D1 E3                 SHL    bx, 1 ; LOGIC
0032A4  8B 87 CE 2C           MOV    ax, word ptr [bx + 0x2cce] ; MOV
0032A8  D3 F8                 SAR    ax, cl ; LOGIC
0032AA  3B 46 EC              CMP    ax, word ptr [bp - 0x14] ; CMP
0032AD  7E 39                 JLE    0x32e8 ; CJUMP
0032AF  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
0032B2  39 46 EC              CMP    word ptr [bp - 0x14], ax ; CMP
0032B5  75 06                 JNE    0x32bd ; CJUMP
0032B7  8B 46 D6              MOV    ax, word ptr [bp - 0x2a] ; LOCAL_LOAD
0032BA  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
0032BD  8B 5E EA              MOV    bx, word ptr [bp - 0x16] ; LOCAL_LOAD
0032C0  D1 E3                 SHL    bx, 1 ; LOGIC
0032C2  F6 87 F5 2C 40        TEST   byte ptr [bx + 0x2cf5], 0x40 ; LOGIC
0032C7  75 03                 JNE    0x32cc ; CJUMP
0032C9  E9 5C FF              JMP    0x3228 ; JUMP
0032CC  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
0032CF  39 46 EC              CMP    word ptr [bp - 0x14], ax ; CMP
0032D2  7C 03                 JL     0x32d7 ; CJUMP
0032D4  E9 51 FF              JMP    0x3228 ; JUMP
0032D7  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
0032DB  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
0032DF  FF 76 D8              PUSH   word ptr [bp - 0x28] ; PUSH_GLOBAL
0032E2  B8 3A 00              MOV    ax, 0x3a ; CONST_LOAD
0032E5  EB 8C                 JMP    0x3273 ; JUMP
0032E7  90                    NOP ; NOP
0032E8  A1 70 00              MOV    ax, word ptr [0x70] ; GLOBAL_LOAD
0032EB  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0032EE  83 7E E2 01           CMP    word ptr [bp - 0x1e], 1 ; CMP
0032F2  75 11                 JNE    0x3305 ; CJUMP
0032F4  8B 5E EA              MOV    bx, word ptr [bp - 0x16] ; LOCAL_LOAD
0032F7  D1 E3                 SHL    bx, 1 ; LOGIC
0032F9  83 BF CE 2C 01        CMP    word ptr [bx + 0x2cce], 1 ; CMP
0032FE  7E 05                 JLE    0x3305 ; CJUMP
003300  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
003305  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
003309  74 71                 JE     0x337c ; CJUMP
00330B  8B 5E EA              MOV    bx, word ptr [bp - 0x16] ; LOCAL_LOAD
00330E  D1 E3                 SHL    bx, 1 ; LOGIC
003310  8B 87 E2 2C           MOV    ax, word ptr [bx + 0x2ce2] ; MOV
003314  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
003317  F6 87 F5 2C 40        TEST   byte ptr [bx + 0x2cf5], 0x40 ; LOGIC
00331C  74 08                 JE     0x3326 ; CJUMP
00331E  01 46 E6              ADD    word ptr [bp - 0x1a], ax ; ARITH
003321  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
003326  6A 01                 PUSH   1 ; STACK_PUSH
003328  8B 5E EA              MOV    bx, word ptr [bp - 0x16] ; LOCAL_LOAD
00332B  D1 E3                 SHL    bx, 1 ; LOGIC
00332D  8A A7 F5 2C           MOV    ah, byte ptr [bx + 0x2cf5] ; MOV
003331  25 00 80              AND    ax, 0x8000 ; LOGIC
003334  3D 01 00              CMP    ax, 1 ; CMP
003337  1B C0                 SBB    ax, ax ; ARITH
003339  25 03 00              AND    ax, 3 ; LOGIC
00333C  05 0C 00              ADD    ax, 0xc ; ARITH
00333F  50                    PUSH   ax ; STACK_PUSH
003340  FF 76 D8              PUSH   word ptr [bp - 0x28] ; PUSH_GLOBAL
003343  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
003346  40                    INC    ax ; ARITH
003347  40                    INC    ax ; ARITH
003348  50                    PUSH   ax ; STACK_PUSH
003349  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
00334C  8B F3                 MOV    si, bx ; MOV
00334E  0E                    PUSH   cs ; STACK_PUSH
00334F  E8 FC FA              CALL   0x2e4e ; CALL_NEAR
003352  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
003355  6A 01                 PUSH   1 ; STACK_PUSH
003357  8A A4 F5 2C           MOV    ah, byte ptr [si + 0x2cf5] ; MOV
00335B  25 00 40              AND    ax, 0x4000 ; LOGIC
00335E  3D 01 00              CMP    ax, 1 ; CMP
003361  1B C0                 SBB    ax, ax ; ARITH
003363  24 FD                 AND    al, 0xfd ; LOGIC
003365  05 0F 00              ADD    ax, 0xf ; ARITH
003368  50                    PUSH   ax ; STACK_PUSH
003369  FF 76 D8              PUSH   word ptr [bp - 0x28] ; PUSH_GLOBAL
00336C  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
00336F  40                    INC    ax ; ARITH
003370  40                    INC    ax ; ARITH
003371  50                    PUSH   ax ; STACK_PUSH
003372  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
003375  0E                    PUSH   cs ; STACK_PUSH
003376  E8 D5 FA              CALL   0x2e4e ; CALL_NEAR
003379  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
00337C  8B 5E EA              MOV    bx, word ptr [bp - 0x16] ; LOCAL_LOAD
00337F  D1 E3                 SHL    bx, 1 ; LOGIC
003381  8B B7 F4 2C           MOV    si, word ptr [bx + 0x2cf4] ; MOV
003385  81 E6 FF 0F           AND    si, 0xfff ; LOGIC
003389  8B C6                 MOV    ax, si ; MOV
00338B  D1 E6                 SHL    si, 1 ; LOGIC
00338D  03 F0                 ADD    si, ax ; ARITH
00338F  C1 E6 02              SHL    si, 2 ; LOGIC
003392  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
003396  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; MOV
00339A  2B 46 F2              SUB    ax, word ptr [bp - 0xe] ; ARITH
00339D  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
0033A0  01 46 D6              ADD    word ptr [bp - 0x2a], ax ; ARITH
0033A3  FF 46 EA              INC    word ptr [bp - 0x16] ; ARITH
0033A6  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
0033A9  39 06 E0 2C           CMP    word ptr [0x2ce0], ax ; CMP
0033AD  7E 35                 JLE    0x33e4 ; CJUMP
0033AF  83 7E DE 00           CMP    word ptr [bp - 0x22], 0 ; CMP
0033B3  75 03                 JNE    0x33b8 ; CJUMP
0033B5  E9 40 FE              JMP    0x31f8 ; JUMP
0033B8  8B D8                 MOV    bx, ax ; MOV
0033BA  D1 E3                 SHL    bx, 1 ; LOGIC
0033BC  8B B7 F4 2C           MOV    si, word ptr [bx + 0x2cf4] ; MOV
0033C0  81 E6 FF 0F           AND    si, 0xfff ; LOGIC
0033C4  8B C6                 MOV    ax, si ; MOV
0033C6  D1 E6                 SHL    si, 1 ; LOGIC
0033C8  03 F0                 ADD    si, ax ; ARITH
0033CA  C1 E6 02              SHL    si, 2 ; LOGIC
0033CD  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
0033D1  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; MOV
0033D5  40                    INC    ax ; ARITH
0033D6  3B 46 DE              CMP    ax, word ptr [bp - 0x22] ; CMP
0033D9  7E 03                 JLE    0x33de ; CJUMP
0033DB  8B 46 DE              MOV    ax, word ptr [bp - 0x22] ; LOCAL_LOAD
0033DE  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
0033E1  E9 19 FE              JMP    0x31fd ; JUMP
0033E4  5E                    POP    si ; STACK_POP
0033E5  C9                    LEAVE ; EPILOGUE
0033E6  CA 02 00              RETF   2 ; RETURN
