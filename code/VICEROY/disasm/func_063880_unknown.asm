; ============================================================================
; func_063880_unknown
; Region   : overlay
; Bytes    : file 0x063880..0x0638FD  (125 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063880  C8 2E 00 00           ENTER  0x2e, 0 ; PROLOGUE
063884  56                    PUSH   si ; STACK_PUSH
063885  2B C0                 SUB    ax, ax ; ARITH
063887  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06388A  A1 C6 23              MOV    ax, word ptr [0x23c6] ; GLOBAL_LOAD
06388D  8B 16 C8 23           MOV    dx, word ptr [0x23c8] ; GLOBAL_LOAD
063891  89 46 DC              MOV    word ptr [bp - 0x24], ax ; LOCAL_STORE
063894  89 56 DE              MOV    word ptr [bp - 0x22], dx ; LOCAL_STORE
063897  80 C4 80              ADD    ah, 0x80 ; ARITH
06389A  89 46 D4              MOV    word ptr [bp - 0x2c], ax ; LOCAL_STORE
06389D  89 56 D6              MOV    word ptr [bp - 0x2a], dx ; LOCAL_STORE
0638A0  FF 36 BE 85           PUSH   word ptr [0x85be] ; PUSH_GLOBAL
0638A4  FF 36 BC 85           PUSH   word ptr [0x85bc] ; PUSH_GLOBAL
0638A8  FF 36 BA 85           PUSH   word ptr [0x85ba] ; PUSH_GLOBAL
0638AC  FF 36 B8 85           PUSH   word ptr [0x85b8] ; PUSH_GLOBAL
0638B0  2A C0                 SUB    al, al ; ARITH
0638B2  9A 84 04 1F 18        LCALL  0x181f, 0x484 ; THUNK -> 0x0B8D:0x0004 (thunk @file 0x01AA74 type B)
0638B7  C7 46 E4 01 00        MOV    word ptr [bp - 0x1c], 1 ; LOCAL_STORE
0638BC  E9 A6 02              JMP    0x63b65 ; JUMP
0638BF  90                    NOP ; NOP
0638C0  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff ; LOCAL_STORE
0638C5  EB 55                 JMP    0x6391c ; JUMP
0638C7  90                    NOP ; NOP
0638C8  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
0638CB  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0638CE  39 06 3A 85           CMP    word ptr [0x853a], ax ; CMP
0638D2  7C 2A                 JL     0x638fe ; CJUMP
0638D4  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
0638D7  F7 6E F8              IMUL   word ptr [bp - 8] ; ARITH
0638DA  8B D8                 MOV    bx, ax ; MOV
0638DC  03 5E FE              ADD    bx, word ptr [bp - 2] ; ARITH
0638DF  D1 E3                 SHL    bx, 1 ; LOGIC
0638E1  03 5E D4              ADD    bx, word ptr [bp - 0x2c] ; ARITH
0638E4  8E 46 D6              MOV    es, word ptr [bp - 0x2a] ; LOCAL_LOAD
0638E7  89 5E E0              MOV    word ptr [bp - 0x20], bx ; LOCAL_STORE
0638EA  8C 46 E2              MOV    word ptr [bp - 0x1e], es ; LOCAL_STORE
0638ED  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
0638F0  26 39 07              CMP    word ptr es:[bx], ax ; CMP
0638F3  75 D3                 JNE    0x638c8 ; CJUMP
0638F5  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
0638F8  26 89 07              MOV    word ptr es:[bx], ax ; MOV
0638FB  EB CB                 JMP    0x638c8 ; JUMP
