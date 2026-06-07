; ============================================================================
; func_01727E_unknown
; Region   : load_image
; Bytes    : file 0x01727E..0x01729F  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01727E  55                    PUSH   bp ; STACK_PUSH
01727F  8B EC                 MOV    bp, sp ; MOV
017281  56                    PUSH   si ; STACK_PUSH
017282  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
017285  BE 34 45              MOV    si, 0x4534 ; CONST_LOAD
017288  39 5C 06              CMP    word ptr [si + 6], bx ; CMP
01728B  73 0D                 JAE    0x1729a ; CJUMP
01728D  4B                    DEC    bx ; ARITH
01728E  4B                    DEC    bx ; ARITH
01728F  80 0F 01              OR     byte ptr [bx], 1 ; LOGIC
017292  39 5C 08              CMP    word ptr [si + 8], bx ; CMP
017295  76 03                 JBE    0x1729a ; CJUMP
017297  89 5C 08              MOV    word ptr [si + 8], bx ; MOV
01729A  5E                    POP    si ; STACK_POP
01729B  8B E5                 MOV    sp, bp ; MOV
01729D  5D                    POP    bp ; STACK_POP
01729E  CB                    RETF ; RETURN
