; ============================================================================
; func_0151B1_unknown
; Region   : load_image
; Bytes    : file 0x0151B1..0x0151F2  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0151B1  55                    PUSH   bp ; STACK_PUSH
0151B2  8B EC                 MOV    bp, sp ; MOV
0151B4  56                    PUSH   si ; STACK_PUSH
0151B5  57                    PUSH   di ; STACK_PUSH
0151B6  06                    PUSH   es ; STACK_PUSH
0151B7  1E                    PUSH   ds ; STACK_PUSH
0151B8  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
0151BB  1E                    PUSH   ds ; STACK_PUSH
0151BC  56                    PUSH   si ; STACK_PUSH
0151BD  E8 59 00              CALL   0x15219 ; CALL_NEAR
0151C0  5E                    POP    si ; STACK_POP
0151C1  1F                    POP    ds ; STACK_POP
0151C2  83 C6 02              ADD    si, 2 ; ARITH
0151C5  2E C4 3E 52 39        LES    di, ptr cs:[0x3952] ; MOV_FAR
0151CA  0B FF                 OR     di, di ; LOGIC
0151CC  74 24                 JE     0x151f2 ; CJUMP
0151CE  51                    PUSH   cx ; STACK_PUSH
0151CF  B9 0A 00              MOV    cx, 0xa ; CONST_LOAD
0151D2  2B F9                 SUB    di, cx ; ARITH
0151D4  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
0151D6  59                    POP    cx ; STACK_POP
0151D7  8C D6                 MOV    si, ss ; MOV
0151D9  8E DE                 MOV    ds, si ; MOV
0151DB  8E C6                 MOV    es, si ; MOV
0151DD  8D 76 0E              LEA    si, [bp + 0xe] ; ADDR
0151E0  8D 7E 02              LEA    di, [bp + 2] ; ADDR
0151E3  FC                    CLD ; FLAG
0151E4  A5                    MOVSW  word ptr es:[di], word ptr [si] ; STR
0151E5  A5                    MOVSW  word ptr es:[di], word ptr [si] ; STR
0151E6  83 C7 04              ADD    di, 4 ; ARITH
0151E9  A5                    MOVSW  word ptr es:[di], word ptr [si] ; STR
0151EA  A5                    MOVSW  word ptr es:[di], word ptr [si] ; STR
0151EB  A5                    MOVSW  word ptr es:[di], word ptr [si] ; STR
0151EC  1F                    POP    ds ; STACK_POP
0151ED  07                    POP    es ; STACK_POP
0151EE  5F                    POP    di ; STACK_POP
0151EF  5E                    POP    si ; STACK_POP
0151F0  5D                    POP    bp ; STACK_POP
0151F1  CB                    RETF ; RETURN
