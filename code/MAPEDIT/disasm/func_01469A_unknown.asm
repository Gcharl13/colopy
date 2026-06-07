; ============================================================================
; func_01469A_unknown
; Region   : load_image
; Bytes    : file 0x01469A..0x0146A2  (8 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01469A  55                    PUSH   bp ; STACK_PUSH
01469B  8B EC                 MOV    bp, sp ; MOV
01469D  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
0146A0  8B C3                 MOV    ax, bx ; MOV
