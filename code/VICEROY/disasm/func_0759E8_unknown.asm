; ============================================================================
; func_0759E8_unknown
; Region   : overlay
; Bytes    : file 0x0759E8..0x075F86  (1438 bytes)
; Purpose  : Game load / open-menu framework (GAME/MAPTOLOAD/OPENMENU/WOODPANL)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; Tagged: "OPENMENU", "*.MP", "MAPTOLOAD"  (auto-named via string xrefs)
; ============================================================================

0759E8  C8 F4 03 00           ENTER  0x3f4, 0 ; PROLOGUE
0759EC  B8 01 00              MOV    ax, 1 ; MOV
0759EF  89 86 1E FF           MOV    word ptr [bp - 0xe2], ax ; LOCAL_STORE
0759F3  89 86 1C FF           MOV    word ptr [bp - 0xe4], ax ; LOCAL_STORE
0759F7  C7 86 10 FF C8 00     MOV    word ptr [bp - 0xf0], 0xc8 ; LOCAL_STORE
0759FD  C7 86 12 FF 40 01     MOV    word ptr [bp - 0xee], 0x140 ; LOCAL_STORE
075A03  C7 86 14 FF 00 00     MOV    word ptr [bp - 0xec], 0 ; LOCAL_STORE
075A09  C7 86 16 FF 00 A0     MOV    word ptr [bp - 0xea], 0xa000 ; LOCAL_STORE
075A0F  9A 3C 05 1F 18        LCALL  0x181f, 0x53c ; THUNK -> 0x030D:0x019C (thunk @file 0x01AB2C type B) overlay @file 0x02AEDA
075A14  83 3E 04 01 00        CMP    word ptr [0x104], 0 ; CMP
075A19  74 37                 JE     0x75a52 ; CJUMP
075A1B  6A 03                 PUSH   3 ; STACK_PUSH
075A1D  9A 98 04 1F 18        LCALL  0x181f, 0x498 ; THUNK -> 0x029F:0x0300 (thunk @file 0x01AA88 type B) overlay @file 0x022328
075A22  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
075A25  6A 0A                 PUSH   0xa ; PUSH_CONST
075A27  8D 86 22 FF           LEA    ax, [bp - 0xde] ; ADDR
075A2B  50                    PUSH   ax ; STACK_PUSH
075A2C  9A DA 0C 1F 1A        LCALL  0x1a1f, 0xcda ; THUNK -> 0x0000:0x0008 (thunk @file 0x01D2CA type A) overlay @file 0x025908
075A31  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
075A34  8D 86 22 FF           LEA    ax, [bp - 0xde] ; ADDR
075A38  50                    PUSH   ax ; STACK_PUSH
075A39  0E                    PUSH   cs ; STACK_PUSH
075A3A  E8 3D 09              CALL   0x7637a ; CALL_NEAR
075A3D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
075A40  0B C0                 OR     ax, ax ; LOGIC
075A42  75 0E                 JNE    0x75a52 ; CJUMP
075A44  39 06 AC 83           CMP    word ptr [0x83ac], ax ; CMP
075A48  74 4D                 JE     0x75a97 ; CJUMP
075A4A  9A E8 04 1F 18        LCALL  0x181f, 0x4e8 ; THUNK -> 0x0A58:0x000D (thunk @file 0x01AAD8 type B)
075A4F  EB 46                 JMP    0x75a97 ; JUMP
075A51  90                    NOP ; NOP
075A52  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
075A57  74 73                 JE     0x75acc ; CJUMP
075A59  6A 05                 PUSH   5 ; STACK_PUSH
075A5B  8D 86 22 FF           LEA    ax, [bp - 0xde] ; ADDR
075A5F  50                    PUSH   ax ; STACK_PUSH
075A60  9A DA 0C 1F 1A        LCALL  0x1a1f, 0xcda ; THUNK -> 0x0000:0x0008 (thunk @file 0x01D2CA type A) overlay @file 0x025908
075A65  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
075A68  6A 00                 PUSH   0 ; STACK_PUSH
075A6A  8D 86 72 FF           LEA    ax, [bp - 0x8e] ; ADDR
075A6E  50                    PUSH   ax ; STACK_PUSH
075A6F  8D 86 22 FF           LEA    ax, [bp - 0xde] ; ADDR
075A73  50                    PUSH   ax ; STACK_PUSH
075A74  0E                    PUSH   cs ; STACK_PUSH
075A75  E8 FD 08              CALL   0x76375 ; CALL_NEAR
075A78  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
075A7B  0B C0                 OR     ax, ax ; LOGIC
075A7D  75 21                 JNE    0x75aa0 ; CJUMP
075A7F  81 BE 7C FF A4 06     CMP    word ptr [bp - 0x84], 0x6a4 ; CMP
075A85  7D 19                 JGE    0x75aa0 ; CJUMP
075A87  8D 86 22 FF           LEA    ax, [bp - 0xde] ; ADDR
075A8B  50                    PUSH   ax ; STACK_PUSH
075A8C  0E                    PUSH   cs ; STACK_PUSH
075A8D  E8 EA 08              CALL   0x7637a ; CALL_NEAR
075A90  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
075A93  0B C0                 OR     ax, ax ; LOGIC
075A95  75 09                 JNE    0x75aa0 ; CJUMP
075A97  C6 06 29 08 01        MOV    byte ptr [0x829], 1 ; GLOBAL_LOAD
075A9C  E9 E8 04              JMP    0x75f87 ; JUMP
075A9F  90                    NOP ; NOP
075AA0  6A 00                 PUSH   0 ; STACK_PUSH
075AA2  0E                    PUSH   cs ; STACK_PUSH
075AA3  E8 1A 09              CALL   0x763c0 ; CALL_NEAR
075AA6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
075AA9  0B C0                 OR     ax, ax ; LOGIC
075AAB  74 03                 JE     0x75ab0 ; CJUMP
075AAD  E9 DD 04              JMP    0x75f8d ; JUMP
075AB0  89 86 0C FF           MOV    word ptr [bp - 0xf4], ax ; LOCAL_STORE
075AB4  6B 9E 0C FF 34        IMUL   bx, word ptr [bp - 0xf4], 0x34 ; ARITH
075AB9  C6 87 3F 54 01        MOV    byte ptr [bx + 0x543f], 1 ; MOV
075ABE  FF 86 0C FF           INC    word ptr [bp - 0xf4] ; ARITH
075AC2  83 BE 0C FF 04        CMP    word ptr [bp - 0xf4], 4 ; CMP
075AC7  7C EB                 JL     0x75ab4 ; CJUMP
075AC9  E9 BB 04              JMP    0x75f87 ; JUMP
075ACC  8D 86 0C FC           LEA    ax, [bp - 0x3f4] ; ADDR
075AD0  16                    PUSH   ss ; STACK_PUSH
075AD1  50                    PUSH   ax ; STACK_PUSH
075AD2  6A 00                 PUSH   0 ; STACK_PUSH
075AD4  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075AD8  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075ADC  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075AE0  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075AE4  68 3C 23              PUSH   0x233c                       ; STRING: "OPENMENU"
075AE7  9A 4E 04 1F 18        LCALL  0x181f, 0x44e ; THUNK -> 0x0000:0x000E (thunk @file 0x01AA3E type A) overlay @file 0x02590E
075AEC  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
075AEF  0B C0                 OR     ax, ax ; LOGIC
075AF1  74 3B                 JE     0x75b2e ; CJUMP
075AF3  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075AF7  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075AFB  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075AFF  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075B03  2A C0                 SUB    al, al ; ARITH
075B05  9A 84 04 1F 18        LCALL  0x181f, 0x484 ; THUNK -> 0x0B8D:0x0004 (thunk @file 0x01AA74 type B)
075B0A  0E                    PUSH   cs ; STACK_PUSH
075B0B  E8 99 08              CALL   0x763a7 ; CALL_NEAR
075B0E  68 00 03              PUSH   0x300 ; PUSH_CONST
075B11  68 00 A0              PUSH   0xa000 ; PUSH_CONST
075B14  68 00 FC              PUSH   0xfc00 ; PUSH_CONST
075B17  8D 86 0C FC           LEA    ax, [bp - 0x3f4] ; ADDR
075B1B  16                    PUSH   ss ; STACK_PUSH
075B1C  50                    PUSH   ax ; STACK_PUSH
075B1D  9A B2 0F 1D 0D        LCALL  0xd1d, 0xfb2 ; LCALL
075B22  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
075B25  C7 86 0E FF 01 00     MOV    word ptr [bp - 0xf2], 1 ; LOCAL_STORE
075B2B  E9 FA 00              JMP    0x75c28 ; JUMP
075B2E  80 3E 2A 08 00        CMP    byte ptr [0x82a], 0 ; CMP
075B33  74 31                 JE     0x75b66 ; CJUMP
075B35  FF B6 16 FF           PUSH   word ptr [bp - 0xea] ; PUSH_GLOBAL
075B39  FF B6 14 FF           PUSH   word ptr [bp - 0xec] ; PUSH_GLOBAL
075B3D  FF B6 12 FF           PUSH   word ptr [bp - 0xee] ; PUSH_GLOBAL
075B41  FF B6 10 FF           PUSH   word ptr [bp - 0xf0] ; PUSH_GLOBAL
075B45  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075B49  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075B4D  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075B51  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075B55  68 B0 00              PUSH   0xb0 ; PUSH_CONST
075B58  2B C0                 SUB    ax, ax ; ARITH
075B5A  99                    CDQ ; ARITH
075B5B  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
075B5E  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
075B63  EB 0C                 JMP    0x75b71 ; JUMP
075B65  90                    NOP ; NOP
075B66  8D 86 0C FC           LEA    ax, [bp - 0x3f4] ; ADDR
075B6A  16                    PUSH   ss ; STACK_PUSH
075B6B  50                    PUSH   ax ; STACK_PUSH
075B6C  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
075B71  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075B75  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075B79  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075B7D  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075B81  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075B84  6A 07                 PUSH   7 ; STACK_PUSH
075B86  6A 06                 PUSH   6 ; STACK_PUSH
075B88  2B C0                 SUB    ax, ax ; ARITH
075B8A  99                    CDQ ; ARITH
075B8B  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
075B8E  9A F8 0D 1F 1A        LCALL  0x1a1f, 0xdf8 ; THUNK -> 0x0BD4:0x0006 (thunk @file 0x01D3E8 type B)
075B93  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075B97  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075B9B  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075B9F  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075BA3  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075BA6  6A 08                 PUSH   8 ; STACK_PUSH
075BA8  6A 09                 PUSH   9 ; STACK_PUSH
075BAA  2B C0                 SUB    ax, ax ; ARITH
075BAC  99                    CDQ ; ARITH
075BAD  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
075BB0  9A F8 0D 1F 1A        LCALL  0x1a1f, 0xdf8 ; THUNK -> 0x0BD4:0x0006 (thunk @file 0x01D3E8 type B)
075BB5  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075BB9  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075BBD  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075BC1  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075BC5  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075BC8  6A 0F                 PUSH   0xf ; PUSH_CONST
075BCA  6A 0E                 PUSH   0xe ; PUSH_CONST
075BCC  2B C0                 SUB    ax, ax ; ARITH
075BCE  99                    CDQ ; ARITH
075BCF  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
075BD2  9A F8 0D 1F 1A        LCALL  0x1a1f, 0xdf8 ; THUNK -> 0x0BD4:0x0006 (thunk @file 0x01D3E8 type B)
075BD7  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075BDB  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075BDF  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075BE3  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075BE7  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
075BEB  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
075BEF  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
075BF3  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
075BF7  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075BFA  2B C0                 SUB    ax, ax ; ARITH
075BFC  99                    CDQ ; ARITH
075BFD  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
075C00  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
075C05  6A 00                 PUSH   0 ; STACK_PUSH
075C07  68 40 01              PUSH   0x140 ; PUSH_CONST
075C0A  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075C0D  2B C0                 SUB    ax, ax ; ARITH
075C0F  99                    CDQ ; ARITH
075C10  2B DB                 SUB    bx, bx ; ARITH
075C12  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
075C17  8D 86 0C FC           LEA    ax, [bp - 0x3f4] ; ADDR
075C1B  16                    PUSH   ss ; STACK_PUSH
075C1C  50                    PUSH   ax ; STACK_PUSH
075C1D  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
075C22  C7 86 0E FF 00 00     MOV    word ptr [bp - 0xf2], 0 ; LOCAL_STORE
075C28  6A 33                 PUSH   0x33 ; PUSH_CONST
075C2A  9A DE 04 1F 18        LCALL  0x181f, 0x4de ; THUNK -> 0x1059:0x000A (thunk @file 0x01AACE type B)
075C2F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
075C32  9A 3C 0F 1F 18        LCALL  0x181f, 0xf3c ; THUNK -> 0x0000:0x0000 (thunk @file 0x01B52C type A) overlay @file 0x025900
075C37  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
075C3C  75 0C                 JNE    0x75c4a ; CJUMP
075C3E  83 3E AC 83 00        CMP    word ptr [0x83ac], 0 ; CMP
075C43  74 05                 JE     0x75c4a ; CJUMP
075C45  9A E8 04 1F 18        LCALL  0x181f, 0x4e8 ; THUNK -> 0x0A58:0x000D (thunk @file 0x01AAD8 type B)
075C4A  83 BE 0E FF 00        CMP    word ptr [bp - 0xf2], 0 ; CMP
075C4F  75 04                 JNE    0x75c55 ; CJUMP
075C51  0E                    PUSH   cs ; STACK_PUSH
075C52  E8 48 07              CALL   0x7639d ; CALL_NEAR
075C55  9A 3C 0F 1F 18        LCALL  0x181f, 0xf3c ; THUNK -> 0x0000:0x0000 (thunk @file 0x01B52C type A) overlay @file 0x025900
075C5A  C7 86 1C FF 00 00     MOV    word ptr [bp - 0xe4], 0 ; LOCAL_STORE
075C60  8D 1E 45 23           LEA    bx, [0x2345] ; ADDR
075C64  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
075C69  89 86 20 FF           MOV    word ptr [bp - 0xe0], ax ; LOCAL_STORE
075C6D  48                    DEC    ax ; ARITH
075C6E  7D 03                 JGE    0x75c73 ; CJUMP
075C70  E9 1A 03              JMP    0x75f8d ; JUMP
075C73  48                    DEC    ax ; ARITH
075C74  48                    DEC    ax ; ARITH
075C75  7E 0F                 JLE    0x75c86 ; CJUMP
075C77  48                    DEC    ax ; ARITH
075C78  75 03                 JNE    0x75c7d ; CJUMP
075C7A  E9 6D 01              JMP    0x75dea ; JUMP
075C7D  48                    DEC    ax ; ARITH
075C7E  75 03                 JNE    0x75c83 ; CJUMP
075C80  E9 2D 02              JMP    0x75eb0 ; JUMP
075C83  E9 07 03              JMP    0x75f8d ; JUMP
075C86  C7 86 0C FF 00 00     MOV    word ptr [bp - 0xf4], 0 ; LOCAL_STORE
075C8C  EB 1A                 JMP    0x75ca8 ; JUMP
075C8E  6A 03                 PUSH   3 ; STACK_PUSH
075C90  6A 00                 PUSH   0 ; STACK_PUSH
075C92  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
075C97  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
075C9A  8B 9E 0C FF           MOV    bx, word ptr [bp - 0xf4] ; LOCAL_LOAD
075C9E  D1 E3                 SHL    bx, 1 ; LOGIC
075CA0  89 87 7E 1E           MOV    word ptr [bx + 0x1e7e], ax ; MOV
075CA4  FF 86 0C FF           INC    word ptr [bp - 0xf4] ; ARITH
075CA8  83 BE 0C FF 05        CMP    word ptr [bp - 0xf4], 5 ; CMP
075CAD  7D 15                 JGE    0x75cc4 ; CJUMP
075CAF  83 BE 20 FF 03        CMP    word ptr [bp - 0xe0], 3 ; CMP
075CB4  75 D8                 JNE    0x75c8e ; CJUMP
075CB6  8B 9E 0C FF           MOV    bx, word ptr [bp - 0xf4] ; LOCAL_LOAD
075CBA  D1 E3                 SHL    bx, 1 ; LOGIC
075CBC  C7 87 7E 1E 01 00     MOV    word ptr [bx + 0x1e7e], 1 ; MOV
075CC2  EB E0                 JMP    0x75ca4 ; JUMP
075CC4  83 BE 20 FF 03        CMP    word ptr [bp - 0xe0], 3 ; CMP
075CC9  75 0F                 JNE    0x75cda ; CJUMP
075CCB  9A E4 0B 1F 1A        LCALL  0x1a1f, 0xbe4 ; THUNK -> 0x0000:0x0270 (thunk @file 0x01D1D4 type A) overlay @file 0x025B70
075CD0  0B C0                 OR     ax, ax ; LOGIC
075CD2  74 06                 JE     0x75cda ; CJUMP
075CD4  C7 86 1C FF 01 00     MOV    word ptr [bp - 0xe4], 1 ; LOCAL_STORE
075CDA  0E                    PUSH   cs ; STACK_PUSH
075CDB  E8 C9 06              CALL   0x763a7 ; CALL_NEAR
075CDE  83 BE 20 FF 02        CMP    word ptr [bp - 0xe0], 2 ; CMP
075CE3  75 67                 JNE    0x75d4c ; CJUMP
075CE5  8D 1E 4F 23           LEA    bx, [0x234f] ; ADDR
075CE9  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
075CEE  89 86 1A FF           MOV    word ptr [bp - 0xe6], ax ; LOCAL_STORE
075CF2  3D 01 00              CMP    ax, 1 ; CMP
075CF5  7D 09                 JGE    0x75d00 ; CJUMP
075CF7  C7 86 1C FF 01 00     MOV    word ptr [bp - 0xe4], 1 ; LOCAL_STORE
075CFD  EB 4D                 JMP    0x75d4c ; JUMP
075CFF  90                    NOP ; NOP
075D00  3D 01 00              CMP    ax, 1 ; CMP
075D03  7E 47                 JLE    0x75d4c ; CJUMP
075D05  8D 86 22 FF           LEA    ax, [bp - 0xde] ; ADDR
075D09  50                    PUSH   ax ; STACK_PUSH
075D0A  68 57 23              PUSH   0x2357                       ; STRING: "*.MP"
075D0D  68 5C 23              PUSH   0x235c                       ; STRING: "MAPTOLOAD"
075D10  68 66 23              PUSH   0x2366                       ; STRING: "GAME"
075D13  0E                    PUSH   cs ; STACK_PUSH
075D14  E8 9F 06              CALL   0x763b6 ; CALL_NEAR
075D17  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
075D1A  89 86 1A FF           MOV    word ptr [bp - 0xe6], ax ; LOCAL_STORE
075D1E  0B C0                 OR     ax, ax ; LOGIC
075D20  7C D5                 JL     0x75cf7 ; CJUMP
075D22  68 66 21              PUSH   0x2166                       ; STRING: "AMER2.MP"
075D25  8D 86 22 FF           LEA    ax, [bp - 0xde] ; ADDR
075D29  50                    PUSH   ax ; STACK_PUSH
075D2A  9A 16 08 1D 0D        LCALL  0xd1d, 0x816 ; LCALL
075D2F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
075D32  0B C0                 OR     ax, ax ; LOGIC
075D34  74 16                 JE     0x75d4c ; CJUMP
075D36  C7 06 74 21 01 00     MOV    word ptr [0x2174], 1 ; GLOBAL_LOAD
075D3C  8D 86 22 FF           LEA    ax, [bp - 0xde] ; ADDR
075D40  50                    PUSH   ax ; STACK_PUSH
075D41  68 66 21              PUSH   0x2166                       ; STRING: "AMER2.MP"
075D44  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
075D49  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
075D4C  83 BE 1C FF 00        CMP    word ptr [bp - 0xe4], 0 ; CMP
075D51  75 2E                 JNE    0x75d81 ; CJUMP
075D53  83 BE 20 FF 02        CMP    word ptr [bp - 0xe0], 2 ; CMP
075D58  75 06                 JNE    0x75d60 ; CJUMP
075D5A  B8 01 00              MOV    ax, 1 ; MOV
075D5D  EB 03                 JMP    0x75d62 ; JUMP
075D5F  90                    NOP ; NOP
075D60  2B C0                 SUB    ax, ax ; ARITH
075D62  50                    PUSH   ax ; STACK_PUSH
075D63  0E                    PUSH   cs ; STACK_PUSH
075D64  E8 59 06              CALL   0x763c0 ; CALL_NEAR
075D67  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
075D6A  89 86 1A FF           MOV    word ptr [bp - 0xe6], ax ; LOCAL_STORE
075D6E  48                    DEC    ax ; ARITH
075D6F  75 06                 JNE    0x75d77 ; CJUMP
075D71  C7 86 1C FF 01 00     MOV    word ptr [bp - 0xe4], 1 ; LOCAL_STORE
075D77  83 BE 1A FF 01        CMP    word ptr [bp - 0xe6], 1 ; CMP
075D7C  7E 03                 JLE    0x75d81 ; CJUMP
075D7E  E9 0C 02              JMP    0x75f8d ; JUMP
075D81  83 BE 1C FF 00        CMP    word ptr [bp - 0xe4], 0 ; CMP
075D86  75 03                 JNE    0x75d8b ; CJUMP
075D88  E9 F2 01              JMP    0x75f7d ; JUMP
075D8B  8D 86 0C FC           LEA    ax, [bp - 0x3f4] ; ADDR
075D8F  16                    PUSH   ss ; STACK_PUSH
075D90  50                    PUSH   ax ; STACK_PUSH
075D91  6A 00                 PUSH   0 ; STACK_PUSH
075D93  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075D97  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075D9B  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075D9F  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075DA3  68 74 23              PUSH   0x2374                       ; STRING: "OPENMENU"
075DA6  9A 4E 04 1F 18        LCALL  0x181f, 0x44e ; THUNK -> 0x0000:0x000E (thunk @file 0x01AA3E type A) overlay @file 0x02590E
075DAB  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
075DAE  0B C0                 OR     ax, ax ; LOGIC
075DB0  75 03                 JNE    0x75db5 ; CJUMP
075DB2  E9 13 01              JMP    0x75ec8 ; JUMP
075DB5  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075DB9  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075DBD  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075DC1  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075DC5  2A C0                 SUB    al, al ; ARITH
075DC7  9A 84 04 1F 18        LCALL  0x181f, 0x484 ; THUNK -> 0x0B8D:0x0004 (thunk @file 0x01AA74 type B)
075DCC  0E                    PUSH   cs ; STACK_PUSH
075DCD  E8 D7 05              CALL   0x763a7 ; CALL_NEAR
075DD0  68 00 03              PUSH   0x300 ; PUSH_CONST
075DD3  68 00 A0              PUSH   0xa000 ; PUSH_CONST
075DD6  68 00 FC              PUSH   0xfc00 ; PUSH_CONST
075DD9  8D 86 0C FC           LEA    ax, [bp - 0x3f4] ; ADDR
075DDD  16                    PUSH   ss ; STACK_PUSH
075DDE  50                    PUSH   ax ; STACK_PUSH
075DDF  9A B2 0F 1D 0D        LCALL  0xd1d, 0xfb2 ; LCALL
075DE4  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
075DE7  E9 93 01              JMP    0x75f7d ; JUMP
075DEA  0E                    PUSH   cs ; STACK_PUSH
075DEB  E8 B9 05              CALL   0x763a7 ; CALL_NEAR
075DEE  6A 00                 PUSH   0 ; STACK_PUSH
075DF0  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075DF4  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075DF8  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075DFC  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075E00  68 6B 23              PUSH   0x236b                       ; STRING: "WOODPANL"
075E03  9A 7A 08 1F 19        LCALL  0x191f, 0x87a ; THUNK -> 0x0000:0x000C (thunk @file 0x01BE6A type A) overlay @file 0x02590C
075E08  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
075E0B  3D 01 00              CMP    ax, 1 ; CMP
075E0E  1B C0                 SBB    ax, ax ; ARITH
075E10  F7 D8                 NEG    ax ; ARITH
075E12  89 86 18 FF           MOV    word ptr [bp - 0xe8], ax ; LOCAL_STORE
075E16  0B C0                 OR     ax, ax ; LOGIC
075E18  74 45                 JE     0x75e5f ; CJUMP
075E1A  9A 0A 04 1F 18        LCALL  0x181f, 0x40a ; THUNK -> 0x0000:0x37F6 (thunk @file 0x01A9FA type A) overlay @file 0x0290F6
075E1F  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075E23  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075E27  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075E2B  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075E2F  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
075E33  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
075E37  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
075E3B  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
075E3F  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075E42  2B C0                 SUB    ax, ax ; ARITH
075E44  99                    CDQ ; ARITH
075E45  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
075E48  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
075E4D  6A 00                 PUSH   0 ; STACK_PUSH
075E4F  68 40 01              PUSH   0x140 ; PUSH_CONST
075E52  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075E55  2B C0                 SUB    ax, ax ; ARITH
075E57  99                    CDQ ; ARITH
075E58  2B DB                 SUB    bx, bx ; ARITH
075E5A  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
075E5F  9A 20 03 1F 19        LCALL  0x191f, 0x320 ; THUNK -> 0x0000:0x04E8 (thunk @file 0x01B910 type A) overlay @file 0x025DE8
075E64  89 86 1A FF           MOV    word ptr [bp - 0xe6], ax ; LOCAL_STORE
075E68  0B C0                 OR     ax, ax ; LOGIC
075E6A  75 2A                 JNE    0x75e96 ; CJUMP
075E6C  C6 06 29 08 01        MOV    byte ptr [0x829], 1 ; GLOBAL_LOAD
075E71  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
075E76  74 0A                 JE     0x75e82 ; CJUMP
075E78  6A 03                 PUSH   3 ; STACK_PUSH
075E7A  9A AC 04 1F 18        LCALL  0x181f, 0x4ac ; THUNK -> 0x029F:0x0318 (thunk @file 0x01AA9C type B) overlay @file 0x022340
075E7F  EB 12                 JMP    0x75e93 ; JUMP
075E81  90                    NOP ; NOP
075E82  6A 01                 PUSH   1 ; STACK_PUSH
075E84  9A AC 04 1F 18        LCALL  0x181f, 0x4ac ; THUNK -> 0x029F:0x0318 (thunk @file 0x01AA9C type B) overlay @file 0x022340
075E89  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
075E8C  6A 02                 PUSH   2 ; STACK_PUSH
075E8E  9A A2 04 1F 18        LCALL  0x181f, 0x4a2 ; THUNK -> 0x029F:0x030C (thunk @file 0x01AA92 type B) overlay @file 0x022334
075E93  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
075E96  83 BE 1A FF 01        CMP    word ptr [bp - 0xe6], 1 ; CMP
075E9B  75 06                 JNE    0x75ea3 ; CJUMP
075E9D  C7 86 1C FF 01 00     MOV    word ptr [bp - 0xe4], 1 ; LOCAL_STORE
075EA3  83 BE 1A FF 01        CMP    word ptr [bp - 0xe6], 1 ; CMP
075EA8  7F 03                 JG     0x75ead ; CJUMP
075EAA  E9 D4 FE              JMP    0x75d81 ; JUMP
075EAD  E9 DD 00              JMP    0x75f8d ; JUMP
075EB0  C7 86 1C FF 01 00     MOV    word ptr [bp - 0xe4], 1 ; LOCAL_STORE
075EB6  0E                    PUSH   cs ; STACK_PUSH
075EB7  E8 ED 04              CALL   0x763a7 ; CALL_NEAR
075EBA  6A 00                 PUSH   0 ; STACK_PUSH
075EBC  9A 8E 0F 1F 19        LCALL  0x191f, 0xf8e ; THUNK -> 0x0000:0x0F56 (thunk @file 0x01C57E type A) overlay @file 0x026856
075EC1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
075EC4  E9 BA FE              JMP    0x75d81 ; JUMP
075EC7  90                    NOP ; NOP
075EC8  0E                    PUSH   cs ; STACK_PUSH
075EC9  E8 E0 04              CALL   0x763ac ; CALL_NEAR
075ECC  8D 86 0C FC           LEA    ax, [bp - 0x3f4] ; ADDR
075ED0  16                    PUSH   ss ; STACK_PUSH
075ED1  50                    PUSH   ax ; STACK_PUSH
075ED2  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
075ED7  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075EDB  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075EDF  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075EE3  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075EE7  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075EEA  6A 07                 PUSH   7 ; STACK_PUSH
075EEC  6A 06                 PUSH   6 ; STACK_PUSH
075EEE  2B C0                 SUB    ax, ax ; ARITH
075EF0  99                    CDQ ; ARITH
075EF1  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
075EF4  9A F8 0D 1F 1A        LCALL  0x1a1f, 0xdf8 ; THUNK -> 0x0BD4:0x0006 (thunk @file 0x01D3E8 type B)
075EF9  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075EFD  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075F01  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075F05  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075F09  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075F0C  6A 08                 PUSH   8 ; STACK_PUSH
075F0E  6A 09                 PUSH   9 ; STACK_PUSH
075F10  2B C0                 SUB    ax, ax ; ARITH
075F12  99                    CDQ ; ARITH
075F13  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
075F16  9A F8 0D 1F 1A        LCALL  0x1a1f, 0xdf8 ; THUNK -> 0x0BD4:0x0006 (thunk @file 0x01D3E8 type B)
075F1B  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075F1F  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075F23  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075F27  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075F2B  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075F2E  6A 0F                 PUSH   0xf ; PUSH_CONST
075F30  6A 0E                 PUSH   0xe ; PUSH_CONST
075F32  2B C0                 SUB    ax, ax ; ARITH
075F34  99                    CDQ ; ARITH
075F35  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
075F38  9A F8 0D 1F 1A        LCALL  0x1a1f, 0xdf8 ; THUNK -> 0x0BD4:0x0006 (thunk @file 0x01D3E8 type B)
075F3D  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
075F41  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
075F45  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
075F49  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
075F4D  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
075F51  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
075F55  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
075F59  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
075F5D  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075F60  2B C0                 SUB    ax, ax ; ARITH
075F62  99                    CDQ ; ARITH
075F63  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
075F66  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
075F6B  6A 00                 PUSH   0 ; STACK_PUSH
075F6D  68 40 01              PUSH   0x140 ; PUSH_CONST
075F70  68 C8 00              PUSH   0xc8 ; PUSH_CONST
075F73  2B C0                 SUB    ax, ax ; ARITH
075F75  99                    CDQ ; ARITH
075F76  2B DB                 SUB    bx, bx ; ARITH
075F78  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
075F7D  83 BE 1C FF 00        CMP    word ptr [bp - 0xe4], 0 ; CMP
075F82  74 03                 JE     0x75f87 ; CJUMP
075F84  E9                    DB     0xE9 ; DATA_BYTE
075F85  C3                    DB     0xC3 ; DATA_BYTE
