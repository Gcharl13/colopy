; ============================================================================
; func_004E9E_unknown
; Region   : load_image
; Bytes    : file 0x004E9E..0x004EC8  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004E9E  55                    PUSH   bp ; STACK_PUSH
004E9F  8B EC                 MOV    bp, sp ; MOV
004EA1  57                    PUSH   di ; STACK_PUSH
004EA2  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
004EA5  33 C0                 XOR    ax, ax ; LOGIC
004EA7  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
004EAA  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004EAC  41                    INC    cx ; ARITH
004EAD  F7 D9                 NEG    cx ; ARITH
004EAF  4F                    DEC    di ; ARITH
004EB0  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
004EB3  FD                    STD ; FLAG
004EB4  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004EB6  47                    INC    di ; ARITH
004EB7  26 38 05              CMP    byte ptr es:[di], al ; CMP
004EBA  74 06                 JE     0x4ec2 ; CJUMP
004EBC  33 C0                 XOR    ax, ax ; LOGIC
004EBE  8B D0                 MOV    dx, ax ; MOV
004EC0  EB 04                 JMP    0x4ec6 ; JUMP
004EC2  8B C7                 MOV    ax, di ; MOV
004EC4  8C C2                 MOV    dx, es ; MOV
004EC6  FC                    CLD ; FLAG
004EC7  5F                    POP    di ; STACK_POP
