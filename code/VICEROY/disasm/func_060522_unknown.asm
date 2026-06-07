; ============================================================================
; func_060522_unknown
; Region   : overlay
; Bytes    : file 0x060522..0x060566  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

060522  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
060526  57                    PUSH   di ; STACK_PUSH
060527  56                    PUSH   si ; STACK_PUSH
060528  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
06052D  EB 1C                 JMP    0x6054b ; JUMP
06052F  90                    NOP ; NOP
060530  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
060533  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
060536  7E 10                 JLE    0x60548 ; CJUMP
060538  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
06053B  48                    DEC    ax ; ARITH
06053C  50                    PUSH   ax ; STACK_PUSH
06053D  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
060540  9A B2 08 1F 18        LCALL  0x181f, 0x8b2 ; THUNK -> 0x0427:0x0FA0 (thunk @file 0x01AEA2 type B) overlay @file 0x031CB4
060545  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
060548  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
06054B  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
06054E  39 06 9C 53           CMP    word ptr [0x539c], ax ; CMP
060552  7E 66                 JLE    0x605ba ; CJUMP
060554  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
060557  8A 8F 47 31           MOV    cl, byte ptr [bx + 0x3147] ; MOV
06055B  80 E1 0F              AND    cl, 0xf ; LOGIC
06055E  3A 0E 94 53           CMP    cl, byte ptr [0x5394] ; CMP
060562  75 E4                 JNE    0x60548 ; CJUMP
060564  8B CB                 MOV    cx, bx ; MOV
