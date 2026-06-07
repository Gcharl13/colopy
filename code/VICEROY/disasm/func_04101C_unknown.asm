; ============================================================================
; func_04101C_unknown
; Region   : overlay
; Bytes    : file 0x04101C..0x041033  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04101C  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
041020  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
041024  C6 87 4C 31 06        MOV    byte ptr [bx + 0x314c], 6 ; MOV
041029  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04102C  9A 34 09 1F 18        LCALL  0x181f, 0x934 ; THUNK -> 0x0427:0x155E (thunk @file 0x01AF24 type B) overlay @file 0x032272
041031  C9                    LEAVE ; EPILOGUE
041032  CB                    RETF ; RETURN
