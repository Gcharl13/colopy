; ============================================================================
; func_004F3E_unknown
; Region   : load_image
; Bytes    : file 0x004F3E..0x004F84  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004F3E  55                    PUSH   bp ; STACK_PUSH
004F3F  8B EC                 MOV    bp, sp ; MOV
004F41  8B D7                 MOV    dx, di ; MOV
004F43  8B DE                 MOV    bx, si ; MOV
004F45  1E                    PUSH   ds ; STACK_PUSH
004F46  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
004F49  33 C0                 XOR    ax, ax ; LOGIC
004F4B  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
004F4E  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004F50  8D 75 FF              LEA    si, [di - 1] ; ADDR
004F53  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
004F56  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
004F59  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004F5B  F7 D1                 NOT    cx ; LOGIC
004F5D  2B F9                 SUB    di, cx ; ARITH
004F5F  8C C0                 MOV    ax, es ; MOV
004F61  8E D8                 MOV    ds, ax ; MOV
004F63  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
004F66  87 FE                 XCHG   si, di ; MOV
004F68  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
004F6B  F7 C6 01 00           TEST   si, 1 ; LOGIC
004F6F  74 02                 JE     0x4f73 ; CJUMP
004F71  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
004F72  49                    DEC    cx ; ARITH
004F73  D1 E9                 SHR    cx, 1 ; LOGIC
004F75  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
004F77  13 C9                 ADC    cx, cx ; ARITH
004F79  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
004F7B  8B F3                 MOV    si, bx ; MOV
004F7D  8B FA                 MOV    di, dx ; MOV
004F7F  1F                    POP    ds ; STACK_POP
004F80  8C C2                 MOV    dx, es ; MOV
004F82  5D                    POP    bp ; STACK_POP
004F83  CB                    RETF ; RETURN
