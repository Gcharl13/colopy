; ============================================================================
; func_0056DE_unknown
; Region   : load_image
; Bytes    : file 0x0056DE..0x00589E  (448 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0056DE  55                    PUSH   bp ; STACK_PUSH
0056DF  8B EC                 MOV    bp, sp ; MOV
0056E1  B8 71 01              MOV    ax, 0x171 ; CONST_LOAD
0056E4  0E                    PUSH   cs ; STACK_PUSH
0056E5  E8 B8 EE              CALL   0x45a0 ; CALL_NEAR
0056E8  56                    PUSH   si ; STACK_PUSH
0056E9  57                    PUSH   di ; STACK_PUSH
0056EA  33 C0                 XOR    ax, ax ; LOGIC
0056EC  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0056EF  88 46 FB              MOV    byte ptr [bp - 5], al ; LOCAL_STORE
0056F2  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
0056F5  AC                    LODSB  al, byte ptr [si] ; STR
0056F6  89 76 08              MOV    word ptr [bp + 8], si ; LOCAL_STORE
0056F9  88 46 FE              MOV    byte ptr [bp - 2], al ; LOCAL_STORE
0056FC  0A C0                 OR     al, al ; LOGIC
0056FE  74 06                 JE     0x5706 ; CJUMP
005700  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
005704  7D 06                 JGE    0x570c ; CJUMP
005706  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
005709  E9 A3 04              JMP    0x5baf ; JUMP
00570C  BB F0 42              MOV    bx, 0x42f0 ; CONST_LOAD
00570F  2C 20                 SUB    al, 0x20 ; ARITH
005711  3C 58                 CMP    al, 0x58 ; CMP
005713  77 05                 JA     0x571a ; CJUMP
005715  D7                    XLATB                               ; UNKNOWN
005716  24 0F                 AND    al, 0xf ; LOGIC
005718  EB 02                 JMP    0x571c ; JUMP
00571A  B0 00                 MOV    al, 0 ; MOV
00571C  B1 03                 MOV    cl, 3 ; MOV
00571E  D2 E0                 SHL    al, cl ; LOGIC
005720  02 46 FB              ADD    al, byte ptr [bp - 5] ; ARITH
005723  D7                    XLATB                               ; UNKNOWN
005724  FE C1                 INC    cl ; ARITH
005726  D2 E8                 SHR    al, cl ; LOGIC
005728  88 46 FB              MOV    byte ptr [bp - 5], al ; LOCAL_STORE
00572B  98                    CWDE ; ARITH
00572C  8B D8                 MOV    bx, ax ; MOV
00572E  D1 E3                 SHL    bx, 1 ; LOGIC
005730  2E FF A7 FE 14        JMP    word ptr cs:[bx + 0x14fe] ; JUMP
005735  8A 56 FE              MOV    dl, byte ptr [bp - 2] ; LOCAL_LOAD
005738  B9 01 00              MOV    cx, 1 ; MOV
00573B  E8 24 04              CALL   0x5b62 ; CALL_NEAR
00573E  EB B2                 JMP    0x56f2 ; JUMP
005740  33 C0                 XOR    ax, ax ; LOGIC
005742  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
005745  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
005748  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
00574B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00574E  48                    DEC    ax ; ARITH
00574F  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
005752  EB 9E                 JMP    0x56f2 ; JUMP
005754  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
005757  3C 2D                 CMP    al, 0x2d ; CMP
005759  75 06                 JNE    0x5761 ; CJUMP
00575B  80 4E FC 04           OR     byte ptr [bp - 4], 4 ; LOGIC
00575F  EB 91                 JMP    0x56f2 ; JUMP
005761  3C 2B                 CMP    al, 0x2b ; CMP
005763  75 06                 JNE    0x576b ; CJUMP
005765  80 4E FC 01           OR     byte ptr [bp - 4], 1 ; LOGIC
005769  EB 87                 JMP    0x56f2 ; JUMP
00576B  3C 20                 CMP    al, 0x20 ; CMP
00576D  75 07                 JNE    0x5776 ; CJUMP
00576F  80 4E FC 02           OR     byte ptr [bp - 4], 2 ; LOGIC
005773  E9 7C FF              JMP    0x56f2 ; JUMP
005776  3C 23                 CMP    al, 0x23 ; CMP
005778  75 07                 JNE    0x5781 ; CJUMP
00577A  80 4E FC 80           OR     byte ptr [bp - 4], 0x80 ; LOGIC
00577E  E9 71 FF              JMP    0x56f2 ; JUMP
005781  80 4E FC 08           OR     byte ptr [bp - 4], 8 ; LOGIC
005785  E9 6A FF              JMP    0x56f2 ; JUMP
005788  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
00578B  80 F9 2A              CMP    cl, 0x2a ; CMP
00578E  75 0F                 JNE    0x579f ; CJUMP
005790  E8 56 03              CALL   0x5ae9 ; CALL_NEAR
005793  0B C0                 OR     ax, ax ; LOGIC
005795  79 17                 JNS    0x57ae ; CJUMP
005797  F7 D8                 NEG    ax ; ARITH
005799  80 4E FC 04           OR     byte ptr [bp - 4], 4 ; LOGIC
00579D  EB 0F                 JMP    0x57ae ; JUMP
00579F  80 E9 30              SUB    cl, 0x30 ; ARITH
0057A2  32 ED                 XOR    ch, ch ; LOGIC
0057A4  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
0057A7  BB 0A 00              MOV    bx, 0xa ; CONST_LOAD
0057AA  F7 E3                 MUL    bx ; ARITH
0057AC  03 C1                 ADD    ax, cx ; ARITH
0057AE  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
0057B1  E9 3E FF              JMP    0x56f2 ; JUMP
0057B4  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
0057B9  E9 36 FF              JMP    0x56f2 ; JUMP
0057BC  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
0057BF  80 F9 2A              CMP    cl, 0x2a ; CMP
0057C2  75 0C                 JNE    0x57d0 ; CJUMP
0057C4  E8 22 03              CALL   0x5ae9 ; CALL_NEAR
0057C7  0B C0                 OR     ax, ax ; LOGIC
0057C9  79 14                 JNS    0x57df ; CJUMP
0057CB  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0057CE  EB 0F                 JMP    0x57df ; JUMP
0057D0  80 E9 30              SUB    cl, 0x30 ; ARITH
0057D3  32 ED                 XOR    ch, ch ; LOGIC
0057D5  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
0057D8  BB 0A 00              MOV    bx, 0xa ; CONST_LOAD
0057DB  F7 E3                 MUL    bx ; ARITH
0057DD  03 C1                 ADD    ax, cx ; ARITH
0057DF  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
0057E2  E9 0D FF              JMP    0x56f2 ; JUMP
0057E5  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
0057E8  3C 6C                 CMP    al, 0x6c ; CMP
0057EA  75 06                 JNE    0x57f2 ; CJUMP
0057EC  80 4E FC 10           OR     byte ptr [bp - 4], 0x10 ; LOGIC
0057F0  EB 22                 JMP    0x5814 ; JUMP
0057F2  3C 46                 CMP    al, 0x46 ; CMP
0057F4  75 06                 JNE    0x57fc ; CJUMP
0057F6  80 4E FC 20           OR     byte ptr [bp - 4], 0x20 ; LOGIC
0057FA  EB 18                 JMP    0x5814 ; JUMP
0057FC  3C 4E                 CMP    al, 0x4e ; CMP
0057FE  75 06                 JNE    0x5806 ; CJUMP
005800  80 4E FD 10           OR     byte ptr [bp - 3], 0x10 ; LOGIC
005804  EB 0E                 JMP    0x5814 ; JUMP
005806  3C 4C                 CMP    al, 0x4c ; CMP
005808  75 06                 JNE    0x5810 ; CJUMP
00580A  80 4E FD 04           OR     byte ptr [bp - 3], 4 ; LOGIC
00580E  EB 04                 JMP    0x5814 ; JUMP
005810  80 4E FD 08           OR     byte ptr [bp - 3], 8 ; LOGIC
005814  E9 DB FE              JMP    0x56f2 ; JUMP
005817  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
00581A  3C 64                 CMP    al, 0x64 ; CMP
00581C  75 03                 JNE    0x5821 ; CJUMP
00581E  E9 8E 01              JMP    0x59af ; JUMP
005821  3C 69                 CMP    al, 0x69 ; CMP
005823  75 03                 JNE    0x5828 ; CJUMP
005825  E9 87 01              JMP    0x59af ; JUMP
005828  3C 75                 CMP    al, 0x75 ; CMP
00582A  75 03                 JNE    0x582f ; CJUMP
00582C  E9 84 01              JMP    0x59b3 ; JUMP
00582F  3C 58                 CMP    al, 0x58 ; CMP
005831  75 03                 JNE    0x5836 ; CJUMP
005833  E9 83 01              JMP    0x59b9 ; JUMP
005836  3C 78                 CMP    al, 0x78 ; CMP
005838  75 03                 JNE    0x583d ; CJUMP
00583A  E9 82 01              JMP    0x59bf ; JUMP
00583D  3C 6F                 CMP    al, 0x6f ; CMP
00583F  75 03                 JNE    0x5844 ; CJUMP
005841  E9 9C 01              JMP    0x59e0 ; JUMP
005844  3C 63                 CMP    al, 0x63 ; CMP
005846  74 1A                 JE     0x5862 ; CJUMP
005848  3C 73                 CMP    al, 0x73 ; CMP
00584A  74 27                 JE     0x5873 ; CJUMP
00584C  3C 6E                 CMP    al, 0x6e ; CMP
00584E  74 51                 JE     0x58a1 ; CJUMP
005850  3C 70                 CMP    al, 0x70 ; CMP
005852  74 60                 JE     0x58b4 ; CJUMP
005854  3C 45                 CMP    al, 0x45 ; CMP
005856  74 07                 JE     0x585f ; CJUMP
005858  3C 47                 CMP    al, 0x47 ; CMP
00585A  74 03                 JE     0x585f ; CJUMP
00585C  E9 BB 00              JMP    0x591a ; JUMP
00585F  E9 B5 00              JMP    0x5917 ; JUMP
005862  E8 84 02              CALL   0x5ae9 ; CALL_NEAR
005865  8D BE 8F FE           LEA    di, [bp - 0x171] ; ADDR
005869  16                    PUSH   ss ; STACK_PUSH
00586A  07                    POP    es ; STACK_POP
00586B  AA                    STOSB  byte ptr es:[di], al ; STR
00586C  4F                    DEC    di ; ARITH
00586D  B9 01 00              MOV    cx, 1 ; MOV
005870  E9 EB 01              JMP    0x5a5e ; JUMP
005873  E8 87 02              CALL   0x5afd ; CALL_NEAR
005876  0B FF                 OR     di, di ; LOGIC
005878  75 12                 JNE    0x588c ; CJUMP
00587A  8C C0                 MOV    ax, es ; MOV
00587C  0B C0                 OR     ax, ax ; LOGIC
00587E  75 0C                 JNE    0x588c ; CJUMP
005880  1E                    PUSH   ds ; STACK_PUSH
005881  07                    POP    es ; STACK_POP
005882  BF 49 43              MOV    di, 0x4349 ; CONST_LOAD
005885  8B 0E 4F 43           MOV    cx, word ptr [0x434f] ; GLOBAL_LOAD
005889  E9 D2 01              JMP    0x5a5e ; JUMP
00588C  57                    PUSH   di ; STACK_PUSH
00588D  8B 4E F4              MOV    cx, word ptr [bp - 0xc] ; LOCAL_LOAD
005890  E3 07                 JCXZ   0x5899 ; CJUMP
005892  32 C0                 XOR    al, al ; LOGIC
005894  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005896  75 01                 JNE    0x5899 ; CJUMP
005898  4F                    DEC    di ; ARITH
005899  59                    POP    cx ; STACK_POP
00589A  2B F9                 SUB    di, cx ; ARITH
00589C  87 CF                 XCHG   di, cx ; MOV
