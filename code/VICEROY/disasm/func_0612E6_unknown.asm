; ============================================================================
; func_0612E6_unknown
; Region   : overlay
; Bytes    : file 0x0612E6..0x061364  (126 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "TRADEDELETE"  (auto-named via string xrefs)
; ============================================================================

0612E6  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0612EA  57                    PUSH   di ; STACK_PUSH
0612EB  56                    PUSH   si ; STACK_PUSH
0612EC  68 96 1D              PUSH   0x1d96                       ; STRING: "TRADEDELETE"
0612EF  6A 00                 PUSH   0 ; STACK_PUSH
0612F1  6A 00                 PUSH   0 ; STACK_PUSH
0612F3  0E                    PUSH   cs ; STACK_PUSH
0612F4  E8 FE 00              CALL   0x613f5 ; CALL_NEAR
0612F7  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0612FA  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0612FD  0B C0                 OR     ax, ax ; LOGIC
0612FF  7D 03                 JGE    0x61304 ; CJUMP
061301  E9 E7 00              JMP    0x613eb ; JUMP
061304  50                    PUSH   ax ; STACK_PUSH
061305  0E                    PUSH   cs ; STACK_PUSH
061306  E8 E7 00              CALL   0x613f0 ; CALL_NEAR
061309  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06130C  FF 36 16 9E           PUSH   word ptr [0x9e16] ; PUSH_GLOBAL
061310  FF 36 14 9E           PUSH   word ptr [0x9e14] ; PUSH_GLOBAL
061314  6A 00                 PUSH   0 ; STACK_PUSH
061316  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
06131B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06131E  8D 1E A2 1D           LEA    bx, [0x1da2] ; ADDR
061322  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
061327  48                    DEC    ax ; ARITH
061328  74 03                 JE     0x6132d ; CJUMP
06132A  E9 BE 00              JMP    0x613eb ; JUMP
06132D  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
061332  EB 1C                 JMP    0x61350 ; JUMP
061334  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
061337  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
06133A  7E 11                 JLE    0x6134d ; CJUMP
06133C  FF 4E FC              DEC    word ptr [bp - 4] ; ARITH
06133F  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
061342  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
061345  9A 62 08 1F 18        LCALL  0x181f, 0x862 ; THUNK -> 0x0427:0x0F74 (thunk @file 0x01AE52 type B) overlay @file 0x031C88
06134A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06134D  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
061350  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
061353  39 06 9C 53           CMP    word ptr [0x539c], ax ; CMP
061357  7E 5B                 JLE    0x613b4 ; CJUMP
061359  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
06135C  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
061360  2A FF                 SUB    bh, bh ; ARITH
061362  8B C3                 MOV    ax, bx ; MOV
