; ============================================================================
; func_015B56_unknown
; Region   : load_image
; Bytes    : file 0x015B56..0x015B9B  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015B56  55                    PUSH   bp ; STACK_PUSH
015B57  8B EC                 MOV    bp, sp ; MOV
015B59  8B D6                 MOV    dx, si ; MOV
015B5B  1E                    PUSH   ds ; STACK_PUSH
015B5C  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
015B5F  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
015B62  B0 FF                 MOV    al, 0xff ; CONST_LOAD
015B64  0A C0                 OR     al, al ; LOGIC
015B66  74 2D                 JE     0x15b95 ; CJUMP
015B68  AC                    LODSB  al, byte ptr [si] ; STR
015B69  26 8A 27              MOV    ah, byte ptr es:[bx] ; MOV
015B6C  43                    INC    bx ; ARITH
015B6D  3A E0                 CMP    ah, al ; CMP
015B6F  74 F3                 JE     0x15b64 ; CJUMP
015B71  2C 41                 SUB    al, 0x41 ; ARITH
015B73  3C 1A                 CMP    al, 0x1a ; CMP
015B75  1A C9                 SBB    cl, cl ; ARITH
015B77  80 E1 20              AND    cl, 0x20 ; LOGIC
015B7A  02 C1                 ADD    al, cl ; ARITH
015B7C  04 41                 ADD    al, 0x41 ; ARITH
015B7E  86 E0                 XCHG   al, ah ; MOV
015B80  2C 41                 SUB    al, 0x41 ; ARITH
015B82  3C 1A                 CMP    al, 0x1a ; CMP
015B84  1A C9                 SBB    cl, cl ; ARITH
015B86  80 E1 20              AND    cl, 0x20 ; LOGIC
015B89  02 C1                 ADD    al, cl ; ARITH
015B8B  04 41                 ADD    al, 0x41 ; ARITH
015B8D  3A C4                 CMP    al, ah ; CMP
015B8F  74 D3                 JE     0x15b64 ; CJUMP
015B91  1A C0                 SBB    al, al ; ARITH
015B93  1C FF                 SBB    al, 0xff ; ARITH
015B95  98                    CWDE ; ARITH
015B96  1F                    POP    ds ; STACK_POP
015B97  8B F2                 MOV    si, dx ; MOV
015B99  5D                    POP    bp ; STACK_POP
015B9A  CB                    RETF ; RETURN
