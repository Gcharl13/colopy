; ============================================================================
; func_007BEC_unknown
; Region   : load_image
; Bytes    : file 0x007BEC..0x007C27  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007BEC  55                    PUSH   bp ; STACK_PUSH
007BED  8B EC                 MOV    bp, sp ; MOV
007BEF  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
007BF2  26 80 7F 01 00        CMP    byte ptr es:[bx + 1], 0 ; CMP
007BF7  74 0D                 JE     0x7c06 ; CJUMP
007BF9  26 FF 77 04           PUSH   word ptr es:[bx + 4] ; STACK_PUSH
007BFD  26 FF 77 02           PUSH   word ptr es:[bx + 2] ; STACK_PUSH
007C01  9A 0C 03 FB 01        LCALL  0x1fb, 0x30c ; LCALL
007C06  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
007C09  2B C0                 SUB    ax, ax ; ARITH
007C0B  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
007C0F  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
007C13  26 89 47 10           MOV    word ptr es:[bx + 0x10], ax ; MOV
007C17  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax ; MOV
007C1B  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax ; MOV
007C1F  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
007C23  C9                    LEAVE ; EPILOGUE
007C24  CA 04 00              RETF   4 ; RETURN
