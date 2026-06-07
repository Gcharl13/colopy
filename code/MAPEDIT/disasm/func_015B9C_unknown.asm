; ============================================================================
; func_015B9C_unknown
; Region   : load_image
; Bytes    : file 0x015B9C..0x015BB6  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015B9C  55                    PUSH   bp ; STACK_PUSH
015B9D  8B EC                 MOV    bp, sp ; MOV
015B9F  57                    PUSH   di ; STACK_PUSH
015BA0  56                    PUSH   si ; STACK_PUSH
015BA1  1E                    PUSH   ds ; STACK_PUSH
015BA2  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
015BA5  E3 27                 JCXZ   0x15bce ; CJUMP
015BA7  8B D9                 MOV    bx, cx ; MOV
015BA9  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
015BAC  8B F7                 MOV    si, di ; MOV
015BAE  33 C0                 XOR    ax, ax ; LOGIC
015BB0  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015BB2  F7 D9                 NEG    cx ; ARITH
015BB4  03 CB                 ADD    cx, bx ; ARITH
