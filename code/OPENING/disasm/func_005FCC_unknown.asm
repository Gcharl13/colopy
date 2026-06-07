; ============================================================================
; func_005FCC_unknown
; Region   : load_image
; Bytes    : file 0x005FCC..0x00601A  (78 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005FCC  55                    PUSH   bp ; STACK_PUSH
005FCD  8B EC                 MOV    bp, sp ; MOV
005FCF  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
005FD2  1E                    PUSH   ds ; STACK_PUSH
005FD3  57                    PUSH   di ; STACK_PUSH
005FD4  56                    PUSH   si ; STACK_PUSH
005FD5  0B C9                 OR     cx, cx ; LOGIC
005FD7  75 03                 JNE    0x5fdc ; CJUMP
005FD9  E9 AF 00              JMP    0x608b ; JUMP
005FDC  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
005FDF  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
005FE2  1E                    PUSH   ds ; STACK_PUSH
005FE3  56                    PUSH   si ; STACK_PUSH
005FE4  06                    PUSH   es ; STACK_PUSH
005FE5  57                    PUSH   di ; STACK_PUSH
005FE6  9A A2 1C 52 04        LCALL  0x452, 0x1ca2 ; LCALL
005FEB  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
005FEE  0B D2                 OR     dx, dx ; LOGIC
005FF0  78 57                 JS     0x6049 ; CJUMP
005FF2  2B C1                 SUB    ax, cx ; ARITH
005FF4  83 DA 00              SBB    dx, 0 ; ARITH
005FF7  73 50                 JAE    0x6049 ; CJUMP
005FF9  49                    DEC    cx ; ARITH
005FFA  03 F1                 ADD    si, cx ; ARITH
005FFC  73 07                 JAE    0x6005 ; CJUMP
005FFE  8C D8                 MOV    ax, ds ; MOV
006000  05 00 10              ADD    ax, 0x1000 ; ARITH
006003  8E D8                 MOV    ds, ax ; MOV
006005  03 F9                 ADD    di, cx ; ARITH
006007  73 07                 JAE    0x6010 ; CJUMP
006009  8C C0                 MOV    ax, es ; MOV
00600B  05 00 10              ADD    ax, 0x1000 ; ARITH
00600E  8E C0                 MOV    es, ax ; MOV
006010  41                    INC    cx ; ARITH
006011  8B C1                 MOV    ax, cx ; MOV
006013  48                    DEC    ax ; ARITH
006014  2B C7                 SUB    ax, di ; ARITH
006016  1B DB                 SBB    bx, bx ; ARITH
006018  23 C3                 AND    ax, bx ; LOGIC
