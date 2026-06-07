; ============================================================================
; func_005EE8_unknown
; Region   : load_image
; Bytes    : file 0x005EE8..0x005F04  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005EE8  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
005EEC  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
005EEF  F7 6E 08              IMUL   word ptr [bp + 8] ; ARITH
005EF2  8B D8                 MOV    bx, ax ; MOV
005EF4  03 1E 68 01           ADD    bx, word ptr [0x168] ; ARITH
005EF8  8E 06 6A 01           MOV    es, word ptr [0x16a] ; GLOBAL_LOAD
005EFC  03 5E 06              ADD    bx, word ptr [bp + 6] ; ARITH
005EFF  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
005F02  C9                    LEAVE ; EPILOGUE
005F03  CB                    RETF ; RETURN
