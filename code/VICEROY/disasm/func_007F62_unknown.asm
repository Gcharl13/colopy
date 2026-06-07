; ============================================================================
; func_007F62_unknown
; Region   : load_image
; Bytes    : file 0x007F62..0x007F80  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007F62  55                    PUSH   bp ; STACK_PUSH
007F63  8B EC                 MOV    bp, sp ; MOV
007F65  56                    PUSH   si ; STACK_PUSH
007F66  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
007F6A  7C 14                 JL     0x7f80 ; CJUMP
007F6C  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
007F6F  6B 76 06 4E           IMUL   si, word ptr [bp + 6], 0x4e ; ARITH
007F73  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
007F76  88 80 D8 59           MOV    byte ptr [bx + si + 0x59d8], al ; MOV
007F7A  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
007F7D  5E                    POP    si ; STACK_POP
007F7E  C9                    LEAVE ; EPILOGUE
007F7F  CB                    RETF ; RETURN
