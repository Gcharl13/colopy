; ============================================================================
; func_0103AC_unknown
; Region   : load_image
; Bytes    : file 0x0103AC..0x0103C2  (22 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0103AC  55                    PUSH   bp ; STACK_PUSH
0103AD  8B EC                 MOV    bp, sp ; MOV
0103AF  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0103B2  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
0103B5  0B D2                 OR     dx, dx ; LOGIC
0103B7  7D 07                 JGE    0x103c0 ; CJUMP
0103B9  F7 D8                 NEG    ax ; ARITH
0103BB  83 D2 00              ADC    dx, 0 ; ARITH
0103BE  F7 DA                 NEG    dx ; ARITH
0103C0  5D                    POP    bp ; STACK_POP
0103C1  CB                    RETF ; RETURN
