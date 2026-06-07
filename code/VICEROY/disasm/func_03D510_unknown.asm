; ============================================================================
; func_03D510_unknown
; Region   : overlay
; Bytes    : file 0x03D510..0x03D948  (1080 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "INTERVENE", "MERCS"  (auto-named via string xrefs)
; ============================================================================

03D510  C8 56 00 00           ENTER  0x56, 0 ; PROLOGUE
03D514  56                    PUSH   si ; STACK_PUSH
03D515  A1 98 53              MOV    ax, word ptr [0x5398] ; GLOBAL_LOAD
03D518  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
03D51B  2B C0                 SUB    ax, ax ; ARITH
03D51D  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
03D520  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
03D523  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
03D526  EB 3F                 JMP    0x3d567 ; JUMP
03D528  50                    PUSH   ax ; STACK_PUSH
03D529  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
03D52E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03D531  8A 46 AA              MOV    al, byte ptr [bp - 0x56] ; LOCAL_LOAD
03D534  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03D538  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
03D53B  75 27                 JNE    0x3d564 ; CJUMP
03D53D  F6 47 1C 40           TEST   byte ptr [bx + 0x1c], 0x40 ; LOGIC
03D541  74 21                 JE     0x3d564 ; CJUMP
03D543  83 7E DE 0A           CMP    word ptr [bp - 0x22], 0xa ; CMP
03D547  7D 1B                 JGE    0x3d564 ; CJUMP
03D549  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
03D54C  98                    CWDE ; ARITH
03D54D  8B 76 DE              MOV    si, word ptr [bp - 0x22] ; LOCAL_LOAD
03D550  D1 E6                 SHL    si, 1 ; LOGIC
03D552  89 42 BA              MOV    word ptr [bp + si - 0x46], ax ; LOCAL_STORE
03D555  01 46 EA              ADD    word ptr [bp - 0x16], ax ; ARITH
03D558  8A 46 AC              MOV    al, byte ptr [bp - 0x54] ; LOCAL_LOAD
03D55B  8B 76 DE              MOV    si, word ptr [bp - 0x22] ; LOCAL_LOAD
03D55E  88 42 D2              MOV    byte ptr [bp + si - 0x2e], al ; LOCAL_STORE
03D561  FF 46 DE              INC    word ptr [bp - 0x22] ; ARITH
03D564  FF 46 AC              INC    word ptr [bp - 0x54] ; ARITH
03D567  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
03D56A  39 06 9E 53           CMP    word ptr [0x539e], ax ; CMP
03D56E  7F B8                 JG     0x3d528 ; CJUMP
03D570  83 7E DE 00           CMP    word ptr [bp - 0x22], 0 ; CMP
03D574  75 03                 JNE    0x3d579 ; CJUMP
03D576  E9 CC 03              JMP    0x3d945 ; JUMP
03D579  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
03D57C  6A 01                 PUSH   1 ; STACK_PUSH
03D57E  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
03D583  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D586  89 46 D0              MOV    word ptr [bp - 0x30], ax ; LOCAL_STORE
03D589  C7 46 AC FF FF        MOV    word ptr [bp - 0x54], 0xffff ; LOCAL_STORE
03D58E  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0 ; LOCAL_STORE
03D593  EB 28                 JMP    0x3d5bd ; JUMP
03D595  90                    NOP ; NOP
03D596  8B 46 DE              MOV    ax, word ptr [bp - 0x22] ; LOCAL_LOAD
03D599  39 46 DC              CMP    word ptr [bp - 0x24], ax ; CMP
03D59C  7D 25                 JGE    0x3d5c3 ; CJUMP
03D59E  8B 76 DC              MOV    si, word ptr [bp - 0x24] ; LOCAL_LOAD
03D5A1  D1 E6                 SHL    si, 1 ; LOGIC
03D5A3  8B 42 BA              MOV    ax, word ptr [bp + si - 0x46] ; LOCAL_LOAD
03D5A6  29 46 D0              SUB    word ptr [bp - 0x30], ax ; ARITH
03D5A9  83 7E D0 00           CMP    word ptr [bp - 0x30], 0 ; CMP
03D5AD  7F 0B                 JG     0x3d5ba ; CJUMP
03D5AF  8B 76 DC              MOV    si, word ptr [bp - 0x24] ; LOCAL_LOAD
03D5B2  8A 42 D2              MOV    al, byte ptr [bp + si - 0x2e] ; LOCAL_LOAD
03D5B5  2A E4                 SUB    ah, ah ; ARITH
03D5B7  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
03D5BA  FF 46 DC              INC    word ptr [bp - 0x24] ; ARITH
03D5BD  83 7E AC 00           CMP    word ptr [bp - 0x54], 0 ; CMP
03D5C1  7C D3                 JL     0x3d596 ; CJUMP
03D5C3  83 7E AC 00           CMP    word ptr [bp - 0x54], 0 ; CMP
03D5C7  7D 03                 JGE    0x3d5cc ; CJUMP
03D5C9  E9 79 03              JMP    0x3d945 ; JUMP
03D5CC  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
03D5CF  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
03D5D4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03D5D7  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03D5DB  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
03D5DE  2A E4                 SUB    ah, ah ; ARITH
03D5E0  50                    PUSH   ax ; STACK_PUSH
03D5E1  8A 07                 MOV    al, byte ptr [bx] ; MOV
03D5E3  50                    PUSH   ax ; STACK_PUSH
03D5E4  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
03D5E9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D5EC  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
03D5EF  2B C0                 SUB    ax, ax ; ARITH
03D5F1  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
03D5F4  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
03D5F7  E9 27 01              JMP    0x3d721 ; JUMP
03D5FA  8B 5E E2              MOV    bx, word ptr [bp - 0x1e] ; LOCAL_LOAD
03D5FD  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
03D601  98                    CWDE ; ARITH
03D602  8B 36 42 85           MOV    si, word ptr [0x8542] ; GLOBAL_LOAD
03D606  8A 4C 01              MOV    cl, byte ptr [si + 1] ; MOV
03D609  2A ED                 SUB    ch, ch ; ARITH
03D60B  03 C1                 ADD    ax, cx ; ARITH
03D60D  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
03D610  C7 46 F0 01 00        MOV    word ptr [bp - 0x10], 1 ; LOCAL_STORE
03D615  50                    PUSH   ax ; STACK_PUSH
03D616  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
03D61A  98                    CWDE ; ARITH
03D61B  8A 0C                 MOV    cl, byte ptr [si] ; MOV
03D61D  03 C1                 ADD    ax, cx ; ARITH
03D61F  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
03D622  50                    PUSH   ax ; STACK_PUSH
03D623  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
03D628  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D62B  0B C0                 OR     ax, ax ; LOGIC
03D62D  75 03                 JNE    0x3d632 ; CJUMP
03D62F  E9 EC 00              JMP    0x3d71e ; JUMP
03D632  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
03D635  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
03D638  9A B4 06 1F 18        LCALL  0x181f, 0x6b4 ; THUNK -> 0x037F:0x01CA (thunk @file 0x01ACA4 type B) overlay @file 0x02ED06
03D63D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D640  FE C8                 DEC    al ; ARITH
03D642  74 03                 JE     0x3d647 ; CJUMP
03D644  E9 D7 00              JMP    0x3d71e ; JUMP
03D647  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
03D64A  8B 56 EC              MOV    dx, word ptr [bp - 0x14] ; LOCAL_LOAD
03D64D  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
03D652  89 46 CE              MOV    word ptr [bp - 0x32], ax ; LOCAL_STORE
03D655  0B C0                 OR     ax, ax ; LOGIC
03D657  7C 2E                 JL     0x3d687 ; CJUMP
03D659  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
03D65C  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
03D660  24 0F                 AND    al, 0xf ; LOGIC
03D662  3A 06 D2 53           CMP    al, byte ptr [0x53d2] ; CMP
03D666  75 1F                 JNE    0x3d687 ; CJUMP
03D668  6B 5E CE 1C           IMUL   bx, word ptr [bp - 0x32], 0x1c ; ARITH
03D66C  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
03D671  75 05                 JNE    0x3d678 ; CJUMP
03D673  81 6E F0 E7 03        SUB    word ptr [bp - 0x10], 0x3e7 ; ARITH
03D678  8B 46 CE              MOV    ax, word ptr [bp - 0x32] ; LOCAL_LOAD
03D67B  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
03D680  89 46 CE              MOV    word ptr [bp - 0x32], ax ; LOCAL_STORE
03D683  0B C0                 OR     ax, ax ; LOGIC
03D685  7D E1                 JGE    0x3d668 ; CJUMP
03D687  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
03D68B  7D 03                 JGE    0x3d690 ; CJUMP
03D68D  E9 8E 00              JMP    0x3d71e ; JUMP
03D690  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
03D693  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
03D696  9A 82 06 1F 18        LCALL  0x181f, 0x682 ; THUNK -> 0x037F:0x0314 (thunk @file 0x01AC72 type B) overlay @file 0x02EE50
03D69B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D69E  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03D6A1  0B C0                 OR     ax, ax ; LOGIC
03D6A3  7C 05                 JL     0x3d6aa ; CJUMP
03D6A5  3B 46 AA              CMP    ax, word ptr [bp - 0x56] ; CMP
03D6A8  75 74                 JNE    0x3d71e ; CJUMP
03D6AA  C7 46 E0 00 00        MOV    word ptr [bp - 0x20], 0 ; LOCAL_STORE
03D6AF  8B 5E E0              MOV    bx, word ptr [bp - 0x20] ; LOCAL_LOAD
03D6B2  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
03D6B6  98                    CWDE ; ARITH
03D6B7  03 46 EC              ADD    ax, word ptr [bp - 0x14] ; ARITH
03D6BA  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
03D6BD  50                    PUSH   ax ; STACK_PUSH
03D6BE  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
03D6C2  98                    CWDE ; ARITH
03D6C3  03 46 F2              ADD    ax, word ptr [bp - 0xe] ; ARITH
03D6C6  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03D6C9  50                    PUSH   ax ; STACK_PUSH
03D6CA  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
03D6CF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D6D2  0B C0                 OR     ax, ax ; LOGIC
03D6D4  75 28                 JNE    0x3d6fe ; CJUMP
03D6D6  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
03D6D9  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
03D6DC  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
03D6E1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D6E4  3B 46 E4              CMP    ax, word ptr [bp - 0x1c] ; CMP
03D6E7  75 15                 JNE    0x3d6fe ; CJUMP
03D6E9  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
03D6EC  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
03D6EF  9A BE 06 1F 18        LCALL  0x181f, 0x6be ; THUNK -> 0x037F:0x03E4 (thunk @file 0x01ACAE type B) overlay @file 0x02EF20
03D6F4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D6F7  0B C0                 OR     ax, ax ; LOGIC
03D6F9  7D 03                 JGE    0x3d6fe ; CJUMP
03D6FB  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
03D6FE  FF 46 E0              INC    word ptr [bp - 0x20] ; ARITH
03D701  83 7E E0 08           CMP    word ptr [bp - 0x20], 8 ; CMP
03D705  7C A8                 JL     0x3d6af ; CJUMP
03D707  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
03D70A  39 46 AE              CMP    word ptr [bp - 0x52], ax ; CMP
03D70D  7D 0F                 JGE    0x3d71e ; CJUMP
03D70F  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
03D712  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
03D715  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
03D718  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
03D71B  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
03D71E  FF 46 E2              INC    word ptr [bp - 0x1e] ; ARITH
03D721  83 7E E2 08           CMP    word ptr [bp - 0x1e], 8 ; CMP
03D725  7D 03                 JGE    0x3d72a ; CJUMP
03D727  E9 D0 FE              JMP    0x3d5fa ; JUMP
03D72A  83 7E AE 00           CMP    word ptr [bp - 0x52], 0 ; CMP
03D72E  7F 03                 JG     0x3d733 ; CJUMP
03D730  E9 12 02              JMP    0x3d945 ; JUMP
03D733  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
03D737  75 04                 JNE    0x3d73d ; CJUMP
03D739  FF 0E E6 53           DEC    word ptr [0x53e6] ; ARITH
03D73D  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
03D740  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
03D743  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
03D746  6A 12                 PUSH   0x12 ; PUSH_CONST
03D748  9A 5C 09 1F 18        LCALL  0x181f, 0x95c ; THUNK -> 0x0427:0x06B4 (thunk @file 0x01AF4C type B) overlay @file 0x0313C8
03D74D  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
03D750  89 46 CE              MOV    word ptr [bp - 0x32], ax ; LOCAL_STORE
03D753  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
03D756  0B C0                 OR     ax, ax ; LOGIC
03D758  7D 03                 JGE    0x3d75d ; CJUMP
03D75A  E9 E8 01              JMP    0x3d945 ; JUMP
03D75D  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
03D760  50                    PUSH   ax ; STACK_PUSH
03D761  9A 3E 09 1F 18        LCALL  0x181f, 0x93e ; THUNK -> 0x0427:0x0992 (thunk @file 0x01AF2E type B) overlay @file 0x0316A6
03D766  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D769  6A 00                 PUSH   0 ; STACK_PUSH
03D76B  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
03D76E  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
03D771  9A 08 0E 1F 18        LCALL  0x181f, 0xe08 ; THUNK -> 0x0984:0x029E (thunk @file 0x01B3F8 type B) overlay @file 0x0321B4
03D776  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03D779  A1 42 85              MOV    ax, word ptr [0x8542] ; GLOBAL_LOAD
03D77C  40                    INC    ax ; ARITH
03D77D  40                    INC    ax ; ARITH
03D77E  1E                    PUSH   ds ; STACK_PUSH
03D77F  50                    PUSH   ax ; STACK_PUSH
03D780  6A 00                 PUSH   0 ; STACK_PUSH
03D782  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
03D787  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03D78A  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
03D78E  75 32                 JNE    0x3d7c2 ; CJUMP
03D790  6A 03                 PUSH   3 ; STACK_PUSH
03D792  9A 98 04 1F 18        LCALL  0x181f, 0x498 ; THUNK -> 0x029F:0x0300 (thunk @file 0x01AA88 type B) overlay @file 0x022328
03D797  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03D79A  FF 36 D4 53           PUSH   word ptr [0x53d4] ; PUSH_GLOBAL
03D79E  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
03D7A3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03D7A6  50                    PUSH   ax ; STACK_PUSH
03D7A7  6A 01                 PUSH   1 ; STACK_PUSH
03D7A9  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
03D7AE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D7B1  B8 3F 00              MOV    ax, 0x3f ; CONST_LOAD
03D7B4  9A C0 04 1F 18        LCALL  0x181f, 0x4c0 ; THUNK -> 0x02D8:0x000E (thunk @file 0x01AAB0 type B)
03D7B9  6A 01                 PUSH   1 ; STACK_PUSH
03D7BB  68 C4 12              PUSH   0x12c4                       ; STRING: "INTERVENE"
03D7BE  EB 1E                 JMP    0x3d7de ; JUMP
03D7C0  90                    NOP ; NOP
03D7C1  90                    NOP ; NOP
03D7C2  FF 36 D6 53           PUSH   word ptr [0x53d6] ; PUSH_GLOBAL
03D7C6  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
03D7CB  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03D7CE  50                    PUSH   ax ; STACK_PUSH
03D7CF  6A 01                 PUSH   1 ; STACK_PUSH
03D7D1  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
03D7D6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D7D9  6A 01                 PUSH   1 ; STACK_PUSH
03D7DB  68 CE 12              PUSH   0x12ce                       ; STRING: "MERCS"
03D7DE  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
03D7E3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D7E6  C7 46 E8 01 00        MOV    word ptr [bp - 0x18], 1 ; LOCAL_STORE
03D7EB  C7 46 B2 06 00        MOV    word ptr [bp - 0x4e], 6 ; LOCAL_STORE
03D7F0  2B C0                 SUB    ax, ax ; ARITH
03D7F2  89 46 B4              MOV    word ptr [bp - 0x4c], ax ; LOCAL_STORE
03D7F5  89 46 B8              MOV    word ptr [bp - 0x48], ax ; LOCAL_STORE
03D7F8  39 06 E4 53           CMP    word ptr [0x53e4], ax ; CMP
03D7FC  74 0E                 JE     0x3d80c ; CJUMP
03D7FE  A1 E4 53              MOV    ax, word ptr [0x53e4] ; GLOBAL_LOAD
03D801  3D 02 00              CMP    ax, 2 ; CMP
03D804  7E 03                 JLE    0x3d809 ; CJUMP
03D806  B8 02 00              MOV    ax, 2 ; MOV
03D809  89 46 B4              MOV    word ptr [bp - 0x4c], ax ; LOCAL_STORE
03D80C  83 3E E8 53 00        CMP    word ptr [0x53e8], 0 ; CMP
03D811  74 0E                 JE     0x3d821 ; CJUMP
03D813  A1 E8 53              MOV    ax, word ptr [0x53e8] ; GLOBAL_LOAD
03D816  3D 02 00              CMP    ax, 2 ; CMP
03D819  7E 03                 JLE    0x3d81e ; CJUMP
03D81B  B8 02 00              MOV    ax, 2 ; MOV
03D81E  89 46 B8              MOV    word ptr [bp - 0x48], ax ; LOCAL_STORE
03D821  8B 46 B4              MOV    ax, word ptr [bp - 0x4c] ; LOCAL_LOAD
03D824  03 46 B8              ADD    ax, word ptr [bp - 0x48] ; ARITH
03D827  29 46 B2              SUB    word ptr [bp - 0x4e], ax ; ARITH
03D82A  C7 46 B0 00 00        MOV    word ptr [bp - 0x50], 0 ; LOCAL_STORE
03D82F  E9 B0 00              JMP    0x3d8e2 ; JUMP
03D832  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
03D835  C6 87 5B 31 15        MOV    byte ptr [bx + 0x315b], 0x15 ; CONST_LOAD
03D83A  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
03D83D  FF 76 CE              PUSH   word ptr [bp - 0x32] ; PUSH_GLOBAL
03D840  9A 3E 09 1F 18        LCALL  0x181f, 0x93e ; THUNK -> 0x0427:0x0992 (thunk @file 0x01AF2E type B) overlay @file 0x0316A6
03D845  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D848  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03D84C  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
03D84F  2A E4                 SUB    ah, ah ; ARITH
03D851  50                    PUSH   ax ; STACK_PUSH
03D852  8A 07                 MOV    al, byte ptr [bx] ; MOV
03D854  50                    PUSH   ax ; STACK_PUSH
03D855  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
03D858  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
03D85B  6A FF                 PUSH   -1 ; STACK_PUSH
03D85D  68 C0 00              PUSH   0xc0 ; PUSH_CONST
03D860  FF 76 CE              PUSH   word ptr [bp - 0x32] ; PUSH_GLOBAL
03D863  9A D0 02 1F 18        LCALL  0x181f, 0x2d0 ; THUNK -> 0x012B:0x0EB6 (thunk @file 0x01A8C0 type B) overlay @file 0x024420
03D868  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
03D86B  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03D86F  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
03D872  2A E4                 SUB    ah, ah ; ARITH
03D874  50                    PUSH   ax ; STACK_PUSH
03D875  8A 07                 MOV    al, byte ptr [bx] ; MOV
03D877  50                    PUSH   ax ; STACK_PUSH
03D878  FF 76 CE              PUSH   word ptr [bp - 0x32] ; PUSH_GLOBAL
03D87B  9A 48 09 1F 18        LCALL  0x181f, 0x948 ; THUNK -> 0x0427:0x040C (thunk @file 0x01AF38 type B) overlay @file 0x031120
03D880  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03D883  6A 01                 PUSH   1 ; STACK_PUSH
03D885  6A 05                 PUSH   5 ; STACK_PUSH
03D887  6A 05                 PUSH   5 ; STACK_PUSH
03D889  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03D88D  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
03D890  2A E4                 SUB    ah, ah ; ARITH
03D892  48                    DEC    ax ; ARITH
03D893  48                    DEC    ax ; ARITH
03D894  50                    PUSH   ax ; STACK_PUSH
03D895  8A 07                 MOV    al, byte ptr [bx] ; MOV
03D897  2A E4                 SUB    ah, ah ; ARITH
03D899  48                    DEC    ax ; ARITH
03D89A  48                    DEC    ax ; ARITH
03D89B  50                    PUSH   ax ; STACK_PUSH
03D89C  9A BA 09 1F 18        LCALL  0x181f, 0x9ba ; THUNK -> 0x0000:0x0004 (thunk @file 0x01AFAA type A) overlay @file 0x025904
03D8A1  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
03D8A4  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
03D8A8  75 09                 JNE    0x3d8b3 ; CJUMP
03D8AA  8B 5E B0              MOV    bx, word ptr [bp - 0x50] ; LOCAL_LOAD
03D8AD  D1 E3                 SHL    bx, 1 ; LOGIC
03D8AF  FF 8F E2 53           DEC    word ptr [bx + 0x53e2] ; ARITH
03D8B3  FF 46 DC              INC    word ptr [bp - 0x24] ; ARITH
03D8B6  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
03D8B9  39 46 DC              CMP    word ptr [bp - 0x24], ax ; CMP
03D8BC  7D 21                 JGE    0x3d8df ; CJUMP
03D8BE  6A FE                 PUSH   -2 ; STACK_PUSH
03D8C0  6A FE                 PUSH   -2 ; STACK_PUSH
03D8C2  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
03D8C5  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
03D8C8  9A 5C 09 1F 18        LCALL  0x181f, 0x95c ; THUNK -> 0x0427:0x06B4 (thunk @file 0x01AF4C type B) overlay @file 0x0313C8
03D8CD  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
03D8D0  89 46 CE              MOV    word ptr [bp - 0x32], ax ; LOCAL_STORE
03D8D3  0B C0                 OR     ax, ax ; LOGIC
03D8D5  7C 03                 JL     0x3d8da ; CJUMP
03D8D7  E9 58 FF              JMP    0x3d832 ; JUMP
03D8DA  C7 46 E8 00 00        MOV    word ptr [bp - 0x18], 0 ; LOCAL_STORE
03D8DF  FF 46 B0              INC    word ptr [bp - 0x50] ; ARITH
03D8E2  83 7E E8 00           CMP    word ptr [bp - 0x18], 0 ; CMP
03D8E6  74 46                 JE     0x3d92e ; CJUMP
03D8E8  83 7E B0 03           CMP    word ptr [bp - 0x50], 3 ; CMP
03D8EC  7F 40                 JG     0x3d92e ; CJUMP
03D8EE  83 7E B0 02           CMP    word ptr [bp - 0x50], 2 ; CMP
03D8F2  74 EB                 JE     0x3d8df ; CJUMP
03D8F4  8B 76 B0              MOV    si, word ptr [bp - 0x50] ; LOCAL_LOAD
03D8F7  D1 E6                 SHL    si, 1 ; LOGIC
03D8F9  8B 42 B2              MOV    ax, word ptr [bp + si - 0x4e] ; LOCAL_LOAD
03D8FC  3B 84 E2 53           CMP    ax, word ptr [si + 0x53e2] ; CMP
03D900  7E 04                 JLE    0x3d906 ; CJUMP
03D902  8B 84 E2 53           MOV    ax, word ptr [si + 0x53e2] ; MOV
03D906  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
03D909  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
03D90C  FF 76 B0              PUSH   word ptr [bp - 0x50] ; PUSH_GLOBAL
03D90F  0E                    PUSH   cs ; STACK_PUSH
03D910  E8 FD 10              CALL   0x3ea10 ; CALL_NEAR
03D913  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03D916  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
03D919  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
03D91D  74 07                 JE     0x3d926 ; CJUMP
03D91F  8B 84 46 9E           MOV    ax, word ptr [si - 0x61ba] ; MOV
03D923  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
03D926  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0 ; LOCAL_STORE
03D92B  EB 89                 JMP    0x3d8b6 ; JUMP
03D92D  90                    NOP ; NOP
03D92E  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
03D932  74 11                 JE     0x3d945 ; CJUMP
03D934  83 7E E6 00           CMP    word ptr [bp - 0x1a], 0 ; CMP
03D938  7C 0B                 JL     0x3d945 ; CJUMP
03D93A  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
03D93D  9A 08 08 1F 18        LCALL  0x181f, 0x808 ; THUNK -> 0x0427:0x0824 (thunk @file 0x01ADF8 type B) overlay @file 0x031538
03D942  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03D945  5E                    POP    si ; STACK_POP
03D946  C9                    LEAVE ; EPILOGUE
03D947  CB                    RETF ; RETURN
