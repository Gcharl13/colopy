; ============================================================================
; func_005600_unknown
; Region   : load_image
; Bytes    : file 0x005600..0x00560F  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005600  55                    PUSH   bp ; STACK_PUSH
005601  8B EC                 MOV    bp, sp ; MOV
005603  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
005606  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
005609  26 89 47 28           MOV    word ptr es:[bx + 0x28], ax ; MOV
00560D  C9                    LEAVE ; EPILOGUE
00560E  CB                    RETF ; RETURN
