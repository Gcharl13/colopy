; ============================================================================
; func_005CE6_unknown
; Region   : load_image
; Bytes    : file 0x005CE6..0x005CFE  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005CE6  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
005CEA  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
005CED  F7 2E 3A 85           IMUL   word ptr [0x853a] ; ARITH
005CF1  03 06 5C 01           ADD    ax, word ptr [0x15c] ; ARITH
005CF5  8B 16 5E 01           MOV    dx, word ptr [0x15e] ; GLOBAL_LOAD
005CF9  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
005CFC  C9                    LEAVE ; EPILOGUE
005CFD  CB                    RETF ; RETURN
