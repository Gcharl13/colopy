; ============================================================================
; strcat_near  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x00fd74 (64 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: MSC 6.0 strcat (size estimated)
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x015466..0x0154A6  (64 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x00fd74)
; ============================================================================

015466  55                    PUSH   bp ; STACK_PUSH
015467  8B EC                 MOV    bp, sp ; MOV
015469  8B D7                 MOV    dx, di ; MOV
01546B  8B DE                 MOV    bx, si ; MOV
01546D  8C D8                 MOV    ax, ds ; MOV
01546F  8E C0                 MOV    es, ax ; MOV
015471  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
015474  33 C0                 XOR    ax, ax ; LOGIC
015476  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
015479  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
01547B  8D 75 FF              LEA    si, [di - 1] ; ADDR
01547E  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
015481  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
015484  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015486  F7 D1                 NOT    cx ; LOGIC
015488  2B F9                 SUB    di, cx ; ARITH
01548A  87 FE                 XCHG   si, di ; MOV
01548C  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
01548F  F7 C6 01 00           TEST   si, 1 ; LOGIC
015493  74 02                 JE     0x15497 ; CJUMP
015495  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
015496  49                    DEC    cx ; ARITH
015497  D1 E9                 SHR    cx, 1 ; LOGIC
015499  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
01549B  13 C9                 ADC    cx, cx ; ARITH
01549D  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
01549F  8B F3                 MOV    si, bx ; MOV
0154A1  8B FA                 MOV    di, dx ; MOV
0154A3  5D                    POP    bp ; STACK_POP
0154A4  CB                    RETF ; RETURN
