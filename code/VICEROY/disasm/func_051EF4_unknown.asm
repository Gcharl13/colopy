; ============================================================================
; func_051EF4_unknown
; Region   : overlay
; Bytes    : file 0x051EF4..0x052339  (1093 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

051EF4  C8 44 00 00           ENTER  0x44, 0 ; PROLOGUE
051EF8  57                    PUSH   di ; STACK_PUSH
051EF9  56                    PUSH   si ; STACK_PUSH
051EFA  2B C0                 SUB    ax, ax ; ARITH
051EFC  89 46 DA              MOV    word ptr [bp - 0x26], ax ; LOCAL_STORE
051EFF  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
051F02  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
051F05  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
051F08  89 46 CE              MOV    word ptr [bp - 0x32], ax ; LOCAL_STORE
051F0B  89 46 D0              MOV    word ptr [bp - 0x30], ax ; LOCAL_STORE
051F0E  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
051F11  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
051F14  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
051F17  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
051F1C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
051F1F  A1 8A 53              MOV    ax, word ptr [0x538a] ; GLOBAL_LOAD
051F22  2D DC 05              SUB    ax, 0x5dc ; ARITH
051F25  B9 32 00              MOV    cx, 0x32 ; CONST_LOAD
051F28  99                    CDQ ; ARITH
051F29  F7 F9                 IDIV   cx ; ARITH
051F2B  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
051F2E  8A 8F 98 92           MOV    cl, byte ptr [bx - 0x6d68] ; MOV
051F32  2A ED                 SUB    ch, ch ; ARITH
051F34  03 C8                 ADD    cx, ax ; ARITH
051F36  89 4E F0              MOV    word ptr [bp - 0x10], cx ; LOCAL_STORE
051F39  83 3E 8E 53 14        CMP    word ptr [0x538e], 0x14 ; CMP
051F3E  7D 05                 JGE    0x51f45 ; CJUMP
051F40  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
051F45  81 3E 8A 53 A4 06     CMP    word ptr [0x538a], 0x6a4 ; CMP
051F4B  7C 03                 JL     0x51f50 ; CJUMP
051F4D  D1 66 F0              SHL    word ptr [bp - 0x10], 1 ; LOGIC
051F50  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
051F53  2A E4                 SUB    ah, ah ; ARITH
051F55  F7 6E F0              IMUL   word ptr [bp - 0x10] ; ARITH
051F58  89 46 D4              MOV    word ptr [bp - 0x2c], ax ; LOCAL_STORE
051F5B  80 3E A6 53 03        CMP    byte ptr [0x53a6], 3 ; CMP
051F60  75 08                 JNE    0x51f6a ; CJUMP
051F62  D1 F8                 SAR    ax, 1 ; LOGIC
051F64  03 46 D4              ADD    ax, word ptr [bp - 0x2c] ; ARITH
051F67  89 46 D4              MOV    word ptr [bp - 0x2c], ax ; LOCAL_STORE
051F6A  80 3E A6 53 04        CMP    byte ptr [0x53a6], 4 ; CMP
051F6F  75 03                 JNE    0x51f74 ; CJUMP
051F71  D1 66 D4              SHL    word ptr [bp - 0x2c], 1 ; LOGIC
051F74  C1 66 D4 02           SHL    word ptr [bp - 0x2c], 2 ; LOGIC
051F78  8B 46 D4              MOV    ax, word ptr [bp - 0x2c] ; LOCAL_LOAD
051F7B  99                    CDQ ; ARITH
051F7C  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
051F80  01 47 2A              ADD    word ptr [bx + 0x2a], ax ; ARITH
051F83  11 57 2C              ADC    word ptr [bx + 0x2c], dx ; ARITH
051F86  C7 46 CC 00 00        MOV    word ptr [bp - 0x34], 0 ; LOCAL_STORE
051F8B  EB 34                 JMP    0x51fc1 ; JUMP
051F8D  90                    NOP ; NOP
051F8E  83 7E EE 00           CMP    word ptr [bp - 0x12], 0 ; CMP
051F92  75 35                 JNE    0x51fc9 ; CJUMP
051F94  FF 76 CC              PUSH   word ptr [bp - 0x34] ; PUSH_GLOBAL
051F97  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
051F9C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
051F9F  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
051FA2  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
051FA6  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
051FA9  75 13                 JNE    0x51fbe ; CJUMP
051FAB  6A 0D                 PUSH   0xd ; PUSH_CONST
051FAD  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
051FB2  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
051FB5  0B C0                 OR     ax, ax ; LOGIC
051FB7  74 05                 JE     0x51fbe ; CJUMP
051FB9  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1 ; LOCAL_STORE
051FBE  FF 46 CC              INC    word ptr [bp - 0x34] ; ARITH
051FC1  A1 9E 53              MOV    ax, word ptr [0x539e] ; GLOBAL_LOAD
051FC4  39 46 CC              CMP    word ptr [bp - 0x34], ax ; CMP
051FC7  7C C5                 JL     0x51f8e ; CJUMP
051FC9  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
051FCE  74 47                 JE     0x52017 ; CJUMP
051FD0  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
051FD3  2D 14 00              SUB    ax, 0x14 ; ARITH
051FD6  8B D0                 MOV    dx, ax ; MOV
051FD8  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
051FDD  EB 09                 JMP    0x51fe8 ; JUMP
051FDF  90                    NOP ; NOP
051FE0  8B 46 BE              MOV    ax, word ptr [bp - 0x42] ; LOCAL_LOAD
051FE3  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
051FE8  89 46 BE              MOV    word ptr [bp - 0x42], ax ; LOCAL_STORE
051FEB  0B C0                 OR     ax, ax ; LOGIC
051FED  7C 28                 JL     0x52017 ; CJUMP
051FEF  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
051FF2  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
051FF6  24 0F                 AND    al, 0xf ; LOGIC
051FF8  3A 46 06              CMP    al, byte ptr [bp + 6] ; CMP
051FFB  75 E3                 JNE    0x51fe0 ; CJUMP
051FFD  6B 5E BE 1C           IMUL   bx, word ptr [bp - 0x42], 0x1c ; ARITH
052001  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
052006  75 D8                 JNE    0x51fe0 ; CJUMP
052008  FF 76 BE              PUSH   word ptr [bp - 0x42] ; PUSH_GLOBAL
05200B  9A 08 08 1F 18        LCALL  0x181f, 0x808 ; THUNK -> 0x0427:0x0824 (thunk @file 0x01ADF8 type B) overlay @file 0x031538
052010  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
052013  FF 06 DE 53           INC    word ptr [0x53de] ; ARITH
052017  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
05201A  80 BF 18 94 01        CMP    byte ptr [bx - 0x6be8], 1 ; CMP
05201F  73 05                 JAE    0x52026 ; CJUMP
052021  B8 01 00              MOV    ax, 1 ; MOV
052024  EB 02                 JMP    0x52028 ; JUMP
052026  2B C0                 SUB    ax, ax ; ARITH
052028  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
05202B  2B C0                 SUB    ax, ax ; ARITH
05202D  89 46 C6              MOV    word ptr [bp - 0x3a], ax ; LOCAL_STORE
052030  89 46 CC              MOV    word ptr [bp - 0x34], ax ; LOCAL_STORE
052033  EB 23                 JMP    0x52058 ; JUMP
052035  90                    NOP ; NOP
052036  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
052039  39 46 CC              CMP    word ptr [bp - 0x34], ax ; CMP
05203C  74 17                 JE     0x52055 ; CJUMP
05203E  6B 5E CC 13           IMUL   bx, word ptr [bp - 0x34], 0x13 ; ARITH
052042  8A 87 5C 92           MOV    al, byte ptr [bx - 0x6da4] ; MOV
052046  2A E4                 SUB    ah, ah ; ARITH
052048  01 46 C6              ADD    word ptr [bp - 0x3a], ax ; ARITH
05204B  8A 87 5D 92           MOV    al, byte ptr [bx - 0x6da3] ; MOV
05204F  C1 E0 02              SHL    ax, 2 ; LOGIC
052052  01 46 C6              ADD    word ptr [bp - 0x3a], ax ; ARITH
052055  FF 46 CC              INC    word ptr [bp - 0x34] ; ARITH
052058  83 7E CC 04           CMP    word ptr [bp - 0x34], 4 ; CMP
05205C  7C D8                 JL     0x52036 ; CJUMP
05205E  C1 7E C6 02           SAR    word ptr [bp - 0x3a], 2 ; LOGIC
052062  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
052067  74 05                 JE     0x5206e ; CJUMP
052069  C7 46 C6 00 00        MOV    word ptr [bp - 0x3a], 0 ; LOCAL_STORE
05206E  80 3E 9B A8 00        CMP    byte ptr [0xa89b], 0 ; CMP
052073  75 07                 JNE    0x5207c ; CJUMP
052075  80 3E 9A A8 00        CMP    byte ptr [0xa89a], 0 ; CMP
05207A  74 5C                 JE     0x520d8 ; CJUMP
05207C  83 7E C6 00           CMP    word ptr [bp - 0x3a], 0 ; CMP
052080  74 56                 JE     0x520d8 ; CJUMP
052082  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
052085  8A 87 98 92           MOV    al, byte ptr [bx - 0x6d68] ; MOV
052089  D0 E8                 SHR    al, 1 ; LOGIC
05208B  3A 06 9B A8           CMP    al, byte ptr [0xa89b] ; CMP
05208F  76 29                 JBE    0x520ba ; CJUMP
052091  8A 87 0C 94           MOV    al, byte ptr [bx - 0x6bf4] ; MOV
052095  D0 E8                 SHR    al, 1 ; LOGIC
052097  2A E4                 SUB    ah, ah ; ARITH
052099  3B 06 52 9E           CMP    ax, word ptr [0x9e52] ; CMP
05209D  7E 1B                 JLE    0x520ba ; CJUMP
05209F  81 3E 8E 53 C8 00     CMP    word ptr [0x538e], 0xc8 ; CMP
0520A5  7E 31                 JLE    0x520d8 ; CJUMP
0520A7  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
0520AB  83 7F 2C 00           CMP    word ptr [bx + 0x2c], 0 ; CMP
0520AF  7C 27                 JL     0x520d8 ; CJUMP
0520B1  7F 07                 JG     0x520ba ; CJUMP
0520B3  81 7F 2A D0 07        CMP    word ptr [bx + 0x2a], 0x7d0 ; CMP
0520B8  72 1E                 JB     0x520d8 ; CJUMP
0520BA  6B 5E 06 13           IMUL   bx, word ptr [bp + 6], 0x13 ; ARITH
0520BE  80 BF 5D 92 00        CMP    byte ptr [bx - 0x6da3], 0 ; CMP
0520C3  75 13                 JNE    0x520d8 ; CJUMP
0520C5  6B 1E 98 53 13        IMUL   bx, word ptr [0x5398], 0x13 ; ARITH
0520CA  80 BF 5D 92 00        CMP    byte ptr [bx - 0x6da3], 0 ; CMP
0520CF  74 07                 JE     0x520d8 ; CJUMP
0520D1  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1 ; LOCAL_STORE
0520D6  EB 05                 JMP    0x520dd ; JUMP
0520D8  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
0520DD  80 3E 9B A8 00        CMP    byte ptr [0xa89b], 0 ; CMP
0520E2  75 07                 JNE    0x520eb ; CJUMP
0520E4  80 3E 9A A8 00        CMP    byte ptr [0xa89a], 0 ; CMP
0520E9  74 61                 JE     0x5214c ; CJUMP
0520EB  83 7E C6 00           CMP    word ptr [bp - 0x3a], 0 ; CMP
0520EF  74 5B                 JE     0x5214c ; CJUMP
0520F1  83 7E F4 00           CMP    word ptr [bp - 0xc], 0 ; CMP
0520F5  75 55                 JNE    0x5214c ; CJUMP
0520F7  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0520FA  8A 87 98 92           MOV    al, byte ptr [bx - 0x6d68] ; MOV
0520FE  D0 E8                 SHR    al, 1 ; LOGIC
052100  3A 06 9A A8           CMP    al, byte ptr [0xa89a] ; CMP
052104  76 28                 JBE    0x5212e ; CJUMP
052106  8A 87 0C 94           MOV    al, byte ptr [bx - 0x6bf4] ; MOV
05210A  D0 E8                 SHR    al, 1 ; LOGIC
05210C  2A E4                 SUB    ah, ah ; ARITH
05210E  3B 06 54 9E           CMP    ax, word ptr [0x9e54] ; CMP
052112  7E 1A                 JLE    0x5212e ; CJUMP
052114  83 3E 8E 53 64        CMP    word ptr [0x538e], 0x64 ; CMP
052119  7E 31                 JLE    0x5214c ; CJUMP
05211B  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
05211F  83 7F 2C 00           CMP    word ptr [bx + 0x2c], 0 ; CMP
052123  7C 27                 JL     0x5214c ; CJUMP
052125  7F 07                 JG     0x5212e ; CJUMP
052127  81 7F 2A E8 03        CMP    word ptr [bx + 0x2a], 0x3e8 ; CMP
05212C  72 1E                 JB     0x5214c ; CJUMP
05212E  6B 5E 06 13           IMUL   bx, word ptr [bp + 6], 0x13 ; ARITH
052132  80 BF 5C 92 02        CMP    byte ptr [bx - 0x6da4], 2 ; CMP
052137  73 13                 JAE    0x5214c ; CJUMP
052139  6B 1E 98 53 13        IMUL   bx, word ptr [0x5398], 0x13 ; ARITH
05213E  80 BF 5C 92 00        CMP    byte ptr [bx - 0x6da4], 0 ; CMP
052143  74 07                 JE     0x5214c ; CJUMP
052145  C7 46 F2 01 00        MOV    word ptr [bp - 0xe], 1 ; LOCAL_STORE
05214A  EB 05                 JMP    0x52151 ; JUMP
05214C  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
052151  83 7E E2 00           CMP    word ptr [bp - 0x1e], 0 ; CMP
052155  74 1A                 JE     0x52171 ; CJUMP
052157  A1 96 97              MOV    ax, word ptr [0x9796] ; GLOBAL_LOAD
05215A  99                    CDQ ; ARITH
05215B  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
05215F  39 57 2C              CMP    word ptr [bx + 0x2c], dx ; CMP
052162  7F 0D                 JG     0x52171 ; CJUMP
052164  7C 05                 JL     0x5216b ; CJUMP
052166  39 47 2A              CMP    word ptr [bx + 0x2a], ax ; CMP
052169  73 06                 JAE    0x52171 ; CJUMP
05216B  89 47 2A              MOV    word ptr [bx + 0x2a], ax ; MOV
05216E  89 57 2C              MOV    word ptr [bx + 0x2c], dx ; MOV
052171  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
052175  74 1A                 JE     0x52191 ; CJUMP
052177  A1 A8 97              MOV    ax, word ptr [0x97a8] ; GLOBAL_LOAD
05217A  99                    CDQ ; ARITH
05217B  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
05217F  39 57 2C              CMP    word ptr [bx + 0x2c], dx ; CMP
052182  7F 0D                 JG     0x52191 ; CJUMP
052184  7C 05                 JL     0x5218b ; CJUMP
052186  39 47 2A              CMP    word ptr [bx + 0x2a], ax ; CMP
052189  73 06                 JAE    0x52191 ; CJUMP
05218B  89 47 2A              MOV    word ptr [bx + 0x2a], ax ; MOV
05218E  89 57 2C              MOV    word ptr [bx + 0x2c], dx ; MOV
052191  83 7E F4 00           CMP    word ptr [bp - 0xc], 0 ; CMP
052195  74 1A                 JE     0x521b1 ; CJUMP
052197  A1 AE 97              MOV    ax, word ptr [0x97ae] ; GLOBAL_LOAD
05219A  99                    CDQ ; ARITH
05219B  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
05219F  39 57 2C              CMP    word ptr [bx + 0x2c], dx ; CMP
0521A2  7F 0D                 JG     0x521b1 ; CJUMP
0521A4  7C 05                 JL     0x521ab ; CJUMP
0521A6  39 47 2A              CMP    word ptr [bx + 0x2a], ax ; CMP
0521A9  73 06                 JAE    0x521b1 ; CJUMP
0521AB  89 47 2A              MOV    word ptr [bx + 0x2a], ax ; MOV
0521AE  89 57 2C              MOV    word ptr [bx + 0x2c], dx ; MOV
0521B1  2B C0                 SUB    ax, ax ; ARITH
0521B3  89 46 DC              MOV    word ptr [bp - 0x24], ax ; LOCAL_STORE
0521B6  89 46 D2              MOV    word ptr [bp - 0x2e], ax ; LOCAL_STORE
0521B9  89 46 CC              MOV    word ptr [bp - 0x34], ax ; LOCAL_STORE
0521BC  EB 17                 JMP    0x521d5 ; JUMP
0521BE  8B 5E CC              MOV    bx, word ptr [bp - 0x34] ; LOCAL_LOAD
0521C1  8A 87 24 94           MOV    al, byte ptr [bx - 0x6bdc] ; MOV
0521C5  2A E4                 SUB    ah, ah ; ARITH
0521C7  3B 46 D2              CMP    ax, word ptr [bp - 0x2e] ; CMP
0521CA  7D 03                 JGE    0x521cf ; CJUMP
0521CC  8B 46 D2              MOV    ax, word ptr [bp - 0x2e] ; LOCAL_LOAD
0521CF  89 46 D2              MOV    word ptr [bp - 0x2e], ax ; LOCAL_STORE
0521D2  FF 46 CC              INC    word ptr [bp - 0x34] ; ARITH
0521D5  83 7E CC 04           CMP    word ptr [bp - 0x34], 4 ; CMP
0521D9  7C E3                 JL     0x521be ; CJUMP
0521DB  C7 46 CC 00 00        MOV    word ptr [bp - 0x34], 0 ; LOCAL_STORE
0521E0  8B 5E CC              MOV    bx, word ptr [bp - 0x34] ; LOCAL_LOAD
0521E3  8A 87 24 94           MOV    al, byte ptr [bx - 0x6bdc] ; MOV
0521E7  2A E4                 SUB    ah, ah ; ARITH
0521E9  3B 46 D2              CMP    ax, word ptr [bp - 0x2e] ; CMP
0521EC  75 03                 JNE    0x521f1 ; CJUMP
0521EE  FF 46 DC              INC    word ptr [bp - 0x24] ; ARITH
0521F1  FF 46 CC              INC    word ptr [bp - 0x34] ; ARITH
0521F4  83 7E CC 04           CMP    word ptr [bp - 0x34], 4 ; CMP
0521F8  7C E6                 JL     0x521e0 ; CJUMP
0521FA  83 7E F4 00           CMP    word ptr [bp - 0xc], 0 ; CMP
0521FE  75 14                 JNE    0x52214 ; CJUMP
052200  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
052203  8A 87 24 94           MOV    al, byte ptr [bx - 0x6bdc] ; MOV
052207  2A E4                 SUB    ah, ah ; ARITH
052209  3B 46 D2              CMP    ax, word ptr [bp - 0x2e] ; CMP
05220C  7C 06                 JL     0x52214 ; CJUMP
05220E  83 7E DC 01           CMP    word ptr [bp - 0x24], 1 ; CMP
052212  7E 08                 JLE    0x5221c ; CJUMP
052214  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
052219  EB 06                 JMP    0x52221 ; JUMP
05221B  90                    NOP ; NOP
05221C  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
052221  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
052224  8A 87 10 94           MOV    al, byte ptr [bx - 0x6bf0] ; MOV
052228  D0 E8                 SHR    al, 1 ; LOGIC
05222A  2A E4                 SUB    ah, ah ; ARITH
05222C  8A 8F 98 92           MOV    cl, byte ptr [bx - 0x6d68] ; MOV
052230  2A ED                 SUB    ch, ch ; ARITH
052232  D1 E1                 SHL    cx, 1 ; LOGIC
052234  03 C1                 ADD    ax, cx ; ARITH
052236  D1 F8                 SAR    ax, 1 ; LOGIC
052238  3A 87 14 94           CMP    al, byte ptr [bx - 0x6bec] ; CMP
05223C  72 0C                 JB     0x5224a ; CJUMP
05223E  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
052243  75 05                 JNE    0x5224a ; CJUMP
052245  C7 46 D0 01 00        MOV    word ptr [bp - 0x30], 1 ; LOCAL_STORE
05224A  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
05224F  74 03                 JE     0x52254 ; CJUMP
052251  E9 42 01              JMP    0x52396 ; JUMP
052254  8A 87 10 94           MOV    al, byte ptr [bx - 0x6bf0] ; MOV
052258  D0 E8                 SHR    al, 1 ; LOGIC
05225A  2A E4                 SUB    ah, ah ; ARITH
05225C  8A 8F 98 92           MOV    cl, byte ptr [bx - 0x6d68] ; MOV
052260  2A ED                 SUB    ch, ch ; ARITH
052262  03 C1                 ADD    ax, cx ; ARITH
052264  8A 8F 14 94           MOV    cl, byte ptr [bx - 0x6bec] ; MOV
052268  3B C1                 CMP    ax, cx ; CMP
05226A  7D 03                 JGE    0x5226f ; CJUMP
05226C  E9 27 01              JMP    0x52396 ; JUMP
05226F  C7 46 C4 00 00        MOV    word ptr [bp - 0x3c], 0 ; LOCAL_STORE
052274  83 7E F4 00           CMP    word ptr [bp - 0xc], 0 ; CMP
052278  74 0E                 JE     0x52288 ; CJUMP
05227A  6A 64                 PUSH   0x64 ; PUSH_CONST
05227C  6A 05                 PUSH   5 ; STACK_PUSH
05227E  0E                    PUSH   cs ; STACK_PUSH
05227F  E8 7B 12              CALL   0x534fd ; CALL_NEAR
052282  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
052285  89 46 C4              MOV    word ptr [bp - 0x3c], ax ; LOCAL_STORE
052288  83 7E C4 00           CMP    word ptr [bp - 0x3c], 0 ; CMP
05228C  75 09                 JNE    0x52297 ; CJUMP
05228E  83 7E F4 00           CMP    word ptr [bp - 0xc], 0 ; CMP
052292  74 03                 JE     0x52297 ; CJUMP
052294  E9 E2 0C              JMP    0x52f79 ; JUMP
052297  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
05229B  74 0E                 JE     0x522ab ; CJUMP
05229D  6A 64                 PUSH   0x64 ; PUSH_CONST
05229F  6A 04                 PUSH   4 ; STACK_PUSH
0522A1  0E                    PUSH   cs ; STACK_PUSH
0522A2  E8 58 12              CALL   0x534fd ; CALL_NEAR
0522A5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0522A8  89 46 C4              MOV    word ptr [bp - 0x3c], ax ; LOCAL_STORE
0522AB  83 7E C4 00           CMP    word ptr [bp - 0x3c], 0 ; CMP
0522AF  75 09                 JNE    0x522ba ; CJUMP
0522B1  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
0522B5  74 03                 JE     0x522ba ; CJUMP
0522B7  E9 BF 0C              JMP    0x52f79 ; JUMP
0522BA  83 7E C4 00           CMP    word ptr [bp - 0x3c], 0 ; CMP
0522BE  75 2E                 JNE    0x522ee ; CJUMP
0522C0  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0522C3  80 BF 24 94 08        CMP    byte ptr [bx - 0x6bdc], 8 ; CMP
0522C8  73 24                 JAE    0x522ee ; CJUMP
0522CA  6A 01                 PUSH   1 ; STACK_PUSH
0522CC  6A 00                 PUSH   0 ; STACK_PUSH
0522CE  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
0522D3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0522D6  0B C0                 OR     ax, ax ; LOGIC
0522D8  74 14                 JE     0x522ee ; CJUMP
0522DA  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
0522DE  74 0E                 JE     0x522ee ; CJUMP
0522E0  6A 23                 PUSH   0x23 ; PUSH_CONST
0522E2  6A 05                 PUSH   5 ; STACK_PUSH
0522E4  0E                    PUSH   cs ; STACK_PUSH
0522E5  E8 15 12              CALL   0x534fd ; CALL_NEAR
0522E8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0522EB  89 46 C4              MOV    word ptr [bp - 0x3c], ax ; LOCAL_STORE
0522EE  83 7E C4 00           CMP    word ptr [bp - 0x3c], 0 ; CMP
0522F2  75 1E                 JNE    0x52312 ; CJUMP
0522F4  6A 03                 PUSH   3 ; STACK_PUSH
0522F6  6A 00                 PUSH   0 ; STACK_PUSH
0522F8  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
0522FD  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
052300  0B C0                 OR     ax, ax ; LOGIC
052302  74 0E                 JE     0x52312 ; CJUMP
052304  6A 32                 PUSH   0x32 ; PUSH_CONST
052306  6A 03                 PUSH   3 ; STACK_PUSH
052308  0E                    PUSH   cs ; STACK_PUSH
052309  E8 F1 11              CALL   0x534fd ; CALL_NEAR
05230C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05230F  89 46 C4              MOV    word ptr [bp - 0x3c], ax ; LOCAL_STORE
052312  83 7E C4 00           CMP    word ptr [bp - 0x3c], 0 ; CMP
052316  75 28                 JNE    0x52340 ; CJUMP
052318  6A 01                 PUSH   1 ; STACK_PUSH
05231A  6A 00                 PUSH   0 ; STACK_PUSH
05231C  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
052321  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
052324  0B C0                 OR     ax, ax ; LOGIC
052326  75 18                 JNE    0x52340 ; CJUMP
052328  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
05232B  80 BF 14 94 0C        CMP    byte ptr [bx - 0x6bec], 0xc ; CMP
052330  73 0E                 JAE    0x52340 ; CJUMP
052332  6A 14                 PUSH   0x14 ; PUSH_CONST
052334  6A 02                 PUSH   2 ; STACK_PUSH
052336  0E                    PUSH   cs ; STACK_PUSH
052337  E8                    DB     0xE8 ; DATA_BYTE
052338  C3                    DB     0xC3 ; DATA_BYTE
