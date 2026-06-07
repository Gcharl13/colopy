; ============================================================================
; func_044A92_unknown
; Region   : overlay
; Bytes    : file 0x044A92..0x044AB3  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044A92  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
044A96  56                    PUSH   si ; STACK_PUSH
044A97  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
044A9A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
044A9D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
044AA0  0E                    PUSH   cs ; STACK_PUSH
044AA1  E8 5D 11              CALL   0x45c01 ; CALL_NEAR
044AA4  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
044AA7  8B F0                 MOV    si, ax ; MOV
044AA9  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
044AAD  74 09                 JE     0x44ab8 ; CJUMP
044AAF  8E C2                 MOV    es, dx ; MOV
044AB1  26                    DB     0x26 ; DATA_BYTE
044AB2  80                    DB     0x80 ; DATA_BYTE
