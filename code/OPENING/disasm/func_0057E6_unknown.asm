; ============================================================================
; strcpy_near  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x00fdb4 (28 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: MSC 6.0 strcpy
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x0057E6..0x005802  (28 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x00fdb4)
; ============================================================================

0057E6  55                    PUSH   bp ; STACK_PUSH
0057E7  8B EC                 MOV    bp, sp ; MOV
0057E9  8B D7                 MOV    dx, di ; MOV
0057EB  8B DE                 MOV    bx, si ; MOV
0057ED  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
0057F0  8B FE                 MOV    di, si ; MOV
0057F2  8C D8                 MOV    ax, ds ; MOV
0057F4  8E C0                 MOV    es, ax ; MOV
0057F6  33 C0                 XOR    ax, ax ; LOGIC
0057F8  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
0057FB  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0057FD  F7 D1                 NOT    cx ; LOGIC
0057FF  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
005802  8B C7                 MOV    ax, di ; MOV
005804  A8 01                 TEST   al, 1 ; LOGIC
005806  74 02                 JE     0x580a ; CJUMP
005808  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
005809  49                    DEC    cx ; ARITH
00580A  D1 E9                 SHR    cx, 1 ; LOGIC
00580C  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
00580E  13 C9                 ADC    cx, cx ; ARITH
005810  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
005812  8B F3                 MOV    si, bx ; MOV
005814  8B FA                 MOV    di, dx ; MOV
005816  5D                    POP    bp ; STACK_POP
005817  CB                    RETF ; RETURN
