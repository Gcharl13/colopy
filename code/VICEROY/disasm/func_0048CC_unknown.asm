; ============================================================================
; func_0048CC_unknown
; Region   : load_image
; Bytes    : file 0x0048CC..0x0048D9  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0048CC  55                    PUSH   bp ; STACK_PUSH
0048CD  8B EC                 MOV    bp, sp ; MOV
0048CF  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
0048D2  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0048D5  3B C2                 CMP    ax, dx ; CMP
0048D7  7D 02                 JGE    0x48db ; CJUMP
