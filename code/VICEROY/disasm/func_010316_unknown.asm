; ============================================================================
; func_010316_unknown
; Region   : load_image
; Bytes    : file 0x010316..0x010334  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010316  55                    PUSH   bp ; STACK_PUSH
010317  8B EC                 MOV    bp, sp ; MOV
010319  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
01031C  8B D3                 MOV    dx, bx ; MOV
01031E  EB 0B                 JMP    0x1032b ; JUMP
010320  2C 41                 SUB    al, 0x41 ; ARITH
010322  3C 1A                 CMP    al, 0x1a ; CMP
010324  73 04                 JAE    0x1032a ; CJUMP
010326  04 61                 ADD    al, 0x61 ; ARITH
010328  88 07                 MOV    byte ptr [bx], al ; MOV
01032A  43                    INC    bx ; ARITH
01032B  8A 07                 MOV    al, byte ptr [bx] ; MOV
01032D  0A C0                 OR     al, al ; LOGIC
01032F  75 EF                 JNE    0x10320 ; CJUMP
010331  92                    XCHG   dx, ax ; MOV
010332  5D                    POP    bp ; STACK_POP
010333  CB                    RETF ; RETURN
