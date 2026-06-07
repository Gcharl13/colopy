; ============================================================================
; func_004B8A_unknown
; Region   : load_image
; Bytes    : file 0x004B8A..0x004BB4  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004B8A  55                    PUSH   bp ; STACK_PUSH
004B8B  8B EC                 MOV    bp, sp ; MOV
004B8D  57                    PUSH   di ; STACK_PUSH
004B8E  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
004B91  1E                    PUSH   ds ; STACK_PUSH
004B92  07                    POP    es ; STACK_POP
004B93  8B DF                 MOV    bx, di ; MOV
004B95  33 C0                 XOR    ax, ax ; LOGIC
004B97  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
004B9A  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004B9C  41                    INC    cx ; ARITH
004B9D  F7 D9                 NEG    cx ; ARITH
004B9F  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
004BA2  8B FB                 MOV    di, bx ; MOV
004BA4  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004BA6  4F                    DEC    di ; ARITH
004BA7  38 05                 CMP    byte ptr [di], al ; CMP
004BA9  74 02                 JE     0x4bad ; CJUMP
004BAB  33 FF                 XOR    di, di ; LOGIC
004BAD  8B C7                 MOV    ax, di ; MOV
004BAF  5F                    POP    di ; STACK_POP
004BB0  8B E5                 MOV    sp, bp ; MOV
004BB2  5D                    POP    bp ; STACK_POP
004BB3  CB                    RETF ; RETURN
