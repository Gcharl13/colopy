; ============================================================================
; func_0603DA_unknown
; Region   : overlay
; Bytes    : file 0x0603DA..0x0603EC  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0603DA  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0603DE  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0603E1  0E                    PUSH   cs ; STACK_PUSH
0603E2  E8 5B 10              CALL   0x61440 ; CALL_NEAR
0603E5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0603E8  8E C2                 MOV    es, dx ; MOV
0603EA  8B D8                 MOV    bx, ax ; MOV
