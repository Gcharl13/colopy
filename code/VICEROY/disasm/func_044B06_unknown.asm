; ============================================================================
; func_044B06_unknown
; Region   : overlay
; Bytes    : file 0x044B06..0x044B27  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044B06  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
044B0A  56                    PUSH   si ; STACK_PUSH
044B0B  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
044B0E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
044B11  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
044B14  0E                    PUSH   cs ; STACK_PUSH
044B15  E8 E9 10              CALL   0x45c01 ; CALL_NEAR
044B18  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
044B1B  8B F0                 MOV    si, ax ; MOV
044B1D  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
044B21  74 09                 JE     0x44b2c ; CJUMP
044B23  8E C2                 MOV    es, dx ; MOV
044B25  26                    DB     0x26 ; DATA_BYTE
044B26  80                    DB     0x80 ; DATA_BYTE
