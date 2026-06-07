; ============================================================================
; func_004F84_unknown
; Region   : load_image
; Bytes    : file 0x004F84..0x004FB5  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004F84  55                    PUSH   bp ; STACK_PUSH
004F85  8B EC                 MOV    bp, sp ; MOV
004F87  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
004F8A  E3 38                 JCXZ   0x4fc4 ; CJUMP
004F8C  57                    PUSH   di ; STACK_PUSH
004F8D  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
004F90  8B D7                 MOV    dx, di ; MOV
004F92  F7 DA                 NEG    dx ; ARITH
004F94  74 0C                 JE     0x4fa2 ; CJUMP
004F96  2B D1                 SUB    dx, cx ; ARITH
004F98  1B DB                 SBB    bx, bx ; ARITH
004F9A  23 D3                 AND    dx, bx ; LOGIC
004F9C  03 D1                 ADD    dx, cx ; ARITH
004F9E  87 D1                 XCHG   cx, dx ; MOV
004FA0  2B D1                 SUB    dx, cx ; ARITH
004FA2  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
004FA5  8A E0                 MOV    ah, al ; MOV
004FA7  D1 E9                 SHR    cx, 1 ; LOGIC
004FA9  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
004FAB  13 C9                 ADC    cx, cx ; ARITH
004FAD  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
004FAF  87 D1                 XCHG   cx, dx ; MOV
004FB1  E3 10                 JCXZ   0x4fc3 ; CJUMP
004FB3  8C C3                 MOV    bx, es ; MOV
