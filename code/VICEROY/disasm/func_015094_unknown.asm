; ============================================================================
; func_015094_unknown
; Region   : load_image
; Bytes    : file 0x015094..0x0150D9  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015094  55                    PUSH   bp ; STACK_PUSH
015095  8B EC                 MOV    bp, sp ; MOV
015097  FC                    CLD ; FLAG
015098  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
01509B  5D                    POP    bp ; STACK_POP
01509C  A9 FF 7F              TEST   ax, 0x7fff ; LOGIC
01509F  74 38                 JE     0x150d9 ; CJUMP
0150A1  0B C0                 OR     ax, ax ; LOGIC
0150A3  9A 41 13 0D 11        LCALL  0x110d, 0x1341 ; LCALL
0150A8  EA DD 1B 0D 11        LJMP   0x110d:0x1bdd                ; UNKNOWN
0150AD  78 11                 JS     0x150c0 ; CJUMP
0150AF  E8 61 00              CALL   0x15113 ; CALL_NEAR
0150B2  72 21                 JB     0x150d5 ; CJUMP
0150B4  E8 E9 38              CALL   0x189a0 ; CALL_NEAR
0150B7  2E 01 06 B7 39        ADD    word ptr cs:[0x39b7], ax ; ARITH
0150BC  33 C0                 XOR    ax, ax ; LOGIC
0150BE  EB 18                 JMP    0x150d8 ; JUMP
0150C0  50                    PUSH   ax ; STACK_PUSH
0150C1  F7 D8                 NEG    ax ; ARITH
0150C3  E8 69 38              CALL   0x1892f ; CALL_NEAR
0150C6  2E 29 06 B7 39        SUB    word ptr cs:[0x39b7], ax ; ARITH
0150CB  58                    POP    ax ; STACK_POP
0150CC  72 07                 JB     0x150d5 ; CJUMP
0150CE  E8 42 00              CALL   0x15113 ; CALL_NEAR
0150D1  33 C0                 XOR    ax, ax ; LOGIC
0150D3  EB 03                 JMP    0x150d8 ; JUMP
0150D5  B8 01 00              MOV    ax, 1 ; MOV
0150D8  CB                    RETF ; RETURN
