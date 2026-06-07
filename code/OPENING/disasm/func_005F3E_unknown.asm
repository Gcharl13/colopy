; ============================================================================
; func_005F3E_unknown
; Region   : load_image
; Bytes    : file 0x005F3E..0x005F84  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005F3E  55                    PUSH   bp ; STACK_PUSH
005F3F  8B EC                 MOV    bp, sp ; MOV
005F41  8B D7                 MOV    dx, di ; MOV
005F43  8B DE                 MOV    bx, si ; MOV
005F45  1E                    PUSH   ds ; STACK_PUSH
005F46  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
005F49  33 C0                 XOR    ax, ax ; LOGIC
005F4B  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
005F4E  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005F50  8D 75 FF              LEA    si, [di - 1] ; ADDR
005F53  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
005F56  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
005F59  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005F5B  F7 D1                 NOT    cx ; LOGIC
005F5D  2B F9                 SUB    di, cx ; ARITH
005F5F  8C C0                 MOV    ax, es ; MOV
005F61  8E D8                 MOV    ds, ax ; MOV
005F63  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
005F66  87 FE                 XCHG   si, di ; MOV
005F68  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005F6B  F7 C6 01 00           TEST   si, 1 ; LOGIC
005F6F  74 02                 JE     0x5f73 ; CJUMP
005F71  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
005F72  49                    DEC    cx ; ARITH
005F73  D1 E9                 SHR    cx, 1 ; LOGIC
005F75  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
005F77  13 C9                 ADC    cx, cx ; ARITH
005F79  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
005F7B  8B F3                 MOV    si, bx ; MOV
005F7D  8B FA                 MOV    di, dx ; MOV
005F7F  1F                    POP    ds ; STACK_POP
005F80  8C C2                 MOV    dx, es ; MOV
005F82  5D                    POP    bp ; STACK_POP
005F83  CB                    RETF ; RETURN
