; ============================================================================
; func_016526_unknown
; Region   : load_image
; Bytes    : file 0x016526..0x0166E6  (448 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016526  55                    PUSH   bp ; STACK_PUSH
016527  8B EC                 MOV    bp, sp ; MOV
016529  B8 71 01              MOV    ax, 0x171 ; CONST_LOAD
01652C  0E                    PUSH   cs ; STACK_PUSH
01652D  E8 EE EB              CALL   0x1511e ; CALL_NEAR
016530  56                    PUSH   si ; STACK_PUSH
016531  57                    PUSH   di ; STACK_PUSH
016532  33 C0                 XOR    ax, ax ; LOGIC
016534  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
016537  88 46 FB              MOV    byte ptr [bp - 5], al ; LOCAL_STORE
01653A  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
01653D  AC                    LODSB  al, byte ptr [si] ; STR
01653E  89 76 08              MOV    word ptr [bp + 8], si ; LOCAL_STORE
016541  88 46 FE              MOV    byte ptr [bp - 2], al ; LOCAL_STORE
016544  0A C0                 OR     al, al ; LOGIC
016546  74 06                 JE     0x1654e ; CJUMP
016548  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
01654C  7D 06                 JGE    0x16554 ; CJUMP
01654E  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
016551  E9 A3 04              JMP    0x169f7 ; JUMP
016554  BB 0E 48              MOV    bx, 0x480e ; CONST_LOAD
016557  2C 20                 SUB    al, 0x20 ; ARITH
016559  3C 58                 CMP    al, 0x58 ; CMP
01655B  77 05                 JA     0x16562 ; CJUMP
01655D  D7                    XLATB                               ; UNKNOWN
01655E  24 0F                 AND    al, 0xf ; LOGIC
016560  EB 02                 JMP    0x16564 ; JUMP
016562  B0 00                 MOV    al, 0 ; MOV
016564  B1 03                 MOV    cl, 3 ; MOV
016566  D2 E0                 SHL    al, cl ; LOGIC
016568  02 46 FB              ADD    al, byte ptr [bp - 5] ; ARITH
01656B  D7                    XLATB                               ; UNKNOWN
01656C  FE C1                 INC    cl ; ARITH
01656E  D2 E8                 SHR    al, cl ; LOGIC
016570  88 46 FB              MOV    byte ptr [bp - 5], al ; LOCAL_STORE
016573  98                    CWDE ; ARITH
016574  8B D8                 MOV    bx, ax ; MOV
016576  D1 E3                 SHL    bx, 1 ; LOGIC
016578  2E FF A7 96 16        JMP    word ptr cs:[bx + 0x1696] ; JUMP
01657D  8A 56 FE              MOV    dl, byte ptr [bp - 2] ; LOCAL_LOAD
016580  B9 01 00              MOV    cx, 1 ; MOV
016583  E8 24 04              CALL   0x169aa ; CALL_NEAR
016586  EB B2                 JMP    0x1653a ; JUMP
016588  33 C0                 XOR    ax, ax ; LOGIC
01658A  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
01658D  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
016590  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
016593  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
016596  48                    DEC    ax ; ARITH
016597  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
01659A  EB 9E                 JMP    0x1653a ; JUMP
01659C  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
01659F  3C 2D                 CMP    al, 0x2d ; CMP
0165A1  75 06                 JNE    0x165a9 ; CJUMP
0165A3  80 4E FC 04           OR     byte ptr [bp - 4], 4 ; LOGIC
0165A7  EB 91                 JMP    0x1653a ; JUMP
0165A9  3C 2B                 CMP    al, 0x2b ; CMP
0165AB  75 06                 JNE    0x165b3 ; CJUMP
0165AD  80 4E FC 01           OR     byte ptr [bp - 4], 1 ; LOGIC
0165B1  EB 87                 JMP    0x1653a ; JUMP
0165B3  3C 20                 CMP    al, 0x20 ; CMP
0165B5  75 07                 JNE    0x165be ; CJUMP
0165B7  80 4E FC 02           OR     byte ptr [bp - 4], 2 ; LOGIC
0165BB  E9 7C FF              JMP    0x1653a ; JUMP
0165BE  3C 23                 CMP    al, 0x23 ; CMP
0165C0  75 07                 JNE    0x165c9 ; CJUMP
0165C2  80 4E FC 80           OR     byte ptr [bp - 4], 0x80 ; LOGIC
0165C6  E9 71 FF              JMP    0x1653a ; JUMP
0165C9  80 4E FC 08           OR     byte ptr [bp - 4], 8 ; LOGIC
0165CD  E9 6A FF              JMP    0x1653a ; JUMP
0165D0  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
0165D3  80 F9 2A              CMP    cl, 0x2a ; CMP
0165D6  75 0F                 JNE    0x165e7 ; CJUMP
0165D8  E8 56 03              CALL   0x16931 ; CALL_NEAR
0165DB  0B C0                 OR     ax, ax ; LOGIC
0165DD  79 17                 JNS    0x165f6 ; CJUMP
0165DF  F7 D8                 NEG    ax ; ARITH
0165E1  80 4E FC 04           OR     byte ptr [bp - 4], 4 ; LOGIC
0165E5  EB 0F                 JMP    0x165f6 ; JUMP
0165E7  80 E9 30              SUB    cl, 0x30 ; ARITH
0165EA  32 ED                 XOR    ch, ch ; LOGIC
0165EC  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
0165EF  BB 0A 00              MOV    bx, 0xa ; CONST_LOAD
0165F2  F7 E3                 MUL    bx ; ARITH
0165F4  03 C1                 ADD    ax, cx ; ARITH
0165F6  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
0165F9  E9 3E FF              JMP    0x1653a ; JUMP
0165FC  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
016601  E9 36 FF              JMP    0x1653a ; JUMP
016604  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
016607  80 F9 2A              CMP    cl, 0x2a ; CMP
01660A  75 0C                 JNE    0x16618 ; CJUMP
01660C  E8 22 03              CALL   0x16931 ; CALL_NEAR
01660F  0B C0                 OR     ax, ax ; LOGIC
016611  79 14                 JNS    0x16627 ; CJUMP
016613  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
016616  EB 0F                 JMP    0x16627 ; JUMP
016618  80 E9 30              SUB    cl, 0x30 ; ARITH
01661B  32 ED                 XOR    ch, ch ; LOGIC
01661D  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
016620  BB 0A 00              MOV    bx, 0xa ; CONST_LOAD
016623  F7 E3                 MUL    bx ; ARITH
016625  03 C1                 ADD    ax, cx ; ARITH
016627  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
01662A  E9 0D FF              JMP    0x1653a ; JUMP
01662D  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
016630  3C 6C                 CMP    al, 0x6c ; CMP
016632  75 06                 JNE    0x1663a ; CJUMP
016634  80 4E FC 10           OR     byte ptr [bp - 4], 0x10 ; LOGIC
016638  EB 22                 JMP    0x1665c ; JUMP
01663A  3C 46                 CMP    al, 0x46 ; CMP
01663C  75 06                 JNE    0x16644 ; CJUMP
01663E  80 4E FC 20           OR     byte ptr [bp - 4], 0x20 ; LOGIC
016642  EB 18                 JMP    0x1665c ; JUMP
016644  3C 4E                 CMP    al, 0x4e ; CMP
016646  75 06                 JNE    0x1664e ; CJUMP
016648  80 4E FD 10           OR     byte ptr [bp - 3], 0x10 ; LOGIC
01664C  EB 0E                 JMP    0x1665c ; JUMP
01664E  3C 4C                 CMP    al, 0x4c ; CMP
016650  75 06                 JNE    0x16658 ; CJUMP
016652  80 4E FD 04           OR     byte ptr [bp - 3], 4 ; LOGIC
016656  EB 04                 JMP    0x1665c ; JUMP
016658  80 4E FD 08           OR     byte ptr [bp - 3], 8 ; LOGIC
01665C  E9 DB FE              JMP    0x1653a ; JUMP
01665F  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
016662  3C 64                 CMP    al, 0x64 ; CMP
016664  75 03                 JNE    0x16669 ; CJUMP
016666  E9 8E 01              JMP    0x167f7 ; JUMP
016669  3C 69                 CMP    al, 0x69 ; CMP
01666B  75 03                 JNE    0x16670 ; CJUMP
01666D  E9 87 01              JMP    0x167f7 ; JUMP
016670  3C 75                 CMP    al, 0x75 ; CMP
016672  75 03                 JNE    0x16677 ; CJUMP
016674  E9 84 01              JMP    0x167fb ; JUMP
016677  3C 58                 CMP    al, 0x58 ; CMP
016679  75 03                 JNE    0x1667e ; CJUMP
01667B  E9 83 01              JMP    0x16801 ; JUMP
01667E  3C 78                 CMP    al, 0x78 ; CMP
016680  75 03                 JNE    0x16685 ; CJUMP
016682  E9 82 01              JMP    0x16807 ; JUMP
016685  3C 6F                 CMP    al, 0x6f ; CMP
016687  75 03                 JNE    0x1668c ; CJUMP
016689  E9 9C 01              JMP    0x16828 ; JUMP
01668C  3C 63                 CMP    al, 0x63 ; CMP
01668E  74 1A                 JE     0x166aa ; CJUMP
016690  3C 73                 CMP    al, 0x73 ; CMP
016692  74 27                 JE     0x166bb ; CJUMP
016694  3C 6E                 CMP    al, 0x6e ; CMP
016696  74 51                 JE     0x166e9 ; CJUMP
016698  3C 70                 CMP    al, 0x70 ; CMP
01669A  74 60                 JE     0x166fc ; CJUMP
01669C  3C 45                 CMP    al, 0x45 ; CMP
01669E  74 07                 JE     0x166a7 ; CJUMP
0166A0  3C 47                 CMP    al, 0x47 ; CMP
0166A2  74 03                 JE     0x166a7 ; CJUMP
0166A4  E9 BB 00              JMP    0x16762 ; JUMP
0166A7  E9 B5 00              JMP    0x1675f ; JUMP
0166AA  E8 84 02              CALL   0x16931 ; CALL_NEAR
0166AD  8D BE 8F FE           LEA    di, [bp - 0x171] ; ADDR
0166B1  16                    PUSH   ss ; STACK_PUSH
0166B2  07                    POP    es ; STACK_POP
0166B3  AA                    STOSB  byte ptr es:[di], al ; STR
0166B4  4F                    DEC    di ; ARITH
0166B5  B9 01 00              MOV    cx, 1 ; MOV
0166B8  E9 EB 01              JMP    0x168a6 ; JUMP
0166BB  E8 87 02              CALL   0x16945 ; CALL_NEAR
0166BE  0B FF                 OR     di, di ; LOGIC
0166C0  75 12                 JNE    0x166d4 ; CJUMP
0166C2  8C C0                 MOV    ax, es ; MOV
0166C4  0B C0                 OR     ax, ax ; LOGIC
0166C6  75 0C                 JNE    0x166d4 ; CJUMP
0166C8  1E                    PUSH   ds ; STACK_PUSH
0166C9  07                    POP    es ; STACK_POP
0166CA  BF 67 48              MOV    di, 0x4867 ; CONST_LOAD
0166CD  8B 0E 6D 48           MOV    cx, word ptr [0x486d] ; GLOBAL_LOAD
0166D1  E9 D2 01              JMP    0x168a6 ; JUMP
0166D4  57                    PUSH   di ; STACK_PUSH
0166D5  8B 4E F4              MOV    cx, word ptr [bp - 0xc] ; LOCAL_LOAD
0166D8  E3 07                 JCXZ   0x166e1 ; CJUMP
0166DA  32 C0                 XOR    al, al ; LOGIC
0166DC  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0166DE  75 01                 JNE    0x166e1 ; CJUMP
0166E0  4F                    DEC    di ; ARITH
0166E1  59                    POP    cx ; STACK_POP
0166E2  2B F9                 SUB    di, cx ; ARITH
0166E4  87 CF                 XCHG   di, cx ; MOV
