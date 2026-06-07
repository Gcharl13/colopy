; ============================================================================
; func_015A6E_unknown
; Region   : load_image
; Bytes    : file 0x015A6E..0x015A8C  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015A6E  55                    PUSH   bp ; STACK_PUSH
015A6F  8B EC                 MOV    bp, sp ; MOV
015A71  33 C0                 XOR    ax, ax ; LOGIC
015A73  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
015A76  E3 4F                 JCXZ   0x15ac7 ; CJUMP
015A78  1E                    PUSH   ds ; STACK_PUSH
015A79  57                    PUSH   di ; STACK_PUSH
015A7A  56                    PUSH   si ; STACK_PUSH
015A7B  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
015A7E  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
015A81  8B C1                 MOV    ax, cx ; MOV
015A83  48                    DEC    ax ; ARITH
015A84  8B D7                 MOV    dx, di ; MOV
015A86  F7 D2                 NOT    dx ; LOGIC
015A88  2B C2                 SUB    ax, dx ; ARITH
015A8A  1B DB                 SBB    bx, bx ; ARITH
