; ============================================================================
; strcat_near  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x00fd74 (64 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: MSC 6.0 strcat (size estimated)
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x0047E2..0x004822  (64 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x00fd74)
; ============================================================================

0047E2  55                    PUSH   bp ; STACK_PUSH
0047E3  8B EC                 MOV    bp, sp ; MOV
0047E5  8B D7                 MOV    dx, di ; MOV
0047E7  8B DE                 MOV    bx, si ; MOV
0047E9  8C D8                 MOV    ax, ds ; MOV
0047EB  8E C0                 MOV    es, ax ; MOV
0047ED  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0047F0  33 C0                 XOR    ax, ax ; LOGIC
0047F2  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
0047F5  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0047F7  8D 75 FF              LEA    si, [di - 1] ; ADDR
0047FA  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
0047FD  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
004800  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004802  F7 D1                 NOT    cx ; LOGIC
004804  2B F9                 SUB    di, cx ; ARITH
004806  87 FE                 XCHG   si, di ; MOV
004808  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00480B  F7 C6 01 00           TEST   si, 1 ; LOGIC
00480F  74 02                 JE     0x4813 ; CJUMP
004811  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
004812  49                    DEC    cx ; ARITH
004813  D1 E9                 SHR    cx, 1 ; LOGIC
004815  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
004817  13 C9                 ADC    cx, cx ; ARITH
004819  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
00481B  8B F3                 MOV    si, bx ; MOV
00481D  8B FA                 MOV    di, dx ; MOV
00481F  5D                    POP    bp ; STACK_POP
004820  CB                    RETF ; RETURN
