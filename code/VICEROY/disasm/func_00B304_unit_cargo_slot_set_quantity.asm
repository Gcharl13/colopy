; ============================================================================
; func_00B304_unknown
; Region   : load_image
; Bytes    : file 0x00B304..0x00B319  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B304  55                    PUSH   bp ; STACK_PUSH
00B305  8B EC                 MOV    bp, sp ; MOV
00B307  56                    PUSH   si ; STACK_PUSH
00B308  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
00B30B  6B 76 06 1C           IMUL   si, word ptr [bp + 6], 0x1c ; ARITH
00B30F  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00B312  88 80 54 31           MOV    byte ptr [bx + si + 0x3154], al ; MOV
00B316  5E                    POP    si ; STACK_POP
00B317  C9                    LEAVE ; EPILOGUE
00B318  CB                    RETF ; RETURN
