; ============================================================================
; func_0102EA_unknown
; Region   : load_image
; Bytes    : file 0x0102EA..0x010315  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0102EA  55                    PUSH   bp ; STACK_PUSH
0102EB  8B EC                 MOV    bp, sp ; MOV
0102ED  57                    PUSH   di ; STACK_PUSH
0102EE  1E                    PUSH   ds ; STACK_PUSH
0102EF  07                    POP    es ; STACK_POP
0102F0  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0102F3  33 C0                 XOR    ax, ax ; LOGIC
0102F5  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
0102F8  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0102FA  41                    INC    cx ; ARITH
0102FB  F7 D9                 NEG    cx ; ARITH
0102FD  4F                    DEC    di ; ARITH
0102FE  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
010301  FD                    STD ; FLAG
010302  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
010304  47                    INC    di ; ARITH
010305  38 05                 CMP    byte ptr [di], al ; CMP
010307  74 04                 JE     0x1030d ; CJUMP
010309  33 C0                 XOR    ax, ax ; LOGIC
01030B  EB 02                 JMP    0x1030f ; JUMP
01030D  8B C7                 MOV    ax, di ; MOV
01030F  FC                    CLD ; FLAG
010310  5F                    POP    di ; STACK_POP
010311  8B E5                 MOV    sp, bp ; MOV
010313  5D                    POP    bp ; STACK_POP
010314  CB                    RETF ; RETURN
