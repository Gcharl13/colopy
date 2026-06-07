; ============================================================================
; func_004FCC_unknown
; Region   : load_image
; Bytes    : file 0x004FCC..0x00501A  (78 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004FCC  55                    PUSH   bp ; STACK_PUSH
004FCD  8B EC                 MOV    bp, sp ; MOV
004FCF  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
004FD2  1E                    PUSH   ds ; STACK_PUSH
004FD3  57                    PUSH   di ; STACK_PUSH
004FD4  56                    PUSH   si ; STACK_PUSH
004FD5  0B C9                 OR     cx, cx ; LOGIC
004FD7  75 03                 JNE    0x4fdc ; CJUMP
004FD9  E9 AF 00              JMP    0x508b ; JUMP
004FDC  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
004FDF  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
004FE2  1E                    PUSH   ds ; STACK_PUSH
004FE3  56                    PUSH   si ; STACK_PUSH
004FE4  06                    PUSH   es ; STACK_PUSH
004FE5  57                    PUSH   di ; STACK_PUSH
004FE6  9A F2 1B 7D 03        LCALL  0x37d, 0x1bf2 ; LCALL
004FEB  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
004FEE  0B D2                 OR     dx, dx ; LOGIC
004FF0  78 57                 JS     0x5049 ; CJUMP
004FF2  2B C1                 SUB    ax, cx ; ARITH
004FF4  83 DA 00              SBB    dx, 0 ; ARITH
004FF7  73 50                 JAE    0x5049 ; CJUMP
004FF9  49                    DEC    cx ; ARITH
004FFA  03 F1                 ADD    si, cx ; ARITH
004FFC  73 07                 JAE    0x5005 ; CJUMP
004FFE  8C D8                 MOV    ax, ds ; MOV
005000  05 00 10              ADD    ax, 0x1000 ; ARITH
005003  8E D8                 MOV    ds, ax ; MOV
005005  03 F9                 ADD    di, cx ; ARITH
005007  73 07                 JAE    0x5010 ; CJUMP
005009  8C C0                 MOV    ax, es ; MOV
00500B  05 00 10              ADD    ax, 0x1000 ; ARITH
00500E  8E C0                 MOV    es, ax ; MOV
005010  41                    INC    cx ; ARITH
005011  8B C1                 MOV    ax, cx ; MOV
005013  48                    DEC    ax ; ARITH
005014  2B C7                 SUB    ax, di ; ARITH
005016  1B DB                 SBB    bx, bx ; ARITH
005018  23 C3                 AND    ax, bx ; LOGIC
