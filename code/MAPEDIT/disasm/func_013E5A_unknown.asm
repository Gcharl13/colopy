; ============================================================================
; func_013E5A_unknown
; Region   : load_image
; Bytes    : file 0x013E5A..0x013E6F  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013E5A  55                    PUSH   bp ; STACK_PUSH
013E5B  8B EC                 MOV    bp, sp ; MOV
013E5D  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
013E60  BB AC 5A              MOV    bx, 0x5aac ; CONST_LOAD
013E63  8B 0E F6 44           MOV    cx, word ptr [0x44f6] ; GLOBAL_LOAD
013E67  E3 1E                 JCXZ   0x13e87 ; CJUMP
013E69  8B 07                 MOV    ax, word ptr [bx] ; MOV
013E6B  3B C2                 CMP    ax, dx ; CMP
013E6D  74 07                 JE     0x13e76 ; CJUMP
