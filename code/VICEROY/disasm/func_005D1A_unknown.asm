; ============================================================================
; func_005D1A_unknown
; Region   : load_image
; Bytes    : file 0x005D1A..0x005D31  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005D1A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
005D1E  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
005D21  F7 6E 08              IMUL   word ptr [bp + 8] ; ARITH
005D24  03 06 60 01           ADD    ax, word ptr [0x160] ; ARITH
005D28  8B 16 62 01           MOV    dx, word ptr [0x162] ; GLOBAL_LOAD
005D2C  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
005D2F  C9                    LEAVE ; EPILOGUE
005D30  CB                    RETF ; RETURN
