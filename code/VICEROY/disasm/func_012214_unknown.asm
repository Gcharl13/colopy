; ============================================================================
; func_012214_unknown
; Region   : load_image
; Bytes    : file 0x012214..0x012235  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012214  55                    PUSH   bp ; STACK_PUSH
012215  8B EC                 MOV    bp, sp ; MOV
012217  56                    PUSH   si ; STACK_PUSH
012218  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
01221B  BE 78 27              MOV    si, 0x2778 ; CONST_LOAD
01221E  39 5C 06              CMP    word ptr [si + 6], bx ; CMP
012221  73 0D                 JAE    0x12230 ; CJUMP
012223  4B                    DEC    bx ; ARITH
012224  4B                    DEC    bx ; ARITH
012225  80 0F 01              OR     byte ptr [bx], 1 ; LOGIC
012228  39 5C 08              CMP    word ptr [si + 8], bx ; CMP
01222B  76 03                 JBE    0x12230 ; CJUMP
01222D  89 5C 08              MOV    word ptr [si + 8], bx ; MOV
012230  5E                    POP    si ; STACK_POP
012231  8B E5                 MOV    sp, bp ; MOV
012233  5D                    POP    bp ; STACK_POP
012234  CB                    RETF ; RETURN
