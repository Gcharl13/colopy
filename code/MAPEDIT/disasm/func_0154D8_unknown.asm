; ============================================================================
; func_0154D8_unknown
; Region   : load_image
; Bytes    : file 0x0154D8..0x015503  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0154D8  55                    PUSH   bp ; STACK_PUSH
0154D9  8B EC                 MOV    bp, sp ; MOV
0154DB  8B D7                 MOV    dx, di ; MOV
0154DD  8B DE                 MOV    bx, si ; MOV
0154DF  8C D8                 MOV    ax, ds ; MOV
0154E1  8E C0                 MOV    es, ax ; MOV
0154E3  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0154E6  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
0154E9  33 C0                 XOR    ax, ax ; LOGIC
0154EB  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
0154EE  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0154F0  F7 D1                 NOT    cx ; LOGIC
0154F2  2B F9                 SUB    di, cx ; ARITH
0154F4  F3 A6                 REPE CMPSB byte ptr [si], byte ptr es:[di] ; STR
0154F6  74 05                 JE     0x154fd ; CJUMP
0154F8  1B C0                 SBB    ax, ax ; ARITH
0154FA  1D FF FF              SBB    ax, 0xffff ; ARITH
0154FD  8B F3                 MOV    si, bx ; MOV
0154FF  8B FA                 MOV    di, dx ; MOV
015501  5D                    POP    bp ; STACK_POP
015502  CB                    RETF ; RETURN
