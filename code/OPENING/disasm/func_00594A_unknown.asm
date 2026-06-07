; ============================================================================
; func_00594A_unknown
; Region   : load_image
; Bytes    : file 0x00594A..0x00596C  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00594A  55                    PUSH   bp ; STACK_PUSH
00594B  8B EC                 MOV    bp, sp ; MOV
00594D  56                    PUSH   si ; STACK_PUSH
00594E  57                    PUSH   di ; STACK_PUSH
00594F  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
005952  0B D2                 OR     dx, dx ; LOGIC
005954  7E 54                 JLE    0x59aa ; CJUMP
005956  4A                    DEC    dx ; ARITH
005957  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
00595A  1E                    PUSH   ds ; STACK_PUSH
00595B  07                    POP    es ; STACK_POP
00595C  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00595F  0B D2                 OR     dx, dx ; LOGIC
005961  74 50                 JE     0x59b3 ; CJUMP
005963  8B 4F 02              MOV    cx, word ptr [bx + 2] ; MOV
005966  E3 1E                 JCXZ   0x5986 ; CJUMP
005968  3B CA                 CMP    cx, dx ; CMP
00596A  76 02                 JBE    0x596e ; CJUMP
