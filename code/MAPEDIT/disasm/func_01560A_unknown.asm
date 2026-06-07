; ============================================================================
; func_01560A_unknown
; Region   : load_image
; Bytes    : file 0x01560A..0x01562C  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01560A  55                    PUSH   bp ; STACK_PUSH
01560B  8B EC                 MOV    bp, sp ; MOV
01560D  56                    PUSH   si ; STACK_PUSH
01560E  57                    PUSH   di ; STACK_PUSH
01560F  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
015612  0B D2                 OR     dx, dx ; LOGIC
015614  7E 54                 JLE    0x1566a ; CJUMP
015616  4A                    DEC    dx ; ARITH
015617  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
01561A  1E                    PUSH   ds ; STACK_PUSH
01561B  07                    POP    es ; STACK_POP
01561C  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
01561F  0B D2                 OR     dx, dx ; LOGIC
015621  74 50                 JE     0x15673 ; CJUMP
015623  8B 4F 02              MOV    cx, word ptr [bx + 2] ; MOV
015626  E3 1E                 JCXZ   0x15646 ; CJUMP
015628  3B CA                 CMP    cx, dx ; CMP
01562A  76 02                 JBE    0x1562e ; CJUMP
