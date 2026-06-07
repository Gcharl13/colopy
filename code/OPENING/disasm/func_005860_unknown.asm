; ============================================================================
; func_005860_unknown
; Region   : load_image
; Bytes    : file 0x005860..0x005893  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005860  55                    PUSH   bp ; STACK_PUSH
005861  8B EC                 MOV    bp, sp ; MOV
005863  57                    PUSH   di ; STACK_PUSH
005864  56                    PUSH   si ; STACK_PUSH
005865  1E                    PUSH   ds ; STACK_PUSH
005866  07                    POP    es ; STACK_POP
005867  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00586A  8B D7                 MOV    dx, di ; MOV
00586C  33 C0                 XOR    ax, ax ; LOGIC
00586E  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
005871  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005873  4F                    DEC    di ; ARITH
005874  8B F7                 MOV    si, di ; MOV
005876  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
005879  8B DF                 MOV    bx, di ; MOV
00587B  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
00587E  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005880  75 01                 JNE    0x5883 ; CJUMP
005882  41                    INC    cx ; ARITH
005883  2B 4E 0A              SUB    cx, word ptr [bp + 0xa] ; ARITH
005886  F7 D9                 NEG    cx ; ARITH
005888  8B FE                 MOV    di, si ; MOV
00588A  8B F3                 MOV    si, bx ; MOV
00588C  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
00588E  AA                    STOSB  byte ptr es:[di], al ; STR
00588F  8B C2                 MOV    ax, dx ; MOV
005891  5E                    POP    si ; STACK_POP
005892  5F                    POP    di ; STACK_POP
