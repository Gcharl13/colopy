; ============================================================================
; func_067082_unknown
; Region   : overlay
; Bytes    : file 0x067082..0x067148  (198 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067082  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
067086  8A 0E 96 53           MOV    cl, byte ptr [0x5396] ; GLOBAL_LOAD
06708A  80 C1 04              ADD    cl, 4 ; ARITH
06708D  B0 01                 MOV    al, 1 ; MOV
06708F  D2 E0                 SHL    al, cl ; LOGIC
067091  88 46 F7              MOV    byte ptr [bp - 9], al ; LOCAL_STORE
067094  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
067097  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
06709A  48                    DEC    ax ; ARITH
06709B  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
06709E  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
0670A1  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
0670A4  48                    DEC    ax ; ARITH
0670A5  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
0670A8  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
0670AB  50                    PUSH   ax ; STACK_PUSH
0670AC  8D 46 F4              LEA    ax, [bp - 0xc] ; ADDR
0670AF  50                    PUSH   ax ; STACK_PUSH
0670B0  8D 46 08              LEA    ax, [bp + 8] ; ADDR
0670B3  50                    PUSH   ax ; STACK_PUSH
0670B4  8D 46 06              LEA    ax, [bp + 6] ; ADDR
0670B7  50                    PUSH   ax ; STACK_PUSH
0670B8  9A 06 09 1F 1A        LCALL  0x1a1f, 0x906 ; THUNK -> 0x0000:0x000C (thunk @file 0x01CEF6 type A) overlay @file 0x02590C
0670BD  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0670C0  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
0670C5  83 3E 9A 53 00        CMP    word ptr [0x539a], 0 ; CMP
0670CA  7F 03                 JG     0x670cf ; CJUMP
0670CC  E9 99 00              JMP    0x67168 ; JUMP
0670CF  C7 46 FA EC 54        MOV    word ptr [bp - 6], 0x54ec ; LOCAL_STORE
0670D4  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
0670D7  8A 07                 MOV    al, byte ptr [bx] ; MOV
0670D9  2A E4                 SUB    ah, ah ; ARITH
0670DB  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0670DE  8A 4F 01              MOV    cl, byte ptr [bx + 1] ; MOV
0670E1  2A ED                 SUB    ch, ch ; ARITH
0670E3  89 4E FE              MOV    word ptr [bp - 2], cx ; LOCAL_STORE
0670E6  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
0670E9  7C 6B                 JL     0x67156 ; CJUMP
0670EB  39 46 F4              CMP    word ptr [bp - 0xc], ax ; CMP
0670EE  7C 66                 JL     0x67156 ; CJUMP
0670F0  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0670F3  3B C8                 CMP    cx, ax ; CMP
0670F5  7C 5F                 JL     0x67156 ; CJUMP
0670F7  8B C1                 MOV    ax, cx ; MOV
0670F9  39 46 F2              CMP    word ptr [bp - 0xe], ax ; CMP
0670FC  7C 58                 JL     0x67156 ; CJUMP
0670FE  50                    PUSH   ax ; STACK_PUSH
0670FF  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
067102  9A 4A 07 1F 18        LCALL  0x181f, 0x74a ; THUNK -> 0x037F:0x02F8 (thunk @file 0x01AD3A type B) overlay @file 0x02EE34
067107  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06710A  84 46 F7              TEST   byte ptr [bp - 9], al ; LOGIC
06710D  75 07                 JNE    0x67116 ; CJUMP
06710F  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
067114  74 40                 JE     0x67156 ; CJUMP
067116  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
06711A  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
06711E  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
067122  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
067126  FF 36 86 01           PUSH   word ptr [0x186] ; PUSH_GLOBAL
06712A  A1 2A 83              MOV    ax, word ptr [0x832a] ; GLOBAL_LOAD
06712D  2B 06 28 83           SUB    ax, word ptr [0x8328] ; ARITH
067131  03 46 FC              ADD    ax, word ptr [bp - 4] ; ARITH
067134  F7 2E D4 5A           IMUL   word ptr [0x5ad4] ; ARITH
067138  8B D0                 MOV    dx, ax ; MOV
06713A  A1 2C 83              MOV    ax, word ptr [0x832c] ; GLOBAL_LOAD
06713D  2B 06 2E 83           SUB    ax, word ptr [0x832e] ; ARITH
067141  03 46 FE              ADD    ax, word ptr [bp - 2] ; ARITH
067144  8B CA                 MOV    cx, dx ; MOV
067146  F7                    DB     0xF7 ; DATA_BYTE
067147  2E                    DB     0x2E ; DATA_BYTE
