; ============================================================================
; func_072CA4_unknown
; Region   : overlay
; Bytes    : file 0x072CA4..0x072CC1  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

072CA4  C8 50 00 00           ENTER  0x50, 0 ; PROLOGUE
072CA8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
072CAB  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
072CAE  50                    PUSH   ax ; STACK_PUSH
072CAF  0E                    PUSH   cs ; STACK_PUSH
072CB0  E8 B3 05              CALL   0x73266 ; CALL_NEAR
072CB3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
072CB6  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
072CB9  50                    PUSH   ax ; STACK_PUSH
072CBA  9A F6 0C 1F 1A        LCALL  0x1a1f, 0xcf6 ; THUNK -> 0x0000:0x0288 (thunk @file 0x01D2E6 type A) overlay @file 0x025B88
072CBF  C9                    LEAVE ; EPILOGUE
072CC0  CB                    RETF ; RETURN
