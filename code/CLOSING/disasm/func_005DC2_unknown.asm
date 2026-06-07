; ============================================================================
; func_005DC2_unknown
; Region   : load_image
; Bytes    : file 0x005DC2..0x005DED  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005DC2  55                    PUSH   bp ; STACK_PUSH
005DC3  8B EC                 MOV    bp, sp ; MOV
005DC5  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
005DC8  2B 46 0C              SUB    ax, word ptr [bp + 0xc] ; ARITH
005DCB  1B D2                 SBB    dx, dx ; ARITH
005DCD  03 C0                 ADD    ax, ax ; ARITH
005DCF  13 D2                 ADC    dx, dx ; ARITH
005DD1  03 C0                 ADD    ax, ax ; ARITH
005DD3  13 D2                 ADC    dx, dx ; ARITH
005DD5  03 C0                 ADD    ax, ax ; ARITH
005DD7  13 D2                 ADC    dx, dx ; ARITH
005DD9  03 C0                 ADD    ax, ax ; ARITH
005DDB  13 D2                 ADC    dx, dx ; ARITH
005DDD  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
005DE0  83 D2 00              ADC    dx, 0 ; ARITH
005DE3  2B 46 0A              SUB    ax, word ptr [bp + 0xa] ; ARITH
005DE6  83 DA 00              SBB    dx, 0 ; ARITH
005DE9  5D                    POP    bp ; STACK_POP
005DEA  CA 08 00              RETF   8 ; RETURN
