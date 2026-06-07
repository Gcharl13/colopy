; ============================================================================
; func_069B56_unknown
; Region   : load_image
; Bytes    : file 0x069B56..0x069B87  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069B56  55                    PUSH   bp                           ; UNKNOWN
069B57  8B EC                 MOV    bp, sp                       ; UNKNOWN
069B59  8B 4E 0C              MOV    cx, word ptr [bp + 0xc]      ; UNKNOWN
069B5C  E3 38                 JCXZ   0x69b96                      ; UNKNOWN
069B5E  57                    PUSH   di                           ; UNKNOWN
069B5F  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
069B62  8B D7                 MOV    dx, di                       ; UNKNOWN
069B64  F7 DA                 NEG    dx                           ; UNKNOWN
069B66  74 0C                 JE     0x69b74                      ; UNKNOWN
069B68  2B D1                 SUB    dx, cx                       ; UNKNOWN
069B6A  1B DB                 SBB    bx, bx                       ; UNKNOWN
069B6C  23 D3                 AND    dx, bx                       ; UNKNOWN
069B6E  03 D1                 ADD    dx, cx                       ; UNKNOWN
069B70  87 D1                 XCHG   cx, dx                       ; UNKNOWN
069B72  2B D1                 SUB    dx, cx                       ; UNKNOWN
069B74  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
069B77  8A E0                 MOV    ah, al                       ; UNKNOWN
069B79  D1 E9                 SHR    cx, 1                        ; UNKNOWN
069B7B  F3 AB                 REP STOSW word ptr es:[di], ax         ; UNKNOWN
069B7D  13 C9                 ADC    cx, cx                       ; UNKNOWN
069B7F  F3 AA                 REP STOSB byte ptr es:[di], al         ; UNKNOWN
069B81  87 D1                 XCHG   cx, dx                       ; UNKNOWN
069B83  E3 10                 JCXZ   0x69b95                      ; UNKNOWN
069B85  8C C3                 MOV    bx, es                       ; UNKNOWN
