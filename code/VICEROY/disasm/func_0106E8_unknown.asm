; ============================================================================
; func_0106E8_unknown
; Region   : load_image
; Bytes    : file 0x0106E8..0x01070C  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0106E8  55                    PUSH   bp ; STACK_PUSH
0106E9  8B EC                 MOV    bp, sp ; MOV
0106EB  8C D9                 MOV    cx, ds ; MOV
0106ED  C5 5E 06              LDS    bx, ptr [bp + 6] ; MOV_FAR
0106F0  8B D3                 MOV    dx, bx ; MOV
0106F2  EB 0B                 JMP    0x106ff ; JUMP
0106F4  2C 61                 SUB    al, 0x61 ; ARITH
0106F6  3C 1A                 CMP    al, 0x1a ; CMP
0106F8  73 04                 JAE    0x106fe ; CJUMP
0106FA  04 41                 ADD    al, 0x41 ; ARITH
0106FC  88 07                 MOV    byte ptr [bx], al ; MOV
0106FE  43                    INC    bx ; ARITH
0106FF  8A 07                 MOV    al, byte ptr [bx] ; MOV
010701  0A C0                 OR     al, al ; LOGIC
010703  75 EF                 JNE    0x106f4 ; CJUMP
010705  92                    XCHG   dx, ax ; MOV
010706  8C DA                 MOV    dx, ds ; MOV
010708  8E D9                 MOV    ds, cx ; MOV
01070A  5D                    POP    bp ; STACK_POP
01070B  CB                    RETF ; RETURN
