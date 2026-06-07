; ============================================================================
; func_007F34_unknown
; Region   : load_image
; Bytes    : file 0x007F34..0x007F4F  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007F34  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
007F38  56                    PUSH   si ; STACK_PUSH
007F39  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
007F3D  7C 11                 JL     0x7f50 ; CJUMP
007F3F  6B 76 06 4E           IMUL   si, word ptr [bp + 6], 0x4e ; ARITH
007F43  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
007F46  8A 80 D8 59           MOV    al, byte ptr [bx + si + 0x59d8] ; MOV
007F4A  2A E4                 SUB    ah, ah ; ARITH
007F4C  5E                    POP    si ; STACK_POP
007F4D  C9                    LEAVE ; EPILOGUE
007F4E  CB                    RETF ; RETURN
