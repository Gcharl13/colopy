; ============================================================================
; func_06C296_unknown
; Region   : overlay
; Bytes    : file 0x06C296..0x06C2D5  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C296  55                    PUSH   bp ; STACK_PUSH
06C297  8B EC                 MOV    bp, sp ; MOV
06C299  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
06C29C  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06C29F  26 89 07              MOV    word ptr es:[bx], ax ; MOV
06C2A2  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
06C2A5  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
06C2A9  8B 46 12              MOV    ax, word ptr [bp + 0x12] ; LOCAL_LOAD
06C2AC  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
06C2B0  8B 46 14              MOV    ax, word ptr [bp + 0x14] ; LOCAL_LOAD
06C2B3  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
06C2B7  8B 46 16              MOV    ax, word ptr [bp + 0x16] ; LOCAL_LOAD
06C2BA  26 89 47 08           MOV    word ptr es:[bx + 8], ax ; MOV
06C2BE  8B 46 18              MOV    ax, word ptr [bp + 0x18] ; LOCAL_LOAD
06C2C1  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
06C2C5  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06C2C8  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
06C2CB  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax ; MOV
06C2CF  26 89 57 0E           MOV    word ptr es:[bx + 0xe], dx ; MOV
06C2D3  C9                    LEAVE ; EPILOGUE
06C2D4  CB                    RETF ; RETURN
