; ============================================================================
; func_007D3E_unknown
; Region   : load_image
; Bytes    : file 0x007D3E..0x007F34  (502 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007D3E  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
007D42  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
007D46  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
007D4A  2A E4                 SUB    ah, ah ; ARITH
007D4C  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
007D4F  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
007D53  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
007D56  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
007D5A  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
007D5E  25 0F 00              AND    ax, 0xf ; LOGIC
007D61  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
007D64  6A 00                 PUSH   0 ; STACK_PUSH
007D66  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
007D69  0E                    PUSH   cs ; STACK_PUSH
007D6A  E8 BD FE              CALL   0x7c2a ; CALL_NEAR
007D6D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007D70  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
007D73  2B C0                 SUB    ax, ax ; ARITH
007D75  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
007D78  A3 04 8D              MOV    word ptr [0x8d04], ax ; GLOBAL_LOAD
007D7B  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
007D7E  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
007D81  9A 92 03 7F 03        LCALL  0x37f, 0x392 ; LCALL
007D86  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007D89  0B C0                 OR     ax, ax ; LOGIC
007D8B  7C 55                 JL     0x7de2 ; CJUMP
007D8D  C7 46 E8 02 00        MOV    word ptr [bp - 0x18], 2 ; LOCAL_STORE
007D92  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
007D95  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
007D98  9A F0 09 1F 18        LCALL  0x181f, 0x9f0 ; THUNK -> 0x0000:0x0304 (thunk @file 0x01AFE0 type A) overlay @file 0x025C04
007D9D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007DA0  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
007DA3  A3 04 1B              MOV    word ptr [0x1b04], ax ; GLOBAL_LOAD
007DA6  6B D8 12              IMUL   bx, ax, 0x12 ; ARITH
007DA9  8A 87 EE 54           MOV    al, byte ptr [bx + 0x54ee] ; MOV
007DAD  2A E4                 SUB    ah, ah ; ARITH
007DAF  2D 04 00              SUB    ax, 4 ; ARITH
007DB2  6B D8 4E              IMUL   bx, ax, 0x4e ; ARITH
007DB5  80 BF D8 5A 02        CMP    byte ptr [bx + 0x5ad8], 2 ; CMP
007DBA  72 0A                 JB     0x7dc6 ; CJUMP
007DBC  C7 46 E8 04 00        MOV    word ptr [bp - 0x18], 4 ; LOCAL_STORE
007DC1  80 0E 02 8D 10        OR     byte ptr [0x8d02], 0x10 ; LOGIC
007DC6  6B 5E F0 12           IMUL   bx, word ptr [bp - 0x10], 0x12 ; ARITH
007DCA  F6 87 EF 54 04        TEST   byte ptr [bx + 0x54ef], 4 ; LOGIC
007DCF  74 08                 JE     0x7dd9 ; CJUMP
007DD1  D1 66 E8              SHL    word ptr [bp - 0x18], 1 ; LOGIC
007DD4  80 0E 02 8D 20        OR     byte ptr [0x8d02], 0x20 ; LOGIC
007DD9  80 0E 02 8D 08        OR     byte ptr [0x8d02], 8 ; LOGIC
007DDE  E9 1D 01              JMP    0x7efe ; JUMP
007DE1  90                    NOP ; NOP
007DE2  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
007DE5  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
007DE8  9A 58 03 7F 03        LCALL  0x37f, 0x358 ; LCALL
007DED  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007DF0  0B C0                 OR     ax, ax ; LOGIC
007DF2  7C 2C                 JL     0x7e20 ; CJUMP
007DF4  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
007DF7  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
007DFA  9A 76 0A EB 05        LCALL  0x5eb, 0xa76 ; LCALL
007DFF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007E02  A3 06 1B              MOV    word ptr [0x1b06], ax ; GLOBAL_LOAD
007E05  50                    PUSH   ax ; STACK_PUSH
007E06  9A 2C 00 EB 05        LCALL  0x5eb, 0x2c ; LCALL
007E0B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007E0E  0E                    PUSH   cs ; STACK_PUSH
007E0F  E8 D6 FD              CALL   0x7be8 ; CALL_NEAR
007E12  40                    INC    ax ; ARITH
007E13  D1 E0                 SHL    ax, 1 ; LOGIC
007E15  01 46 E8              ADD    word ptr [bp - 0x18], ax ; ARITH
007E18  80 0E 02 8D 40        OR     byte ptr [0x8d02], 0x40 ; LOGIC
007E1D  E9 DE 00              JMP    0x7efe ; JUMP
007E20  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
007E23  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
007E26  9A 3A 00 E4 03        LCALL  0x3e4, 0x3a ; LCALL
007E2B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007E2E  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
007E31  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
007E35  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
007E39  24 0F                 AND    al, 0xf ; LOGIC
007E3B  3C 04                 CMP    al, 4 ; CMP
007E3D  73 1E                 JAE    0x7e5d ; CJUMP
007E3F  83 7E FE 04           CMP    word ptr [bp - 2], 4 ; CMP
007E43  7D 2F                 JGE    0x7e74 ; CJUMP
007E45  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
007E4A  74 11                 JE     0x7e5d ; CJUMP
007E4C  83 7E FE 04           CMP    word ptr [bp - 2], 4 ; CMP
007E50  7D 0B                 JGE    0x7e5d ; CJUMP
007E52  6B 5E FE 34           IMUL   bx, word ptr [bp - 2], 0x34 ; ARITH
007E56  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
007E5B  74 17                 JE     0x7e74 ; CJUMP
007E5D  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
007E60  C1 E3 04              SHL    bx, 4 ; LOGIC
007E63  8A 87 77 2F           MOV    al, byte ptr [bx + 0x2f77] ; MOV
007E67  2A E4                 SUB    ah, ah ; ARITH
007E69  01 46 E8              ADD    word ptr [bp - 0x18], ax ; ARITH
007E6C  80 0E 02 8D 80        OR     byte ptr [0x8d02], 0x80 ; LOGIC
007E71  E9 8A 00              JMP    0x7efe ; JUMP
007E74  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
007E79  83 7E FE 04           CMP    word ptr [bp - 2], 4 ; CMP
007E7D  7D 55                 JGE    0x7ed4 ; CJUMP
007E7F  6B 5E FE 34           IMUL   bx, word ptr [bp - 2], 0x34 ; ARITH
007E83  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
007E88  75 4A                 JNE    0x7ed4 ; CJUMP
007E8A  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
007E8D  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
007E90  9A 58 03 7F 03        LCALL  0x37f, 0x358 ; LCALL
007E95  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007E98  0B C0                 OR     ax, ax ; LOGIC
007E9A  7D 1C                 JGE    0x7eb8 ; CJUMP
007E9C  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
007EA0  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
007EA4  2A E4                 SUB    ah, ah ; ARITH
007EA6  50                    PUSH   ax ; STACK_PUSH
007EA7  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
007EAB  50                    PUSH   ax ; STACK_PUSH
007EAC  9A 58 03 7F 03        LCALL  0x37f, 0x358 ; LCALL
007EB1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007EB4  0B C0                 OR     ax, ax ; LOGIC
007EB6  7C 2C                 JL     0x7ee4 ; CJUMP
007EB8  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
007EBD  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
007EC0  C1 E3 04              SHL    bx, 4 ; LOGIC
007EC3  8A 87 77 2F           MOV    al, byte ptr [bx + 0x2f77] ; MOV
007EC7  2A E4                 SUB    ah, ah ; ARITH
007EC9  01 46 E8              ADD    word ptr [bp - 0x18], ax ; ARITH
007ECC  80 0E 02 8D 80        OR     byte ptr [0x8d02], 0x80 ; LOGIC
007ED1  EB 11                 JMP    0x7ee4 ; JUMP
007ED3  90                    NOP ; NOP
007ED4  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
007ED8  80 BF 4C 31 06        CMP    byte ptr [bx + 0x314c], 6 ; CMP
007EDD  75 05                 JNE    0x7ee4 ; CJUMP
007EDF  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
007EE4  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
007EE8  74 14                 JE     0x7efe ; CJUMP
007EEA  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
007EED  C1 E3 04              SHL    bx, 4 ; LOGIC
007EF0  8A 87 77 2F           MOV    al, byte ptr [bx + 0x2f77] ; MOV
007EF4  2A E4                 SUB    ah, ah ; ARITH
007EF6  A3 04 8D              MOV    word ptr [0x8d04], ax ; GLOBAL_LOAD
007EF9  80 0E 00 8D 80        OR     byte ptr [0x8d00], 0x80 ; LOGIC
007EFE  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
007F02  80 BF 4C 31 06        CMP    byte ptr [bx + 0x314c], 6 ; CMP
007F07  75 1D                 JNE    0x7f26 ; CJUMP
007F09  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
007F0E  72 07                 JB     0x7f17 ; CJUMP
007F10  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
007F15  76 0F                 JBE    0x7f26 ; CJUMP
007F17  83 7E E8 05           CMP    word ptr [bp - 0x18], 5 ; CMP
007F1B  7D 09                 JGE    0x7f26 ; CJUMP
007F1D  83 46 E8 02           ADD    word ptr [bp - 0x18], 2 ; ARITH
007F21  80 0E 03 8D 20        OR     byte ptr [0x8d03], 0x20 ; LOGIC
007F26  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
007F29  05 04 00              ADD    ax, 4 ; ARITH
007F2C  F7 6E F6              IMUL   word ptr [bp - 0xa] ; ARITH
007F2F  C1 F8 02              SAR    ax, 2 ; LOGIC
007F32  C9                    LEAVE ; EPILOGUE
007F33  CB                    RETF ; RETURN
