; ============================================================================
; func_004DF2_unknown
; Region   : load_image
; Bytes    : file 0x004DF2..0x004E37  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004DF2  55                    PUSH   bp ; STACK_PUSH
004DF3  8B EC                 MOV    bp, sp ; MOV
004DF5  8B D6                 MOV    dx, si ; MOV
004DF7  1E                    PUSH   ds ; STACK_PUSH
004DF8  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
004DFB  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
004DFE  B0 FF                 MOV    al, 0xff ; CONST_LOAD
004E00  0A C0                 OR     al, al ; LOGIC
004E02  74 2D                 JE     0x4e31 ; CJUMP
004E04  AC                    LODSB  al, byte ptr [si] ; STR
004E05  26 8A 27              MOV    ah, byte ptr es:[bx] ; MOV
004E08  43                    INC    bx ; ARITH
004E09  3A E0                 CMP    ah, al ; CMP
004E0B  74 F3                 JE     0x4e00 ; CJUMP
004E0D  2C 41                 SUB    al, 0x41 ; ARITH
004E0F  3C 1A                 CMP    al, 0x1a ; CMP
004E11  1A C9                 SBB    cl, cl ; ARITH
004E13  80 E1 20              AND    cl, 0x20 ; LOGIC
004E16  02 C1                 ADD    al, cl ; ARITH
004E18  04 41                 ADD    al, 0x41 ; ARITH
004E1A  86 E0                 XCHG   al, ah ; MOV
004E1C  2C 41                 SUB    al, 0x41 ; ARITH
004E1E  3C 1A                 CMP    al, 0x1a ; CMP
004E20  1A C9                 SBB    cl, cl ; ARITH
004E22  80 E1 20              AND    cl, 0x20 ; LOGIC
004E25  02 C1                 ADD    al, cl ; ARITH
004E27  04 41                 ADD    al, 0x41 ; ARITH
004E29  3A C4                 CMP    al, ah ; CMP
004E2B  74 D3                 JE     0x4e00 ; CJUMP
004E2D  1A C0                 SBB    al, al ; ARITH
004E2F  1C FF                 SBB    al, 0xff ; ARITH
004E31  98                    CWDE ; ARITH
004E32  1F                    POP    ds ; STACK_POP
004E33  8B F2                 MOV    si, dx ; MOV
004E35  5D                    POP    bp ; STACK_POP
004E36  CB                    RETF ; RETURN
