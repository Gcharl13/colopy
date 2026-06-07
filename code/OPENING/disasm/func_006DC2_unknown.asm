; ============================================================================
; func_006DC2_unknown
; Region   : load_image
; Bytes    : file 0x006DC2..0x006DED  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006DC2  55                    PUSH   bp ; STACK_PUSH
006DC3  8B EC                 MOV    bp, sp ; MOV
006DC5  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
006DC8  2B 46 0C              SUB    ax, word ptr [bp + 0xc] ; ARITH
006DCB  1B D2                 SBB    dx, dx ; ARITH
006DCD  03 C0                 ADD    ax, ax ; ARITH
006DCF  13 D2                 ADC    dx, dx ; ARITH
006DD1  03 C0                 ADD    ax, ax ; ARITH
006DD3  13 D2                 ADC    dx, dx ; ARITH
006DD5  03 C0                 ADD    ax, ax ; ARITH
006DD7  13 D2                 ADC    dx, dx ; ARITH
006DD9  03 C0                 ADD    ax, ax ; ARITH
006DDB  13 D2                 ADC    dx, dx ; ARITH
006DDD  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
006DE0  83 D2 00              ADC    dx, 0 ; ARITH
006DE3  2B 46 0A              SUB    ax, word ptr [bp + 0xa] ; ARITH
006DE6  83 DA 00              SBB    dx, 0 ; ARITH
006DE9  5D                    POP    bp ; STACK_POP
006DEA  CA 08 00              RETF   8 ; RETURN
