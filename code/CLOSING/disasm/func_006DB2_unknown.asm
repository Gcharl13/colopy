; ============================================================================
; func_006DB2_unknown
; Region   : load_image
; Bytes    : file 0x006DB2..0x006DD7  (37 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006DB2  55                    PUSH   bp ; STACK_PUSH
006DB3  8B EC                 MOV    bp, sp ; MOV
006DB5  56                    PUSH   si ; STACK_PUSH
006DB6  57                    PUSH   di ; STACK_PUSH
006DB7  1E                    PUSH   ds ; STACK_PUSH
006DB8  1F                    POP    ds ; STACK_POP
006DB9  BB FF FF              MOV    bx, 0xffff ; CONST_LOAD
006DBC  B4 48                 MOV    ah, 0x48 ; CONST_LOAD
006DBE  CD 21                 INT    0x21 ; SYS
006DC0  3C 07                 CMP    al, 7 ; CMP
006DC2  74 42                 JE     0x6e06 ; CJUMP
006DC4  8B 1E 50 40           MOV    bx, word ptr [0x4050] ; GLOBAL_LOAD
006DC8  8B D3                 MOV    dx, bx ; MOV
006DCA  4B                    DEC    bx ; ARITH
006DCB  33 C9                 XOR    cx, cx ; LOGIC
006DCD  1E                    PUSH   ds ; STACK_PUSH
006DCE  8E DB                 MOV    ds, bx ; MOV
006DD0  A1 01 00              MOV    ax, word ptr [1] ; MOV
006DD3  3B C2                 CMP    ax, dx ; CMP
006DD5  74 06                 JE     0x6ddd ; CJUMP
