; ============================================================================
; func_030590_unknown
; Region   : overlay
; Bytes    : file 0x030590..0x0305A8  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030590  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
030594  56                    PUSH   si ; STACK_PUSH
030595  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
030599  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
03059C  8A 40 4C              MOV    al, byte ptr [bx + si + 0x4c] ; MOV
03059F  98                    CWDE ; ARITH
0305A0  48                    DEC    ax ; ARITH
0305A1  79 02                 JNS    0x305a5 ; CJUMP
0305A3  2B C0                 SUB    ax, ax ; ARITH
0305A5  5E                    POP    si ; STACK_POP
0305A6  C9                    LEAVE ; EPILOGUE
0305A7  CB                    RETF ; RETURN
