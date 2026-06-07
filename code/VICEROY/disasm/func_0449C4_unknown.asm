; ============================================================================
; func_0449C4_unknown
; Region   : overlay
; Bytes    : file 0x0449C4..0x0449E8  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0449C4  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
0449C8  57                    PUSH   di ; STACK_PUSH
0449C9  56                    PUSH   si ; STACK_PUSH
0449CA  2B C9                 SUB    cx, cx ; ARITH
0449CC  2B C0                 SUB    ax, ax ; ARITH
0449CE  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
0449D1  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
0449D4  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
0449D7  26 8B 44 38           MOV    ax, word ptr es:[si + 0x38] ; MOV
0449DB  26 8B 54 3A           MOV    dx, word ptr es:[si + 0x3a] ; MOV
0449DF  8B D8                 MOV    bx, ax ; MOV
0449E1  89 56 F2              MOV    word ptr [bp - 0xe], dx ; LOCAL_STORE
0449E4  8B C2                 MOV    ax, dx ; MOV
0449E6  0B C3                 OR     ax, bx ; LOGIC
