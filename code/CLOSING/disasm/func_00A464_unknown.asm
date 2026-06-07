; ============================================================================
; func_00A464_unknown
; Region   : load_image
; Bytes    : file 0x00A464..0x00A46E  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A464  55                    PUSH   bp ; STACK_PUSH
00A465  8B EC                 MOV    bp, sp ; MOV
00A467  C4 46 06              LES    ax, ptr [bp + 6] ; MOV_FAR
00A46A  8C C2                 MOV    dx, es ; MOV
00A46C  0B C0                 OR     ax, ax ; LOGIC
