; ============================================================================
; func_032278_unknown
; Region   : overlay
; Bytes    : file 0x032278..0x032293  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032278  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
03227C  56                    PUSH   si ; STACK_PUSH
03227D  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
032281  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
032284  8A 40 4C              MOV    al, byte ptr [bx + si + 0x4c] ; MOV
032287  98                    CWDE ; ARITH
032288  48                    DEC    ax ; ARITH
032289  79 02                 JNS    0x3228d ; CJUMP
03228B  2B C0                 SUB    ax, ax ; ARITH
03228D  88 40 4C              MOV    byte ptr [bx + si + 0x4c], al ; MOV
032290  5E                    POP    si ; STACK_POP
032291  C9                    LEAVE ; EPILOGUE
032292  CB                    RETF ; RETURN
