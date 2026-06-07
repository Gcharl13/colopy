; ============================================================================
; func_040E22_unknown
; Region   : overlay
; Bytes    : file 0x040E22..0x040FD6  (436 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040E22  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
040E26  56                    PUSH   si ; STACK_PUSH
040E27  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040E2B  80 BF 4C 31 0C        CMP    byte ptr [bx + 0x314c], 0xc ; CMP
040E30  75 08                 JNE    0x40e3a ; CJUMP
040E32  C7 06 D6 1D FF FF     MOV    word ptr [0x1dd6], 0xffff ; GLOBAL_LOAD
040E38  EB 0E                 JMP    0x40e48 ; JUMP
040E3A  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040E3E  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
040E42  25 0F 00              AND    ax, 0xf ; LOGIC
040E45  A3 D6 1D              MOV    word ptr [0x1dd6], ax ; GLOBAL_LOAD
040E48  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
040E4B  9A 10 02 1F 1A        LCALL  0x1a1f, 0x210 ; THUNK -> 0x0000:0x0F74 (thunk @file 0x01C800 type A) overlay @file 0x026874
040E50  0B C0                 OR     ax, ax ; LOGIC
040E52  7D 03                 JGE    0x40e57 ; CJUMP
040E54  E9 5D 01              JMP    0x40fb4 ; JUMP
040E57  3D 08 00              CMP    ax, 8 ; CMP
040E5A  7C 03                 JL     0x40e5f ; CJUMP
040E5C  E9 55 01              JMP    0x40fb4 ; JUMP
040E5F  8B 0E 9C 53           MOV    cx, word ptr [0x539c] ; GLOBAL_LOAD
040E63  89 4E FE              MOV    word ptr [bp - 2], cx ; LOCAL_STORE
040E66  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040E6A  8A 8F 47 31           MOV    cl, byte ptr [bx + 0x3147] ; MOV
040E6E  80 E1 0F              AND    cl, 0xf ; LOGIC
040E71  80 F9 04              CMP    cl, 4 ; CMP
040E74  73 2E                 JAE    0x40ea4 ; CJUMP
040E76  2A ED                 SUB    ch, ch ; ARITH
040E78  6B F1 34              IMUL   si, cx, 0x34 ; ARITH
040E7B  38 AC 3F 54           CMP    byte ptr [si + 0x543f], ch ; CMP
040E7F  75 23                 JNE    0x40ea4 ; CJUMP
040E81  8B F0                 MOV    si, ax ; MOV
040E83  8A 84 BE 00           MOV    al, byte ptr [si + 0xbe] ; MOV
040E87  98                    CWDE ; ARITH
040E88  50                    PUSH   ax ; STACK_PUSH
040E89  8A 84 B4 00           MOV    al, byte ptr [si + 0xb4] ; MOV
040E8D  98                    CWDE ; ARITH
040E8E  50                    PUSH   ax ; STACK_PUSH
040E8F  8B F3                 MOV    si, bx ; MOV
040E91  9A 4E 04 1F 19        LCALL  0x191f, 0x44e ; THUNK -> 0x0000:0x049E (thunk @file 0x01BA3E type A) overlay @file 0x025D9E
040E96  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040E99  0B C0                 OR     ax, ax ; LOGIC
040E9B  74 32                 JE     0x40ecf ; CJUMP
040E9D  C6 84 4C 31 00        MOV    byte ptr [si + 0x314c], 0 ; MOV
040EA2  EB 2B                 JMP    0x40ecf ; JUMP
040EA4  8B D8                 MOV    bx, ax ; MOV
040EA6  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
040EAA  98                    CWDE ; ARITH
040EAB  6B 76 06 1C           IMUL   si, word ptr [bp + 6], 0x1c ; ARITH
040EAF  8A 8C 45 31           MOV    cl, byte ptr [si + 0x3145] ; MOV
040EB3  2A ED                 SUB    ch, ch ; ARITH
040EB5  03 C1                 ADD    ax, cx ; ARITH
040EB7  50                    PUSH   ax ; STACK_PUSH
040EB8  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
040EBC  98                    CWDE ; ARITH
040EBD  8A 8C 44 31           MOV    cl, byte ptr [si + 0x3144] ; MOV
040EC1  03 C8                 ADD    cx, ax ; ARITH
040EC3  51                    PUSH   cx ; STACK_PUSH
040EC4  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
040EC7  9A 42 01 1F 1A        LCALL  0x1a1f, 0x142 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01C732 type A) overlay @file 0x025900
040ECC  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
040ECF  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
040ED2  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
040ED5  74 03                 JE     0x40eda ; CJUMP
040ED7  E9 F3 00              JMP    0x40fcd ; JUMP
040EDA  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040EDE  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
040EE2  38 87 4D 31           CMP    byte ptr [bx + 0x314d], al ; CMP
040EE6  74 03                 JE     0x40eeb ; CJUMP
040EE8  E9 E2 00              JMP    0x40fcd ; JUMP
040EEB  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
040EEF  38 8F 4E 31           CMP    byte ptr [bx + 0x314e], cl ; CMP
040EF3  74 03                 JE     0x40ef8 ; CJUMP
040EF5  E9 D5 00              JMP    0x40fcd ; JUMP
040EF8  2A ED                 SUB    ch, ch ; ARITH
040EFA  51                    PUSH   cx ; STACK_PUSH
040EFB  2A E4                 SUB    ah, ah ; ARITH
040EFD  50                    PUSH   ax ; STACK_PUSH
040EFE  8B F3                 MOV    si, bx ; MOV
040F00  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
040F05  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040F08  3D 1A 00              CMP    ax, 0x1a ; CMP
040F0B  75 67                 JNE    0x40f74 ; CJUMP
040F0D  80 BC 4C 31 0C        CMP    byte ptr [si + 0x314c], 0xc ; CMP
040F12  74 60                 JE     0x40f74 ; CJUMP
040F14  83 3E 94 53 04        CMP    word ptr [0x5394], 4 ; CMP
040F19  7D 0C                 JGE    0x40f27 ; CJUMP
040F1B  6B 1E 94 53 34        IMUL   bx, word ptr [0x5394], 0x34 ; ARITH
040F20  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
040F25  74 0B                 JE     0x40f32 ; CJUMP
040F27  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040F2B  80 BF 4B 31 45        CMP    byte ptr [bx + 0x314b], 0x45 ; CMP
040F30  75 42                 JNE    0x40f74 ; CJUMP
040F32  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
040F37  74 14                 JE     0x40f4d ; CJUMP
040F39  A1 D2 53              MOV    ax, word ptr [0x53d2] ; GLOBAL_LOAD
040F3C  39 06 94 53           CMP    word ptr [0x5394], ax ; CMP
040F40  75 32                 JNE    0x40f74 ; CJUMP
040F42  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040F46  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
040F4B  75 27                 JNE    0x40f74 ; CJUMP
040F4D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
040F50  A3 92 53              MOV    word ptr [0x5392], ax ; GLOBAL_LOAD
040F53  9A 08 02 1F 19        LCALL  0x191f, 0x208 ; THUNK -> 0x0000:0x007A (thunk @file 0x01B7F8 type A) overlay @file 0x02597A
040F58  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040F5C  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
040F60  24 0F                 AND    al, 0xf ; LOGIC
040F62  3A 06 96 53           CMP    al, byte ptr [0x5396] ; CMP
040F66  75 0C                 JNE    0x40f74 ; CJUMP
040F68  FF 36 92 53           PUSH   word ptr [0x5392] ; PUSH_GLOBAL
040F6C  9A F4 0D 1F 18        LCALL  0x181f, 0xdf4 ; THUNK -> 0x0984:0x053A (thunk @file 0x01B3E4 type B) overlay @file 0x032450
040F71  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
040F74  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040F78  80 BF 46 31 02        CMP    byte ptr [bx + 0x3146], 2 ; CMP
040F7D  75 0A                 JNE    0x40f89 ; CJUMP
040F7F  C6 87 55 31 00        MOV    byte ptr [bx + 0x3155], 0 ; MOV
040F84  C6 87 56 31 FF        MOV    byte ptr [bx + 0x3156], 0xff ; CONST_LOAD
040F89  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040F8D  80 BF 4C 31 0B        CMP    byte ptr [bx + 0x314c], 0xb ; CMP
040F92  75 0B                 JNE    0x40f9f ; CJUMP
040F94  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
040F97  9A 34 09 1F 18        LCALL  0x181f, 0x934 ; THUNK -> 0x0427:0x155E (thunk @file 0x01AF24 type B) overlay @file 0x032272
040F9C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
040F9F  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040FA3  80 BF 4C 31 02        CMP    byte ptr [bx + 0x314c], 2 ; CMP
040FA8  74 23                 JE     0x40fcd ; CJUMP
040FAA  80 BF 4C 31 0C        CMP    byte ptr [bx + 0x314c], 0xc ; CMP
040FAF  74 1C                 JE     0x40fcd ; CJUMP
040FB1  EB 15                 JMP    0x40fc8 ; JUMP
040FB3  90                    NOP ; NOP
040FB4  3D 08 00              CMP    ax, 8 ; CMP
040FB7  75 0B                 JNE    0x40fc4 ; CJUMP
040FB9  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040FBD  80 BF 4C 31 02        CMP    byte ptr [bx + 0x314c], 2 ; CMP
040FC2  74 09                 JE     0x40fcd ; CJUMP
040FC4  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040FC8  C6 87 4C 31 00        MOV    byte ptr [bx + 0x314c], 0 ; MOV
040FCD  C7 06 D6 1D FF FF     MOV    word ptr [0x1dd6], 0xffff ; GLOBAL_LOAD
040FD3  5E                    POP    si ; STACK_POP
040FD4  C9                    LEAVE ; EPILOGUE
040FD5  CB                    RETF ; RETURN
