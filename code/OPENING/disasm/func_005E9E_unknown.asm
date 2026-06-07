; ============================================================================
; func_005E9E_unknown
; Region   : load_image
; Bytes    : file 0x005E9E..0x005EC8  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005E9E  55                    PUSH   bp ; STACK_PUSH
005E9F  8B EC                 MOV    bp, sp ; MOV
005EA1  57                    PUSH   di ; STACK_PUSH
005EA2  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
005EA5  33 C0                 XOR    ax, ax ; LOGIC
005EA7  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
005EAA  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005EAC  41                    INC    cx ; ARITH
005EAD  F7 D9                 NEG    cx ; ARITH
005EAF  4F                    DEC    di ; ARITH
005EB0  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
005EB3  FD                    STD ; FLAG
005EB4  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005EB6  47                    INC    di ; ARITH
005EB7  26 38 05              CMP    byte ptr es:[di], al ; CMP
005EBA  74 06                 JE     0x5ec2 ; CJUMP
005EBC  33 C0                 XOR    ax, ax ; LOGIC
005EBE  8B D0                 MOV    dx, ax ; MOV
005EC0  EB 04                 JMP    0x5ec6 ; JUMP
005EC2  8B C7                 MOV    ax, di ; MOV
005EC4  8C C2                 MOV    dx, es ; MOV
005EC6  FC                    CLD ; FLAG
005EC7  5F                    POP    di ; STACK_POP
