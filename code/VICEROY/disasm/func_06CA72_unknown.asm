; ============================================================================
; func_06CA72_unknown
; Region   : overlay
; Bytes    : file 0x06CA72..0x06CA81  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06CA72  55                    PUSH   bp ; STACK_PUSH
06CA73  8B EC                 MOV    bp, sp ; MOV
06CA75  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06CA78  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06CA7B  26 89 47 28           MOV    word ptr es:[bx + 0x28], ax ; MOV
06CA7F  C9                    LEAVE ; EPILOGUE
06CA80  CB                    RETF ; RETURN
