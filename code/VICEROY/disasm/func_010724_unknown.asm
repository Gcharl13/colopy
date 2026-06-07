; ============================================================================
; func_010724_unknown
; Region   : load_image
; Bytes    : file 0x010724..0x01074D  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010724  55                    PUSH   bp ; STACK_PUSH
010725  8B EC                 MOV    bp, sp ; MOV
010727  8B D7                 MOV    dx, di ; MOV
010729  8B DE                 MOV    bx, si ; MOV
01072B  1E                    PUSH   ds ; STACK_PUSH
01072C  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
01072F  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
010732  33 C0                 XOR    ax, ax ; LOGIC
010734  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
010737  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
010739  F7 D1                 NOT    cx ; LOGIC
01073B  2B F9                 SUB    di, cx ; ARITH
01073D  F3 A6                 REPE CMPSB byte ptr [si], byte ptr es:[di] ; STR
01073F  74 05                 JE     0x10746 ; CJUMP
010741  1B C0                 SBB    ax, ax ; ARITH
010743  1D FF FF              SBB    ax, 0xffff ; ARITH
010746  1F                    POP    ds ; STACK_POP
010747  8B F3                 MOV    si, bx ; MOV
010749  8B FA                 MOV    di, dx ; MOV
01074B  5D                    POP    bp ; STACK_POP
01074C  CB                    RETF ; RETURN
