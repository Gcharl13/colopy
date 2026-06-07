; ============================================================================
; func_041080_unknown
; Region   : overlay
; Bytes    : file 0x041080..0x041098  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041080  C8 42 00 00           ENTER  0x42, 0 ; PROLOGUE
041084  56                    PUSH   si ; STACK_PUSH
041085  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
041089  80 BF 4C 31 02        CMP    byte ptr [bx + 0x314c], 2 ; CMP
04108E  74 08                 JE     0x41098 ; CJUMP
041090  C6 87 4C 31 00        MOV    byte ptr [bx + 0x314c], 0 ; MOV
041095  5E                    POP    si ; STACK_POP
041096  C9                    LEAVE ; EPILOGUE
041097  CB                    RETF ; RETURN
