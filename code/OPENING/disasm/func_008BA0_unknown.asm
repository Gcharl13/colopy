; ============================================================================
; func_008BA0_unknown
; Region   : load_image
; Bytes    : file 0x008BA0..0x008BDE  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008BA0  55                    PUSH   bp ; STACK_PUSH
008BA1  8B EC                 MOV    bp, sp ; MOV
008BA3  C4 5E 0E              LES    bx, ptr [bp + 0xe] ; MOV_FAR
008BA6  26 C6 47 01 00        MOV    byte ptr es:[bx + 1], 0 ; MOV
008BAB  26 88 07              MOV    byte ptr es:[bx], al ; MOV
008BAE  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
008BB1  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
008BB4  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
008BB8  26 89 57 08           MOV    word ptr es:[bx + 8], dx ; MOV
008BBC  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
008BC0  26 89 57 04           MOV    word ptr es:[bx + 4], dx ; MOV
008BC4  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
008BC7  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
008BCA  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax ; MOV
008BCE  26 89 57 10           MOV    word ptr es:[bx + 0x10], dx ; MOV
008BD2  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
008BD6  26 89 57 0C           MOV    word ptr es:[bx + 0xc], dx ; MOV
008BDA  C9                    LEAVE ; EPILOGUE
008BDB  CA 0C 00              RETF   0xc ; RETURN
