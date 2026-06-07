; ============================================================================
; func_016056_unknown
; Region   : load_image
; Bytes    : file 0x016056..0x016068  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016056  55                    PUSH   bp ; STACK_PUSH
016057  8B EC                 MOV    bp, sp ; MOV
016059  56                    PUSH   si ; STACK_PUSH
01605A  57                    PUSH   di ; STACK_PUSH
01605B  1E                    PUSH   ds ; STACK_PUSH
01605C  07                    POP    es ; STACK_POP
01605D  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
016060  BE C0 48              MOV    si, 0x48c0 ; CONST_LOAD
016063  AD                    LODSW  ax, word ptr [si] ; STR
016064  3B C2                 CMP    ax, dx ; CMP
016066  74 10                 JE     0x16078 ; CJUMP
