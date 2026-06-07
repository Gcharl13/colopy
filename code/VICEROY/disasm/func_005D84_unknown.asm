; ============================================================================
; func_005D84_unknown
; Region   : load_image
; Bytes    : file 0x005D84..0x005D9B  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005D84  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
005D88  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
005D8B  F7 6E 08              IMUL   word ptr [bp + 8] ; ARITH
005D8E  03 06 64 01           ADD    ax, word ptr [0x164] ; ARITH
005D92  8B 16 66 01           MOV    dx, word ptr [0x166] ; GLOBAL_LOAD
005D96  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
005D99  C9                    LEAVE ; EPILOGUE
005D9A  CB                    RETF ; RETURN
