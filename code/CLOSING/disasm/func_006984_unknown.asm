; ============================================================================
; func_006984_unknown
; Region   : load_image
; Bytes    : file 0x006984..0x0069A5  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006984  55                    PUSH   bp ; STACK_PUSH
006985  8B EC                 MOV    bp, sp ; MOV
006987  56                    PUSH   si ; STACK_PUSH
006988  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00698B  BE 16 40              MOV    si, 0x4016 ; CONST_LOAD
00698E  39 5C 06              CMP    word ptr [si + 6], bx ; CMP
006991  73 0D                 JAE    0x69a0 ; CJUMP
006993  4B                    DEC    bx ; ARITH
006994  4B                    DEC    bx ; ARITH
006995  80 0F 01              OR     byte ptr [bx], 1 ; LOGIC
006998  39 5C 08              CMP    word ptr [si + 8], bx ; CMP
00699B  76 03                 JBE    0x69a0 ; CJUMP
00699D  89 5C 08              MOV    word ptr [si + 8], bx ; MOV
0069A0  5E                    POP    si ; STACK_POP
0069A1  8B E5                 MOV    sp, bp ; MOV
0069A3  5D                    POP    bp ; STACK_POP
0069A4  CB                    RETF ; RETURN
