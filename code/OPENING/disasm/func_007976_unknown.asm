; ============================================================================
; func_007976_unknown
; Region   : load_image
; Bytes    : file 0x007976..0x007997  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007976  55                    PUSH   bp ; STACK_PUSH
007977  8B EC                 MOV    bp, sp ; MOV
007979  56                    PUSH   si ; STACK_PUSH
00797A  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00797D  BE 6C 42              MOV    si, 0x426c ; CONST_LOAD
007980  39 5C 06              CMP    word ptr [si + 6], bx ; CMP
007983  73 0D                 JAE    0x7992 ; CJUMP
007985  4B                    DEC    bx ; ARITH
007986  4B                    DEC    bx ; ARITH
007987  80 0F 01              OR     byte ptr [bx], 1 ; LOGIC
00798A  39 5C 08              CMP    word ptr [si + 8], bx ; CMP
00798D  76 03                 JBE    0x7992 ; CJUMP
00798F  89 5C 08              MOV    word ptr [si + 8], bx ; MOV
007992  5E                    POP    si ; STACK_POP
007993  8B E5                 MOV    sp, bp ; MOV
007995  5D                    POP    bp ; STACK_POP
007996  CB                    RETF ; RETURN
