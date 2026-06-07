; ============================================================================
; func_0048FA_unknown
; Region   : load_image
; Bytes    : file 0x0048FA..0x004915  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0048FA  55                    PUSH   bp ; STACK_PUSH
0048FB  8B EC                 MOV    bp, sp ; MOV
0048FD  57                    PUSH   di ; STACK_PUSH
0048FE  56                    PUSH   si ; STACK_PUSH
0048FF  1E                    PUSH   ds ; STACK_PUSH
004900  07                    POP    es ; STACK_POP
004901  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
004904  E3 26                 JCXZ   0x492c ; CJUMP
004906  8B D9                 MOV    bx, cx ; MOV
004908  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00490B  8B F7                 MOV    si, di ; MOV
00490D  33 C0                 XOR    ax, ax ; LOGIC
00490F  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004911  F7 D9                 NEG    cx ; ARITH
004913  03 CB                 ADD    cx, bx ; ARITH
