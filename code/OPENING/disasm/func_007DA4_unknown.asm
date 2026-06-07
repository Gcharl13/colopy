; ============================================================================
; func_007DA4_unknown
; Region   : load_image
; Bytes    : file 0x007DA4..0x007DC9  (37 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007DA4  55                    PUSH   bp ; STACK_PUSH
007DA5  8B EC                 MOV    bp, sp ; MOV
007DA7  56                    PUSH   si ; STACK_PUSH
007DA8  57                    PUSH   di ; STACK_PUSH
007DA9  1E                    PUSH   ds ; STACK_PUSH
007DAA  1F                    POP    ds ; STACK_POP
007DAB  BB FF FF              MOV    bx, 0xffff ; CONST_LOAD
007DAE  B4 48                 MOV    ah, 0x48 ; CONST_LOAD
007DB0  CD 21                 INT    0x21 ; SYS
007DB2  3C 07                 CMP    al, 7 ; CMP
007DB4  74 42                 JE     0x7df8 ; CJUMP
007DB6  8B 1E A6 42           MOV    bx, word ptr [0x42a6] ; GLOBAL_LOAD
007DBA  8B D3                 MOV    dx, bx ; MOV
007DBC  4B                    DEC    bx ; ARITH
007DBD  33 C9                 XOR    cx, cx ; LOGIC
007DBF  1E                    PUSH   ds ; STACK_PUSH
007DC0  8E DB                 MOV    ds, bx ; MOV
007DC2  A1 01 00              MOV    ax, word ptr [1] ; MOV
007DC5  3B C2                 CMP    ax, dx ; CMP
007DC7  74 06                 JE     0x7dcf ; CJUMP
