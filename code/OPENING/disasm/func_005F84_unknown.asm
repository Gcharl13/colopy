; ============================================================================
; func_005F84_unknown
; Region   : load_image
; Bytes    : file 0x005F84..0x005FB5  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005F84  55                    PUSH   bp ; STACK_PUSH
005F85  8B EC                 MOV    bp, sp ; MOV
005F87  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
005F8A  E3 38                 JCXZ   0x5fc4 ; CJUMP
005F8C  57                    PUSH   di ; STACK_PUSH
005F8D  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
005F90  8B D7                 MOV    dx, di ; MOV
005F92  F7 DA                 NEG    dx ; ARITH
005F94  74 0C                 JE     0x5fa2 ; CJUMP
005F96  2B D1                 SUB    dx, cx ; ARITH
005F98  1B DB                 SBB    bx, bx ; ARITH
005F9A  23 D3                 AND    dx, bx ; LOGIC
005F9C  03 D1                 ADD    dx, cx ; ARITH
005F9E  87 D1                 XCHG   cx, dx ; MOV
005FA0  2B D1                 SUB    dx, cx ; ARITH
005FA2  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
005FA5  8A E0                 MOV    ah, al ; MOV
005FA7  D1 E9                 SHR    cx, 1 ; LOGIC
005FA9  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
005FAB  13 C9                 ADC    cx, cx ; ARITH
005FAD  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
005FAF  87 D1                 XCHG   cx, dx ; MOV
005FB1  E3 10                 JCXZ   0x5fc3 ; CJUMP
005FB3  8C C3                 MOV    bx, es ; MOV
