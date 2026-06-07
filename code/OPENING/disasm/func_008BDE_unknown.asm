; ============================================================================
; func_008BDE_unknown
; Region   : load_image
; Bytes    : file 0x008BDE..0x008C19  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008BDE  55                    PUSH   bp ; STACK_PUSH
008BDF  8B EC                 MOV    bp, sp ; MOV
008BE1  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
008BE4  26 80 7F 01 00        CMP    byte ptr es:[bx + 1], 0 ; CMP
008BE9  74 0D                 JE     0x8bf8 ; CJUMP
008BEB  26 FF 77 04           PUSH   word ptr es:[bx + 4] ; STACK_PUSH
008BEF  26 FF 77 02           PUSH   word ptr es:[bx + 2] ; STACK_PUSH
008BF3  9A 12 03 C9 02        LCALL  0x2c9, 0x312 ; LCALL
008BF8  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
008BFB  2B C0                 SUB    ax, ax ; ARITH
008BFD  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
008C01  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
008C05  26 89 47 10           MOV    word ptr es:[bx + 0x10], ax ; MOV
008C09  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax ; MOV
008C0D  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax ; MOV
008C11  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
008C15  C9                    LEAVE ; EPILOGUE
008C16  CA 04 00              RETF   4 ; RETURN
