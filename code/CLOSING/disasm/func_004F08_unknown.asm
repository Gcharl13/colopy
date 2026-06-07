; ============================================================================
; func_004F08_unknown
; Region   : load_image
; Bytes    : file 0x004F08..0x004F3E  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004F08  55                    PUSH   bp ; STACK_PUSH
004F09  8B EC                 MOV    bp, sp ; MOV
004F0B  8B D7                 MOV    dx, di ; MOV
004F0D  8B DE                 MOV    bx, si ; MOV
004F0F  1E                    PUSH   ds ; STACK_PUSH
004F10  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
004F13  8B FE                 MOV    di, si ; MOV
004F15  8C D8                 MOV    ax, ds ; MOV
004F17  8E C0                 MOV    es, ax ; MOV
004F19  33 C0                 XOR    ax, ax ; LOGIC
004F1B  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
004F1E  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004F20  F7 D1                 NOT    cx ; LOGIC
004F22  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
004F25  8B C7                 MOV    ax, di ; MOV
004F27  A8 01                 TEST   al, 1 ; LOGIC
004F29  74 02                 JE     0x4f2d ; CJUMP
004F2B  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
004F2C  49                    DEC    cx ; ARITH
004F2D  D1 E9                 SHR    cx, 1 ; LOGIC
004F2F  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
004F31  13 C9                 ADC    cx, cx ; ARITH
004F33  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
004F35  8B F3                 MOV    si, bx ; MOV
004F37  8B FA                 MOV    di, dx ; MOV
004F39  1F                    POP    ds ; STACK_POP
004F3A  8C C2                 MOV    dx, es ; MOV
004F3C  5D                    POP    bp ; STACK_POP
004F3D  CB                    RETF ; RETURN
