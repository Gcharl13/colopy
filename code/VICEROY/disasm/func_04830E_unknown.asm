; ============================================================================
; func_04830E_unknown
; Region   : overlay
; Bytes    : file 0x04830E..0x0485F5  (743 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04830E  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
048312  56                    PUSH   si ; STACK_PUSH
048313  C7 46 EC 00 00        MOV    word ptr [bp - 0x14], 0 ; LOCAL_STORE
048318  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04831B  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
048320  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
048323  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
048326  0E                    PUSH   cs ; STACK_PUSH
048327  E8 0A 37              CALL   0x4ba34 ; CALL_NEAR
04832A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04832D  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
048331  3A 47 04              CMP    al, byte ptr [bx + 4] ; CMP
048334  76 05                 JBE    0x4833b ; CJUMP
048336  C7 46 EC 02 00        MOV    word ptr [bp - 0x14], 2 ; LOCAL_STORE
04833B  F6 47 03 01           TEST   byte ptr [bx + 3], 1 ; LOGIC
04833F  74 05                 JE     0x48346 ; CJUMP
048341  C7 46 EC 01 00        MOV    word ptr [bp - 0x14], 1 ; LOCAL_STORE
048346  83 7E EC 00           CMP    word ptr [bp - 0x14], 0 ; CMP
04834A  75 03                 JNE    0x4834f ; CJUMP
04834C  E9 93 00              JMP    0x483e2 ; JUMP
04834F  8A 47 04              MOV    al, byte ptr [bx + 4] ; MOV
048352  00 47 06              ADD    byte ptr [bx + 6], al ; ARITH
048355  80 7F 06 14           CMP    byte ptr [bx + 6], 0x14 ; CMP
048359  7D 03                 JGE    0x4835e ; CJUMP
04835B  E9 84 00              JMP    0x483e2 ; JUMP
04835E  C6 47 06 00           MOV    byte ptr [bx + 6], 0 ; MOV
048362  83 7E EC 02           CMP    word ptr [bp - 0x14], 2 ; CMP
048366  75 06                 JNE    0x4836e ; CJUMP
048368  FE 47 04              INC    byte ptr [bx + 4] ; ARITH
04836B  EB 75                 JMP    0x483e2 ; JUMP
04836D  90                    NOP ; NOP
04836E  C7 46 FE 13 00        MOV    word ptr [bp - 2], 0x13 ; LOCAL_STORE
048373  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
048377  80 7F 07 00           CMP    byte ptr [bx + 7], 0 ; CMP
04837B  7E 1E                 JLE    0x4839b ; CJUMP
04837D  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
048380  2A E4                 SUB    ah, ah ; ARITH
048382  50                    PUSH   ax ; STACK_PUSH
048383  6A 00                 PUSH   0 ; STACK_PUSH
048385  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
04838A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04838D  0B C0                 OR     ax, ax ; LOGIC
04838F  75 07                 JNE    0x48398 ; CJUMP
048391  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
048395  FE 4F 07              DEC    byte ptr [bx + 7] ; ARITH
048398  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
04839B  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
04839F  83 7F 0A 32           CMP    word ptr [bx + 0xa], 0x32 ; CMP
0483A3  7C 08                 JL     0x483ad ; CJUMP
0483A5  83 6F 0A 32           SUB    word ptr [bx + 0xa], 0x32 ; ARITH
0483A9  83 46 FE 02           ADD    word ptr [bp - 2], 2 ; ARITH
0483AD  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
0483B1  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
0483B4  2A E4                 SUB    ah, ah ; ARITH
0483B6  50                    PUSH   ax ; STACK_PUSH
0483B7  8A 07                 MOV    al, byte ptr [bx] ; MOV
0483B9  50                    PUSH   ax ; STACK_PUSH
0483BA  8A 47 02              MOV    al, byte ptr [bx + 2] ; MOV
0483BD  50                    PUSH   ax ; STACK_PUSH
0483BE  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0483C1  9A 5C 09 1F 18        LCALL  0x181f, 0x95c ; THUNK -> 0x0427:0x06B4 (thunk @file 0x01AF4C type B) overlay @file 0x0313C8
0483C6  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0483C9  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
0483CC  0B C0                 OR     ax, ax ; LOGIC
0483CE  7C 12                 JL     0x483e2 ; CJUMP
0483D0  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
0483D3  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
0483D6  88 87 4A 31           MOV    byte ptr [bx + 0x314a], al ; MOV
0483DA  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
0483DE  80 67 03 FE           AND    byte ptr [bx + 3], 0xfe ; LOGIC
0483E2  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
0483E7  74 03                 JE     0x483ec ; CJUMP
0483E9  E9 82 00              JMP    0x4846e ; JUMP
0483EC  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0 ; LOCAL_STORE
0483F1  EB 35                 JMP    0x48428 ; JUMP
0483F3  90                    NOP ; NOP
0483F4  B8 0C 00              MOV    ax, 0xc ; CONST_LOAD
0483F7  2B 46 E8              SUB    ax, word ptr [bp - 0x18] ; ARITH
0483FA  50                    PUSH   ax ; STACK_PUSH
0483FB  6A 00                 PUSH   0 ; STACK_PUSH
0483FD  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
048402  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048405  0B C0                 OR     ax, ax ; LOGIC
048407  75 03                 JNE    0x4840c ; CJUMP
048409  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
04840C  FF 46 F4              INC    word ptr [bp - 0xc] ; ARITH
04840F  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
048412  40                    INC    ax ; ARITH
048413  3B 46 F4              CMP    ax, word ptr [bp - 0xc] ; CMP
048416  7F DC                 JG     0x483f4 ; CJUMP
048418  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
04841B  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
04841F  8B 76 EE              MOV    si, word ptr [bp - 0x12] ; LOCAL_LOAD
048422  00 40 36              ADD    byte ptr [bx + si + 0x36], al ; ARITH
048425  FF 46 EE              INC    word ptr [bp - 0x12] ; ARITH
048428  83 7E EE 04           CMP    word ptr [bp - 0x12], 4 ; CMP
04842C  7D 40                 JGE    0x4846e ; CJUMP
04842E  FF 36 50 8D           PUSH   word ptr [0x8d50] ; PUSH_GLOBAL
048432  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
048435  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
04843A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04843D  A8 20                 TEST   al, 0x20 ; LOGIC
04843F  74 E4                 JE     0x48425 ; CJUMP
048441  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
048444  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
048448  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
04844D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048450  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
048453  50                    PUSH   ax ; STACK_PUSH
048454  9A 60 0A 1F 18        LCALL  0x181f, 0xa60 ; THUNK -> 0x05DC:0x00A2 (thunk @file 0x01B050 type B) overlay @file 0x021A84
048459  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04845C  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
04845F  F7 E8                 IMUL   ax ; ARITH
048461  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
048464  2B C0                 SUB    ax, ax ; ARITH
048466  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
048469  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
04846C  EB A1                 JMP    0x4840f ; JUMP
04846E  8D 46 FC              LEA    ax, [bp - 4] ; ADDR
048471  50                    PUSH   ax ; STACK_PUSH
048472  FF 36 4C 8D           PUSH   word ptr [0x8d4c] ; PUSH_GLOBAL
048476  9A 16 03 1F 18        LCALL  0x181f, 0x316 ; THUNK -> 0x0000:0x03F8 (thunk @file 0x01A906 type A) overlay @file 0x025CF8
04847B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04847E  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
048481  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
048485  8A 47 05              MOV    al, byte ptr [bx + 5] ; MOV
048488  98                    CWDE ; ARITH
048489  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
04848C  0B C0                 OR     ax, ax ; LOGIC
04848E  7C 06                 JL     0x48496 ; CJUMP
048490  25 0F 00              AND    ax, 0xf ; LOGIC
048493  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
048496  0B C0                 OR     ax, ax ; LOGIC
048498  7D 09                 JGE    0x484a3 ; CJUMP
04849A  83 7E EE 00           CMP    word ptr [bp - 0x12], 0 ; CMP
04849E  7D 03                 JGE    0x484a3 ; CJUMP
0484A0  E9 19 01              JMP    0x485bc ; JUMP
0484A3  8A 47 03              MOV    al, byte ptr [bx + 3] ; MOV
0484A6  24 04                 AND    al, 4 ; LOGIC
0484A8  3C 01                 CMP    al, 1 ; CMP
0484AA  1B C0                 SBB    ax, ax ; ARITH
0484AC  40                    INC    ax ; ARITH
0484AD  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0484B0  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
0484B4  7C 68                 JL     0x4851e ; CJUMP
0484B6  8B C8                 MOV    cx, ax ; MOV
0484B8  8A 47 05              MOV    al, byte ptr [bx + 5] ; MOV
0484BB  24 10                 AND    al, 0x10 ; LOGIC
0484BD  3C 01                 CMP    al, 1 ; CMP
0484BF  1B C0                 SBB    ax, ax ; ARITH
0484C1  24 FD                 AND    al, 0xfd ; LOGIC
0484C3  05 04 00              ADD    ax, 4 ; ARITH
0484C6  D3 E0                 SHL    ax, cl ; LOGIC
0484C8  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0484CB  6A 18                 PUSH   0x18 ; PUSH_CONST
0484CD  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
0484D0  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
0484D5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0484D8  0B C0                 OR     ax, ax ; LOGIC
0484DA  74 03                 JE     0x484df ; CJUMP
0484DC  D1 66 FA              SHL    word ptr [bp - 6], 1 ; LOGIC
0484DF  6A 17                 PUSH   0x17 ; PUSH_CONST
0484E1  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
0484E4  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
0484E9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0484EC  0B C0                 OR     ax, ax ; LOGIC
0484EE  74 03                 JE     0x484f3 ; CJUMP
0484F0  D1 7E FA              SAR    word ptr [bp - 6], 1 ; LOGIC
0484F3  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
0484F6  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
0484FA  8B 76 F2              MOV    si, word ptr [bp - 0xe] ; LOCAL_LOAD
0484FD  00 40 36              ADD    byte ptr [bx + si + 0x36], al ; ARITH
048500  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
048503  8B C8                 MOV    cx, ax ; MOV
048505  D1 E0                 SHL    ax, 1 ; LOGIC
048507  03 C1                 ADD    ax, cx ; ARITH
048509  D1 E6                 SHL    si, 1 ; LOGIC
04850B  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04850F  29 40 0A              SUB    word ptr [bx + si + 0xa], ax ; ARITH
048512  8B 40 0A              MOV    ax, word ptr [bx + si + 0xa] ; MOV
048515  0B C0                 OR     ax, ax ; LOGIC
048517  7D 02                 JGE    0x4851b ; CJUMP
048519  2B C0                 SUB    ax, ax ; ARITH
04851B  89 40 0A              MOV    word ptr [bx + si + 0xa], ax ; MOV
04851E  83 7E EE 00           CMP    word ptr [bp - 0x12], 0 ; CMP
048522  7C 44                 JL     0x48568 ; CJUMP
048524  8A 4E F8              MOV    cl, byte ptr [bp - 8] ; LOCAL_LOAD
048527  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
04852A  D3 E0                 SHL    ax, cl ; LOGIC
04852C  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
04852F  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
048533  8B 76 EE              MOV    si, word ptr [bp - 0x12] ; LOCAL_LOAD
048536  28 40 36              SUB    byte ptr [bx + si + 0x36], al ; ARITH
048539  3B 76 F2              CMP    si, word ptr [bp - 0xe] ; CMP
04853C  75 03                 JNE    0x48541 ; CJUMP
04853E  D1 7E F6              SAR    word ptr [bp - 0xa], 1 ; LOGIC
048541  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
048544  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
048548  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
04854D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048550  B9 05 00              MOV    cx, 5 ; MOV
048553  99                    CDQ ; ARITH
048554  F7 F9                 IDIV   cx ; ARITH
048556  01 46 F6              ADD    word ptr [bp - 0xa], ax ; ARITH
048559  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
04855C  8B 76 EE              MOV    si, word ptr [bp - 0x12] ; LOCAL_LOAD
04855F  D1 E6                 SHL    si, 1 ; LOGIC
048561  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
048565  01 40 0A              ADD    word ptr [bx + si + 0xa], ax ; ARITH
048568  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
04856C  7C 24                 JL     0x48592 ; CJUMP
04856E  EB 15                 JMP    0x48585 ; JUMP
048570  80 68 36 08           SUB    byte ptr [bx + si + 0x36], 8 ; ARITH
048574  6A 03                 PUSH   3 ; STACK_PUSH
048576  6A FF                 PUSH   -1 ; STACK_PUSH
048578  56                    PUSH   si ; STACK_PUSH
048579  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
04857D  9A 6C 0D 1F 18        LCALL  0x181f, 0xd6c ; THUNK -> 0x0000:0x00F2 (thunk @file 0x01B35C type A) overlay @file 0x0259F2
048582  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
048585  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
048589  8B 76 F2              MOV    si, word ptr [bp - 0xe] ; LOCAL_LOAD
04858C  80 78 36 08           CMP    byte ptr [bx + si + 0x36], 8 ; CMP
048590  7D DE                 JGE    0x48570 ; CJUMP
048592  83 7E EE 00           CMP    word ptr [bp - 0x12], 0 ; CMP
048596  7C 24                 JL     0x485bc ; CJUMP
048598  EB 15                 JMP    0x485af ; JUMP
04859A  80 40 36 08           ADD    byte ptr [bx + si + 0x36], 8 ; ARITH
04859E  6A 05                 PUSH   5 ; STACK_PUSH
0485A0  6A 01                 PUSH   1 ; STACK_PUSH
0485A2  56                    PUSH   si ; STACK_PUSH
0485A3  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
0485A7  9A 6C 0D 1F 18        LCALL  0x181f, 0xd6c ; THUNK -> 0x0000:0x00F2 (thunk @file 0x01B35C type A) overlay @file 0x0259F2
0485AC  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0485AF  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
0485B3  8B 76 EE              MOV    si, word ptr [bp - 0x12] ; LOCAL_LOAD
0485B6  80 78 36 F8           CMP    byte ptr [bx + si + 0x36], 0xf8 ; CMP
0485BA  7E DE                 JLE    0x4859a ; CJUMP
0485BC  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0 ; LOCAL_STORE
0485C1  EB 04                 JMP    0x485c7 ; JUMP
0485C3  90                    NOP ; NOP
0485C4  FF 46 EE              INC    word ptr [bp - 0x12] ; ARITH
0485C7  83 7E EE 04           CMP    word ptr [bp - 0x12], 4 ; CMP
0485CB  7D 25                 JGE    0x485f2 ; CJUMP
0485CD  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
0485D1  8B 76 EE              MOV    si, word ptr [bp - 0x12] ; LOCAL_LOAD
0485D4  80 78 36 08           CMP    byte ptr [bx + si + 0x36], 8 ; CMP
0485D8  7C EA                 JL     0x485c4 ; CJUMP
0485DA  80 68 36 08           SUB    byte ptr [bx + si + 0x36], 8 ; ARITH
0485DE  6A 00                 PUSH   0 ; STACK_PUSH
0485E0  6A FF                 PUSH   -1 ; STACK_PUSH
0485E2  56                    PUSH   si ; STACK_PUSH
0485E3  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
0485E7  9A 6C 0D 1F 18        LCALL  0x181f, 0xd6c ; THUNK -> 0x0000:0x00F2 (thunk @file 0x01B35C type A) overlay @file 0x0259F2
0485EC  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0485EF  EB DC                 JMP    0x485cd ; JUMP
0485F1  90                    NOP ; NOP
0485F2  5E                    POP    si ; STACK_POP
0485F3  C9                    LEAVE ; EPILOGUE
0485F4  CB                    RETF ; RETURN
