; ============================================================================
; func_015C02_unknown
; Region   : load_image
; Bytes    : file 0x015C02..0x015C2C  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015C02  55                    PUSH   bp ; STACK_PUSH
015C03  8B EC                 MOV    bp, sp ; MOV
015C05  57                    PUSH   di ; STACK_PUSH
015C06  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
015C09  33 C0                 XOR    ax, ax ; LOGIC
015C0B  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
015C0E  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015C10  41                    INC    cx ; ARITH
015C11  F7 D9                 NEG    cx ; ARITH
015C13  4F                    DEC    di ; ARITH
015C14  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
015C17  FD                    STD ; FLAG
015C18  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015C1A  47                    INC    di ; ARITH
015C1B  26 38 05              CMP    byte ptr es:[di], al ; CMP
015C1E  74 06                 JE     0x15c26 ; CJUMP
015C20  33 C0                 XOR    ax, ax ; LOGIC
015C22  8B D0                 MOV    dx, ax ; MOV
015C24  EB 04                 JMP    0x15c2a ; JUMP
015C26  8B C7                 MOV    ax, di ; MOV
015C28  8C C2                 MOV    dx, es ; MOV
015C2A  FC                    CLD ; FLAG
015C2B  5F                    POP    di ; STACK_POP
