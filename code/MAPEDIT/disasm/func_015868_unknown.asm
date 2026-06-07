; ============================================================================
; func_015868_unknown
; Region   : load_image
; Bytes    : file 0x015868..0x015892  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015868  55                    PUSH   bp ; STACK_PUSH
015869  8B EC                 MOV    bp, sp ; MOV
01586B  57                    PUSH   di ; STACK_PUSH
01586C  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
01586F  1E                    PUSH   ds ; STACK_PUSH
015870  07                    POP    es ; STACK_POP
015871  8B DF                 MOV    bx, di ; MOV
015873  33 C0                 XOR    ax, ax ; LOGIC
015875  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
015878  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
01587A  41                    INC    cx ; ARITH
01587B  F7 D9                 NEG    cx ; ARITH
01587D  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
015880  8B FB                 MOV    di, bx ; MOV
015882  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015884  4F                    DEC    di ; ARITH
015885  38 05                 CMP    byte ptr [di], al ; CMP
015887  74 02                 JE     0x1588b ; CJUMP
015889  33 FF                 XOR    di, di ; LOGIC
01588B  8B C7                 MOV    ax, di ; MOV
01588D  5F                    POP    di ; STACK_POP
01588E  8B E5                 MOV    sp, bp ; MOV
015890  5D                    POP    bp ; STACK_POP
015891  CB                    RETF ; RETURN
