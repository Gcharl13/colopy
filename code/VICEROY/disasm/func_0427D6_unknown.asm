; ============================================================================
; func_0427D6_unknown
; Region   : overlay
; Bytes    : file 0x0427D6..0x04288E  (184 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0427D6  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0427DA  56                    PUSH   si ; STACK_PUSH
0427DB  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0427DE  05 04 00              ADD    ax, 4 ; ARITH
0427E1  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0427E4  2A C0                 SUB    al, al ; ARITH
0427E6  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0427E9  88 87 84 91           MOV    byte ptr [bx - 0x6e7c], al ; MOV
0427ED  88 87 22 96           MOV    byte ptr [bx - 0x69de], al ; MOV
0427F1  88 87 2A 96           MOV    byte ptr [bx - 0x69d6], al ; MOV
0427F5  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
0427FA  2A C0                 SUB    al, al ; ARITH
0427FC  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0427FF  C1 E6 04              SHL    si, 4 ; LOGIC
042802  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
042805  88 80 CC 91           MOV    byte ptr [bx + si - 0x6e34], al ; MOV
042809  88 87 7E 94           MOV    byte ptr [bx - 0x6b82], al ; MOV
04280D  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
042810  83 7E FA 10           CMP    word ptr [bp - 6], 0x10 ; CMP
042814  7C E4                 JL     0x427fa ; CJUMP
042816  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
04281B  EB 3E                 JMP    0x4285b ; JUMP
04281D  90                    NOP ; NOP
04281E  50                    PUSH   ax ; STACK_PUSH
04281F  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
042824  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
042827  8A 46 F8              MOV    al, byte ptr [bp - 8] ; LOCAL_LOAD
04282A  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04282E  38 47 02              CMP    byte ptr [bx + 2], al ; CMP
042831  75 25                 JNE    0x42858 ; CJUMP
042833  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
042836  FE 84 2A 96           INC    byte ptr [si - 0x69d6] ; ARITH
04283A  8A 47 04              MOV    al, byte ptr [bx + 4] ; MOV
04283D  00 84 22 96           ADD    byte ptr [si - 0x69de], al ; ARITH
042841  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
042844  2A E4                 SUB    ah, ah ; ARITH
042846  50                    PUSH   ax ; STACK_PUSH
042847  8A 07                 MOV    al, byte ptr [bx] ; MOV
042849  50                    PUSH   ax ; STACK_PUSH
04284A  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
04284F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
042852  8B D8                 MOV    bx, ax ; MOV
042854  FE 87 7E 94           INC    byte ptr [bx - 0x6b82] ; ARITH
042858  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
04285B  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
04285E  39 06 9A 53           CMP    word ptr [0x539a], ax ; CMP
042862  7F BA                 JG     0x4281e ; CJUMP
042864  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
042869  EB 4E                 JMP    0x428b9 ; JUMP
04286B  90                    NOP ; NOP
04286C  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
04286F  8A 8F 47 31           MOV    cl, byte ptr [bx + 0x3147] ; MOV
042873  80 E1 0F              AND    cl, 0xf ; LOGIC
042876  3A 4E F8              CMP    cl, byte ptr [bp - 8] ; CMP
042879  75 3B                 JNE    0x428b6 ; CJUMP
04287B  6A 01                 PUSH   1 ; STACK_PUSH
04287D  50                    PUSH   ax ; STACK_PUSH
04287E  9A C8 09 1F 18        LCALL  0x181f, 0x9c8 ; THUNK -> 0x057E:0x004A (thunk @file 0x01AFB8 type B) overlay @file 0x0305A8
042883  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
042886  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
042889  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04288C  81                    DB     0x81 ; DATA_BYTE
04288D  C3                    DB     0xC3 ; DATA_BYTE
