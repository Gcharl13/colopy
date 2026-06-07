; ============================================================================
; func_00AE5C_unknown
; Region   : load_image
; Bytes    : file 0x00AE5C..0x00AE64  (8 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00AE5C  55                    PUSH   bp ; STACK_PUSH
00AE5D  8B EC                 MOV    bp, sp ; MOV
00AE5F  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
00AE62  8B C3                 MOV    ax, bx ; MOV
