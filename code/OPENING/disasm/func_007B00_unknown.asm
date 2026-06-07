; ============================================================================
; func_007B00_unknown
; Region   : load_image
; Bytes    : file 0x007B00..0x007B2B  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007B00  55                    PUSH   bp ; STACK_PUSH
007B01  8B EC                 MOV    bp, sp ; MOV
007B03  57                    PUSH   di ; STACK_PUSH
007B04  1E                    PUSH   ds ; STACK_PUSH
007B05  07                    POP    es ; STACK_POP
007B06  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
007B09  33 C0                 XOR    ax, ax ; LOGIC
007B0B  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
007B0E  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
007B10  41                    INC    cx ; ARITH
007B11  F7 D9                 NEG    cx ; ARITH
007B13  4F                    DEC    di ; ARITH
007B14  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
007B17  FD                    STD ; FLAG
007B18  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
007B1A  47                    INC    di ; ARITH
007B1B  38 05                 CMP    byte ptr [di], al ; CMP
007B1D  74 04                 JE     0x7b23 ; CJUMP
007B1F  33 C0                 XOR    ax, ax ; LOGIC
007B21  EB 02                 JMP    0x7b25 ; JUMP
007B23  8B C7                 MOV    ax, di ; MOV
007B25  FC                    CLD ; FLAG
007B26  5F                    POP    di ; STACK_POP
007B27  8B E5                 MOV    sp, bp ; MOV
007B29  5D                    POP    bp ; STACK_POP
007B2A  CB                    RETF ; RETURN
