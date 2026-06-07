; ============================================================================
; func_004984_unknown
; Region   : load_image
; Bytes    : file 0x004984..0x004990  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004984  55                    PUSH   bp ; STACK_PUSH
004985  8B EC                 MOV    bp, sp ; MOV
004987  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00498A  0B DB                 OR     bx, bx ; LOGIC
00498C  7F 07                 JG     0x4995 ; CJUMP
00498E  8B C3                 MOV    ax, bx ; MOV
