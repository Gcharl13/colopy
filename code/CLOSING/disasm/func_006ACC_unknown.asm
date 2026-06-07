; ============================================================================
; func_006ACC_unknown
; Region   : load_image
; Bytes    : file 0x006ACC..0x006B0E  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006ACC  55                    PUSH   bp ; STACK_PUSH
006ACD  8B EC                 MOV    bp, sp ; MOV
006ACF  8B D6                 MOV    dx, si ; MOV
006AD1  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
006AD4  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
006AD7  B0 FF                 MOV    al, 0xff ; CONST_LOAD
006AD9  0A C0                 OR     al, al ; LOGIC
006ADB  74 2C                 JE     0x6b09 ; CJUMP
006ADD  AC                    LODSB  al, byte ptr [si] ; STR
006ADE  8A 27                 MOV    ah, byte ptr [bx] ; MOV
006AE0  43                    INC    bx ; ARITH
006AE1  3A E0                 CMP    ah, al ; CMP
006AE3  74 F4                 JE     0x6ad9 ; CJUMP
006AE5  2C 41                 SUB    al, 0x41 ; ARITH
006AE7  3C 1A                 CMP    al, 0x1a ; CMP
006AE9  1A C9                 SBB    cl, cl ; ARITH
006AEB  80 E1 20              AND    cl, 0x20 ; LOGIC
006AEE  02 C1                 ADD    al, cl ; ARITH
006AF0  04 41                 ADD    al, 0x41 ; ARITH
006AF2  86 E0                 XCHG   al, ah ; MOV
006AF4  2C 41                 SUB    al, 0x41 ; ARITH
006AF6  3C 1A                 CMP    al, 0x1a ; CMP
006AF8  1A C9                 SBB    cl, cl ; ARITH
006AFA  80 E1 20              AND    cl, 0x20 ; LOGIC
006AFD  02 C1                 ADD    al, cl ; ARITH
006AFF  04 41                 ADD    al, 0x41 ; ARITH
006B01  3A C4                 CMP    al, ah ; CMP
006B03  74 D4                 JE     0x6ad9 ; CJUMP
006B05  1A C0                 SBB    al, al ; ARITH
006B07  1C FF                 SBB    al, 0xff ; ARITH
006B09  98                    CWDE ; ARITH
006B0A  8B F2                 MOV    si, dx ; MOV
006B0C  5D                    POP    bp ; STACK_POP
006B0D  CB                    RETF ; RETURN
