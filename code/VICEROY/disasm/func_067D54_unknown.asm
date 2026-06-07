; ============================================================================
; func_067D54_unknown
; Region   : overlay
; Bytes    : file 0x067D54..0x067DBA  (102 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067D54  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
067D58  50                    PUSH   ax ; STACK_PUSH
067D59  56                    PUSH   si ; STACK_PUSH
067D5A  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
067D5F  3B 16 84 01           CMP    dx, word ptr [0x184] ; CMP
067D63  7C 5D                 JL     0x67dc2 ; CJUMP
067D65  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
067D6A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
067D6F  EB 36                 JMP    0x67da7 ; JUMP
067D71  90                    NOP ; NOP
067D72  A1 48 85              MOV    ax, word ptr [0x8548] ; GLOBAL_LOAD
067D75  F7 D0                 NOT    ax ; LOGIC
067D77  40                    INC    ax ; ARITH
067D78  EB 02                 JMP    0x67d7c ; JUMP
067D7A  2B C0                 SUB    ax, ax ; ARITH
067D7C  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
067D7F  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
067D83  98                    CWDE ; ARITH
067D84  8B D8                 MOV    bx, ax ; MOV
067D86  03 1E 94 A5           ADD    bx, word ptr [0xa594] ; ARITH
067D8A  8E 06 96 A5           MOV    es, word ptr [0xa596] ; GLOBAL_LOAD
067D8E  8B 76 F8              MOV    si, word ptr [bp - 8] ; LOCAL_LOAD
067D91  26 8A 00              MOV    al, byte ptr es:[bx + si] ; MOV
067D94  2A E4                 SUB    ah, ah ; ARITH
067D96  85 46 F4              TEST   word ptr [bp - 0xc], ax ; LOGIC
067D99  74 06                 JE     0x67da1 ; CJUMP
067D9B  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
067D9E  09 46 FC              OR     word ptr [bp - 4], ax ; LOGIC
067DA1  D1 66 FA              SHL    word ptr [bp - 6], 1 ; LOGIC
067DA4  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
067DA7  83 7E FE 08           CMP    word ptr [bp - 2], 8 ; CMP
067DAB  7D 15                 JGE    0x67dc2 ; CJUMP
067DAD  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
067DB0  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
067DB4  0A C0                 OR     al, al ; LOGIC
067DB6  74 C2                 JE     0x67d7a ; CJUMP
067DB8  0A C0                 OR     al, al ; LOGIC
