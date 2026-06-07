; ============================================================================
; func_015CA2_unknown
; Region   : load_image
; Bytes    : file 0x015CA2..0x015CE8  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015CA2  55                    PUSH   bp ; STACK_PUSH
015CA3  8B EC                 MOV    bp, sp ; MOV
015CA5  8B D7                 MOV    dx, di ; MOV
015CA7  8B DE                 MOV    bx, si ; MOV
015CA9  1E                    PUSH   ds ; STACK_PUSH
015CAA  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
015CAD  33 C0                 XOR    ax, ax ; LOGIC
015CAF  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
015CB2  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015CB4  8D 75 FF              LEA    si, [di - 1] ; ADDR
015CB7  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
015CBA  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
015CBD  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015CBF  F7 D1                 NOT    cx ; LOGIC
015CC1  2B F9                 SUB    di, cx ; ARITH
015CC3  8C C0                 MOV    ax, es ; MOV
015CC5  8E D8                 MOV    ds, ax ; MOV
015CC7  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
015CCA  87 FE                 XCHG   si, di ; MOV
015CCC  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
015CCF  F7 C6 01 00           TEST   si, 1 ; LOGIC
015CD3  74 02                 JE     0x15cd7 ; CJUMP
015CD5  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
015CD6  49                    DEC    cx ; ARITH
015CD7  D1 E9                 SHR    cx, 1 ; LOGIC
015CD9  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
015CDB  13 C9                 ADC    cx, cx ; ARITH
015CDD  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
015CDF  8B F3                 MOV    si, bx ; MOV
015CE1  8B FA                 MOV    di, dx ; MOV
015CE3  1F                    POP    ds ; STACK_POP
015CE4  8C C2                 MOV    dx, es ; MOV
015CE6  5D                    POP    bp ; STACK_POP
015CE7  CB                    RETF ; RETURN
