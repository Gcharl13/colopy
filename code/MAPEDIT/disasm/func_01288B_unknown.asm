; ============================================================================
; func_01288B_unknown
; Region   : load_image
; Bytes    : file 0x01288B..0x01289B  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01288B  55                    PUSH   bp ; STACK_PUSH
01288C  8B EC                 MOV    bp, sp ; MOV
01288E  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
012891  89 87 26 44           MOV    word ptr [bx + 0x4426], ax ; MOV
012895  FE 06 36 44           INC    byte ptr [0x4436] ; ARITH
012899  5D                    POP    bp ; STACK_POP
01289A  CB                    RETF ; RETURN
