; ============================================================================
; func_004BD2_unknown
; Region   : load_image
; Bytes    : file 0x004BD2..0x004BF0  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004BD2  55                    PUSH   bp ; STACK_PUSH
004BD3  8B EC                 MOV    bp, sp ; MOV
004BD5  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
004BD8  8B D3                 MOV    dx, bx ; MOV
004BDA  EB 0B                 JMP    0x4be7 ; JUMP
004BDC  2C 61                 SUB    al, 0x61 ; ARITH
004BDE  3C 1A                 CMP    al, 0x1a ; CMP
004BE0  73 04                 JAE    0x4be6 ; CJUMP
004BE2  04 41                 ADD    al, 0x41 ; ARITH
004BE4  88 07                 MOV    byte ptr [bx], al ; MOV
004BE6  43                    INC    bx ; ARITH
004BE7  8A 07                 MOV    al, byte ptr [bx] ; MOV
004BE9  0A C0                 OR     al, al ; LOGIC
004BEB  75 EF                 JNE    0x4bdc ; CJUMP
004BED  92                    XCHG   dx, ax ; MOV
004BEE  5D                    POP    bp ; STACK_POP
004BEF  CB                    RETF ; RETURN
