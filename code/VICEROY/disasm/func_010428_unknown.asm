; ============================================================================
; func_010428_unknown
; Region   : load_image
; Bytes    : file 0x010428..0x010433  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010428  55                    PUSH   bp ; STACK_PUSH
010429  8B EC                 MOV    bp, sp ; MOV
01042B  1E                    PUSH   ds ; STACK_PUSH
01042C  B0 4F                 MOV    al, 0x4f ; CONST_LOAD
01042E  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
010431  EB 09                 JMP    0x1043c ; JUMP
