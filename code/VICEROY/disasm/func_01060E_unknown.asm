; ============================================================================
; func_01060E_unknown
; Region   : load_image
; Bytes    : file 0x01060E..0x010653  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01060E  55                    PUSH   bp ; STACK_PUSH
01060F  8B EC                 MOV    bp, sp ; MOV
010611  8B D6                 MOV    dx, si ; MOV
010613  1E                    PUSH   ds ; STACK_PUSH
010614  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
010617  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
01061A  B0 FF                 MOV    al, 0xff ; CONST_LOAD
01061C  0A C0                 OR     al, al ; LOGIC
01061E  74 2D                 JE     0x1064d ; CJUMP
010620  AC                    LODSB  al, byte ptr [si] ; STR
010621  26 8A 27              MOV    ah, byte ptr es:[bx] ; MOV
010624  43                    INC    bx ; ARITH
010625  3A E0                 CMP    ah, al ; CMP
010627  74 F3                 JE     0x1061c ; CJUMP
010629  2C 41                 SUB    al, 0x41 ; ARITH
01062B  3C 1A                 CMP    al, 0x1a ; CMP
01062D  1A C9                 SBB    cl, cl ; ARITH
01062F  80 E1 20              AND    cl, 0x20 ; LOGIC
010632  02 C1                 ADD    al, cl ; ARITH
010634  04 41                 ADD    al, 0x41 ; ARITH
010636  86 E0                 XCHG   al, ah ; MOV
010638  2C 41                 SUB    al, 0x41 ; ARITH
01063A  3C 1A                 CMP    al, 0x1a ; CMP
01063C  1A C9                 SBB    cl, cl ; ARITH
01063E  80 E1 20              AND    cl, 0x20 ; LOGIC
010641  02 C1                 ADD    al, cl ; ARITH
010643  04 41                 ADD    al, 0x41 ; ARITH
010645  3A C4                 CMP    al, ah ; CMP
010647  74 D3                 JE     0x1061c ; CJUMP
010649  1A C0                 SBB    al, al ; ARITH
01064B  1C FF                 SBB    al, 0xff ; ARITH
01064D  98                    CWDE ; ARITH
01064E  1F                    POP    ds ; STACK_POP
01064F  8B F2                 MOV    si, dx ; MOV
010651  5D                    POP    bp ; STACK_POP
010652  CB                    RETF ; RETURN
