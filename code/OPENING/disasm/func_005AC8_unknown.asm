; ============================================================================
; func_005AC8_unknown
; Region   : load_image
; Bytes    : file 0x005AC8..0x005B4E  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005AC8  55                    PUSH   bp ; STACK_PUSH
005AC9  8B EC                 MOV    bp, sp ; MOV
005ACB  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
005ACE  56                    PUSH   si ; STACK_PUSH
005ACF  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
005AD2  0B F6                 OR     si, si ; LOGIC
005AD4  7C 06                 JL     0x5adc ; CJUMP
005AD6  39 36 AD 42           CMP    word ptr [0x42ad], si ; CMP
005ADA  7F 0C                 JG     0x5ae8 ; CJUMP
005ADC  C7 06 A0 42 09 00     MOV    word ptr [0x42a0], 9 ; GLOBAL_LOAD
005AE2  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
005AE5  99                    CDQ ; ARITH
005AE6  EB 61                 JMP    0x5b49 ; JUMP
005AE8  B8 01 00              MOV    ax, 1 ; MOV
005AEB  50                    PUSH   ax ; STACK_PUSH
005AEC  2B C0                 SUB    ax, ax ; ARITH
005AEE  50                    PUSH   ax ; STACK_PUSH
005AEF  50                    PUSH   ax ; STACK_PUSH
005AF0  56                    PUSH   si ; STACK_PUSH
005AF1  9A EA 1A 52 04        LCALL  0x452, 0x1aea ; LCALL
005AF6  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
005AF9  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
005AFC  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
005AFF  3D FF FF              CMP    ax, 0xffff ; CMP
005B02  75 0C                 JNE    0x5b10 ; CJUMP
005B04  3B D0                 CMP    dx, ax ; CMP
005B06  75 08                 JNE    0x5b10 ; CJUMP
005B08  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
005B0B  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
005B0E  EB 33                 JMP    0x5b43 ; JUMP
005B10  B8 02 00              MOV    ax, 2 ; MOV
005B13  50                    PUSH   ax ; STACK_PUSH
005B14  2B C0                 SUB    ax, ax ; ARITH
005B16  50                    PUSH   ax ; STACK_PUSH
005B17  50                    PUSH   ax ; STACK_PUSH
005B18  56                    PUSH   si ; STACK_PUSH
005B19  9A EA 1A 52 04        LCALL  0x452, 0x1aea ; LCALL
005B1E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
005B21  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
005B24  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
005B27  3B 46 F8              CMP    ax, word ptr [bp - 8] ; CMP
005B2A  75 05                 JNE    0x5b31 ; CJUMP
005B2C  3B 56 FA              CMP    dx, word ptr [bp - 6] ; CMP
005B2F  74 12                 JE     0x5b43 ; CJUMP
005B31  2B C0                 SUB    ax, ax ; ARITH
005B33  50                    PUSH   ax ; STACK_PUSH
005B34  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
005B37  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
005B3A  56                    PUSH   si ; STACK_PUSH
005B3B  9A EA 1A 52 04        LCALL  0x452, 0x1aea ; LCALL
005B40  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
005B43  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
005B46  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
005B49  5E                    POP    si ; STACK_POP
005B4A  8B E5                 MOV    sp, bp ; MOV
005B4C  5D                    POP    bp ; STACK_POP
005B4D  CB                    RETF ; RETURN
