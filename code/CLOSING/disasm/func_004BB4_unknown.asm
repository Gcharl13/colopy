; ============================================================================
; func_004BB4_unknown
; Region   : load_image
; Bytes    : file 0x004BB4..0x004BD2  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004BB4  55                    PUSH   bp ; STACK_PUSH
004BB5  8B EC                 MOV    bp, sp ; MOV
004BB7  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
004BBA  8B D3                 MOV    dx, bx ; MOV
004BBC  EB 0B                 JMP    0x4bc9 ; JUMP
004BBE  2C 41                 SUB    al, 0x41 ; ARITH
004BC0  3C 1A                 CMP    al, 0x1a ; CMP
004BC2  73 04                 JAE    0x4bc8 ; CJUMP
004BC4  04 61                 ADD    al, 0x61 ; ARITH
004BC6  88 07                 MOV    byte ptr [bx], al ; MOV
004BC8  43                    INC    bx ; ARITH
004BC9  8A 07                 MOV    al, byte ptr [bx] ; MOV
004BCB  0A C0                 OR     al, al ; LOGIC
004BCD  75 EF                 JNE    0x4bbe ; CJUMP
004BCF  92                    XCHG   dx, ax ; MOV
004BD0  5D                    POP    bp ; STACK_POP
004BD1  CB                    RETF ; RETURN
