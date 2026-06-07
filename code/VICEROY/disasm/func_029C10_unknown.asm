; ============================================================================
; func_029C10_unknown
; Region   : overlay
; Bytes    : file 0x029C10..0x029C41  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029C10  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
029C14  0E                    PUSH   cs ; STACK_PUSH
029C15  E8 A6 2E              CALL   0x2cabe ; CALL_NEAR
029C18  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
029C1B  83 3E 54 8D 06        CMP    word ptr [0x8d54], 6 ; CMP
029C20  75 20                 JNE    0x29c42 ; CJUMP
029C22  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
029C27  75 03                 JNE    0x29c2c ; CJUMP
029C29  E9 F5 00              JMP    0x29d21 ; JUMP
029C2C  83 3E 56 8D 00        CMP    word ptr [0x8d56], 0 ; CMP
029C31  75 03                 JNE    0x29c36 ; CJUMP
029C33  E9 EB 00              JMP    0x29d21 ; JUMP
029C36  6A 00                 PUSH   0 ; STACK_PUSH
029C38  0E                    PUSH   cs ; STACK_PUSH
029C39  E8 46 2E              CALL   0x2ca82 ; CALL_NEAR
029C3C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
029C3F  C9                    LEAVE ; EPILOGUE
029C40  CB                    RETF ; RETURN
