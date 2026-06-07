; ============================================================================
; func_078BCE_unknown
; Region   : overlay
; Bytes    : file 0x078BCE..0x078C0C  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078BCE  55                    PUSH   bp ; STACK_PUSH
078BCF  8B EC                 MOV    bp, sp ; MOV
078BD1  C4 5E 0E              LES    bx, ptr [bp + 0xe] ; MOV_FAR
078BD4  26 C6 47 01 00        MOV    byte ptr es:[bx + 1], 0 ; MOV
078BD9  26 88 07              MOV    byte ptr es:[bx], al ; MOV
078BDC  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
078BDF  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
078BE2  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
078BE6  26 89 57 08           MOV    word ptr es:[bx + 8], dx ; MOV
078BEA  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
078BEE  26 89 57 04           MOV    word ptr es:[bx + 4], dx ; MOV
078BF2  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
078BF5  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
078BF8  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax ; MOV
078BFC  26 89 57 10           MOV    word ptr es:[bx + 0x10], dx ; MOV
078C00  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
078C04  26 89 57 0C           MOV    word ptr es:[bx + 0xc], dx ; MOV
078C08  C9                    LEAVE ; EPILOGUE
078C09  CA 0C 00              RETF   0xc ; RETURN
