; ============================================================================
; func_0409D6_unknown
; Region   : overlay
; Bytes    : file 0x0409D6..0x040C11  (571 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0409D6  C8 1C 00 00           ENTER  0x1c, 0 ; PROLOGUE
0409DA  56                    PUSH   si ; STACK_PUSH
0409DB  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
0409DF  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
0409E3  2A E4                 SUB    ah, ah ; ARITH
0409E5  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
0409E8  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
0409EC  2A ED                 SUB    ch, ch ; ARITH
0409EE  89 4E F2              MOV    word ptr [bp - 0xe], cx ; LOCAL_STORE
0409F1  51                    PUSH   cx ; STACK_PUSH
0409F2  50                    PUSH   ax ; STACK_PUSH
0409F3  8B F3                 MOV    si, bx ; MOV
0409F5  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
0409FA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0409FD  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
040A00  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
040A03  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
040A06  9A 40 07 1F 18        LCALL  0x181f, 0x740 ; THUNK -> 0x037F:0x012A (thunk @file 0x01AD30 type B) overlay @file 0x02EC66
040A0B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040A0E  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
040A11  89 56 F0              MOV    word ptr [bp - 0x10], dx ; LOCAL_STORE
040A14  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
040A17  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
040A1A  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
040A1F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040A22  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
040A25  8A 84 47 31           MOV    al, byte ptr [si + 0x3147] ; MOV
040A29  25 0F 00              AND    ax, 0xf ; LOGIC
040A2C  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
040A2F  C4 5E EE              LES    bx, ptr [bp - 0x12] ; MOV_FAR
040A32  26 F6 07 0A           TEST   byte ptr es:[bx], 0xa ; LOGIC
040A36  74 03                 JE     0x40a3b ; CJUMP
040A38  E9 D7 01              JMP    0x40c12 ; JUMP
040A3B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
040A3E  9A 34 09 1F 18        LCALL  0x181f, 0x934 ; THUNK -> 0x0427:0x155E (thunk @file 0x01AF24 type B) overlay @file 0x032272
040A43  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
040A46  FE 84 5A 31           INC    byte ptr [si + 0x315a] ; ARITH
040A4A  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
040A4D  C1 E3 04              SHL    bx, 4 ; LOGIC
040A50  8A 87 78 2F           MOV    al, byte ptr [bx + 0x2f78] ; MOV
040A54  2A E4                 SUB    ah, ah ; ARITH
040A56  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
040A59  80 BC 5B 31 14        CMP    byte ptr [si + 0x315b], 0x14 ; CMP
040A5E  75 05                 JNE    0x40a65 ; CJUMP
040A60  D1 F8                 SAR    ax, 1 ; LOGIC
040A62  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
040A65  8A 46 E6              MOV    al, byte ptr [bp - 0x1a] ; LOCAL_LOAD
040A68  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040A6C  38 87 5A 31           CMP    byte ptr [bx + 0x315a], al ; CMP
040A70  73 03                 JAE    0x40a75 ; CJUMP
040A72  E9 A6 01              JMP    0x40c1b ; JUMP
040A75  2A C0                 SUB    al, al ; ARITH
040A77  88 87 5A 31           MOV    byte ptr [bx + 0x315a], al ; MOV
040A7B  88 87 4C 31           MOV    byte ptr [bx + 0x314c], al ; MOV
040A7F  83 3E 9E 53 00        CMP    word ptr [0x539e], 0 ; CMP
040A84  74 28                 JE     0x40aae ; CJUMP
040A86  6A FF                 PUSH   -1 ; STACK_PUSH
040A88  6A FF                 PUSH   -1 ; STACK_PUSH
040A8A  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
040A8D  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
040A90  8B F3                 MOV    si, bx ; MOV
040A92  9A 14 06 1F 18        LCALL  0x181f, 0x614 ; THUNK -> 0x05EB:0x0142 (thunk @file 0x01AC04 type B) overlay @file 0x027132
040A97  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
040A9A  8A 84 47 31           MOV    al, byte ptr [si + 0x3147] ; MOV
040A9E  24 0F                 AND    al, 0xf ; LOGIC
040AA0  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
040AA4  3A 47 1A              CMP    al, byte ptr [bx + 0x1a] ; CMP
040AA7  75 05                 JNE    0x40aae ; CJUMP
040AA9  83 87 98 00 0A        ADD    word ptr [bx + 0x98], 0xa ; ARITH
040AAE  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
040AB1  39 06 94 53           CMP    word ptr [0x5394], ax ; CMP
040AB5  74 1C                 JE     0x40ad3 ; CJUMP
040AB7  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
040ABC  74 2B                 JE     0x40ae9 ; CJUMP
040ABE  83 3E 94 53 04        CMP    word ptr [0x5394], 4 ; CMP
040AC3  7C 05                 JL     0x40aca ; CJUMP
040AC5  B8 00 80              MOV    ax, 0x8000 ; CONST_LOAD
040AC8  EB 03                 JMP    0x40acd ; JUMP
040ACA  B8 00 40              MOV    ax, 0x4000 ; CONST_LOAD
040ACD  85 06 82 53           TEST   word ptr [0x5382], ax ; LOGIC
040AD1  74 16                 JE     0x40ae9 ; CJUMP
040AD3  6A 01                 PUSH   1 ; STACK_PUSH
040AD5  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
040AD8  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
040ADB  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
040ADE  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
040AE1  9A 52 03 1F 18        LCALL  0x181f, 0x352 ; THUNK -> 0x0984:0x02FC (thunk @file 0x01A942 type B) overlay @file 0x032212
040AE6  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
040AE9  C4 5E EE              LES    bx, ptr [bp - 0x12] ; MOV_FAR
040AEC  26 80 0F 08           OR     byte ptr es:[bx], 8 ; LOGIC
040AF0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
040AF3  0E                    PUSH   cs ; STACK_PUSH
040AF4  E8 2B 0D              CALL   0x41822 ; CALL_NEAR
040AF7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
040AFA  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
040AFD  39 06 94 53           CMP    word ptr [0x5394], ax ; CMP
040B01  74 1C                 JE     0x40b1f ; CJUMP
040B03  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
040B08  74 2D                 JE     0x40b37 ; CJUMP
040B0A  83 3E 94 53 04        CMP    word ptr [0x5394], 4 ; CMP
040B0F  7C 05                 JL     0x40b16 ; CJUMP
040B11  B8 00 80              MOV    ax, 0x8000 ; CONST_LOAD
040B14  EB 03                 JMP    0x40b19 ; JUMP
040B16  B8 00 40              MOV    ax, 0x4000 ; CONST_LOAD
040B19  85 06 82 53           TEST   word ptr [0x5382], ax ; LOGIC
040B1D  74 18                 JE     0x40b37 ; CJUMP
040B1F  6A 01                 PUSH   1 ; STACK_PUSH
040B21  6A 03                 PUSH   3 ; STACK_PUSH
040B23  6A 03                 PUSH   3 ; STACK_PUSH
040B25  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
040B28  48                    DEC    ax ; ARITH
040B29  50                    PUSH   ax ; STACK_PUSH
040B2A  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
040B2D  48                    DEC    ax ; ARITH
040B2E  50                    PUSH   ax ; STACK_PUSH
040B2F  9A BA 09 1F 18        LCALL  0x181f, 0x9ba ; THUNK -> 0x0000:0x0004 (thunk @file 0x01AFAA type A) overlay @file 0x025904
040B34  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
040B37  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
040B3A  6A FF                 PUSH   -1 ; STACK_PUSH
040B3C  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
040B3F  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
040B42  9A 84 0D 1F 18        LCALL  0x181f, 0xd84 ; THUNK -> 0x0000:0x0356 (thunk @file 0x01B374 type A) overlay @file 0x025C56
040B47  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
040B4A  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
040B4D  0B C0                 OR     ax, ax ; LOGIC
040B4F  7D 03                 JGE    0x40b54 ; CJUMP
040B51  E9 C7 00              JMP    0x40c1b ; JUMP
040B54  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
040B57  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
040B5A  9A 54 07 1F 18        LCALL  0x181f, 0x754 ; THUNK -> 0x037F:0x0142 (thunk @file 0x01AD44 type B) overlay @file 0x02EC7E
040B5F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040B62  A8 10                 TEST   al, 0x10 ; LOGIC
040B64  74 03                 JE     0x40b69 ; CJUMP
040B66  E9 B2 00              JMP    0x40c1b ; JUMP
040B69  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
040B6C  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
040B6F  9A 96 06 1F 18        LCALL  0x181f, 0x696 ; THUNK -> 0x037F:0x0358 (thunk @file 0x01AC86 type B) overlay @file 0x02EE94
040B74  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040B77  0B C0                 OR     ax, ax ; LOGIC
040B79  7C 03                 JL     0x40b7e ; CJUMP
040B7B  E9 9D 00              JMP    0x40c1b ; JUMP
040B7E  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
040B82  9A 56 0A 1F 18        LCALL  0x181f, 0xa56 ; THUNK -> 0x05DC:0x006A (thunk @file 0x01B046 type B) overlay @file 0x021A4C
040B87  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
040B8A  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
040B8D  A1 B8 8D              MOV    ax, word ptr [0x8db8] ; GLOBAL_LOAD
040B90  39 46 F6              CMP    word ptr [bp - 0xa], ax ; CMP
040B93  7D 03                 JGE    0x40b98 ; CJUMP
040B95  E9 83 00              JMP    0x40c1b ; JUMP
040B98  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
040B9B  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
040B9E  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
040BA1  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
040BA4  0E                    PUSH   cs ; STACK_PUSH
040BA5  E8 75 0C              CALL   0x4181d ; CALL_NEAR
040BA8  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
040BAB  0B C0                 OR     ax, ax ; LOGIC
040BAD  75 6C                 JNE    0x40c1b ; CJUMP
040BAF  6A 02                 PUSH   2 ; STACK_PUSH
040BB1  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
040BB4  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
040BB9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040BBC  0B C0                 OR     ax, ax ; LOGIC
040BBE  75 5B                 JNE    0x40c1b ; CJUMP
040BC0  83 3E 94 53 04        CMP    word ptr [0x5394], 4 ; CMP
040BC5  7D 11                 JGE    0x40bd8 ; CJUMP
040BC7  6B 1E 94 53 34        IMUL   bx, word ptr [0x5394], 0x34 ; ARITH
040BCC  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
040BD1  75 05                 JNE    0x40bd8 ; CJUMP
040BD3  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
040BD6  2A E4                 SUB    ah, ah ; ARITH
040BD8  05 03 00              ADD    ax, 3 ; ARITH
040BDB  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
040BDE  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
040BE1  83 3E B8 8D 02        CMP    word ptr [0x8db8], 2 ; CMP
040BE6  7F 05                 JG     0x40bed ; CJUMP
040BE8  D1 E0                 SHL    ax, 1 ; LOGIC
040BEA  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
040BED  83 3E B8 8D 01        CMP    word ptr [0x8db8], 1 ; CMP
040BF2  7F 06                 JG     0x40bfa ; CJUMP
040BF4  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
040BF7  01 46 EC              ADD    word ptr [bp - 0x14], ax ; ARITH
040BFA  6A 01                 PUSH   1 ; STACK_PUSH
040BFC  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
040BFF  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
040C02  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
040C06  9A 6C 0D 1F 18        LCALL  0x181f, 0xd6c ; THUNK -> 0x0000:0x00F2 (thunk @file 0x01B35C type A) overlay @file 0x0259F2
040C0B  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
040C0E  5E                    POP    si ; STACK_POP
040C0F  C9                    LEAVE ; EPILOGUE
040C10  CB                    RETF ; RETURN
