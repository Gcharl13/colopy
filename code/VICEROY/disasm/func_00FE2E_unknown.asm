; ============================================================================
; func_00FE2E_unknown
; Region   : load_image
; Bytes    : file 0x00FE2E..0x00FE61  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FE2E  55                    PUSH   bp ; STACK_PUSH
00FE2F  8B EC                 MOV    bp, sp ; MOV
00FE31  57                    PUSH   di ; STACK_PUSH
00FE32  56                    PUSH   si ; STACK_PUSH
00FE33  1E                    PUSH   ds ; STACK_PUSH
00FE34  07                    POP    es ; STACK_POP
00FE35  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00FE38  8B D7                 MOV    dx, di ; MOV
00FE3A  33 C0                 XOR    ax, ax ; LOGIC
00FE3C  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
00FE3F  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
00FE41  4F                    DEC    di ; ARITH
00FE42  8B F7                 MOV    si, di ; MOV
00FE44  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
00FE47  8B DF                 MOV    bx, di ; MOV
00FE49  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
00FE4C  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
00FE4E  75 01                 JNE    0xfe51 ; CJUMP
00FE50  41                    INC    cx ; ARITH
00FE51  2B 4E 0A              SUB    cx, word ptr [bp + 0xa] ; ARITH
00FE54  F7 D9                 NEG    cx ; ARITH
00FE56  8B FE                 MOV    di, si ; MOV
00FE58  8B F3                 MOV    si, bx ; MOV
00FE5A  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
00FE5C  AA                    STOSB  byte ptr es:[di], al ; STR
00FE5D  8B C2                 MOV    ax, dx ; MOV
00FE5F  5E                    POP    si ; STACK_POP
00FE60  5F                    POP    di ; STACK_POP
