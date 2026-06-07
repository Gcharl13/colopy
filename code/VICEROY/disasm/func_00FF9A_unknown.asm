; ============================================================================
; func_00FF9A_unknown
; Region   : load_image
; Bytes    : file 0x00FF9A..0x00FFBC  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FF9A  55                    PUSH   bp ; STACK_PUSH
00FF9B  8B EC                 MOV    bp, sp ; MOV
00FF9D  56                    PUSH   si ; STACK_PUSH
00FF9E  57                    PUSH   di ; STACK_PUSH
00FF9F  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00FFA2  0B D2                 OR     dx, dx ; LOGIC
00FFA4  7E 54                 JLE    0xfffa ; CJUMP
00FFA6  4A                    DEC    dx ; ARITH
00FFA7  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
00FFAA  1E                    PUSH   ds ; STACK_PUSH
00FFAB  07                    POP    es ; STACK_POP
00FFAC  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00FFAF  0B D2                 OR     dx, dx ; LOGIC
00FFB1  74 50                 JE     0x10003 ; CJUMP
00FFB3  8B 4F 02              MOV    cx, word ptr [bx + 2] ; MOV
00FFB6  E3 1E                 JCXZ   0xffd6 ; CJUMP
00FFB8  3B CA                 CMP    cx, dx ; CMP
00FFBA  76 02                 JBE    0xffbe ; CJUMP
