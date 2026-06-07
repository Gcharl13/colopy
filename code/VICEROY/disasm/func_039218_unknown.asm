; ============================================================================
; func_039218_unknown
; Region   : overlay
; Bytes    : file 0x039218..0x03925E  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

039218  C8 68 00 00           ENTER  0x68, 0 ; PROLOGUE
03921C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03921F  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
039224  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
039227  C7 46 A6 02 00        MOV    word ptr [bp - 0x5a], 2 ; LOCAL_STORE
03922C  C7 46 A2 14 00        MOV    word ptr [bp - 0x5e], 0x14 ; LOCAL_STORE
039231  0E                    PUSH   cs ; STACK_PUSH
039232  E8 23 0C              CALL   0x39e58 ; CALL_NEAR
039235  2B C0                 SUB    ax, ax ; ARITH
039237  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
03923A  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
03923D  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
039240  E9 AB 00              JMP    0x392ee ; JUMP
039243  90                    NOP ; NOP
039244  8B 46 9C              MOV    ax, word ptr [bp - 0x64] ; LOCAL_LOAD
039247  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
03924C  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
03924F  0B C0                 OR     ax, ax ; LOGIC
039251  7C 51                 JL     0x392a4 ; CJUMP
039253  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
039256  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
03925A  2A FF                 SUB    bh, bh ; ARITH
03925C  8B C3                 MOV    ax, bx ; MOV
