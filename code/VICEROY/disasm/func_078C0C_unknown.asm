; ============================================================================
; func_078C0C_unknown
; Region   : overlay
; Bytes    : file 0x078C0C..0x078C47  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078C0C  55                    PUSH   bp ; STACK_PUSH
078C0D  8B EC                 MOV    bp, sp ; MOV
078C0F  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
078C12  26 80 7F 01 00        CMP    byte ptr es:[bx + 1], 0 ; CMP
078C17  74 0D                 JE     0x78c26 ; CJUMP
078C19  26 FF 77 04           PUSH   word ptr es:[bx + 4] ; STACK_PUSH
078C1D  26 FF 77 02           PUSH   word ptr es:[bx + 2] ; STACK_PUSH
078C21  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
078C26  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
078C29  2B C0                 SUB    ax, ax ; ARITH
078C2B  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
078C2F  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
078C33  26 89 47 10           MOV    word ptr es:[bx + 0x10], ax ; MOV
078C37  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax ; MOV
078C3B  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax ; MOV
078C3F  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
078C43  C9                    LEAVE ; EPILOGUE
078C44  CA 04 00              RETF   4 ; RETURN
