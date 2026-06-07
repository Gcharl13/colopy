; ============================================================================
; func_015C6C_unknown
; Region   : load_image
; Bytes    : file 0x015C6C..0x015CA2  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015C6C  55                    PUSH   bp ; STACK_PUSH
015C6D  8B EC                 MOV    bp, sp ; MOV
015C6F  8B D7                 MOV    dx, di ; MOV
015C71  8B DE                 MOV    bx, si ; MOV
015C73  1E                    PUSH   ds ; STACK_PUSH
015C74  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
015C77  8B FE                 MOV    di, si ; MOV
015C79  8C D8                 MOV    ax, ds ; MOV
015C7B  8E C0                 MOV    es, ax ; MOV
015C7D  33 C0                 XOR    ax, ax ; LOGIC
015C7F  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
015C82  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015C84  F7 D1                 NOT    cx ; LOGIC
015C86  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
015C89  8B C7                 MOV    ax, di ; MOV
015C8B  A8 01                 TEST   al, 1 ; LOGIC
015C8D  74 02                 JE     0x15c91 ; CJUMP
015C8F  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
015C90  49                    DEC    cx ; ARITH
015C91  D1 E9                 SHR    cx, 1 ; LOGIC
015C93  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
015C95  13 C9                 ADC    cx, cx ; ARITH
015C97  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
015C99  8B F3                 MOV    si, bx ; MOV
015C9B  8B FA                 MOV    di, dx ; MOV
015C9D  1F                    POP    ds ; STACK_POP
015C9E  8C C2                 MOV    dx, es ; MOV
015CA0  5D                    POP    bp ; STACK_POP
015CA1  CB                    RETF ; RETURN
