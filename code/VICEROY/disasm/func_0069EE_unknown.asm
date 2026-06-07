; ============================================================================
; func_0069EE_unknown
; Region   : load_image
; Bytes    : file 0x0069EE..0x006A0F  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0069EE  55                    PUSH   bp ; STACK_PUSH
0069EF  8B EC                 MOV    bp, sp ; MOV
0069F1  56                    PUSH   si ; STACK_PUSH
0069F2  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0069F5  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
0069F8  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
0069FC  2A E4                 SUB    ah, ah ; ARITH
0069FE  50                    PUSH   ax ; STACK_PUSH
0069FF  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
006A03  50                    PUSH   ax ; STACK_PUSH
006A04  56                    PUSH   si ; STACK_PUSH
006A05  0E                    PUSH   cs ; STACK_PUSH
006A06  E8 C9 FF              CALL   0x69d2 ; CALL_NEAR
006A09  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
006A0C  5E                    POP    si ; STACK_POP
006A0D  C9                    LEAVE ; EPILOGUE
006A0E  CB                    RETF ; RETURN
