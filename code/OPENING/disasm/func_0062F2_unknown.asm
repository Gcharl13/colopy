; ============================================================================
; func_0062F2_unknown
; Region   : load_image
; Bytes    : file 0x0062F2..0x006304  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0062F2  55                    PUSH   bp ; STACK_PUSH
0062F3  8B EC                 MOV    bp, sp ; MOV
0062F5  56                    PUSH   si ; STACK_PUSH
0062F6  57                    PUSH   di ; STACK_PUSH
0062F7  1E                    PUSH   ds ; STACK_PUSH
0062F8  07                    POP    es ; STACK_POP
0062F9  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
0062FC  BE 34 46              MOV    si, 0x4634 ; CONST_LOAD
0062FF  AD                    LODSW  ax, word ptr [si] ; STR
006300  3B C2                 CMP    ax, dx ; CMP
006302  74 10                 JE     0x6314 ; CJUMP
