; ============================================================================
; func_00B39A_unknown
; Region   : load_image
; Bytes    : file 0x00B39A..0x00B3A4  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B39A  55                    PUSH   bp ; STACK_PUSH
00B39B  8B EC                 MOV    bp, sp ; MOV
00B39D  C4 46 06              LES    ax, ptr [bp + 6] ; MOV_FAR
00B3A0  8C C2                 MOV    dx, es ; MOV
00B3A2  0B C0                 OR     ax, ax ; LOGIC
