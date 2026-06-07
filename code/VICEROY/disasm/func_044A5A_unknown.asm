; ============================================================================
; func_044A5A_unknown
; Region   : overlay
; Bytes    : file 0x044A5A..0x044A89  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044A5A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
044A5E  56                    PUSH   si ; STACK_PUSH
044A5F  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
044A62  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
044A65  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
044A68  0E                    PUSH   cs ; STACK_PUSH
044A69  E8 90 11              CALL   0x45bfc ; CALL_NEAR
044A6C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
044A6F  8B F0                 MOV    si, ax ; MOV
044A71  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
044A74  0B D0                 OR     dx, ax ; LOGIC
044A76  74 17                 JE     0x44a8f ; CJUMP
044A78  8E 46 FE              MOV    es, word ptr [bp - 2] ; LOCAL_LOAD
044A7B  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
044A7F  74 09                 JE     0x44a8a ; CJUMP
044A81  26 80 4C 0C 01        OR     byte ptr es:[si + 0xc], 1 ; LOGIC
044A86  5E                    POP    si ; STACK_POP
044A87  C9                    LEAVE ; EPILOGUE
044A88  CB                    RETF ; RETURN
