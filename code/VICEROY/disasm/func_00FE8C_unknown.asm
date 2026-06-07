; ============================================================================
; func_00FE8C_unknown
; Region   : load_image
; Bytes    : file 0x00FE8C..0x00FEA7  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FE8C  55                    PUSH   bp ; STACK_PUSH
00FE8D  8B EC                 MOV    bp, sp ; MOV
00FE8F  57                    PUSH   di ; STACK_PUSH
00FE90  56                    PUSH   si ; STACK_PUSH
00FE91  1E                    PUSH   ds ; STACK_PUSH
00FE92  07                    POP    es ; STACK_POP
00FE93  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
00FE96  E3 26                 JCXZ   0xfebe ; CJUMP
00FE98  8B D9                 MOV    bx, cx ; MOV
00FE9A  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00FE9D  8B F7                 MOV    si, di ; MOV
00FE9F  33 C0                 XOR    ax, ax ; LOGIC
00FEA1  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
00FEA3  F7 D9                 NEG    cx ; ARITH
00FEA5  03 CB                 ADD    cx, bx ; ARITH
