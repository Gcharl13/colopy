; ============================================================================
; func_005B78_unknown
; Region   : load_image
; Bytes    : file 0x005B78..0x005B96  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005B78  55                    PUSH   bp ; STACK_PUSH
005B79  8B EC                 MOV    bp, sp ; MOV
005B7B  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
005B7E  8B D3                 MOV    dx, bx ; MOV
005B80  EB 0B                 JMP    0x5b8d ; JUMP
005B82  2C 41                 SUB    al, 0x41 ; ARITH
005B84  3C 1A                 CMP    al, 0x1a ; CMP
005B86  73 04                 JAE    0x5b8c ; CJUMP
005B88  04 61                 ADD    al, 0x61 ; ARITH
005B8A  88 07                 MOV    byte ptr [bx], al ; MOV
005B8C  43                    INC    bx ; ARITH
005B8D  8A 07                 MOV    al, byte ptr [bx] ; MOV
005B8F  0A C0                 OR     al, al ; LOGIC
005B91  75 EF                 JNE    0x5b82 ; CJUMP
005B93  92                    XCHG   dx, ax ; MOV
005B94  5D                    POP    bp ; STACK_POP
005B95  CB                    RETF ; RETURN
