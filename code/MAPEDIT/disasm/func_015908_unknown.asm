; ============================================================================
; func_015908_unknown
; Region   : load_image
; Bytes    : file 0x015908..0x015926  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015908  55                    PUSH   bp ; STACK_PUSH
015909  8B EC                 MOV    bp, sp ; MOV
01590B  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
01590E  8B D3                 MOV    dx, bx ; MOV
015910  EB 0B                 JMP    0x1591d ; JUMP
015912  2C 61                 SUB    al, 0x61 ; ARITH
015914  3C 1A                 CMP    al, 0x1a ; CMP
015916  73 04                 JAE    0x1591c ; CJUMP
015918  04 41                 ADD    al, 0x41 ; ARITH
01591A  88 07                 MOV    byte ptr [bx], al ; MOV
01591C  43                    INC    bx ; ARITH
01591D  8A 07                 MOV    al, byte ptr [bx] ; MOV
01591F  0A C0                 OR     al, al ; LOGIC
015921  75 EF                 JNE    0x15912 ; CJUMP
015923  92                    XCHG   dx, ax ; MOV
015924  5D                    POP    bp ; STACK_POP
015925  CB                    RETF ; RETURN
