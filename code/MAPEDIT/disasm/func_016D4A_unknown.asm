; ============================================================================
; func_016D4A_unknown
; Region   : load_image
; Bytes    : file 0x016D4A..0x016D75  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016D4A  55                    PUSH   bp ; STACK_PUSH
016D4B  8B EC                 MOV    bp, sp ; MOV
016D4D  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
016D50  2B 46 0C              SUB    ax, word ptr [bp + 0xc] ; ARITH
016D53  1B D2                 SBB    dx, dx ; ARITH
016D55  03 C0                 ADD    ax, ax ; ARITH
016D57  13 D2                 ADC    dx, dx ; ARITH
016D59  03 C0                 ADD    ax, ax ; ARITH
016D5B  13 D2                 ADC    dx, dx ; ARITH
016D5D  03 C0                 ADD    ax, ax ; ARITH
016D5F  13 D2                 ADC    dx, dx ; ARITH
016D61  03 C0                 ADD    ax, ax ; ARITH
016D63  13 D2                 ADC    dx, dx ; ARITH
016D65  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
016D68  83 D2 00              ADC    dx, 0 ; ARITH
016D6B  2B 46 0A              SUB    ax, word ptr [bp + 0xa] ; ARITH
016D6E  83 DA 00              SBB    dx, 0 ; ARITH
016D71  5D                    POP    bp ; STACK_POP
016D72  CA 08 00              RETF   8 ; RETURN
