; ============================================================================
; func_0673CC_unknown
; Region   : overlay
; Bytes    : file 0x0673CC..0x067459  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0673CC  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0673D0  57                    PUSH   di ; STACK_PUSH
0673D1  56                    PUSH   si ; STACK_PUSH
0673D2  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
0673D6  74 09                 JE     0x673e1 ; CJUMP
0673D8  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
0673DC  75 03                 JNE    0x673e1 ; CJUMP
0673DE  E9 90 00              JMP    0x67471 ; JUMP
0673E1  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
0673E5  74 09                 JE     0x673f0 ; CJUMP
0673E7  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0673EA  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
0673EE  75 1E                 JNE    0x6740e ; CJUMP
0673F0  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0673F3  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
0673F6  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
0673FA  2A E4                 SUB    ah, ah ; ARITH
0673FC  50                    PUSH   ax ; STACK_PUSH
0673FD  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
067401  50                    PUSH   ax ; STACK_PUSH
067402  9A BE 07 1F 18        LCALL  0x181f, 0x7be ; THUNK -> 0x05EB:0x0A76 (thunk @file 0x01ADAE type B) overlay @file 0x027A66
067407  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06740A  0B C0                 OR     ax, ax ; LOGIC
06740C  7D 63                 JGE    0x67471 ; CJUMP
06740E  83 7E 08 01           CMP    word ptr [bp + 8], 1 ; CMP
067412  1B FF                 SBB    di, di ; ARITH
067414  83 E7 40              AND    di, 0x40 ; LOGIC
067417  81 C7 80 00           ADD    di, 0x80 ; ARITH
06741B  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
06741E  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
067422  2A E4                 SUB    ah, ah ; ARITH
067424  2B 06 28 83           SUB    ax, word ptr [0x8328] ; ARITH
067428  03 06 2A 83           ADD    ax, word ptr [0x832a] ; ARITH
06742C  F7 2E D4 5A           IMUL   word ptr [0x5ad4] ; ARITH
067430  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
067433  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
067437  2A E4                 SUB    ah, ah ; ARITH
067439  2B 06 2E 83           SUB    ax, word ptr [0x832e] ; ARITH
06743D  03 06 2C 83           ADD    ax, word ptr [0x832c] ; ARITH
067441  F7 2E 26 83           IMUL   word ptr [0x8326] ; ARITH
067445  05 08 00              ADD    ax, 8 ; ARITH
067448  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06744B  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
06744F  24 0F                 AND    al, 0xf ; LOGIC
067451  3A 06 96 53           CMP    al, byte ptr [0x5396] ; CMP
067455  74 03                 JE     0x6745a ; CJUMP
067457  83                    DB     0x83 ; DATA_BYTE
067458  CF                    DB     0xCF ; DATA_BYTE
