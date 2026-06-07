; ============================================================================
; func_005B4E_unknown
; Region   : load_image
; Bytes    : file 0x005B4E..0x005B78  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005B4E  55                    PUSH   bp ; STACK_PUSH
005B4F  8B EC                 MOV    bp, sp ; MOV
005B51  57                    PUSH   di ; STACK_PUSH
005B52  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
005B55  1E                    PUSH   ds ; STACK_PUSH
005B56  07                    POP    es ; STACK_POP
005B57  8B DF                 MOV    bx, di ; MOV
005B59  33 C0                 XOR    ax, ax ; LOGIC
005B5B  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
005B5E  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005B60  41                    INC    cx ; ARITH
005B61  F7 D9                 NEG    cx ; ARITH
005B63  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
005B66  8B FB                 MOV    di, bx ; MOV
005B68  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005B6A  4F                    DEC    di ; ARITH
005B6B  38 05                 CMP    byte ptr [di], al ; CMP
005B6D  74 02                 JE     0x5b71 ; CJUMP
005B6F  33 FF                 XOR    di, di ; LOGIC
005B71  8B C7                 MOV    ax, di ; MOV
005B73  5F                    POP    di ; STACK_POP
005B74  8B E5                 MOV    sp, bp ; MOV
005B76  5D                    POP    bp ; STACK_POP
005B77  CB                    RETF ; RETURN
