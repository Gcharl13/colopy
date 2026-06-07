; ============================================================================
; func_010F3E_unknown
; Region   : load_image
; Bytes    : file 0x010F3E..0x0110FE  (448 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010F3E  55                    PUSH   bp ; STACK_PUSH
010F3F  8B EC                 MOV    bp, sp ; MOV
010F41  B8 71 01              MOV    ax, 0x171 ; CONST_LOAD
010F44  0E                    PUSH   cs ; STACK_PUSH
010F45  E8 58 EA              CALL   0xf9a0 ; CALL_NEAR
010F48  56                    PUSH   si ; STACK_PUSH
010F49  57                    PUSH   di ; STACK_PUSH
010F4A  33 C0                 XOR    ax, ax ; LOGIC
010F4C  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
010F4F  88 46 FB              MOV    byte ptr [bp - 5], al ; LOCAL_STORE
010F52  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
010F55  AC                    LODSB  al, byte ptr [si] ; STR
010F56  89 76 08              MOV    word ptr [bp + 8], si ; LOCAL_STORE
010F59  88 46 FE              MOV    byte ptr [bp - 2], al ; LOCAL_STORE
010F5C  0A C0                 OR     al, al ; LOGIC
010F5E  74 06                 JE     0x10f66 ; CJUMP
010F60  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
010F64  7D 06                 JGE    0x10f6c ; CJUMP
010F66  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
010F69  E9 A3 04              JMP    0x1140f ; JUMP
010F6C  BB 56 2A              MOV    bx, 0x2a56 ; CONST_LOAD
010F6F  2C 20                 SUB    al, 0x20 ; ARITH
010F71  3C 58                 CMP    al, 0x58 ; CMP
010F73  77 05                 JA     0x10f7a ; CJUMP
010F75  D7                    XLATB                               ; UNKNOWN
010F76  24 0F                 AND    al, 0xf ; LOGIC
010F78  EB 02                 JMP    0x10f7c ; JUMP
010F7A  B0 00                 MOV    al, 0 ; MOV
010F7C  B1 03                 MOV    cl, 3 ; MOV
010F7E  D2 E0                 SHL    al, cl ; LOGIC
010F80  02 46 FB              ADD    al, byte ptr [bp - 5] ; ARITH
010F83  D7                    XLATB                               ; UNKNOWN
010F84  FE C1                 INC    cl ; ARITH
010F86  D2 E8                 SHR    al, cl ; LOGIC
010F88  88 46 FB              MOV    byte ptr [bp - 5], al ; LOCAL_STORE
010F8B  98                    CWDE ; ARITH
010F8C  8B D8                 MOV    bx, ax ; MOV
010F8E  D1 E3                 SHL    bx, 1 ; LOGIC
010F90  2E FF A7 5E 19        JMP    word ptr cs:[bx + 0x195e] ; JUMP
010F95  8A 56 FE              MOV    dl, byte ptr [bp - 2] ; LOCAL_LOAD
010F98  B9 01 00              MOV    cx, 1 ; MOV
010F9B  E8 24 04              CALL   0x113c2 ; CALL_NEAR
010F9E  EB B2                 JMP    0x10f52 ; JUMP
010FA0  33 C0                 XOR    ax, ax ; LOGIC
010FA2  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
010FA5  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
010FA8  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
010FAB  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
010FAE  48                    DEC    ax ; ARITH
010FAF  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
010FB2  EB 9E                 JMP    0x10f52 ; JUMP
010FB4  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
010FB7  3C 2D                 CMP    al, 0x2d ; CMP
010FB9  75 06                 JNE    0x10fc1 ; CJUMP
010FBB  80 4E FC 04           OR     byte ptr [bp - 4], 4 ; LOGIC
010FBF  EB 91                 JMP    0x10f52 ; JUMP
010FC1  3C 2B                 CMP    al, 0x2b ; CMP
010FC3  75 06                 JNE    0x10fcb ; CJUMP
010FC5  80 4E FC 01           OR     byte ptr [bp - 4], 1 ; LOGIC
010FC9  EB 87                 JMP    0x10f52 ; JUMP
010FCB  3C 20                 CMP    al, 0x20 ; CMP
010FCD  75 07                 JNE    0x10fd6 ; CJUMP
010FCF  80 4E FC 02           OR     byte ptr [bp - 4], 2 ; LOGIC
010FD3  E9 7C FF              JMP    0x10f52 ; JUMP
010FD6  3C 23                 CMP    al, 0x23 ; CMP
010FD8  75 07                 JNE    0x10fe1 ; CJUMP
010FDA  80 4E FC 80           OR     byte ptr [bp - 4], 0x80 ; LOGIC
010FDE  E9 71 FF              JMP    0x10f52 ; JUMP
010FE1  80 4E FC 08           OR     byte ptr [bp - 4], 8 ; LOGIC
010FE5  E9 6A FF              JMP    0x10f52 ; JUMP
010FE8  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
010FEB  80 F9 2A              CMP    cl, 0x2a ; CMP
010FEE  75 0F                 JNE    0x10fff ; CJUMP
010FF0  E8 56 03              CALL   0x11349 ; CALL_NEAR
010FF3  0B C0                 OR     ax, ax ; LOGIC
010FF5  79 17                 JNS    0x1100e ; CJUMP
010FF7  F7 D8                 NEG    ax ; ARITH
010FF9  80 4E FC 04           OR     byte ptr [bp - 4], 4 ; LOGIC
010FFD  EB 0F                 JMP    0x1100e ; JUMP
010FFF  80 E9 30              SUB    cl, 0x30 ; ARITH
011002  32 ED                 XOR    ch, ch ; LOGIC
011004  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
011007  BB 0A 00              MOV    bx, 0xa ; CONST_LOAD
01100A  F7 E3                 MUL    bx ; ARITH
01100C  03 C1                 ADD    ax, cx ; ARITH
01100E  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
011011  E9 3E FF              JMP    0x10f52 ; JUMP
011014  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
011019  E9 36 FF              JMP    0x10f52 ; JUMP
01101C  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
01101F  80 F9 2A              CMP    cl, 0x2a ; CMP
011022  75 0C                 JNE    0x11030 ; CJUMP
011024  E8 22 03              CALL   0x11349 ; CALL_NEAR
011027  0B C0                 OR     ax, ax ; LOGIC
011029  79 14                 JNS    0x1103f ; CJUMP
01102B  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
01102E  EB 0F                 JMP    0x1103f ; JUMP
011030  80 E9 30              SUB    cl, 0x30 ; ARITH
011033  32 ED                 XOR    ch, ch ; LOGIC
011035  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
011038  BB 0A 00              MOV    bx, 0xa ; CONST_LOAD
01103B  F7 E3                 MUL    bx ; ARITH
01103D  03 C1                 ADD    ax, cx ; ARITH
01103F  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
011042  E9 0D FF              JMP    0x10f52 ; JUMP
011045  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
011048  3C 6C                 CMP    al, 0x6c ; CMP
01104A  75 06                 JNE    0x11052 ; CJUMP
01104C  80 4E FC 10           OR     byte ptr [bp - 4], 0x10 ; LOGIC
011050  EB 22                 JMP    0x11074 ; JUMP
011052  3C 46                 CMP    al, 0x46 ; CMP
011054  75 06                 JNE    0x1105c ; CJUMP
011056  80 4E FC 20           OR     byte ptr [bp - 4], 0x20 ; LOGIC
01105A  EB 18                 JMP    0x11074 ; JUMP
01105C  3C 4E                 CMP    al, 0x4e ; CMP
01105E  75 06                 JNE    0x11066 ; CJUMP
011060  80 4E FD 10           OR     byte ptr [bp - 3], 0x10 ; LOGIC
011064  EB 0E                 JMP    0x11074 ; JUMP
011066  3C 4C                 CMP    al, 0x4c ; CMP
011068  75 06                 JNE    0x11070 ; CJUMP
01106A  80 4E FD 04           OR     byte ptr [bp - 3], 4 ; LOGIC
01106E  EB 04                 JMP    0x11074 ; JUMP
011070  80 4E FD 08           OR     byte ptr [bp - 3], 8 ; LOGIC
011074  E9 DB FE              JMP    0x10f52 ; JUMP
011077  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
01107A  3C 64                 CMP    al, 0x64 ; CMP
01107C  75 03                 JNE    0x11081 ; CJUMP
01107E  E9 8E 01              JMP    0x1120f ; JUMP
011081  3C 69                 CMP    al, 0x69 ; CMP
011083  75 03                 JNE    0x11088 ; CJUMP
011085  E9 87 01              JMP    0x1120f ; JUMP
011088  3C 75                 CMP    al, 0x75 ; CMP
01108A  75 03                 JNE    0x1108f ; CJUMP
01108C  E9 84 01              JMP    0x11213 ; JUMP
01108F  3C 58                 CMP    al, 0x58 ; CMP
011091  75 03                 JNE    0x11096 ; CJUMP
011093  E9 83 01              JMP    0x11219 ; JUMP
011096  3C 78                 CMP    al, 0x78 ; CMP
011098  75 03                 JNE    0x1109d ; CJUMP
01109A  E9 82 01              JMP    0x1121f ; JUMP
01109D  3C 6F                 CMP    al, 0x6f ; CMP
01109F  75 03                 JNE    0x110a4 ; CJUMP
0110A1  E9 9C 01              JMP    0x11240 ; JUMP
0110A4  3C 63                 CMP    al, 0x63 ; CMP
0110A6  74 1A                 JE     0x110c2 ; CJUMP
0110A8  3C 73                 CMP    al, 0x73 ; CMP
0110AA  74 27                 JE     0x110d3 ; CJUMP
0110AC  3C 6E                 CMP    al, 0x6e ; CMP
0110AE  74 51                 JE     0x11101 ; CJUMP
0110B0  3C 70                 CMP    al, 0x70 ; CMP
0110B2  74 60                 JE     0x11114 ; CJUMP
0110B4  3C 45                 CMP    al, 0x45 ; CMP
0110B6  74 07                 JE     0x110bf ; CJUMP
0110B8  3C 47                 CMP    al, 0x47 ; CMP
0110BA  74 03                 JE     0x110bf ; CJUMP
0110BC  E9 BB 00              JMP    0x1117a ; JUMP
0110BF  E9 B5 00              JMP    0x11177 ; JUMP
0110C2  E8 84 02              CALL   0x11349 ; CALL_NEAR
0110C5  8D BE 8F FE           LEA    di, [bp - 0x171] ; ADDR
0110C9  16                    PUSH   ss ; STACK_PUSH
0110CA  07                    POP    es ; STACK_POP
0110CB  AA                    STOSB  byte ptr es:[di], al ; STR
0110CC  4F                    DEC    di ; ARITH
0110CD  B9 01 00              MOV    cx, 1 ; MOV
0110D0  E9 EB 01              JMP    0x112be ; JUMP
0110D3  E8 87 02              CALL   0x1135d ; CALL_NEAR
0110D6  0B FF                 OR     di, di ; LOGIC
0110D8  75 12                 JNE    0x110ec ; CJUMP
0110DA  8C C0                 MOV    ax, es ; MOV
0110DC  0B C0                 OR     ax, ax ; LOGIC
0110DE  75 0C                 JNE    0x110ec ; CJUMP
0110E0  1E                    PUSH   ds ; STACK_PUSH
0110E1  07                    POP    es ; STACK_POP
0110E2  BF AF 2A              MOV    di, 0x2aaf ; CONST_LOAD
0110E5  8B 0E B5 2A           MOV    cx, word ptr [0x2ab5] ; GLOBAL_LOAD
0110E9  E9 D2 01              JMP    0x112be ; JUMP
0110EC  57                    PUSH   di ; STACK_PUSH
0110ED  8B 4E F4              MOV    cx, word ptr [bp - 0xc] ; LOCAL_LOAD
0110F0  E3 07                 JCXZ   0x110f9 ; CJUMP
0110F2  32 C0                 XOR    al, al ; LOGIC
0110F4  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
0110F6  75 01                 JNE    0x110f9 ; CJUMP
0110F8  4F                    DEC    di ; ARITH
0110F9  59                    POP    cx ; STACK_POP
0110FA  2B F9                 SUB    di, cx ; ARITH
0110FC  87 CF                 XCHG   di, cx ; MOV
