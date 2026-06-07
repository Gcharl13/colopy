; ============================================================================
; func_01347C_unknown
; Region   : load_image
; Bytes    : file 0x01347C..0x013491  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01347C  55                    PUSH   bp ; STACK_PUSH
01347D  8B EC                 MOV    bp, sp ; MOV
01347F  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
013482  BB 6A A6              MOV    bx, 0xa66a ; CONST_LOAD
013485  8B 0E 70 27           MOV    cx, word ptr [0x2770] ; GLOBAL_LOAD
013489  E3 1E                 JCXZ   0x134a9 ; CJUMP
01348B  8B 07                 MOV    ax, word ptr [bx] ; MOV
01348D  3B C2                 CMP    ax, dx ; CMP
01348F  74 07                 JE     0x13498 ; CJUMP
