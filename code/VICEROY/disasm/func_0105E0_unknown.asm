; ============================================================================
; func_0105E0_unknown
; Region   : load_image
; Bytes    : file 0x0105E0..0x01060A  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0105E0  55                    PUSH   bp ; STACK_PUSH
0105E1  8B EC                 MOV    bp, sp ; MOV
0105E3  57                    PUSH   di ; STACK_PUSH
0105E4  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
0105E7  8B DF                 MOV    bx, di ; MOV
0105E9  33 C0                 XOR    ax, ax ; LOGIC
0105EB  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
0105EE  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0105F0  41                    INC    cx ; ARITH
0105F1  F7 D9                 NEG    cx ; ARITH
0105F3  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
0105F6  8B FB                 MOV    di, bx ; MOV
0105F8  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0105FA  4F                    DEC    di ; ARITH
0105FB  26 38 05              CMP    byte ptr es:[di], al ; CMP
0105FE  74 04                 JE     0x10604 ; CJUMP
010600  33 FF                 XOR    di, di ; LOGIC
010602  8E C7                 MOV    es, di ; MOV
010604  8B C7                 MOV    ax, di ; MOV
010606  8C C2                 MOV    dx, es ; MOV
010608  5F                    POP    di ; STACK_POP
010609  8B                    DB     0x8B ; DATA_BYTE
