; ============================================================================
; func_004D0A_unknown
; Region   : load_image
; Bytes    : file 0x004D0A..0x004D28  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004D0A  55                    PUSH   bp ; STACK_PUSH
004D0B  8B EC                 MOV    bp, sp ; MOV
004D0D  33 C0                 XOR    ax, ax ; LOGIC
004D0F  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
004D12  E3 4F                 JCXZ   0x4d63 ; CJUMP
004D14  1E                    PUSH   ds ; STACK_PUSH
004D15  57                    PUSH   di ; STACK_PUSH
004D16  56                    PUSH   si ; STACK_PUSH
004D17  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
004D1A  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
004D1D  8B C1                 MOV    ax, cx ; MOV
004D1F  48                    DEC    ax ; ARITH
004D20  8B D7                 MOV    dx, di ; MOV
004D22  F7 D2                 NOT    dx ; LOGIC
004D24  2B C2                 SUB    ax, dx ; ARITH
004D26  1B DB                 SBB    bx, bx ; ARITH
