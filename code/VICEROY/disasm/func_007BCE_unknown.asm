; ============================================================================
; func_007BCE_unknown
; Region   : load_image
; Bytes    : file 0x007BCE..0x007BE7  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007BCE  55                    PUSH   bp ; STACK_PUSH
007BCF  8B EC                 MOV    bp, sp ; MOV
007BD1  56                    PUSH   si ; STACK_PUSH
007BD2  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
007BD5  56                    PUSH   si ; STACK_PUSH
007BD6  0E                    PUSH   cs ; STACK_PUSH
007BD7  E8 F0 F0              CALL   0x6cca ; CALL_NEAR
007BDA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007BDD  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
007BE0  88 87 49 31           MOV    byte ptr [bx + 0x3149], al ; MOV
007BE4  5E                    POP    si ; STACK_POP
007BE5  C9                    LEAVE ; EPILOGUE
007BE6  CB                    RETF ; RETURN
