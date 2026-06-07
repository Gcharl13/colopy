; ============================================================================
; func_0772DA_unknown
; Region   : overlay
; Bytes    : file 0x0772DA..0x0772F9  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0772DA  55                    PUSH   bp ; STACK_PUSH
0772DB  8B EC                 MOV    bp, sp ; MOV
0772DD  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0772E0  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
0772E3  A3 5A 24              MOV    word ptr [0x245a], ax ; GLOBAL_LOAD
0772E6  89 16 5C 24           MOV    word ptr [0x245c], dx ; GLOBAL_LOAD
0772EA  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
0772ED  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
0772F0  A3 5E 24              MOV    word ptr [0x245e], ax ; GLOBAL_LOAD
0772F3  89 16 60 24           MOV    word ptr [0x2460], dx ; GLOBAL_LOAD
0772F7  C9                    LEAVE ; EPILOGUE
0772F8  CB                    RETF ; RETURN
