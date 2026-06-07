; ============================================================================
; func_010AE0_unknown
; Region   : load_image
; Bytes    : file 0x010AE0..0x010B1E  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010AE0  55                    PUSH   bp ; STACK_PUSH
010AE1  8B EC                 MOV    bp, sp ; MOV
010AE3  C4 5E 0E              LES    bx, ptr [bp + 0xe] ; MOV_FAR
010AE6  26 C6 47 01 00        MOV    byte ptr es:[bx + 1], 0 ; MOV
010AEB  26 88 07              MOV    byte ptr es:[bx], al ; MOV
010AEE  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
010AF1  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
010AF4  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
010AF8  26 89 57 08           MOV    word ptr es:[bx + 8], dx ; MOV
010AFC  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
010B00  26 89 57 04           MOV    word ptr es:[bx + 4], dx ; MOV
010B04  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
010B07  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
010B0A  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax ; MOV
010B0E  26 89 57 10           MOV    word ptr es:[bx + 0x10], dx ; MOV
010B12  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
010B16  26 89 57 0C           MOV    word ptr es:[bx + 0xc], dx ; MOV
010B1A  C9                    LEAVE ; EPILOGUE
010B1B  CA 0C 00              RETF   0xc ; RETURN
