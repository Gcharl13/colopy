; ============================================================================
; func_06FABA_unknown
; Region   : overlay
; Bytes    : file 0x06FABA..0x06FAE8  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06FABA  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
06FABE  56                    PUSH   si ; STACK_PUSH
06FABF  C6 46 FF 00           MOV    byte ptr [bp - 1], 0 ; LOCAL_STORE
06FAC3  0E                    PUSH   cs ; STACK_PUSH
06FAC4  E8 66 00              CALL   0x6fb2d ; CALL_NEAR
06FAC7  BE B8 A5              MOV    si, 0xa5b8 ; CONST_LOAD
06FACA  80 3C 30              CMP    byte ptr [si], 0x30 ; CMP
06FACD  74 05                 JE     0x6fad4 ; CJUMP
06FACF  80 3C 31              CMP    byte ptr [si], 0x31 ; CMP
06FAD2  75 0E                 JNE    0x6fae2 ; CJUMP
06FAD4  D0 66 FF              SHL    byte ptr [bp - 1], 1 ; LOGIC
06FAD7  80 3C 31              CMP    byte ptr [si], 0x31 ; CMP
06FADA  75 03                 JNE    0x6fadf ; CJUMP
06FADC  FE 46 FF              INC    byte ptr [bp - 1] ; ARITH
06FADF  46                    INC    si ; ARITH
06FAE0  EB E8                 JMP    0x6faca ; JUMP
06FAE2  8A 46 FF              MOV    al, byte ptr [bp - 1] ; LOCAL_LOAD
06FAE5  5E                    POP    si ; STACK_POP
06FAE6  C9                    LEAVE ; EPILOGUE
06FAE7  CB                    RETF ; RETURN
