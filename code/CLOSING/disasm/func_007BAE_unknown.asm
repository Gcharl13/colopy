; ============================================================================
; func_007BAE_unknown
; Region   : load_image
; Bytes    : file 0x007BAE..0x007BEC  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007BAE  55                    PUSH   bp ; STACK_PUSH
007BAF  8B EC                 MOV    bp, sp ; MOV
007BB1  C4 5E 0E              LES    bx, ptr [bp + 0xe] ; MOV_FAR
007BB4  26 C6 47 01 00        MOV    byte ptr es:[bx + 1], 0 ; MOV
007BB9  26 88 07              MOV    byte ptr es:[bx], al ; MOV
007BBC  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
007BBF  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
007BC2  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
007BC6  26 89 57 08           MOV    word ptr es:[bx + 8], dx ; MOV
007BCA  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
007BCE  26 89 57 04           MOV    word ptr es:[bx + 4], dx ; MOV
007BD2  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
007BD5  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
007BD8  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax ; MOV
007BDC  26 89 57 10           MOV    word ptr es:[bx + 0x10], dx ; MOV
007BE0  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
007BE4  26 89 57 0C           MOV    word ptr es:[bx + 0xc], dx ; MOV
007BE8  C9                    LEAVE ; EPILOGUE
007BE9  CA 0C 00              RETF   0xc ; RETURN
