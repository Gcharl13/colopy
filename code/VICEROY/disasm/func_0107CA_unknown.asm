; ============================================================================
; func_0107CA_unknown
; Region   : load_image
; Bytes    : file 0x0107CA..0x0107FB  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0107CA  55                    PUSH   bp ; STACK_PUSH
0107CB  8B EC                 MOV    bp, sp ; MOV
0107CD  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
0107D0  E3 38                 JCXZ   0x1080a ; CJUMP
0107D2  57                    PUSH   di ; STACK_PUSH
0107D3  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
0107D6  8B D7                 MOV    dx, di ; MOV
0107D8  F7 DA                 NEG    dx ; ARITH
0107DA  74 0C                 JE     0x107e8 ; CJUMP
0107DC  2B D1                 SUB    dx, cx ; ARITH
0107DE  1B DB                 SBB    bx, bx ; ARITH
0107E0  23 D3                 AND    dx, bx ; LOGIC
0107E2  03 D1                 ADD    dx, cx ; ARITH
0107E4  87 D1                 XCHG   cx, dx ; MOV
0107E6  2B D1                 SUB    dx, cx ; ARITH
0107E8  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
0107EB  8A E0                 MOV    ah, al ; MOV
0107ED  D1 E9                 SHR    cx, 1 ; LOGIC
0107EF  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
0107F1  13 C9                 ADC    cx, cx ; ARITH
0107F3  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
0107F5  87 D1                 XCHG   cx, dx ; MOV
0107F7  E3 10                 JCXZ   0x10809 ; CJUMP
0107F9  8C C3                 MOV    bx, es ; MOV
