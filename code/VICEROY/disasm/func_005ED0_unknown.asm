; ============================================================================
; func_005ED0_unknown
; Region   : load_image
; Bytes    : file 0x005ED0..0x005EE7  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005ED0  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
005ED4  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
005ED7  F7 6E 08              IMUL   word ptr [bp + 8] ; ARITH
005EDA  03 06 68 01           ADD    ax, word ptr [0x168] ; ARITH
005EDE  8B 16 6A 01           MOV    dx, word ptr [0x16a] ; GLOBAL_LOAD
005EE2  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
005EE5  C9                    LEAVE ; EPILOGUE
005EE6  CB                    RETF ; RETURN
