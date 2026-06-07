; ============================================================================
; func_0772FA_unknown
; Region   : overlay
; Bytes    : file 0x0772FA..0x0773CF  (213 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0772FA  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0772FE  53                    PUSH   bx ; STACK_PUSH
0772FF  52                    PUSH   dx ; STACK_PUSH
077300  50                    PUSH   ax ; STACK_PUSH
077301  57                    PUSH   di ; STACK_PUSH
077302  56                    PUSH   si ; STACK_PUSH
077303  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
077308  0B D2                 OR     dx, dx ; LOGIC
07730A  75 1C                 JNE    0x77328 ; CJUMP
07730C  C7 06 44 A6 10 0F     MOV    word ptr [0xa644], 0xf10 ; GLOBAL_LOAD
077312  C7 06 46 A6 1F 1A     MOV    word ptr [0xa646], 0x1a1f ; GLOBAL_LOAD
077318  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
07731B  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
07731E  A3 48 A6              MOV    word ptr [0xa648], ax ; GLOBAL_LOAD
077321  89 16 4A A6           MOV    word ptr [0xa64a], dx ; GLOBAL_LOAD
077325  EB 1D                 JMP    0x77344 ; JUMP
077327  90                    NOP ; NOP
077328  C7 06 44 A6 06 0F     MOV    word ptr [0xa644], 0xf06 ; GLOBAL_LOAD
07732E  C7 06 46 A6 1F 1A     MOV    word ptr [0xa646], 0x1a1f ; GLOBAL_LOAD
077334  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
077337  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
07733A  0E                    PUSH   cs ; STACK_PUSH
07733B  E8 A9 02              CALL   0x775e7 ; CALL_NEAR
07733E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
077341  A3 42 A6              MOV    word ptr [0xa642], ax ; GLOBAL_LOAD
077344  83 7E F8 02           CMP    word ptr [bp - 8], 2 ; CMP
077348  74 3E                 JE     0x77388 ; CJUMP
07734A  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
07734E  75 1C                 JNE    0x7736c ; CJUMP
077350  C7 06 3A A6 FC 0E     MOV    word ptr [0xa63a], 0xefc ; GLOBAL_LOAD
077356  C7 06 3C A6 1F 1A     MOV    word ptr [0xa63c], 0x1a1f ; GLOBAL_LOAD
07735C  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
07735F  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
077362  A3 3E A6              MOV    word ptr [0xa63e], ax ; GLOBAL_LOAD
077365  89 16 40 A6           MOV    word ptr [0xa640], dx ; GLOBAL_LOAD
077369  EB 1D                 JMP    0x77388 ; JUMP
07736B  90                    NOP ; NOP
07736C  C7 06 3A A6 F2 0E     MOV    word ptr [0xa63a], 0xef2 ; GLOBAL_LOAD
077372  C7 06 3C A6 1F 1A     MOV    word ptr [0xa63c], 0x1a1f ; GLOBAL_LOAD
077378  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
07737B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
07737E  0E                    PUSH   cs ; STACK_PUSH
07737F  E8 65 02              CALL   0x775e7 ; CALL_NEAR
077382  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
077385  A3 38 A6              MOV    word ptr [0xa638], ax ; GLOBAL_LOAD
077388  2B C0                 SUB    ax, ax ; ARITH
07738A  A3 2A A6              MOV    word ptr [0xa62a], ax ; GLOBAL_LOAD
07738D  A3 28 A6              MOV    word ptr [0xa628], ax ; GLOBAL_LOAD
077390  A3 36 A6              MOV    word ptr [0xa636], ax ; GLOBAL_LOAD
077393  A3 34 A6              MOV    word ptr [0xa634], ax ; GLOBAL_LOAD
077396  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
077399  0B C0                 OR     ax, ax ; LOGIC
07739B  74 2D                 JE     0x773ca ; CJUMP
07739D  48                    DEC    ax ; ARITH
07739E  75 03                 JNE    0x773a3 ; CJUMP
0773A0  E9 8D 00              JMP    0x77430 ; JUMP
0773A3  C7 06 26 A6 00 10     MOV    word ptr [0xa626], 0x1000 ; GLOBAL_LOAD
0773A9  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
0773AC  8B 56 10              MOV    dx, word ptr [bp + 0x10] ; LOCAL_LOAD
0773AF  A3 30 A6              MOV    word ptr [0xa630], ax ; GLOBAL_LOAD
0773B2  89 16 32 A6           MOV    word ptr [0xa632], dx ; GLOBAL_LOAD
0773B6  A3 2C A6              MOV    word ptr [0xa62c], ax ; GLOBAL_LOAD
0773B9  89 16 2E A6           MOV    word ptr [0xa62e], dx ; GLOBAL_LOAD
0773BD  C7 46 FA 30 A6        MOV    word ptr [bp - 6], 0xa630 ; LOCAL_STORE
0773C2  C7 46 FE 28 A6        MOV    word ptr [bp - 2], 0xa628 ; LOCAL_STORE
0773C7  E9 22 01              JMP    0x774ec ; JUMP
0773CA  83 3E CA 26 01        CMP    word ptr [0x26ca], 1 ; CMP
