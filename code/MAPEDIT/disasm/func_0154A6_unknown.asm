; ============================================================================
; strcpy_near  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x00fdb4 (28 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: MSC 6.0 strcpy
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x0154A6..0x0154C2  (28 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x00fdb4)
; ============================================================================

0154A6  55                    PUSH   bp ; STACK_PUSH
0154A7  8B EC                 MOV    bp, sp ; MOV
0154A9  8B D7                 MOV    dx, di ; MOV
0154AB  8B DE                 MOV    bx, si ; MOV
0154AD  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
0154B0  8B FE                 MOV    di, si ; MOV
0154B2  8C D8                 MOV    ax, ds ; MOV
0154B4  8E C0                 MOV    es, ax ; MOV
0154B6  33 C0                 XOR    ax, ax ; LOGIC
0154B8  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
0154BB  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0154BD  F7 D1                 NOT    cx ; LOGIC
0154BF  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0154C2  8B C7                 MOV    ax, di ; MOV
0154C4  A8 01                 TEST   al, 1 ; LOGIC
0154C6  74 02                 JE     0x154ca ; CJUMP
0154C8  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
0154C9  49                    DEC    cx ; ARITH
0154CA  D1 E9                 SHR    cx, 1 ; LOGIC
0154CC  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
0154CE  13 C9                 ADC    cx, cx ; ARITH
0154D0  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
0154D2  8B F3                 MOV    si, bx ; MOV
0154D4  8B FA                 MOV    di, dx ; MOV
0154D6  5D                    POP    bp ; STACK_POP
0154D7  CB                    RETF ; RETURN
