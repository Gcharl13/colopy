; ============================================================================
; func_0066DE_unknown
; Region   : load_image
; Bytes    : file 0x0066DE..0x00689E  (448 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0066DE  55                    PUSH   bp ; STACK_PUSH
0066DF  8B EC                 MOV    bp, sp ; MOV
0066E1  B8 71 01              MOV    ax, 0x171 ; CONST_LOAD
0066E4  0E                    PUSH   cs ; STACK_PUSH
0066E5  E8 14 EE              CALL   0x54fc ; CALL_NEAR
0066E8  56                    PUSH   si ; STACK_PUSH
0066E9  57                    PUSH   di ; STACK_PUSH
0066EA  33 C0                 XOR    ax, ax ; LOGIC
0066EC  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0066EF  88 46 FB              MOV    byte ptr [bp - 5], al ; LOCAL_STORE
0066F2  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
0066F5  AC                    LODSB  al, byte ptr [si] ; STR
0066F6  89 76 08              MOV    word ptr [bp + 8], si ; LOCAL_STORE
0066F9  88 46 FE              MOV    byte ptr [bp - 2], al ; LOCAL_STORE
0066FC  0A C0                 OR     al, al ; LOGIC
0066FE  74 06                 JE     0x6706 ; CJUMP
006700  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
006704  7D 06                 JGE    0x670c ; CJUMP
006706  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
006709  E9 A3 04              JMP    0x6baf ; JUMP
00670C  BB 46 45              MOV    bx, 0x4546 ; CONST_LOAD
00670F  2C 20                 SUB    al, 0x20 ; ARITH
006711  3C 58                 CMP    al, 0x58 ; CMP
006713  77 05                 JA     0x671a ; CJUMP
006715  D7                    XLATB                               ; UNKNOWN
006716  24 0F                 AND    al, 0xf ; LOGIC
006718  EB 02                 JMP    0x671c ; JUMP
00671A  B0 00                 MOV    al, 0 ; MOV
00671C  B1 03                 MOV    cl, 3 ; MOV
00671E  D2 E0                 SHL    al, cl ; LOGIC
006720  02 46 FB              ADD    al, byte ptr [bp - 5] ; ARITH
006723  D7                    XLATB                               ; UNKNOWN
006724  FE C1                 INC    cl ; ARITH
006726  D2 E8                 SHR    al, cl ; LOGIC
006728  88 46 FB              MOV    byte ptr [bp - 5], al ; LOCAL_STORE
00672B  98                    CWDE ; ARITH
00672C  8B D8                 MOV    bx, ax ; MOV
00672E  D1 E3                 SHL    bx, 1 ; LOGIC
006730  2E FF A7 AE 15        JMP    word ptr cs:[bx + 0x15ae] ; JUMP
006735  8A 56 FE              MOV    dl, byte ptr [bp - 2] ; LOCAL_LOAD
006738  B9 01 00              MOV    cx, 1 ; MOV
00673B  E8 24 04              CALL   0x6b62 ; CALL_NEAR
00673E  EB B2                 JMP    0x66f2 ; JUMP
006740  33 C0                 XOR    ax, ax ; LOGIC
006742  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
006745  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
006748  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
00674B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00674E  48                    DEC    ax ; ARITH
00674F  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
006752  EB 9E                 JMP    0x66f2 ; JUMP
006754  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
006757  3C 2D                 CMP    al, 0x2d ; CMP
006759  75 06                 JNE    0x6761 ; CJUMP
00675B  80 4E FC 04           OR     byte ptr [bp - 4], 4 ; LOGIC
00675F  EB 91                 JMP    0x66f2 ; JUMP
006761  3C 2B                 CMP    al, 0x2b ; CMP
006763  75 06                 JNE    0x676b ; CJUMP
006765  80 4E FC 01           OR     byte ptr [bp - 4], 1 ; LOGIC
006769  EB 87                 JMP    0x66f2 ; JUMP
00676B  3C 20                 CMP    al, 0x20 ; CMP
00676D  75 07                 JNE    0x6776 ; CJUMP
00676F  80 4E FC 02           OR     byte ptr [bp - 4], 2 ; LOGIC
006773  E9 7C FF              JMP    0x66f2 ; JUMP
006776  3C 23                 CMP    al, 0x23 ; CMP
006778  75 07                 JNE    0x6781 ; CJUMP
00677A  80 4E FC 80           OR     byte ptr [bp - 4], 0x80 ; LOGIC
00677E  E9 71 FF              JMP    0x66f2 ; JUMP
006781  80 4E FC 08           OR     byte ptr [bp - 4], 8 ; LOGIC
006785  E9 6A FF              JMP    0x66f2 ; JUMP
006788  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
00678B  80 F9 2A              CMP    cl, 0x2a ; CMP
00678E  75 0F                 JNE    0x679f ; CJUMP
006790  E8 56 03              CALL   0x6ae9 ; CALL_NEAR
006793  0B C0                 OR     ax, ax ; LOGIC
006795  79 17                 JNS    0x67ae ; CJUMP
006797  F7 D8                 NEG    ax ; ARITH
006799  80 4E FC 04           OR     byte ptr [bp - 4], 4 ; LOGIC
00679D  EB 0F                 JMP    0x67ae ; JUMP
00679F  80 E9 30              SUB    cl, 0x30 ; ARITH
0067A2  32 ED                 XOR    ch, ch ; LOGIC
0067A4  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
0067A7  BB 0A 00              MOV    bx, 0xa ; CONST_LOAD
0067AA  F7 E3                 MUL    bx ; ARITH
0067AC  03 C1                 ADD    ax, cx ; ARITH
0067AE  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
0067B1  E9 3E FF              JMP    0x66f2 ; JUMP
0067B4  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
0067B9  E9 36 FF              JMP    0x66f2 ; JUMP
0067BC  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
0067BF  80 F9 2A              CMP    cl, 0x2a ; CMP
0067C2  75 0C                 JNE    0x67d0 ; CJUMP
0067C4  E8 22 03              CALL   0x6ae9 ; CALL_NEAR
0067C7  0B C0                 OR     ax, ax ; LOGIC
0067C9  79 14                 JNS    0x67df ; CJUMP
0067CB  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0067CE  EB 0F                 JMP    0x67df ; JUMP
0067D0  80 E9 30              SUB    cl, 0x30 ; ARITH
0067D3  32 ED                 XOR    ch, ch ; LOGIC
0067D5  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
0067D8  BB 0A 00              MOV    bx, 0xa ; CONST_LOAD
0067DB  F7 E3                 MUL    bx ; ARITH
0067DD  03 C1                 ADD    ax, cx ; ARITH
0067DF  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
0067E2  E9 0D FF              JMP    0x66f2 ; JUMP
0067E5  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
0067E8  3C 6C                 CMP    al, 0x6c ; CMP
0067EA  75 06                 JNE    0x67f2 ; CJUMP
0067EC  80 4E FC 10           OR     byte ptr [bp - 4], 0x10 ; LOGIC
0067F0  EB 22                 JMP    0x6814 ; JUMP
0067F2  3C 46                 CMP    al, 0x46 ; CMP
0067F4  75 06                 JNE    0x67fc ; CJUMP
0067F6  80 4E FC 20           OR     byte ptr [bp - 4], 0x20 ; LOGIC
0067FA  EB 18                 JMP    0x6814 ; JUMP
0067FC  3C 4E                 CMP    al, 0x4e ; CMP
0067FE  75 06                 JNE    0x6806 ; CJUMP
006800  80 4E FD 10           OR     byte ptr [bp - 3], 0x10 ; LOGIC
006804  EB 0E                 JMP    0x6814 ; JUMP
006806  3C 4C                 CMP    al, 0x4c ; CMP
006808  75 06                 JNE    0x6810 ; CJUMP
00680A  80 4E FD 04           OR     byte ptr [bp - 3], 4 ; LOGIC
00680E  EB 04                 JMP    0x6814 ; JUMP
006810  80 4E FD 08           OR     byte ptr [bp - 3], 8 ; LOGIC
006814  E9 DB FE              JMP    0x66f2 ; JUMP
006817  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
00681A  3C 64                 CMP    al, 0x64 ; CMP
00681C  75 03                 JNE    0x6821 ; CJUMP
00681E  E9 8E 01              JMP    0x69af ; JUMP
006821  3C 69                 CMP    al, 0x69 ; CMP
006823  75 03                 JNE    0x6828 ; CJUMP
006825  E9 87 01              JMP    0x69af ; JUMP
006828  3C 75                 CMP    al, 0x75 ; CMP
00682A  75 03                 JNE    0x682f ; CJUMP
00682C  E9 84 01              JMP    0x69b3 ; JUMP
00682F  3C 58                 CMP    al, 0x58 ; CMP
006831  75 03                 JNE    0x6836 ; CJUMP
006833  E9 83 01              JMP    0x69b9 ; JUMP
006836  3C 78                 CMP    al, 0x78 ; CMP
006838  75 03                 JNE    0x683d ; CJUMP
00683A  E9 82 01              JMP    0x69bf ; JUMP
00683D  3C 6F                 CMP    al, 0x6f ; CMP
00683F  75 03                 JNE    0x6844 ; CJUMP
006841  E9 9C 01              JMP    0x69e0 ; JUMP
006844  3C 63                 CMP    al, 0x63 ; CMP
006846  74 1A                 JE     0x6862 ; CJUMP
006848  3C 73                 CMP    al, 0x73 ; CMP
00684A  74 27                 JE     0x6873 ; CJUMP
00684C  3C 6E                 CMP    al, 0x6e ; CMP
00684E  74 51                 JE     0x68a1 ; CJUMP
006850  3C 70                 CMP    al, 0x70 ; CMP
006852  74 60                 JE     0x68b4 ; CJUMP
006854  3C 45                 CMP    al, 0x45 ; CMP
006856  74 07                 JE     0x685f ; CJUMP
006858  3C 47                 CMP    al, 0x47 ; CMP
00685A  74 03                 JE     0x685f ; CJUMP
00685C  E9 BB 00              JMP    0x691a ; JUMP
00685F  E9 B5 00              JMP    0x6917 ; JUMP
006862  E8 84 02              CALL   0x6ae9 ; CALL_NEAR
006865  8D BE 8F FE           LEA    di, [bp - 0x171] ; ADDR
006869  16                    PUSH   ss ; STACK_PUSH
00686A  07                    POP    es ; STACK_POP
00686B  AA                    STOSB  byte ptr es:[di], al ; STR
00686C  4F                    DEC    di ; ARITH
00686D  B9 01 00              MOV    cx, 1 ; MOV
006870  E9 EB 01              JMP    0x6a5e ; JUMP
006873  E8 87 02              CALL   0x6afd ; CALL_NEAR
006876  0B FF                 OR     di, di ; LOGIC
006878  75 12                 JNE    0x688c ; CJUMP
00687A  8C C0                 MOV    ax, es ; MOV
00687C  0B C0                 OR     ax, ax ; LOGIC
00687E  75 0C                 JNE    0x688c ; CJUMP
006880  1E                    PUSH   ds ; STACK_PUSH
006881  07                    POP    es ; STACK_POP
006882  BF 9F 45              MOV    di, 0x459f ; CONST_LOAD
006885  8B 0E A5 45           MOV    cx, word ptr [0x45a5] ; GLOBAL_LOAD
006889  E9 D2 01              JMP    0x6a5e ; JUMP
00688C  57                    PUSH   di ; STACK_PUSH
00688D  8B 4E F4              MOV    cx, word ptr [bp - 0xc] ; LOCAL_LOAD
006890  E3 07                 JCXZ   0x6899 ; CJUMP
006892  32 C0                 XOR    al, al ; LOGIC
006894  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
006896  75 01                 JNE    0x6899 ; CJUMP
006898  4F                    DEC    di ; ARITH
006899  59                    POP    cx ; STACK_POP
00689A  2B F9                 SUB    di, cx ; ARITH
00689C  87 CF                 XCHG   di, cx ; MOV
