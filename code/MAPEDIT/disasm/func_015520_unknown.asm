; ============================================================================
; func_015520_unknown
; Region   : load_image
; Bytes    : file 0x015520..0x015553  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015520  55                    PUSH   bp ; STACK_PUSH
015521  8B EC                 MOV    bp, sp ; MOV
015523  57                    PUSH   di ; STACK_PUSH
015524  56                    PUSH   si ; STACK_PUSH
015525  1E                    PUSH   ds ; STACK_PUSH
015526  07                    POP    es ; STACK_POP
015527  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
01552A  8B D7                 MOV    dx, di ; MOV
01552C  33 C0                 XOR    ax, ax ; LOGIC
01552E  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
015531  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015533  4F                    DEC    di ; ARITH
015534  8B F7                 MOV    si, di ; MOV
015536  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
015539  8B DF                 MOV    bx, di ; MOV
01553B  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
01553E  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015540  75 01                 JNE    0x15543 ; CJUMP
015542  41                    INC    cx ; ARITH
015543  2B 4E 0A              SUB    cx, word ptr [bp + 0xa] ; ARITH
015546  F7 D9                 NEG    cx ; ARITH
015548  8B FE                 MOV    di, si ; MOV
01554A  8B F3                 MOV    si, bx ; MOV
01554C  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
01554E  AA                    STOSB  byte ptr es:[di], al ; STR
01554F  8B C2                 MOV    ax, dx ; MOV
015551  5E                    POP    si ; STACK_POP
015552  5F                    POP    di ; STACK_POP
