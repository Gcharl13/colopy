; ============================================================================
; func_0052F2_unknown
; Region   : load_image
; Bytes    : file 0x0052F2..0x005304  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0052F2  55                    PUSH   bp ; STACK_PUSH
0052F3  8B EC                 MOV    bp, sp ; MOV
0052F5  56                    PUSH   si ; STACK_PUSH
0052F6  57                    PUSH   di ; STACK_PUSH
0052F7  1E                    PUSH   ds ; STACK_PUSH
0052F8  07                    POP    es ; STACK_POP
0052F9  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
0052FC  BE DE 43              MOV    si, 0x43de ; CONST_LOAD
0052FF  AD                    LODSW  ax, word ptr [si] ; STR
005300  3B C2                 CMP    ax, dx ; CMP
005302  74 10                 JE     0x5314 ; CJUMP
