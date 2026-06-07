; ============================================================================
; func_010250_unknown
; Region   : load_image
; Bytes    : file 0x010250..0x010292  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010250  55                    PUSH   bp ; STACK_PUSH
010251  8B EC                 MOV    bp, sp ; MOV
010253  8B D6                 MOV    dx, si ; MOV
010255  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
010258  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
01025B  B0 FF                 MOV    al, 0xff ; CONST_LOAD
01025D  0A C0                 OR     al, al ; LOGIC
01025F  74 2C                 JE     0x1028d ; CJUMP
010261  AC                    LODSB  al, byte ptr [si] ; STR
010262  8A 27                 MOV    ah, byte ptr [bx] ; MOV
010264  43                    INC    bx ; ARITH
010265  3A E0                 CMP    ah, al ; CMP
010267  74 F4                 JE     0x1025d ; CJUMP
010269  2C 41                 SUB    al, 0x41 ; ARITH
01026B  3C 1A                 CMP    al, 0x1a ; CMP
01026D  1A C9                 SBB    cl, cl ; ARITH
01026F  80 E1 20              AND    cl, 0x20 ; LOGIC
010272  02 C1                 ADD    al, cl ; ARITH
010274  04 41                 ADD    al, 0x41 ; ARITH
010276  86 E0                 XCHG   al, ah ; MOV
010278  2C 41                 SUB    al, 0x41 ; ARITH
01027A  3C 1A                 CMP    al, 0x1a ; CMP
01027C  1A C9                 SBB    cl, cl ; ARITH
01027E  80 E1 20              AND    cl, 0x20 ; LOGIC
010281  02 C1                 ADD    al, cl ; ARITH
010283  04 41                 ADD    al, 0x41 ; ARITH
010285  3A C4                 CMP    al, ah ; CMP
010287  74 D4                 JE     0x1025d ; CJUMP
010289  1A C0                 SBB    al, al ; ARITH
01028B  1C FF                 SBB    al, 0xff ; ARITH
01028D  98                    CWDE ; ARITH
01028E  8B F2                 MOV    si, dx ; MOV
010290  5D                    POP    bp ; STACK_POP
010291  CB                    RETF ; RETURN
