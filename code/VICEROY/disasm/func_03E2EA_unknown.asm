; ============================================================================
; func_03E2EA_unknown
; Region   : overlay
; Bytes    : file 0x03E2EA..0x03E35C  (114 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03E2EA  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
03E2EE  56                    PUSH   si ; STACK_PUSH
03E2EF  6A 03                 PUSH   3 ; STACK_PUSH
03E2F1  9A AC 04 1F 18        LCALL  0x181f, 0x4ac ; THUNK -> 0x029F:0x0318 (thunk @file 0x01AA9C type B) overlay @file 0x022340
03E2F6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03E2F9  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
03E2FE  E9 C9 00              JMP    0x3e3ca ; JUMP
03E301  90                    NOP ; NOP
03E302  6B 5E F6 1C           IMUL   bx, word ptr [bp - 0xa], 0x1c ; ARITH
03E306  C6 87 46 31 07        MOV    byte ptr [bx + 0x3146], 7 ; MOV
03E30B  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
03E30E  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
03E311  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
03E316  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
03E319  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
03E31D  7E 63                 JLE    0x3e382 ; CJUMP
03E31F  0B C0                 OR     ax, ax ; LOGIC
03E321  7C 5F                 JL     0x3e382 ; CJUMP
03E323  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
03E326  80 BF 46 31 01        CMP    byte ptr [bx + 0x3146], 1 ; CMP
03E32B  74 07                 JE     0x3e334 ; CJUMP
03E32D  80 BF 46 31 04        CMP    byte ptr [bx + 0x3146], 4 ; CMP
03E332  75 DA                 JNE    0x3e30e ; CJUMP
03E334  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
03E337  80 BF 5B 31 15        CMP    byte ptr [bx + 0x315b], 0x15 ; CMP
03E33C  75 D0                 JNE    0x3e30e ; CJUMP
03E33E  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
03E341  A1 42 85              MOV    ax, word ptr [0x8542] ; GLOBAL_LOAD
03E344  40                    INC    ax ; ARITH
03E345  40                    INC    ax ; ARITH
03E346  1E                    PUSH   ds ; STACK_PUSH
03E347  50                    PUSH   ax ; STACK_PUSH
03E348  6A 00                 PUSH   0 ; STACK_PUSH
03E34A  8B F3                 MOV    si, bx ; MOV
03E34C  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
03E351  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03E354  8A 9C 46 31           MOV    bl, byte ptr [si + 0x3146] ; MOV
03E358  2A FF                 SUB    bh, bh ; ARITH
03E35A  8B C3                 MOV    ax, bx ; MOV
