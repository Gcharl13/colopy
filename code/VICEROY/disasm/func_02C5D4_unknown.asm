; ============================================================================
; func_02C5D4_unknown
; Region   : overlay
; Bytes    : file 0x02C5D4..0x02C824  (592 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "TUTORIAL4", "TUTORIAL12"  (auto-named via string xrefs)
; ============================================================================

02C5D4  C8 1A 00 00           ENTER  0x1a, 0 ; PROLOGUE
02C5D8  56                    PUSH   si ; STACK_PUSH
02C5D9  9A 5E 09 1F 19        LCALL  0x191f, 0x95e ; THUNK -> 0x0000:0x01F6 (thunk @file 0x01BF4E type A) overlay @file 0x025AF6
02C5DE  6A 00                 PUSH   0 ; STACK_PUSH
02C5E0  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
02C5E5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02C5E8  6A 07                 PUSH   7 ; STACK_PUSH
02C5EA  68 40 01              PUSH   0x140 ; PUSH_CONST
02C5ED  6A 00                 PUSH   0 ; STACK_PUSH
02C5EF  6A 00                 PUSH   0 ; STACK_PUSH
02C5F1  9A A6 00 1F 18        LCALL  0x181f, 0xa6 ; THUNK -> 0x0009:0x02AE (thunk @file 0x01A696 type B) overlay @file 0x022A78
02C5F6  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
02C5F9  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02C5FC  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
02C601  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02C604  C7 06 7C 8D 00 00     MOV    word ptr [0x8d7c], 0 ; GLOBAL_LOAD
02C60A  9A 72 0C 1F 18        LCALL  0x181f, 0xc72 ; THUNK -> 0x05EB:0x26E4 (thunk @file 0x01B262 type B) overlay @file 0x0296D4
02C60F  C7 06 90 08 01 00     MOV    word ptr [0x890], 1 ; GLOBAL_LOAD
02C615  0E                    PUSH   cs ; STACK_PUSH
02C616  E8 78 04              CALL   0x2ca91 ; CALL_NEAR
02C619  83 3E 4A 03 00        CMP    word ptr [0x34a], 0 ; CMP
02C61E  7C 0E                 JL     0x2c62e ; CJUMP
02C620  6A 00                 PUSH   0 ; STACK_PUSH
02C622  FF 36 4A 03           PUSH   word ptr [0x34a] ; PUSH_GLOBAL
02C626  9A BE 0B 1F 18        LCALL  0x181f, 0xbbe ; THUNK -> 0x05EB:0x1030 (thunk @file 0x01B1AE type B) overlay @file 0x028020
02C62B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02C62E  0E                    PUSH   cs ; STACK_PUSH
02C62F  E8 60 03              CALL   0x2c992 ; CALL_NEAR
02C632  6A 01                 PUSH   1 ; STACK_PUSH
02C634  0E                    PUSH   cs ; STACK_PUSH
02C635  E8 DC 03              CALL   0x2ca14 ; CALL_NEAR
02C638  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02C63B  83 3E 4A 03 00        CMP    word ptr [0x34a], 0 ; CMP
02C640  7C 2D                 JL     0x2c66f ; CJUMP
02C642  6A 01                 PUSH   1 ; STACK_PUSH
02C644  FF 36 4A 03           PUSH   word ptr [0x34a] ; PUSH_GLOBAL
02C648  9A BE 0B 1F 18        LCALL  0x181f, 0xbbe ; THUNK -> 0x05EB:0x1030 (thunk @file 0x01B1AE type B) overlay @file 0x028020
02C64D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02C650  0E                    PUSH   cs ; STACK_PUSH
02C651  E8 3E 03              CALL   0x2c992 ; CALL_NEAR
02C654  6A 00                 PUSH   0 ; STACK_PUSH
02C656  0E                    PUSH   cs ; STACK_PUSH
02C657  E8 BA 03              CALL   0x2ca14 ; CALL_NEAR
02C65A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02C65D  B8 54 00              MOV    ax, 0x54 ; CONST_LOAD
02C660  9A C0 04 1F 18        LCALL  0x181f, 0x4c0 ; THUNK -> 0x02D8:0x000E (thunk @file 0x01AAB0 type B)
02C665  6A 08                 PUSH   8 ; STACK_PUSH
02C667  9A EA 03 1F 18        LCALL  0x181f, 0x3ea ; THUNK -> 0x02D6:0x0000 (thunk @file 0x01A9DA type B)
02C66C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02C66F  83 3E 98 0B 00        CMP    word ptr [0xb98], 0 ; CMP
02C674  74 08                 JE     0x2c67e ; CJUMP
02C676  9A C0 03 1F 18        LCALL  0x181f, 0x3c0 ; THUNK -> 0x0262:0x0060 (thunk @file 0x01A9B0 type B) overlay @file 0x021D90
02C67B  E9 D6 02              JMP    0x2c954 ; JUMP
02C67E  F6 06 82 53 80        TEST   byte ptr [0x5382], 0x80 ; LOGIC
02C683  75 03                 JNE    0x2c688 ; CJUMP
02C685  E9 C7 00              JMP    0x2c74f ; JUMP
02C688  F6 06 86 53 80        TEST   byte ptr [0x5386], 0x80 ; LOGIC
02C68D  74 03                 JE     0x2c692 ; CJUMP
02C68F  E9 BD 00              JMP    0x2c74f ; JUMP
02C692  6A 00                 PUSH   0 ; STACK_PUSH
02C694  9A 0E 0C 1F 18        LCALL  0x181f, 0xc0e ; THUNK -> 0x05EB:0x0E18 (thunk @file 0x01B1FE type B) overlay @file 0x027E08
02C699  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02C69C  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
02C69F  3D 0D 00              CMP    ax, 0xd ; CMP
02C6A2  75 0C                 JNE    0x2c6b0 ; CJUMP
02C6A4  C7 46 EC 10 00        MOV    word ptr [bp - 0x14], 0x10 ; LOCAL_STORE
02C6A9  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
02C6AE  EB 67                 JMP    0x2c717 ; JUMP
02C6B0  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
02C6B3  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
02C6B6  50                    PUSH   ax ; STACK_PUSH
02C6B7  8D 4E F4              LEA    cx, [bp - 0xc] ; ADDR
02C6BA  51                    PUSH   cx ; STACK_PUSH
02C6BB  2B D2                 SUB    dx, dx ; ARITH
02C6BD  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
02C6C0  52                    PUSH   dx ; STACK_PUSH
02C6C1  9A 30 0D 1F 18        LCALL  0x181f, 0xd30 ; THUNK -> 0x05EB:0x1646 (thunk @file 0x01B320 type B) overlay @file 0x028636
02C6C6  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02C6C9  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02C6CD  8A 07                 MOV    al, byte ptr [bx] ; MOV
02C6CF  2A E4                 SUB    ah, ah ; ARITH
02C6D1  48                    DEC    ax ; ARITH
02C6D2  48                    DEC    ax ; ARITH
02C6D3  01 46 F4              ADD    word ptr [bp - 0xc], ax ; ARITH
02C6D6  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
02C6D9  2A E4                 SUB    ah, ah ; ARITH
02C6DB  48                    DEC    ax ; ARITH
02C6DC  48                    DEC    ax ; ARITH
02C6DD  01 46 F2              ADD    word ptr [bp - 0xe], ax ; ARITH
02C6E0  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
02C6E3  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02C6E6  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
02C6EB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02C6EE  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
02C6F1  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
02C6F6  8B 76 F0              MOV    si, word ptr [bp - 0x10] ; LOCAL_LOAD
02C6F9  C1 E6 04              SHL    si, 4 ; LOGIC
02C6FC  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
02C6FF  80 B8 7B 2F 00        CMP    byte ptr [bx + si + 0x2f7b], 0 ; CMP
02C704  74 08                 JE     0x2c70e ; CJUMP
02C706  3B 5E EE              CMP    bx, word ptr [bp - 0x12] ; CMP
02C709  74 03                 JE     0x2c70e ; CJUMP
02C70B  89 5E FE              MOV    word ptr [bp - 2], bx ; LOCAL_STORE
02C70E  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
02C711  83 7E FA 08           CMP    word ptr [bp - 6], 8 ; CMP
02C715  7C DF                 JL     0x2c6f6 ; CJUMP
02C717  8B 5E EC              MOV    bx, word ptr [bp - 0x14] ; LOCAL_LOAD
02C71A  D1 E3                 SHL    bx, 1 ; LOGIC
02C71C  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
02C720  6A 00                 PUSH   0 ; STACK_PUSH
02C722  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
02C727  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02C72A  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
02C72D  D1 E3                 SHL    bx, 1 ; LOGIC
02C72F  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
02C733  6A 01                 PUSH   1 ; STACK_PUSH
02C735  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
02C73A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02C73D  6A 05                 PUSH   5 ; STACK_PUSH
02C73F  68 3D 0D              PUSH   0xd3d                        ; STRING: "TUTORIAL4"
02C742  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
02C747  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02C74A  80 0E 86 53 80        OR     byte ptr [0x5386], 0x80 ; LOGIC
02C74F  F6 06 82 53 80        TEST   byte ptr [0x5382], 0x80 ; LOGIC
02C754  74 6B                 JE     0x2c7c1 ; CJUMP
02C756  F6 06 87 53 80        TEST   byte ptr [0x5387], 0x80 ; LOGIC
02C75B  75 64                 JNE    0x2c7c1 ; CJUMP
02C75D  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
02C762  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02C766  8A 07                 MOV    al, byte ptr [bx] ; MOV
02C768  2A E4                 SUB    ah, ah ; ARITH
02C76A  8A 57 01              MOV    dl, byte ptr [bx + 1] ; MOV
02C76D  2A F6                 SUB    dh, dh ; ARITH
02C76F  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
02C774  EB 1B                 JMP    0x2c791 ; JUMP
02C776  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
02C779  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
02C77E  72 0C                 JB     0x2c78c ; CJUMP
02C780  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
02C785  77 05                 JA     0x2c78c ; CJUMP
02C787  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
02C78C  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
02C791  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
02C794  0B C0                 OR     ax, ax ; LOGIC
02C796  7D DE                 JGE    0x2c776 ; CJUMP
02C798  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
02C79C  74 23                 JE     0x2c7c1 ; CJUMP
02C79E  A1 42 85              MOV    ax, word ptr [0x8542] ; GLOBAL_LOAD
02C7A1  40                    INC    ax ; ARITH
02C7A2  40                    INC    ax ; ARITH
02C7A3  1E                    PUSH   ds ; STACK_PUSH
02C7A4  50                    PUSH   ax ; STACK_PUSH
02C7A5  6A 00                 PUSH   0 ; STACK_PUSH
02C7A7  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
02C7AC  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02C7AF  6A 05                 PUSH   5 ; STACK_PUSH
02C7B1  68 47 0D              PUSH   0xd47                        ; STRING: "TUTORIAL12"
02C7B4  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
02C7B9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02C7BC  80 0E 87 53 80        OR     byte ptr [0x5387], 0x80 ; LOGIC
02C7C1  C7 06 46 03 01 00     MOV    word ptr [0x346], 1 ; GLOBAL_LOAD
02C7C7  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
02C7CC  05 14 00              ADD    ax, 0x14 ; ARITH
02C7CF  83 D2 00              ADC    dx, 0 ; ARITH
02C7D2  A3 5A 8D              MOV    word ptr [0x8d5a], ax ; GLOBAL_LOAD
02C7D5  89 16 5C 8D           MOV    word ptr [0x8d5c], dx ; GLOBAL_LOAD
02C7D9  9A 7A 04 1F 18        LCALL  0x181f, 0x47a ; THUNK -> 0x0ACB:0x0030 (thunk @file 0x01AA6A type B) overlay @file 0x0318D2
02C7DE  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
02C7E3  74 77                 JE     0x2c85c ; CJUMP
02C7E5  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
02C7EA  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
02C7ED  89 56 F8              MOV    word ptr [bp - 8], dx ; LOCAL_STORE
02C7F0  9A 70 04 1F 18        LCALL  0x181f, 0x470 ; THUNK -> 0x029F:0x00F6 (thunk @file 0x01AA60 type B) overlay @file 0x02211E
02C7F5  2B C0                 SUB    ax, ax ; ARITH
02C7F7  9A 66 04 1F 18        LCALL  0x181f, 0x466 ; THUNK -> 0x0ACB:0x0056 (thunk @file 0x01AA56 type B) overlay @file 0x0318F8
02C7FC  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
02C801  75 09                 JNE    0x2c80c ; CJUMP
02C803  9A F6 00 1F 18        LCALL  0x181f, 0xf6 ; THUNK -> 0x0AE7:0x0002 (thunk @file 0x01A6E6 type B) overlay @file 0x026FF2
02C808  0B C0                 OR     ax, ax ; LOGIC
02C80A  74 17                 JE     0x2c823 ; CJUMP
02C80C  9A EC 00 1F 18        LCALL  0x181f, 0xec ; THUNK -> 0x0262:0x00DA (thunk @file 0x01A6DC type B) overlay @file 0x021E0A
02C811  6A 05                 PUSH   5 ; STACK_PUSH
02C813  9A B6 05 1F 18        LCALL  0x181f, 0x5b6 ; THUNK -> 0x0000:0x0034 (thunk @file 0x01ABA6 type A) overlay @file 0x025934
02C818  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02C81B  2B C0                 SUB    ax, ax ; ARITH
02C81D  A3 46 03              MOV    word ptr [0x346], ax ; GLOBAL_LOAD
02C820  A3 C2 53              MOV    word ptr [0x53c2], ax ; GLOBAL_LOAD
02C823  2B                    DB     0x2B ; DATA_BYTE
