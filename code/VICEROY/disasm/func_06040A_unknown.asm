; ============================================================================
; func_06040A_unknown
; Region   : overlay
; Bytes    : file 0x06040A..0x06041C  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06040A  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
06040E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
060411  0E                    PUSH   cs ; STACK_PUSH
060412  E8 2B 10              CALL   0x61440 ; CALL_NEAR
060415  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060418  8E C2                 MOV    es, dx ; MOV
06041A  8B D8                 MOV    bx, ax ; MOV
