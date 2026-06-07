; ============================================================================
; func_006024_unknown
; Region   : load_image
; Bytes    : file 0x006024..0x006050  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006024  55                    PUSH   bp ; STACK_PUSH
006025  8B EC                 MOV    bp, sp ; MOV
006027  8B D7                 MOV    dx, di ; MOV
006029  8B DE                 MOV    bx, si ; MOV
00602B  8C D8                 MOV    ax, ds ; MOV
00602D  8E C0                 MOV    es, ax ; MOV
00602F  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
006032  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
006035  8B C7                 MOV    ax, di ; MOV
006037  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
00603A  E3 0E                 JCXZ   0x604a ; CJUMP
00603C  A8 01                 TEST   al, 1 ; LOGIC
00603E  74 02                 JE     0x6042 ; CJUMP
006040  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
006041  49                    DEC    cx ; ARITH
006042  D1 E9                 SHR    cx, 1 ; LOGIC
006044  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
006046  13 C9                 ADC    cx, cx ; ARITH
006048  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
00604A  8B F3                 MOV    si, bx ; MOV
00604C  8B FA                 MOV    di, dx ; MOV
00604E  5D                    POP    bp ; STACK_POP
00604F  CB                    RETF ; RETURN
