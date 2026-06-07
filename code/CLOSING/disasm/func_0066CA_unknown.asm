; ============================================================================
; func_0066CA_unknown
; Region   : load_image
; Bytes    : file 0x0066CA..0x00685D  (403 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0066CA  55                    PUSH   bp ; STACK_PUSH
0066CB  8B EC                 MOV    bp, sp ; MOV
0066CD  B8 AE 00              MOV    ax, 0xae ; CONST_LOAD
0066D0  9A D0 03 7D 03        LCALL  0x37d, 0x3d0 ; LCALL
0066D5  56                    PUSH   si ; STACK_PUSH
0066D6  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0066D9  C7 46 D8 01 00        MOV    word ptr [bp - 0x28], 1 ; LOCAL_STORE
0066DE  C7 46 D2 00 00        MOV    word ptr [bp - 0x2e], 0 ; LOCAL_STORE
0066E3  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
0066E7  75 46                 JNE    0x672f ; CJUMP
0066E9  89 76 DC              MOV    word ptr [bp - 0x24], si ; LOCAL_STORE
0066EC  B8 7A 43              MOV    ax, 0x437a ; CONST_LOAD
0066EF  50                    PUSH   ax ; STACK_PUSH
0066F0  9A 9A 24 7D 03        LCALL  0x37d, 0x249a ; LCALL
0066F5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0066F8  8B F0                 MOV    si, ax ; MOV
0066FA  0B F6                 OR     si, si ; LOGIC
0066FC  75 0C                 JNE    0x670a ; CJUMP
0066FE  C7 06 4A 40 08 00     MOV    word ptr [0x404a], 8 ; GLOBAL_LOAD
006704  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
006707  E9 4E 01              JMP    0x6858 ; JUMP
00670A  FF 76 DC              PUSH   word ptr [bp - 0x24] ; PUSH_GLOBAL
00670D  56                    PUSH   si ; STACK_PUSH
00670E  8D 86 52 FF           LEA    ax, [bp - 0xae] ; ADDR
006712  50                    PUSH   ax ; STACK_PUSH
006713  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
006716  50                    PUSH   ax ; STACK_PUSH
006717  8D 46 D2              LEA    ax, [bp - 0x2e] ; ADDR
00671A  50                    PUSH   ax ; STACK_PUSH
00671B  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00671E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
006721  9A 6A 29 7D 03        LCALL  0x37d, 0x296a ; LCALL
006726  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
006729  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
00672C  40                    INC    ax ; ARITH
00672D  74 D5                 JE     0x6704 ; CJUMP
00672F  B8 20 00              MOV    ax, 0x20 ; CONST_LOAD
006732  50                    PUSH   ax ; STACK_PUSH
006733  B8 00 80              MOV    ax, 0x8000 ; CONST_LOAD
006736  50                    PUSH   ax ; STACK_PUSH
006737  56                    PUSH   si ; STACK_PUSH
006738  9A 92 21 7D 03        LCALL  0x37d, 0x2192 ; LCALL
00673D  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
006740  89 46 DA              MOV    word ptr [bp - 0x26], ax ; LOCAL_STORE
006743  40                    INC    ax ; ARITH
006744  75 14                 JNE    0x675a ; CJUMP
006746  83 7E D2 00           CMP    word ptr [bp - 0x2e], 0 ; CMP
00674A  74 B8                 JE     0x6704 ; CJUMP
00674C  FF 76 D2              PUSH   word ptr [bp - 0x2e] ; PUSH_GLOBAL
00674F  9A 94 24 7D 03        LCALL  0x37d, 0x2494 ; LCALL
006754  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006757  EB AB                 JMP    0x6704 ; JUMP
006759  90                    NOP ; NOP
00675A  B8 18 00              MOV    ax, 0x18 ; CONST_LOAD
00675D  50                    PUSH   ax ; STACK_PUSH
00675E  8D 46 E2              LEA    ax, [bp - 0x1e] ; ADDR
006761  50                    PUSH   ax ; STACK_PUSH
006762  FF 76 DA              PUSH   word ptr [bp - 0x26] ; PUSH_GLOBAL
006765  9A B4 1A 7D 03        LCALL  0x37d, 0x1ab4 ; LCALL
00676A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00676D  40                    INC    ax ; ARITH
00676E  75 2C                 JNE    0x679c ; CJUMP
006770  FF 76 DA              PUSH   word ptr [bp - 0x26] ; PUSH_GLOBAL
006773  9A 1A 1A 7D 03        LCALL  0x37d, 0x1a1a ; LCALL
006778  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00677B  83 7E D2 00           CMP    word ptr [bp - 0x2e], 0 ; CMP
00677F  74 0B                 JE     0x678c ; CJUMP
006781  FF 76 D2              PUSH   word ptr [bp - 0x2e] ; PUSH_GLOBAL
006784  9A 94 24 7D 03        LCALL  0x37d, 0x2494 ; LCALL
006789  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00678C  C7 06 4A 40 08 00     MOV    word ptr [0x404a], 8 ; GLOBAL_LOAD
006792  C7 06 55 40 0B 00     MOV    word ptr [0x4055], 0xb ; GLOBAL_LOAD
006798  E9 69 FF              JMP    0x6704 ; JUMP
00679B  90                    NOP ; NOP
00679C  B8 02 00              MOV    ax, 2 ; MOV
00679F  50                    PUSH   ax ; STACK_PUSH
0067A0  2B C0                 SUB    ax, ax ; ARITH
0067A2  50                    PUSH   ax ; STACK_PUSH
0067A3  50                    PUSH   ax ; STACK_PUSH
0067A4  FF 76 DA              PUSH   word ptr [bp - 0x26] ; PUSH_GLOBAL
0067A7  9A 3A 1A 7D 03        LCALL  0x37d, 0x1a3a ; LCALL
0067AC  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0067AF  05 0F 00              ADD    ax, 0xf ; ARITH
0067B2  83 D2 00              ADC    dx, 0 ; ARITH
0067B5  D1 FA                 SAR    dx, 1 ; LOGIC
0067B7  D1 D8                 RCR    ax, 1 ; LOGIC
0067B9  D1 FA                 SAR    dx, 1 ; LOGIC
0067BB  D1 D8                 RCR    ax, 1 ; LOGIC
0067BD  D1 FA                 SAR    dx, 1 ; LOGIC
0067BF  D1 D8                 RCR    ax, 1 ; LOGIC
0067C1  D1 FA                 SAR    dx, 1 ; LOGIC
0067C3  D1 D8                 RCR    ax, 1 ; LOGIC
0067C5  89 46 D4              MOV    word ptr [bp - 0x2c], ax ; LOCAL_STORE
0067C8  89 56 D6              MOV    word ptr [bp - 0x2a], dx ; LOCAL_STORE
0067CB  FF 76 DA              PUSH   word ptr [bp - 0x26] ; PUSH_GLOBAL
0067CE  9A 1A 1A 7D 03        LCALL  0x37d, 0x1a1a ; LCALL
0067D3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0067D6  81 7E E2 5A 4D        CMP    word ptr [bp - 0x1e], 0x4d5a ; CMP
0067DB  74 07                 JE     0x67e4 ; CJUMP
0067DD  81 7E E2 4D 5A        CMP    word ptr [bp - 0x1e], 0x5a4d ; CMP
0067E2  75 03                 JNE    0x67e7 ; CJUMP
0067E4  FF 4E D8              DEC    word ptr [bp - 0x28] ; ARITH
0067E7  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
0067EB  74 28                 JE     0x6815 ; CJUMP
0067ED  2B C0                 SUB    ax, ax ; ARITH
0067EF  50                    PUSH   ax ; STACK_PUSH
0067F0  56                    PUSH   si ; STACK_PUSH
0067F1  8D 86 52 FF           LEA    ax, [bp - 0xae] ; ADDR
0067F5  50                    PUSH   ax ; STACK_PUSH
0067F6  8D 46 E0              LEA    ax, [bp - 0x20] ; ADDR
0067F9  50                    PUSH   ax ; STACK_PUSH
0067FA  8D 46 D2              LEA    ax, [bp - 0x2e] ; ADDR
0067FD  50                    PUSH   ax ; STACK_PUSH
0067FE  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
006801  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
006804  9A 6A 29 7D 03        LCALL  0x37d, 0x296a ; LCALL
006809  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
00680C  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
00680F  40                    INC    ax ; ARITH
006810  75 03                 JNE    0x6815 ; CJUMP
006812  E9 EF FE              JMP    0x6704 ; JUMP
006815  FF 76 D4              PUSH   word ptr [bp - 0x2c] ; PUSH_GLOBAL
006818  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
00681B  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
00681E  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
006821  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
006824  8B 46 E6              MOV    ax, word ptr [bp - 0x1a] ; LOCAL_LOAD
006827  B1 05                 MOV    cl, 5 ; MOV
006829  D3 E0                 SHL    ax, cl ; LOGIC
00682B  2B 46 EA              SUB    ax, word ptr [bp - 0x16] ; ARITH
00682E  03 46 EC              ADD    ax, word ptr [bp - 0x14] ; ARITH
006831  50                    PUSH   ax ; STACK_PUSH
006832  FF 76 DE              PUSH   word ptr [bp - 0x22] ; PUSH_GLOBAL
006835  FF 76 E0              PUSH   word ptr [bp - 0x20] ; PUSH_GLOBAL
006838  8D 86 52 FF           LEA    ax, [bp - 0xae] ; ADDR
00683C  50                    PUSH   ax ; STACK_PUSH
00683D  56                    PUSH   si ; STACK_PUSH
00683E  9A B0 06 7D 03        LCALL  0x37d, 0x6b0 ; LCALL
006843  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006846  40                    INC    ax ; ARITH
006847  50                    PUSH   ax ; STACK_PUSH
006848  56                    PUSH   si ; STACK_PUSH
006849  FF 76 D8              PUSH   word ptr [bp - 0x28] ; PUSH_GLOBAL
00684C  9A E2 2B 7D 03        LCALL  0x37d, 0x2be2 ; LCALL
006851  83 C4 18              ADD    sp, 0x18 ; STACK_CLEANUP
006854  E9 F5 FE              JMP    0x674c ; JUMP
006857  90                    NOP ; NOP
006858  5E                    POP    si ; STACK_POP
006859  8B E5                 MOV    sp, bp ; MOV
00685B  5D                    POP    bp ; STACK_POP
00685C  CB                    RETF ; RETURN
