; ============================================================================
; func_005B96_unknown
; Region   : load_image
; Bytes    : file 0x005B96..0x005BB4  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005B96  55                    PUSH   bp ; STACK_PUSH
005B97  8B EC                 MOV    bp, sp ; MOV
005B99  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
005B9C  8B D3                 MOV    dx, bx ; MOV
005B9E  EB 0B                 JMP    0x5bab ; JUMP
005BA0  2C 61                 SUB    al, 0x61 ; ARITH
005BA2  3C 1A                 CMP    al, 0x1a ; CMP
005BA4  73 04                 JAE    0x5baa ; CJUMP
005BA6  04 41                 ADD    al, 0x41 ; ARITH
005BA8  88 07                 MOV    byte ptr [bx], al ; MOV
005BAA  43                    INC    bx ; ARITH
005BAB  8A 07                 MOV    al, byte ptr [bx] ; MOV
005BAD  0A C0                 OR     al, al ; LOGIC
005BAF  75 EF                 JNE    0x5ba0 ; CJUMP
005BB1  92                    XCHG   dx, ax ; MOV
005BB2  5D                    POP    bp ; STACK_POP
005BB3  CB                    RETF ; RETURN
