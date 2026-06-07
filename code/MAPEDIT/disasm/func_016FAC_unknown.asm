; ============================================================================
; func_016FAC_unknown
; Region   : load_image
; Bytes    : file 0x016FAC..0x016FD8  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016FAC  55                    PUSH   bp ; STACK_PUSH
016FAD  8B EC                 MOV    bp, sp ; MOV
016FAF  8B D7                 MOV    dx, di ; MOV
016FB1  8B DE                 MOV    bx, si ; MOV
016FB3  8C D8                 MOV    ax, ds ; MOV
016FB5  8E C0                 MOV    es, ax ; MOV
016FB7  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
016FBA  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
016FBD  8B C7                 MOV    ax, di ; MOV
016FBF  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
016FC2  E3 0E                 JCXZ   0x16fd2 ; CJUMP
016FC4  A8 01                 TEST   al, 1 ; LOGIC
016FC6  74 02                 JE     0x16fca ; CJUMP
016FC8  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
016FC9  49                    DEC    cx ; ARITH
016FCA  D1 E9                 SHR    cx, 1 ; LOGIC
016FCC  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
016FCE  13 C9                 ADC    cx, cx ; ARITH
016FD0  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
016FD2  8B F3                 MOV    si, bx ; MOV
016FD4  8B FA                 MOV    di, dx ; MOV
016FD6  5D                    POP    bp ; STACK_POP
016FD7  CB                    RETF ; RETURN
