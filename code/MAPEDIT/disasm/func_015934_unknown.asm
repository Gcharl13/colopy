; ============================================================================
; func_015934_unknown
; Region   : load_image
; Bytes    : file 0x015934..0x01593F  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015934  55                    PUSH   bp ; STACK_PUSH
015935  8B EC                 MOV    bp, sp ; MOV
015937  1E                    PUSH   ds ; STACK_PUSH
015938  B0 4F                 MOV    al, 0x4f ; CONST_LOAD
01593A  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
01593D  EB 09                 JMP    0x15948 ; JUMP
