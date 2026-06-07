; ============================================================================
; func_004E24_unknown
; Region   : load_image
; Bytes    : file 0x004E24..0x004E63  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004E24  55                    PUSH   bp ; STACK_PUSH
004E25  8B EC                 MOV    bp, sp ; MOV
004E27  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
004E2A  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
004E2D  26 89 07              MOV    word ptr es:[bx], ax ; MOV
004E30  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
004E33  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
004E37  8B 46 12              MOV    ax, word ptr [bp + 0x12] ; LOCAL_LOAD
004E3A  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
004E3E  8B 46 14              MOV    ax, word ptr [bp + 0x14] ; LOCAL_LOAD
004E41  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
004E45  8B 46 16              MOV    ax, word ptr [bp + 0x16] ; LOCAL_LOAD
004E48  26 89 47 08           MOV    word ptr es:[bx + 8], ax ; MOV
004E4C  8B 46 18              MOV    ax, word ptr [bp + 0x18] ; LOCAL_LOAD
004E4F  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
004E53  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
004E56  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
004E59  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax ; MOV
004E5D  26 89 57 0E           MOV    word ptr es:[bx + 0xe], dx ; MOV
004E61  C9                    LEAVE ; EPILOGUE
004E62  CB                    RETF ; RETURN
