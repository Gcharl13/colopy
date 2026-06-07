; ============================================================================
; func_015CE8_unknown
; Region   : load_image
; Bytes    : file 0x015CE8..0x015D19  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015CE8  55                    PUSH   bp ; STACK_PUSH
015CE9  8B EC                 MOV    bp, sp ; MOV
015CEB  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
015CEE  E3 38                 JCXZ   0x15d28 ; CJUMP
015CF0  57                    PUSH   di ; STACK_PUSH
015CF1  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
015CF4  8B D7                 MOV    dx, di ; MOV
015CF6  F7 DA                 NEG    dx ; ARITH
015CF8  74 0C                 JE     0x15d06 ; CJUMP
015CFA  2B D1                 SUB    dx, cx ; ARITH
015CFC  1B DB                 SBB    bx, bx ; ARITH
015CFE  23 D3                 AND    dx, bx ; LOGIC
015D00  03 D1                 ADD    dx, cx ; ARITH
015D02  87 D1                 XCHG   cx, dx ; MOV
015D04  2B D1                 SUB    dx, cx ; ARITH
015D06  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
015D09  8A E0                 MOV    ah, al ; MOV
015D0B  D1 E9                 SHR    cx, 1 ; LOGIC
015D0D  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
015D0F  13 C9                 ADC    cx, cx ; ARITH
015D11  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
015D13  87 D1                 XCHG   cx, dx ; MOV
015D15  E3 10                 JCXZ   0x15d27 ; CJUMP
015D17  8C C3                 MOV    bx, es ; MOV
