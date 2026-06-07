; ============================================================================
; func_010352_unknown
; Region   : load_image
; Bytes    : file 0x010352..0x01037E  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010352  55                    PUSH   bp ; STACK_PUSH
010353  8B EC                 MOV    bp, sp ; MOV
010355  8B D7                 MOV    dx, di ; MOV
010357  8B DE                 MOV    bx, si ; MOV
010359  8C D8                 MOV    ax, ds ; MOV
01035B  8E C0                 MOV    es, ax ; MOV
01035D  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
010360  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
010363  8B C7                 MOV    ax, di ; MOV
010365  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
010368  E3 0E                 JCXZ   0x10378 ; CJUMP
01036A  A8 01                 TEST   al, 1 ; LOGIC
01036C  74 02                 JE     0x10370 ; CJUMP
01036E  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
01036F  49                    DEC    cx ; ARITH
010370  D1 E9                 SHR    cx, 1 ; LOGIC
010372  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
010374  13 C9                 ADC    cx, cx ; ARITH
010376  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
010378  8B F3                 MOV    si, bx ; MOV
01037A  8B FA                 MOV    di, dx ; MOV
01037C  5D                    POP    bp ; STACK_POP
01037D  CB                    RETF ; RETURN
