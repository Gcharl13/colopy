; ============================================================================
; func_005D0A_unknown
; Region   : load_image
; Bytes    : file 0x005D0A..0x005D28  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005D0A  55                    PUSH   bp ; STACK_PUSH
005D0B  8B EC                 MOV    bp, sp ; MOV
005D0D  33 C0                 XOR    ax, ax ; LOGIC
005D0F  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
005D12  E3 4F                 JCXZ   0x5d63 ; CJUMP
005D14  1E                    PUSH   ds ; STACK_PUSH
005D15  57                    PUSH   di ; STACK_PUSH
005D16  56                    PUSH   si ; STACK_PUSH
005D17  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
005D1A  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
005D1D  8B C1                 MOV    ax, cx ; MOV
005D1F  48                    DEC    ax ; ARITH
005D20  8B D7                 MOV    dx, di ; MOV
005D22  F7 D2                 NOT    dx ; LOGIC
005D24  2B C2                 SUB    ax, dx ; ARITH
005D26  1B DB                 SBB    bx, bx ; ARITH
