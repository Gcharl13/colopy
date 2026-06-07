; ============================================================================
; func_007024_unknown
; Region   : load_image
; Bytes    : file 0x007024..0x007050  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007024  55                    PUSH   bp ; STACK_PUSH
007025  8B EC                 MOV    bp, sp ; MOV
007027  8B D7                 MOV    dx, di ; MOV
007029  8B DE                 MOV    bx, si ; MOV
00702B  8C D8                 MOV    ax, ds ; MOV
00702D  8E C0                 MOV    es, ax ; MOV
00702F  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
007032  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
007035  8B C7                 MOV    ax, di ; MOV
007037  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
00703A  E3 0E                 JCXZ   0x704a ; CJUMP
00703C  A8 01                 TEST   al, 1 ; LOGIC
00703E  74 02                 JE     0x7042 ; CJUMP
007040  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
007041  49                    DEC    cx ; ARITH
007042  D1 E9                 SHR    cx, 1 ; LOGIC
007044  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
007046  13 C9                 ADC    cx, cx ; ARITH
007048  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
00704A  8B F3                 MOV    si, bx ; MOV
00704C  8B FA                 MOV    di, dx ; MOV
00704E  5D                    POP    bp ; STACK_POP
00704F  CB                    RETF ; RETURN
