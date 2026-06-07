; ============================================================================
; func_009F26_unknown
; Region   : load_image
; Bytes    : file 0x009F26..0x009F2E  (8 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009F26  55                    PUSH   bp ; STACK_PUSH
009F27  8B EC                 MOV    bp, sp ; MOV
009F29  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
009F2C  8B C3                 MOV    ax, bx ; MOV
