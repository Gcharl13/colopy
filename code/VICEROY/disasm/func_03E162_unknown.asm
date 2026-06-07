; ============================================================================
; func_03E162_unknown
; Region   : overlay
; Bytes    : file 0x03E162..0x03E1F3  (145 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03E162  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
03E166  56                    PUSH   si ; STACK_PUSH
03E167  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03E16A  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
03E16F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03E172  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
03E177  74 03                 JE     0x3e17c ; CJUMP
03E179  E9 6A 01              JMP    0x3e2e6 ; JUMP
03E17C  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
03E17F  2A E4                 SUB    ah, ah ; ARITH
03E181  C1 E0 03              SHL    ax, 3 ; LOGIC
03E184  05 0A 00              ADD    ax, 0xa ; ARITH
03E187  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03E18A  81 3E 8A 53 40 06     CMP    word ptr [0x538a], 0x640 ; CMP
03E190  7C 05                 JL     0x3e197 ; CJUMP
03E192  D1 E0                 SHL    ax, 1 ; LOGIC
03E194  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03E197  81 3E 8A 53 A4 06     CMP    word ptr [0x538a], 0x6a4 ; CMP
03E19D  7C 03                 JL     0x3e1a2 ; CJUMP
03E19F  D1 66 FC              SHL    word ptr [bp - 4], 1 ; LOGIC
03E1A2  81 3E 8A 53 D6 06     CMP    word ptr [0x538a], 0x6d6 ; CMP
03E1A8  7C 03                 JL     0x3e1ad ; CJUMP
03E1AA  D1 66 FC              SHL    word ptr [bp - 4], 1 ; LOGIC
03E1AD  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
03E1B0  99                    CDQ ; ARITH
03E1B1  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
03E1B5  01 47 22              ADD    word ptr [bx + 0x22], ax ; ARITH
03E1B8  11 57 24              ADC    word ptr [bx + 0x24], dx ; ARITH
03E1BB  83 7F 24 00           CMP    word ptr [bx + 0x24], 0 ; CMP
03E1BF  7F 0F                 JG     0x3e1d0 ; CJUMP
03E1C1  7D 03                 JGE    0x3e1c6 ; CJUMP
03E1C3  E9 20 01              JMP    0x3e2e6 ; JUMP
03E1C6  81 7F 22 08 07        CMP    word ptr [bx + 0x22], 0x708 ; CMP
03E1CB  73 03                 JAE    0x3e1d0 ; CJUMP
03E1CD  E9 16 01              JMP    0x3e2e6 ; JUMP
03E1D0  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
03E1D5  A1 DA 53              MOV    ax, word ptr [0x53da] ; GLOBAL_LOAD
03E1D8  40                    INC    ax ; ARITH
03E1D9  40                    INC    ax ; ARITH
03E1DA  B9 03 00              MOV    cx, 3 ; MOV
03E1DD  99                    CDQ ; ARITH
03E1DE  F7 F9                 IDIV   cx ; ARITH
03E1E0  3B 06 DC 53           CMP    ax, word ptr [0x53dc] ; CMP
03E1E4  7E 05                 JLE    0x3e1eb ; CJUMP
03E1E6  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1 ; LOCAL_STORE
03E1EB  A1 DA 53              MOV    ax, word ptr [0x53da] ; GLOBAL_LOAD
03E1EE  99                    CDQ ; ARITH
03E1EF  33 C2                 XOR    ax, dx ; LOGIC
03E1F1  2B C2                 SUB    ax, dx ; ARITH
