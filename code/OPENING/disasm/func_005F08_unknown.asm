; ============================================================================
; func_005F08_unknown
; Region   : load_image
; Bytes    : file 0x005F08..0x005F3E  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005F08  55                    PUSH   bp ; STACK_PUSH
005F09  8B EC                 MOV    bp, sp ; MOV
005F0B  8B D7                 MOV    dx, di ; MOV
005F0D  8B DE                 MOV    bx, si ; MOV
005F0F  1E                    PUSH   ds ; STACK_PUSH
005F10  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
005F13  8B FE                 MOV    di, si ; MOV
005F15  8C D8                 MOV    ax, ds ; MOV
005F17  8E C0                 MOV    es, ax ; MOV
005F19  33 C0                 XOR    ax, ax ; LOGIC
005F1B  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
005F1E  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005F20  F7 D1                 NOT    cx ; LOGIC
005F22  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
005F25  8B C7                 MOV    ax, di ; MOV
005F27  A8 01                 TEST   al, 1 ; LOGIC
005F29  74 02                 JE     0x5f2d ; CJUMP
005F2B  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
005F2C  49                    DEC    cx ; ARITH
005F2D  D1 E9                 SHR    cx, 1 ; LOGIC
005F2F  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
005F31  13 C9                 ADC    cx, cx ; ARITH
005F33  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
005F35  8B F3                 MOV    si, bx ; MOV
005F37  8B FA                 MOV    di, dx ; MOV
005F39  1F                    POP    ds ; STACK_POP
005F3A  8C C2                 MOV    dx, es ; MOV
005F3C  5D                    POP    bp ; STACK_POP
005F3D  CB                    RETF ; RETURN
