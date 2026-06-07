; ============================================================================
; func_010B1E_unknown
; Region   : load_image
; Bytes    : file 0x010B1E..0x010B59  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010B1E  55                    PUSH   bp ; STACK_PUSH
010B1F  8B EC                 MOV    bp, sp ; MOV
010B21  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
010B24  26 80 7F 01 00        CMP    byte ptr es:[bx + 1], 0 ; CMP
010B29  74 0D                 JE     0x10b38 ; CJUMP
010B2B  26 FF 77 04           PUSH   word ptr es:[bx + 4] ; STACK_PUSH
010B2F  26 FF 77 02           PUSH   word ptr es:[bx + 2] ; STACK_PUSH
010B33  9A 10 03 C9 0C        LCALL  0xcc9, 0x310 ; LCALL
010B38  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
010B3B  2B C0                 SUB    ax, ax ; ARITH
010B3D  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
010B41  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
010B45  26 89 47 10           MOV    word ptr es:[bx + 0x10], ax ; MOV
010B49  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax ; MOV
010B4D  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax ; MOV
010B51  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
010B55  C9                    LEAVE ; EPILOGUE
010B56  CA 04 00              RETF   4 ; RETURN
