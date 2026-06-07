; ============================================================================
; func_006B0E_unknown
; Region   : load_image
; Bytes    : file 0x006B0E..0x006B39  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006B0E  55                    PUSH   bp ; STACK_PUSH
006B0F  8B EC                 MOV    bp, sp ; MOV
006B11  57                    PUSH   di ; STACK_PUSH
006B12  1E                    PUSH   ds ; STACK_PUSH
006B13  07                    POP    es ; STACK_POP
006B14  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
006B17  33 C0                 XOR    ax, ax ; LOGIC
006B19  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
006B1C  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
006B1E  41                    INC    cx ; ARITH
006B1F  F7 D9                 NEG    cx ; ARITH
006B21  4F                    DEC    di ; ARITH
006B22  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
006B25  FD                    STD ; FLAG
006B26  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
006B28  47                    INC    di ; ARITH
006B29  38 05                 CMP    byte ptr [di], al ; CMP
006B2B  74 04                 JE     0x6b31 ; CJUMP
006B2D  33 C0                 XOR    ax, ax ; LOGIC
006B2F  EB 02                 JMP    0x6b33 ; JUMP
006B31  8B C7                 MOV    ax, di ; MOV
006B33  FC                    CLD ; FLAG
006B34  5F                    POP    di ; STACK_POP
006B35  8B E5                 MOV    sp, bp ; MOV
006B37  5D                    POP    bp ; STACK_POP
006B38  CB                    RETF ; RETURN
