; ============================================================================
; func_014B7E_unknown
; Region   : load_image
; Bytes    : file 0x014B7E..0x014B88  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

014B7E  55                    PUSH   bp ; STACK_PUSH
014B7F  8B EC                 MOV    bp, sp ; MOV
014B81  C4 46 06              LES    ax, ptr [bp + 6] ; MOV_FAR
014B84  8C C2                 MOV    dx, es ; MOV
014B86  0B C0                 OR     ax, ax ; LOGIC
