; ============================================================================
; func_010CA0_unknown
; Region   : load_image
; Bytes    : file 0x010CA0..0x010CCC  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010CA0  55                    PUSH   bp ; STACK_PUSH
010CA1  8B EC                 MOV    bp, sp ; MOV
010CA3  56                    PUSH   si ; STACK_PUSH
010CA4  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
010CA7  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
010CAA  A8 83                 TEST   al, 0x83 ; LOGIC
010CAC  74 1B                 JE     0x10cc9 ; CJUMP
010CAE  A8 08                 TEST   al, 8 ; LOGIC
010CB0  74 17                 JE     0x10cc9 ; CJUMP
010CB2  FF 74 04              PUSH   word ptr [si + 4] ; STACK_PUSH
010CB5  9A 1C 29 1D 0D        LCALL  0xd1d, 0x291c ; LCALL
010CBA  59                    POP    cx ; STACK_POP
010CBB  80 64 06 F7           AND    byte ptr [si + 6], 0xf7 ; LOGIC
010CBF  33 C0                 XOR    ax, ax ; LOGIC
010CC1  89 44 04              MOV    word ptr [si + 4], ax ; MOV
010CC4  89 04                 MOV    word ptr [si], ax ; MOV
010CC6  89 44 02              MOV    word ptr [si + 2], ax ; MOV
010CC9  5E                    POP    si ; STACK_POP
010CCA  5D                    POP    bp ; STACK_POP
010CCB  C3                    RET ; RETURN
