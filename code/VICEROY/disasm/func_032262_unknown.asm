; ============================================================================
; func_032262_unknown
; Region   : overlay
; Bytes    : file 0x032262..0x032278  (22 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032262  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
032266  56                    PUSH   si ; STACK_PUSH
032267  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
03226B  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
03226E  8A 40 4C              MOV    al, byte ptr [bx + si + 0x4c] ; MOV
032271  40                    INC    ax ; ARITH
032272  88 40 4C              MOV    byte ptr [bx + si + 0x4c], al ; MOV
032275  5E                    POP    si ; STACK_POP
032276  C9                    LEAVE ; EPILOGUE
032277  CB                    RETF ; RETURN
