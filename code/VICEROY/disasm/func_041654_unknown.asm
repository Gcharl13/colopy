; ============================================================================
; func_041654_unknown
; Region   : overlay
; Bytes    : file 0x041654..0x041669  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041654  C8 3E 00 00           ENTER  0x3e, 0 ; PROLOGUE
041658  56                    PUSH   si ; STACK_PUSH
041659  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1 ; LOCAL_STORE
04165E  C7 46 E6 FF FF        MOV    word ptr [bp - 0x1a], 0xffff ; LOCAL_STORE
041663  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
041667  8B C3                 MOV    ax, bx ; MOV
