; ============================================================================
; func_0058BE_unknown
; Region   : load_image
; Bytes    : file 0x0058BE..0x0058D9  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0058BE  55                    PUSH   bp ; STACK_PUSH
0058BF  8B EC                 MOV    bp, sp ; MOV
0058C1  57                    PUSH   di ; STACK_PUSH
0058C2  56                    PUSH   si ; STACK_PUSH
0058C3  1E                    PUSH   ds ; STACK_PUSH
0058C4  07                    POP    es ; STACK_POP
0058C5  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0058C8  E3 26                 JCXZ   0x58f0 ; CJUMP
0058CA  8B D9                 MOV    bx, cx ; MOV
0058CC  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0058CF  8B F7                 MOV    si, di ; MOV
0058D1  33 C0                 XOR    ax, ax ; LOGIC
0058D3  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0058D5  F7 D9                 NEG    cx ; ARITH
0058D7  03 CB                 ADD    cx, bx ; ARITH
