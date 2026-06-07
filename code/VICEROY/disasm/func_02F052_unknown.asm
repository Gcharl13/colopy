; ============================================================================
; func_02F052_unknown
; Region   : overlay
; Bytes    : file 0x02F052..0x02F0C7  (117 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02F052  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
02F056  57                    PUSH   di ; STACK_PUSH
02F057  56                    PUSH   si ; STACK_PUSH
02F058  A1 94 53              MOV    ax, word ptr [0x5394] ; GLOBAL_LOAD
02F05B  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
02F05E  8B D8                 MOV    bx, ax ; MOV
02F060  8A 87 48 08           MOV    al, byte ptr [bx + 0x848] ; MOV
02F064  2A E4                 SUB    ah, ah ; ARITH
02F066  50                    PUSH   ax ; STACK_PUSH
02F067  9A 90 05 1F 18        LCALL  0x181f, 0x590 ; THUNK -> 0x0984:0x00AA (thunk @file 0x01AB80 type B) overlay @file 0x031FC0
02F06C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02F06F  2B C0                 SUB    ax, ax ; ARITH
02F071  A3 4C 01              MOV    word ptr [0x14c], ax ; GLOBAL_LOAD
02F074  C7 06 4E 01 FF FF     MOV    word ptr [0x14e], 0xffff ; GLOBAL_LOAD
02F07A  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
02F07D  48                    DEC    ax ; ARITH
02F07E  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
02F081  EB 16                 JMP    0x2f099 ; JUMP
02F083  90                    NOP ; NOP
02F084  6B 5E FA 1C           IMUL   bx, word ptr [bp - 6], 0x1c ; ARITH
02F088  F6 87 48 31 80        TEST   byte ptr [bx + 0x3148], 0x80 ; LOGIC
02F08D  74 07                 JE     0x2f096 ; CJUMP
02F08F  80 BF 46 31 0B        CMP    byte ptr [bx + 0x3146], 0xb ; CMP
02F094  75 46                 JNE    0x2f0dc ; CJUMP
02F096  FF 4E FA              DEC    word ptr [bp - 6] ; ARITH
02F099  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
02F09D  7D 03                 JGE    0x2f0a2 ; CJUMP
02F09F  E9 68 01              JMP    0x2f20a ; JUMP
02F0A2  6B 5E FA 1C           IMUL   bx, word ptr [bp - 6], 0x1c ; ARITH
02F0A6  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
02F0AA  24 0F                 AND    al, 0xf ; LOGIC
02F0AC  3A 46 F8              CMP    al, byte ptr [bp - 8] ; CMP
02F0AF  75 E5                 JNE    0x2f096 ; CJUMP
02F0B1  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
02F0B4  9A A0 07 1F 18        LCALL  0x181f, 0x7a0 ; THUNK -> 0x03F1:0x02F8 (thunk @file 0x01AD90 type B) overlay @file 0x022586
02F0B9  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
02F0BC  0E                    PUSH   cs ; STACK_PUSH
02F0BD  E8 2A 0A              CALL   0x2faea ; CALL_NEAR
02F0C0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02F0C3  0B C0                 OR     ax, ax ; LOGIC
02F0C5  74 CF                 JE     0x2f096 ; CJUMP
