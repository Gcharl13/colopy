; ============================================================================
; func_010334_unknown
; Region   : load_image
; Bytes    : file 0x010334..0x010352  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010334  55                    PUSH   bp ; STACK_PUSH
010335  8B EC                 MOV    bp, sp ; MOV
010337  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
01033A  8B D3                 MOV    dx, bx ; MOV
01033C  EB 0B                 JMP    0x10349 ; JUMP
01033E  2C 61                 SUB    al, 0x61 ; ARITH
010340  3C 1A                 CMP    al, 0x1a ; CMP
010342  73 04                 JAE    0x10348 ; CJUMP
010344  04 41                 ADD    al, 0x41 ; ARITH
010346  88 07                 MOV    byte ptr [bx], al ; MOV
010348  43                    INC    bx ; ARITH
010349  8A 07                 MOV    al, byte ptr [bx] ; MOV
01034B  0A C0                 OR     al, al ; LOGIC
01034D  75 EF                 JNE    0x1033e ; CJUMP
01034F  92                    XCHG   dx, ax ; MOV
010350  5D                    POP    bp ; STACK_POP
010351  CB                    RETF ; RETURN
