; ============================================================================
; func_06FAE8_unknown
; Region   : overlay
; Bytes    : file 0x06FAE8..0x06FB1D  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06FAE8  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
06FAEC  56                    PUSH   si ; STACK_PUSH
06FAED  BE 01 00              MOV    si, 1 ; MOV
06FAF0  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06FAF3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06FAF6  0E                    PUSH   cs ; STACK_PUSH
06FAF7  E8 29 00              CALL   0x6fb23 ; CALL_NEAR
06FAFA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06FAFD  0B C0                 OR     ax, ax ; LOGIC
06FAFF  75 13                 JNE    0x6fb14 ; CJUMP
06FB01  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
06FB04  0B DB                 OR     bx, bx ; LOGIC
06FB06  7C 0A                 JL     0x6fb12 ; CJUMP
06FB08  8D 77 01              LEA    si, [bx + 1] ; ADDR
06FB0B  0E                    PUSH   cs ; STACK_PUSH
06FB0C  E8 0F 00              CALL   0x6fb1e ; CALL_NEAR
06FB0F  4E                    DEC    si ; ARITH
06FB10  75 F9                 JNE    0x6fb0b ; CJUMP
06FB12  2B F6                 SUB    si, si ; ARITH
06FB14  0E                    PUSH   cs ; STACK_PUSH
06FB15  E8 10 00              CALL   0x6fb28 ; CALL_NEAR
06FB18  8B C6                 MOV    ax, si ; MOV
06FB1A  5E                    POP    si ; STACK_POP
06FB1B  C9                    LEAVE ; EPILOGUE
06FB1C  CB                    RETF ; RETURN
