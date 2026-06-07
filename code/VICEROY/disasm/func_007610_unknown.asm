; ============================================================================
; func_007610_unknown
; Region   : load_image
; Bytes    : file 0x007610..0x00762F  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007610  55                    PUSH   bp ; STACK_PUSH
007611  8B EC                 MOV    bp, sp ; MOV
007613  56                    PUSH   si ; STACK_PUSH
007614  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
007617  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
00761A  8A 87 5B 31           MOV    al, byte ptr [bx + 0x315b] ; MOV
00761E  24 0F                 AND    al, 0xf ; LOGIC
007620  8A 4E 08              MOV    cl, byte ptr [bp + 8] ; LOCAL_LOAD
007623  C0 E1 04              SHL    cl, 4 ; LOGIC
007626  0A C1                 OR     al, cl ; LOGIC
007628  88 87 5B 31           MOV    byte ptr [bx + 0x315b], al ; MOV
00762C  5E                    POP    si ; STACK_POP
00762D  C9                    LEAVE ; EPILOGUE
00762E  CB                    RETF ; RETURN
