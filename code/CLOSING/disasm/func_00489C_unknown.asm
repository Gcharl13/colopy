; ============================================================================
; func_00489C_unknown
; Region   : load_image
; Bytes    : file 0x00489C..0x0048CF  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00489C  55                    PUSH   bp ; STACK_PUSH
00489D  8B EC                 MOV    bp, sp ; MOV
00489F  57                    PUSH   di ; STACK_PUSH
0048A0  56                    PUSH   si ; STACK_PUSH
0048A1  1E                    PUSH   ds ; STACK_PUSH
0048A2  07                    POP    es ; STACK_POP
0048A3  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0048A6  8B D7                 MOV    dx, di ; MOV
0048A8  33 C0                 XOR    ax, ax ; LOGIC
0048AA  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
0048AD  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0048AF  4F                    DEC    di ; ARITH
0048B0  8B F7                 MOV    si, di ; MOV
0048B2  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
0048B5  8B DF                 MOV    bx, di ; MOV
0048B7  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0048BA  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0048BC  75 01                 JNE    0x48bf ; CJUMP
0048BE  41                    INC    cx ; ARITH
0048BF  2B 4E 0A              SUB    cx, word ptr [bp + 0xa] ; ARITH
0048C2  F7 D9                 NEG    cx ; ARITH
0048C4  8B FE                 MOV    di, si ; MOV
0048C6  8B F3                 MOV    si, bx ; MOV
0048C8  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
0048CA  AA                    STOSB  byte ptr es:[di], al ; STR
0048CB  8B C2                 MOV    ax, dx ; MOV
0048CD  5E                    POP    si ; STACK_POP
0048CE  5F                    POP    di ; STACK_POP
