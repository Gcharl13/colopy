; ============================================================================
; func_004880_unknown
; Region   : load_image
; Bytes    : file 0x004880..0x00489B  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004880  55                    PUSH   bp ; STACK_PUSH
004881  8B EC                 MOV    bp, sp ; MOV
004883  8B D7                 MOV    dx, di ; MOV
004885  8C D8                 MOV    ax, ds ; MOV
004887  8E C0                 MOV    es, ax ; MOV
004889  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00488C  33 C0                 XOR    ax, ax ; LOGIC
00488E  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
004891  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004893  F7 D1                 NOT    cx ; LOGIC
004895  49                    DEC    cx ; ARITH
004896  91                    XCHG   cx, ax ; MOV
004897  8B FA                 MOV    di, dx ; MOV
004899  5D                    POP    bp ; STACK_POP
00489A  CB                    RETF ; RETURN
