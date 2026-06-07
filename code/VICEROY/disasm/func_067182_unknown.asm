; ============================================================================
; func_067182_unknown
; Region   : overlay
; Bytes    : file 0x067182..0x0671ED  (107 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067182  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
067186  57                    PUSH   di ; STACK_PUSH
067187  56                    PUSH   si ; STACK_PUSH
067188  8A 0E 96 53           MOV    cl, byte ptr [0x5396] ; GLOBAL_LOAD
06718C  80 C1 04              ADD    cl, 4 ; ARITH
06718F  B0 01                 MOV    al, 1 ; MOV
067191  D2 E0                 SHL    al, cl ; LOGIC
067193  88 46 F3              MOV    byte ptr [bp - 0xd], al ; LOCAL_STORE
067196  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
067199  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
06719C  48                    DEC    ax ; ARITH
06719D  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
0671A0  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
0671A3  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
0671A6  48                    DEC    ax ; ARITH
0671A7  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
0671AA  8D 46 EE              LEA    ax, [bp - 0x12] ; ADDR
0671AD  50                    PUSH   ax ; STACK_PUSH
0671AE  8D 46 F0              LEA    ax, [bp - 0x10] ; ADDR
0671B1  50                    PUSH   ax ; STACK_PUSH
0671B2  8D 46 08              LEA    ax, [bp + 8] ; ADDR
0671B5  50                    PUSH   ax ; STACK_PUSH
0671B6  8D 46 06              LEA    ax, [bp + 6] ; ADDR
0671B9  50                    PUSH   ax ; STACK_PUSH
0671BA  9A 06 09 1F 1A        LCALL  0x1a1f, 0x906 ; THUNK -> 0x0000:0x000C (thunk @file 0x01CEF6 type A) overlay @file 0x02590C
0671BF  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0671C2  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0671C7  83 3E 9E 53 00        CMP    word ptr [0x539e], 0 ; CMP
0671CC  7F 03                 JG     0x671d1 ; CJUMP
0671CE  E9 F3 00              JMP    0x672c4 ; JUMP
0671D1  C7 46 FC 46 5D        MOV    word ptr [bp - 4], 0x5d46 ; LOCAL_STORE
0671D6  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
0671D9  8A 07                 MOV    al, byte ptr [bx] ; MOV
0671DB  2A E4                 SUB    ah, ah ; ARITH
0671DD  8B F8                 MOV    di, ax ; MOV
0671DF  8A 4F 01              MOV    cl, byte ptr [bx + 1] ; MOV
0671E2  2A ED                 SUB    ch, ch ; ARITH
0671E4  8B F1                 MOV    si, cx ; MOV
0671E6  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
0671E9  7D 03                 JGE    0x671ee ; CJUMP
0671EB  E9                    DB     0xE9 ; DATA_BYTE
0671EC  C3                    DB     0xC3 ; DATA_BYTE
