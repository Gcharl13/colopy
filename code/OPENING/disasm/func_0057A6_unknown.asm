; ============================================================================
; strcat_near  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x00fd74 (64 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: MSC 6.0 strcat (size estimated)
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x0057A6..0x0057E6  (64 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x00fd74)
; ============================================================================

0057A6  55                    PUSH   bp ; STACK_PUSH
0057A7  8B EC                 MOV    bp, sp ; MOV
0057A9  8B D7                 MOV    dx, di ; MOV
0057AB  8B DE                 MOV    bx, si ; MOV
0057AD  8C D8                 MOV    ax, ds ; MOV
0057AF  8E C0                 MOV    es, ax ; MOV
0057B1  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0057B4  33 C0                 XOR    ax, ax ; LOGIC
0057B6  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
0057B9  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0057BB  8D 75 FF              LEA    si, [di - 1] ; ADDR
0057BE  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
0057C1  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
0057C4  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0057C6  F7 D1                 NOT    cx ; LOGIC
0057C8  2B F9                 SUB    di, cx ; ARITH
0057CA  87 FE                 XCHG   si, di ; MOV
0057CC  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0057CF  F7 C6 01 00           TEST   si, 1 ; LOGIC
0057D3  74 02                 JE     0x57d7 ; CJUMP
0057D5  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
0057D6  49                    DEC    cx ; ARITH
0057D7  D1 E9                 SHR    cx, 1 ; LOGIC
0057D9  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
0057DB  13 C9                 ADC    cx, cx ; ARITH
0057DD  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
0057DF  8B F3                 MOV    si, bx ; MOV
0057E1  8B FA                 MOV    di, dx ; MOV
0057E3  5D                    POP    bp ; STACK_POP
0057E4  CB                    RETF ; RETURN
