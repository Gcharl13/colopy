; ============================================================================
; func_0033DE_unknown
; Region   : load_image
; Bytes    : file 0x0033DE..0x00340F  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0033DE  55                    PUSH   bp ; STACK_PUSH
0033DF  8B EC                 MOV    bp, sp ; MOV
0033E1  57                    PUSH   di ; STACK_PUSH
0033E2  56                    PUSH   si ; STACK_PUSH
0033E3  C7 06 80 36 01 00     MOV    word ptr [0x3680], 1 ; GLOBAL_LOAD
0033E9  8B 1E 7E 36           MOV    bx, word ptr [0x367e] ; GLOBAL_LOAD
0033ED  BF 00 03              MOV    di, 0x300 ; CONST_LOAD
0033F0  1E                    PUSH   ds ; STACK_PUSH
0033F1  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
0033F4  BA C8 03              MOV    dx, 0x3c8 ; CONST_LOAD
0033F7  32 C0                 XOR    al, al ; LOGIC
0033F9  EE                    OUT    dx, al ; IO
0033FA  42                    INC    dx ; ARITH
0033FB  52                    PUSH   dx ; STACK_PUSH
0033FC  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
0033FF  B4 08                 MOV    ah, 8 ; MOV
003401  EC                    IN     al, dx ; IO
003402  22 C4                 AND    al, ah ; LOGIC
003404  75 FB                 JNE    0x3401 ; CJUMP
003406  EC                    IN     al, dx ; IO
003407  22 C4                 AND    al, ah ; LOGIC
003409  74 FB                 JE     0x3406 ; CJUMP
00340B  FA                    CLI ; FLAG
00340C  5A                    POP    dx ; STACK_POP
00340D  8B CF                 MOV    cx, di ; MOV
