; ============================================================================
; func_005DF2_unknown
; Region   : load_image
; Bytes    : file 0x005DF2..0x005E37  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005DF2  55                    PUSH   bp ; STACK_PUSH
005DF3  8B EC                 MOV    bp, sp ; MOV
005DF5  8B D6                 MOV    dx, si ; MOV
005DF7  1E                    PUSH   ds ; STACK_PUSH
005DF8  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
005DFB  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
005DFE  B0 FF                 MOV    al, 0xff ; CONST_LOAD
005E00  0A C0                 OR     al, al ; LOGIC
005E02  74 2D                 JE     0x5e31 ; CJUMP
005E04  AC                    LODSB  al, byte ptr [si] ; STR
005E05  26 8A 27              MOV    ah, byte ptr es:[bx] ; MOV
005E08  43                    INC    bx ; ARITH
005E09  3A E0                 CMP    ah, al ; CMP
005E0B  74 F3                 JE     0x5e00 ; CJUMP
005E0D  2C 41                 SUB    al, 0x41 ; ARITH
005E0F  3C 1A                 CMP    al, 0x1a ; CMP
005E11  1A C9                 SBB    cl, cl ; ARITH
005E13  80 E1 20              AND    cl, 0x20 ; LOGIC
005E16  02 C1                 ADD    al, cl ; ARITH
005E18  04 41                 ADD    al, 0x41 ; ARITH
005E1A  86 E0                 XCHG   al, ah ; MOV
005E1C  2C 41                 SUB    al, 0x41 ; ARITH
005E1E  3C 1A                 CMP    al, 0x1a ; CMP
005E20  1A C9                 SBB    cl, cl ; ARITH
005E22  80 E1 20              AND    cl, 0x20 ; LOGIC
005E25  02 C1                 ADD    al, cl ; ARITH
005E27  04 41                 ADD    al, 0x41 ; ARITH
005E29  3A C4                 CMP    al, ah ; CMP
005E2B  74 D3                 JE     0x5e00 ; CJUMP
005E2D  1A C0                 SBB    al, al ; ARITH
005E2F  1C FF                 SBB    al, 0xff ; ARITH
005E31  98                    CWDE ; ARITH
005E32  1F                    POP    ds ; STACK_POP
005E33  8B F2                 MOV    si, dx ; MOV
005E35  5D                    POP    bp ; STACK_POP
005E36  CB                    RETF ; RETURN
