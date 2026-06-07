; ============================================================================
; func_063F3C_unknown
; Region   : overlay
; Bytes    : file 0x063F3C..0x06412D  (497 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063F3C  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
063F40  57                    PUSH   di ; STACK_PUSH
063F41  56                    PUSH   si ; STACK_PUSH
063F42  2B F6                 SUB    si, si ; ARITH
063F44  39 36 3C 85           CMP    word ptr [0x853c], si ; CMP
063F48  7F 03                 JG     0x63f4d ; CJUMP
063F4A  E9 02 02              JMP    0x6414f ; JUMP
063F4D  2B FF                 SUB    di, di ; ARITH
063F4F  39 3E 3A 85           CMP    word ptr [0x853a], di ; CMP
063F53  7F 03                 JG     0x63f58 ; CJUMP
063F55  E9 E8 01              JMP    0x64140 ; JUMP
063F58  89 76 F4              MOV    word ptr [bp - 0xc], si ; LOCAL_STORE
063F5B  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
063F60  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
063F63  57                    PUSH   di ; STACK_PUSH
063F64  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
063F69  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
063F6C  0B C0                 OR     ax, ax ; LOGIC
063F6E  75 03                 JNE    0x63f73 ; CJUMP
063F70  E9 34 01              JMP    0x640a7 ; JUMP
063F73  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
063F76  57                    PUSH   di ; STACK_PUSH
063F77  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
063F7C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
063F7F  0B C0                 OR     ax, ax ; LOGIC
063F81  74 03                 JE     0x63f86 ; CJUMP
063F83  E9 21 01              JMP    0x640a7 ; JUMP
063F86  89 7E EC              MOV    word ptr [bp - 0x14], di ; LOCAL_STORE
063F89  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
063F8C  8B 5E F2              MOV    bx, word ptr [bp - 0xe] ; LOCAL_LOAD
063F8F  8A 87 DE 00           MOV    al, byte ptr [bx + 0xde] ; MOV
063F93  98                    CWDE ; ARITH
063F94  03 46 F4              ADD    ax, word ptr [bp - 0xc] ; ARITH
063F97  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
063F9A  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
063F9F  50                    PUSH   ax ; STACK_PUSH
063FA0  8A 87 C8 00           MOV    al, byte ptr [bx + 0xc8] ; MOV
063FA4  98                    CWDE ; ARITH
063FA5  03 46 EC              ADD    ax, word ptr [bp - 0x14] ; ARITH
063FA8  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
063FAB  50                    PUSH   ax ; STACK_PUSH
063FAC  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
063FB1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
063FB4  0B C0                 OR     ax, ax ; LOGIC
063FB6  75 03                 JNE    0x63fbb ; CJUMP
063FB8  E9 DD 00              JMP    0x64098 ; JUMP
063FBB  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
063FBE  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
063FC1  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
063FC6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
063FC9  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
063FCC  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
063FCF  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
063FD2  9A 18 07 1F 18        LCALL  0x181f, 0x718 ; THUNK -> 0x037F:0x04B0 (thunk @file 0x01AD08 type B) overlay @file 0x02EFEC
063FD7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
063FDA  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
063FDD  40                    INC    ax ; ARITH
063FDE  74 0E                 JE     0x63fee ; CJUMP
063FE0  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
063FE3  8A 87 B2 97           MOV    al, byte ptr [bx - 0x684e] ; MOV
063FE7  2A E4                 SUB    ah, ah ; ARITH
063FE9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
063FEC  EB 4C                 JMP    0x6403a ; JUMP
063FEE  83 7E EE 19           CMP    word ptr [bp - 0x12], 0x19 ; CMP
063FF2  75 3A                 JNE    0x6402e ; CJUMP
063FF4  BA 02 00              MOV    dx, 2 ; MOV
063FF7  2B F6                 SUB    si, si ; ARITH
063FF9  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
063FFC  8B FA                 MOV    di, dx ; MOV
063FFE  8A 84 BE 00           MOV    al, byte ptr [si + 0xbe] ; MOV
064002  98                    CWDE ; ARITH
064003  03 46 F8              ADD    ax, word ptr [bp - 8] ; ARITH
064006  50                    PUSH   ax ; STACK_PUSH
064007  8A 84 B4 00           MOV    al, byte ptr [si + 0xb4] ; MOV
06400B  98                    CWDE ; ARITH
06400C  03 46 F6              ADD    ax, word ptr [bp - 0xa] ; ARITH
06400F  50                    PUSH   ax ; STACK_PUSH
064010  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
064015  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064018  0B C0                 OR     ax, ax ; LOGIC
06401A  75 02                 JNE    0x6401e ; CJUMP
06401C  47                    INC    di ; ARITH
06401D  47                    INC    di ; ARITH
06401E  46                    INC    si ; ARITH
06401F  83 FE 08              CMP    si, 8 ; CMP
064022  7C DA                 JL     0x63ffe ; CJUMP
064024  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
064027  8B D7                 MOV    dx, di ; MOV
064029  C1 FF 02              SAR    di, 2 ; LOGIC
06402C  EB 0E                 JMP    0x6403c ; JUMP
06402E  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
064031  C1 E3 04              SHL    bx, 4 ; LOGIC
064034  8A 87 79 2F           MOV    al, byte ptr [bx + 0x2f79] ; MOV
064038  2A E4                 SUB    ah, ah ; ARITH
06403A  8B F8                 MOV    di, ax ; MOV
06403C  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
06403F  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
064042  9A 2C 07 1F 18        LCALL  0x181f, 0x72c ; THUNK -> 0x037F:0x010E (thunk @file 0x01AD1C type B) overlay @file 0x02EC4A
064047  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06404A  A8 40                 TEST   al, 0x40 ; LOGIC
06404C  74 01                 JE     0x6404f ; CJUMP
06404E  47                    INC    di ; ARITH
06404F  BA 02 00              MOV    dx, 2 ; MOV
064052  83 7E F2 04           CMP    word ptr [bp - 0xe], 4 ; CMP
064056  7D 10                 JGE    0x64068 ; CJUMP
064058  BA 05 00              MOV    dx, 5 ; MOV
06405B  83 7E EE 19           CMP    word ptr [bp - 0x12], 0x19 ; CMP
06405F  75 07                 JNE    0x64068 ; CJUMP
064061  8D 45 01              LEA    ax, [di + 1] ; ADDR
064064  D1 F8                 SAR    ax, 1 ; LOGIC
064066  8B F8                 MOV    di, ax ; MOV
064068  83 7E F2 08           CMP    word ptr [bp - 0xe], 8 ; CMP
06406C  7D 02                 JGE    0x64070 ; CJUMP
06406E  42                    INC    dx ; ARITH
06406F  42                    INC    dx ; ARITH
064070  83 7E F2 0C           CMP    word ptr [bp - 0xe], 0xc ; CMP
064074  7D 01                 JGE    0x64077 ; CJUMP
064076  42                    INC    dx ; ARITH
064077  83 7E F2 14           CMP    word ptr [bp - 0xe], 0x14 ; CMP
06407B  7D 01                 JGE    0x6407e ; CJUMP
06407D  42                    INC    dx ; ARITH
06407E  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
064081  83 7E F2 14           CMP    word ptr [bp - 0xe], 0x14 ; CMP
064085  75 05                 JNE    0x6408c ; CJUMP
064087  C7 46 FA 04 00        MOV    word ptr [bp - 6], 4 ; LOCAL_STORE
06408C  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
06408F  F7 EF                 IMUL   di ; ARITH
064091  D1 F8                 SAR    ax, 1 ; LOGIC
064093  8B F8                 MOV    di, ax ; MOV
064095  01 7E F0              ADD    word ptr [bp - 0x10], di ; ARITH
064098  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
06409B  83 7E F2 15           CMP    word ptr [bp - 0xe], 0x15 ; CMP
06409F  7D 03                 JGE    0x640a4 ; CJUMP
0640A1  E9 E8 FE              JMP    0x63f8c ; JUMP
0640A4  8B 7E EC              MOV    di, word ptr [bp - 0x14] ; LOCAL_LOAD
0640A7  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
0640AA  57                    PUSH   di ; STACK_PUSH
0640AB  9A 12 0D 1F 18        LCALL  0x181f, 0xd12 ; THUNK -> 0x05EB:0x00A2 (thunk @file 0x01B302 type B) overlay @file 0x027092
0640B0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0640B3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0640B6  0B C0                 OR     ax, ax ; LOGIC
0640B8  74 19                 JE     0x640d3 ; CJUMP
0640BA  FF 36 BC 8D           PUSH   word ptr [0x8dbc] ; PUSH_GLOBAL
0640BE  FF 36 BA 8D           PUSH   word ptr [0x8dba] ; PUSH_GLOBAL
0640C2  9A B4 06 1F 18        LCALL  0x181f, 0x6b4 ; THUNK -> 0x037F:0x01CA (thunk @file 0x01ACA4 type B) overlay @file 0x02ED06
0640C7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0640CA  FE C8                 DEC    al ; ARITH
0640CC  74 05                 JE     0x640d3 ; CJUMP
0640CE  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0640D3  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0640D7  75 03                 JNE    0x640dc ; CJUMP
0640D9  D1 7E F0              SAR    word ptr [bp - 0x10], 1 ; LOGIC
0640DC  8B 76 F0              MOV    si, word ptr [bp - 0x10] ; LOCAL_LOAD
0640DF  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
0640E2  57                    PUSH   di ; STACK_PUSH
0640E3  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
0640E8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0640EB  3D 1B 00              CMP    ax, 0x1b ; CMP
0640EE  75 02                 JNE    0x640f2 ; CJUMP
0640F0  2B F6                 SUB    si, si ; ARITH
0640F2  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
0640F5  57                    PUSH   di ; STACK_PUSH
0640F6  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
0640FB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0640FE  3D 1C 00              CMP    ax, 0x1c ; CMP
064101  75 02                 JNE    0x64105 ; CJUMP
064103  D1 FE                 SAR    si, 1 ; LOGIC
064105  6A 0F                 PUSH   0xf ; PUSH_CONST
064107  6A 00                 PUSH   0 ; STACK_PUSH
064109  8B C6                 MOV    ax, si ; MOV
06410B  B9 0A 00              MOV    cx, 0xa ; CONST_LOAD
06410E  99                    CDQ ; ARITH
06410F  F7 F9                 IDIV   cx ; ARITH
064111  50                    PUSH   ax ; STACK_PUSH
064112  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
064117  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06411A  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06411D  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
064120  57                    PUSH   di ; STACK_PUSH
064121  9A 36 07 1F 18        LCALL  0x181f, 0x736 ; THUNK -> 0x037F:0x02E0 (thunk @file 0x01AD26 type B) overlay @file 0x02EE1C
064126  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064129  8E C2                 MOV    es, dx ; MOV
06412B  8B D8                 MOV    bx, ax ; MOV
