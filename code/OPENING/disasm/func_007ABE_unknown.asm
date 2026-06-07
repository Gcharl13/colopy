; ============================================================================
; func_007ABE_unknown
; Region   : load_image
; Bytes    : file 0x007ABE..0x007B00  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007ABE  55                    PUSH   bp ; STACK_PUSH
007ABF  8B EC                 MOV    bp, sp ; MOV
007AC1  8B D6                 MOV    dx, si ; MOV
007AC3  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
007AC6  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
007AC9  B0 FF                 MOV    al, 0xff ; CONST_LOAD
007ACB  0A C0                 OR     al, al ; LOGIC
007ACD  74 2C                 JE     0x7afb ; CJUMP
007ACF  AC                    LODSB  al, byte ptr [si] ; STR
007AD0  8A 27                 MOV    ah, byte ptr [bx] ; MOV
007AD2  43                    INC    bx ; ARITH
007AD3  3A E0                 CMP    ah, al ; CMP
007AD5  74 F4                 JE     0x7acb ; CJUMP
007AD7  2C 41                 SUB    al, 0x41 ; ARITH
007AD9  3C 1A                 CMP    al, 0x1a ; CMP
007ADB  1A C9                 SBB    cl, cl ; ARITH
007ADD  80 E1 20              AND    cl, 0x20 ; LOGIC
007AE0  02 C1                 ADD    al, cl ; ARITH
007AE2  04 41                 ADD    al, 0x41 ; ARITH
007AE4  86 E0                 XCHG   al, ah ; MOV
007AE6  2C 41                 SUB    al, 0x41 ; ARITH
007AE8  3C 1A                 CMP    al, 0x1a ; CMP
007AEA  1A C9                 SBB    cl, cl ; ARITH
007AEC  80 E1 20              AND    cl, 0x20 ; LOGIC
007AEF  02 C1                 ADD    al, cl ; ARITH
007AF1  04 41                 ADD    al, 0x41 ; ARITH
007AF3  3A C4                 CMP    al, ah ; CMP
007AF5  74 D4                 JE     0x7acb ; CJUMP
007AF7  1A C0                 SBB    al, al ; ARITH
007AF9  1C FF                 SBB    al, 0xff ; ARITH
007AFB  98                    CWDE ; ARITH
007AFC  8B F2                 MOV    si, dx ; MOV
007AFE  5D                    POP    bp ; STACK_POP
007AFF  CB                    RETF ; RETURN
