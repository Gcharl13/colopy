; ============================================================================
; func_048CF8_unknown
; Region   : overlay
; Bytes    : file 0x048CF8..0x048F34  (572 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "HERESY0", "HERESY1"  (auto-named via string xrefs)
; ============================================================================

048CF8  C8 25 0F 00           ENTER  0xf25, 0 ; PROLOGUE
048CFC  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
048CFF  8A C1                 MOV    al, cl ; MOV
048D01  25 10 00              AND    ax, 0x10 ; LOGIC
048D04  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
048D07  8A 4F 04              MOV    cl, byte ptr [bx + 4] ; MOV
048D0A  2A ED                 SUB    ch, ch ; ARITH
048D0C  01 4E F6              ADD    word ptr [bp - 0xa], cx ; ARITH
048D0F  0B C0                 OR     ax, ax ; LOGIC
048D11  74 03                 JE     0x48d16 ; CJUMP
048D13  D1 66 F6              SHL    word ptr [bp - 0xa], 1 ; LOGIC
048D16  F6 47 03 04           TEST   byte ptr [bx + 3], 4 ; LOGIC
048D1A  74 03                 JE     0x48d1f ; CJUMP
048D1C  D1 66 F6              SHL    word ptr [bp - 0xa], 1 ; LOGIC
048D1F  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
048D22  39 46 F2              CMP    word ptr [bp - 0xe], ax ; CMP
048D25  75 09                 JNE    0x48d30 ; CJUMP
048D27  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
048D2A  01 46 EC              ADD    word ptr [bp - 0x14], ax ; ARITH
048D2D  EB 18                 JMP    0x48d47 ; JUMP
048D2F  90                    NOP ; NOP
048D30  39 46 EE              CMP    word ptr [bp - 0x12], ax ; CMP
048D33  75 09                 JNE    0x48d3e ; CJUMP
048D35  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
048D38  01 46 E8              ADD    word ptr [bp - 0x18], ax ; ARITH
048D3B  EB 0A                 JMP    0x48d47 ; JUMP
048D3D  90                    NOP ; NOP
048D3E  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
048D41  01 46 F0              ADD    word ptr [bp - 0x10], ax ; ARITH
048D44  01 46 F4              ADD    word ptr [bp - 0xc], ax ; ARITH
048D47  FF 46 EA              INC    word ptr [bp - 0x16] ; ARITH
048D4A  A1 9A 53              MOV    ax, word ptr [0x539a] ; GLOBAL_LOAD
048D4D  39 46 EA              CMP    word ptr [bp - 0x16], ax ; CMP
048D50  7D 40                 JGE    0x48d92 ; CJUMP
048D52  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
048D55  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
048D5A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
048D5D  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
048D60  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
048D64  38 47 02              CMP    byte ptr [bx + 2], al ; CMP
048D67  75 DE                 JNE    0x48d47 ; CJUMP
048D69  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
048D6E  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
048D71  50                    PUSH   ax ; STACK_PUSH
048D72  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
048D75  9A 16 03 1F 18        LCALL  0x181f, 0x316 ; THUNK -> 0x0000:0x03F8 (thunk @file 0x01A906 type A) overlay @file 0x025CF8
048D7A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048D7D  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
048D80  3B 46 F2              CMP    ax, word ptr [bp - 0xe] ; CMP
048D83  74 03                 JE     0x48d88 ; CJUMP
048D85  E9 4E FF              JMP    0x48cd6 ; JUMP
048D88  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
048D8B  01 46 E8              ADD    word ptr [bp - 0x18], ax ; ARITH
048D8E  E9 59 FF              JMP    0x48cea ; JUMP
048D91  90                    NOP ; NOP
048D92  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
048D95  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
048D9A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
048D9D  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
048DA1  80 BF 5B 31 03        CMP    byte ptr [bx + 0x315b], 3 ; CMP
048DA6  75 06                 JNE    0x48dae ; CJUMP
048DA8  B8 01 00              MOV    ax, 1 ; MOV
048DAB  EB 03                 JMP    0x48db0 ; JUMP
048DAD  90                    NOP ; NOP
048DAE  2B C0                 SUB    ax, ax ; ARITH
048DB0  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
048DB3  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
048DB7  8A 47 05              MOV    al, byte ptr [bx + 5] ; MOV
048DBA  25 10 00              AND    ax, 0x10 ; LOGIC
048DBD  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
048DC0  8A 47 03              MOV    al, byte ptr [bx + 3] ; MOV
048DC3  25 04 00              AND    ax, 4 ; LOGIC
048DC6  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
048DC9  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
048DCC  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
048DD0  8B F0                 MOV    si, ax ; MOV
048DD2  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
048DD7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048DDA  8B CE                 MOV    cx, si ; MOV
048DDC  D3 E0                 SHL    ax, cl ; LOGIC
048DDE  01 46 E8              ADD    word ptr [bp - 0x18], ax ; ARITH
048DE1  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
048DE4  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
048DE8  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
048DED  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048DF0  B1 01                 MOV    cl, 1 ; MOV
048DF2  2A 4E E4              SUB    cl, byte ptr [bp - 0x1c] ; ARITH
048DF5  D3 F8                 SAR    ax, cl ; LOGIC
048DF7  01 46 EC              ADD    word ptr [bp - 0x14], ax ; ARITH
048DFA  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
048DFD  50                    PUSH   ax ; STACK_PUSH
048DFE  9A 60 0A 1F 18        LCALL  0x181f, 0xa60 ; THUNK -> 0x05DC:0x00A2 (thunk @file 0x01B050 type B) overlay @file 0x021A84
048E03  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
048E06  40                    INC    ax ; ARITH
048E07  01 46 F0              ADD    word ptr [bp - 0x10], ax ; ARITH
048E0A  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
048E0D  9A 60 0A 1F 18        LCALL  0x181f, 0xa60 ; THUNK -> 0x05DC:0x00A2 (thunk @file 0x01B050 type B) overlay @file 0x021A84
048E12  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
048E15  40                    INC    ax ; ARITH
048E16  01 46 F4              ADD    word ptr [bp - 0xc], ax ; ARITH
048E19  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0 ; CMP
048E1D  74 27                 JE     0x48e46 ; CJUMP
048E1F  6A 14                 PUSH   0x14 ; PUSH_CONST
048E21  6A 01                 PUSH   1 ; STACK_PUSH
048E23  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
048E28  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048E2B  01 46 E8              ADD    word ptr [bp - 0x18], ax ; ARITH
048E2E  6A 14                 PUSH   0x14 ; PUSH_CONST
048E30  6A 01                 PUSH   1 ; STACK_PUSH
048E32  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
048E37  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048E3A  03 46 EC              ADD    ax, word ptr [bp - 0x14] ; ARITH
048E3D  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
048E40  D1 66 F4              SHL    word ptr [bp - 0xc], 1 ; LOGIC
048E43  D1 66 F0              SHL    word ptr [bp - 0x10], 1 ; LOGIC
048E46  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
048E4A  74 06                 JE     0x48e52 ; CJUMP
048E4C  D1 66 E8              SHL    word ptr [bp - 0x18], 1 ; LOGIC
048E4F  D1 66 F4              SHL    word ptr [bp - 0xc], 1 ; LOGIC
048E52  83 7E E0 00           CMP    word ptr [bp - 0x20], 0 ; CMP
048E56  74 06                 JE     0x48e5e ; CJUMP
048E58  D1 66 EC              SHL    word ptr [bp - 0x14], 1 ; LOGIC
048E5B  D1 66 F0              SHL    word ptr [bp - 0x10], 1 ; LOGIC
048E5E  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
048E61  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
048E66  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
048E69  50                    PUSH   ax ; STACK_PUSH
048E6A  6A 00                 PUSH   0 ; STACK_PUSH
048E6C  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
048E71  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048E74  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
048E77  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
048E7C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
048E7F  50                    PUSH   ax ; STACK_PUSH
048E80  6A 01                 PUSH   1 ; STACK_PUSH
048E82  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
048E87  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048E8A  FF 36 50 8D           PUSH   word ptr [0x8d50] ; PUSH_GLOBAL
048E8E  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
048E93  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
048E96  50                    PUSH   ax ; STACK_PUSH
048E97  6A 02                 PUSH   2 ; STACK_PUSH
048E99  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
048E9E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048EA1  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
048EA4  03 46 E8              ADD    ax, word ptr [bp - 0x18] ; ARITH
048EA7  50                    PUSH   ax ; STACK_PUSH
048EA8  6A 01                 PUSH   1 ; STACK_PUSH
048EAA  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
048EAF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048EB2  3B 46 E8              CMP    ax, word ptr [bp - 0x18] ; CMP
048EB5  7F 2F                 JG     0x48ee6 ; CJUMP
048EB7  B8 24 80              MOV    ax, 0x8024 ; CONST_LOAD
048EBA  9A C0 04 1F 18        LCALL  0x181f, 0x4c0 ; THUNK -> 0x02D8:0x000E (thunk @file 0x01AAB0 type B)
048EBF  6A 04                 PUSH   4 ; STACK_PUSH
048EC1  68 3B 15              PUSH   0x153b                       ; STRING: "HERESY0"
048EC4  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
048EC9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048ECC  8A 46 EE              MOV    al, byte ptr [bp - 0x12] ; LOCAL_LOAD
048ECF  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
048ED3  88 47 05              MOV    byte ptr [bx + 5], al ; MOV
048ED6  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
048EDA  74 05                 JE     0x48ee1 ; CJUMP
048EDC  0C 10                 OR     al, 0x10 ; LOGIC
048EDE  88 47 05              MOV    byte ptr [bx + 5], al ; MOV
048EE1  F7 5E F0              NEG    word ptr [bp - 0x10] ; ARITH
048EE4  EB 18                 JMP    0x48efe ; JUMP
048EE6  B8 53 00              MOV    ax, 0x53 ; CONST_LOAD
048EE9  9A C0 04 1F 18        LCALL  0x181f, 0x4c0 ; THUNK -> 0x02D8:0x000E (thunk @file 0x01AAB0 type B)
048EEE  6A 04                 PUSH   4 ; STACK_PUSH
048EF0  68 43 15              PUSH   0x1543                       ; STRING: "HERESY1"
048EF3  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
048EF8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048EFB  F7 5E F4              NEG    word ptr [bp - 0xc] ; ARITH
048EFE  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
048F01  9A 08 08 1F 18        LCALL  0x181f, 0x808 ; THUNK -> 0x0427:0x0824 (thunk @file 0x01ADF8 type B) overlay @file 0x031538
048F06  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
048F09  6A 00                 PUSH   0 ; STACK_PUSH
048F0B  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
048F0E  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
048F11  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
048F15  9A 6C 0D 1F 18        LCALL  0x181f, 0xd6c ; THUNK -> 0x0000:0x00F2 (thunk @file 0x01B35C type A) overlay @file 0x0259F2
048F1A  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
048F1D  6A 00                 PUSH   0 ; STACK_PUSH
048F1F  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
048F22  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
048F25  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
048F29  9A 6C 0D 1F 18        LCALL  0x181f, 0xd6c ; THUNK -> 0x0000:0x00F2 (thunk @file 0x01B35C type A) overlay @file 0x0259F2
048F2E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
048F31  5E                    POP    si ; STACK_POP
048F32  C9                    LEAVE ; EPILOGUE
048F33  CB                    RETF ; RETURN
