; ============================================================================
; strcpy_near  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x00fdb4 (28 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: MSC 6.0 strcpy
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x004822..0x00483E  (28 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x00fdb4)
; ============================================================================

004822  55                    PUSH   bp ; STACK_PUSH
004823  8B EC                 MOV    bp, sp ; MOV
004825  8B D7                 MOV    dx, di ; MOV
004827  8B DE                 MOV    bx, si ; MOV
004829  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
00482C  8B FE                 MOV    di, si ; MOV
00482E  8C D8                 MOV    ax, ds ; MOV
004830  8E C0                 MOV    es, ax ; MOV
004832  33 C0                 XOR    ax, ax ; LOGIC
004834  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
004837  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004839  F7 D1                 NOT    cx ; LOGIC
00483B  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00483E  8B C7                 MOV    ax, di ; MOV
004840  A8 01                 TEST   al, 1 ; LOGIC
004842  74 02                 JE     0x4846 ; CJUMP
004844  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
004845  49                    DEC    cx ; ARITH
004846  D1 E9                 SHR    cx, 1 ; LOGIC
004848  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
00484A  13 C9                 ADC    cx, cx ; ARITH
00484C  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
00484E  8B F3                 MOV    si, bx ; MOV
004850  8B FA                 MOV    di, dx ; MOV
004852  5D                    POP    bp ; STACK_POP
004853  CB                    RETF ; RETURN
