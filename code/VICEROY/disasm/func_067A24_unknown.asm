; ============================================================================
; func_067A24_unknown
; Region   : overlay
; Bytes    : file 0x067A24..0x067AC7  (163 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067A24  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
067A28  56                    PUSH   si ; STACK_PUSH
067A29  2A C0                 SUB    al, al ; ARITH
067A2B  A2 A3 A8              MOV    byte ptr [0xa8a3], al ; GLOBAL_LOAD
067A2E  A2 A6 A8              MOV    byte ptr [0xa8a6], al ; GLOBAL_LOAD
067A31  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
067A36  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
067A39  C6 87 24 2D 00        MOV    byte ptr [bx + 0x2d24], 0 ; MOV
067A3E  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
067A41  83 7E FC 04           CMP    word ptr [bp - 4], 4 ; CMP
067A45  7C EF                 JL     0x67a36 ; CJUMP
067A47  83 3E 84 01 00        CMP    word ptr [0x184], 0 ; CMP
067A4C  74 03                 JE     0x67a51 ; CJUMP
067A4E  E9 BF 00              JMP    0x67b10 ; JUMP
067A51  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
067A56  E9 9E 00              JMP    0x67af7 ; JUMP
067A59  90                    NOP ; NOP
067A5A  A1 48 85              MOV    ax, word ptr [0x8548] ; GLOBAL_LOAD
067A5D  F7 D8                 NEG    ax ; ARITH
067A5F  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
067A62  80 BF BE 00 00        CMP    byte ptr [bx + 0xbe], 0 ; CMP
067A67  7E 05                 JLE    0x67a6e ; CJUMP
067A69  A1 48 85              MOV    ax, word ptr [0x8548] ; GLOBAL_LOAD
067A6C  EB 02                 JMP    0x67a70 ; JUMP
067A6E  2B C0                 SUB    ax, ax ; ARITH
067A70  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
067A73  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
067A77  98                    CWDE ; ARITH
067A78  8B D8                 MOV    bx, ax ; MOV
067A7A  03 1E 98 A5           ADD    bx, word ptr [0xa598] ; ARITH
067A7E  8E 06 9A A5           MOV    es, word ptr [0xa59a] ; GLOBAL_LOAD
067A82  03 5E F2              ADD    bx, word ptr [bp - 0xe] ; ARITH
067A85  8B 76 F0              MOV    si, word ptr [bp - 0x10] ; LOCAL_LOAD
067A88  26 8A 00              MOV    al, byte ptr es:[bx + si] ; MOV
067A8B  24 1F                 AND    al, 0x1f ; LOGIC
067A8D  88 46 F6              MOV    byte ptr [bp - 0xa], al ; LOCAL_STORE
067A90  3C 18                 CMP    al, 0x18 ; CMP
067A92  73 04                 JAE    0x67a98 ; CJUMP
067A94  80 66 F6 07           AND    byte ptr [bp - 0xa], 7 ; LOGIC
067A98  8A 46 F6              MOV    al, byte ptr [bp - 0xa] ; LOCAL_LOAD
067A9B  2A E4                 SUB    ah, ah ; ARITH
067A9D  50                    PUSH   ax ; STACK_PUSH
067A9E  9A AA 06 1F 18        LCALL  0x181f, 0x6aa ; THUNK -> 0x037F:0x0614 (thunk @file 0x01AC9A type B) overlay @file 0x02F150
067AA3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
067AA6  3C 19                 CMP    al, 0x19 ; CMP
067AA8  74 4A                 JE     0x67af4 ; CJUMP
067AAA  3C 1A                 CMP    al, 0x1a ; CMP
067AAC  74 46                 JE     0x67af4 ; CJUMP
067AAE  8A 4E FC              MOV    cl, byte ptr [bp - 4] ; LOCAL_LOAD
067AB1  B0 01                 MOV    al, 1 ; MOV
067AB3  D2 E0                 SHL    al, cl ; LOGIC
067AB5  08 06 A6 A8           OR     byte ptr [0xa8a6], al ; LOGIC
067AB9  FE 06 A3 A8           INC    byte ptr [0xa8a3] ; ARITH
067ABD  F6 46 FC 01           TEST   byte ptr [bp - 4], 1 ; LOGIC
067AC1  74 11                 JE     0x67ad4 ; CJUMP
067AC3  8A D9                 MOV    bl, cl ; MOV
067AC5  FE C3                 INC    bl ; ARITH
