; ============================================================================
; func_0158EA_unknown
; Region   : load_image
; Bytes    : file 0x0158EA..0x015908  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0158EA  55                    PUSH   bp ; STACK_PUSH
0158EB  8B EC                 MOV    bp, sp ; MOV
0158ED  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0158F0  8B D3                 MOV    dx, bx ; MOV
0158F2  EB 0B                 JMP    0x158ff ; JUMP
0158F4  2C 41                 SUB    al, 0x41 ; ARITH
0158F6  3C 1A                 CMP    al, 0x1a ; CMP
0158F8  73 04                 JAE    0x158fe ; CJUMP
0158FA  04 61                 ADD    al, 0x61 ; ARITH
0158FC  88 07                 MOV    byte ptr [bx], al ; MOV
0158FE  43                    INC    bx ; ARITH
0158FF  8A 07                 MOV    al, byte ptr [bx] ; MOV
015901  0A C0                 OR     al, al ; LOGIC
015903  75 EF                 JNE    0x158f4 ; CJUMP
015905  92                    XCHG   dx, ax ; MOV
015906  5D                    POP    bp ; STACK_POP
015907  CB                    RETF ; RETURN
