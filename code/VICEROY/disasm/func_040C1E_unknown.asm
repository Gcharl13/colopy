; ============================================================================
; func_040C1E_unknown
; Region   : overlay
; Bytes    : file 0x040C1E..0x040E21  (515 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040C1E  C8 66 00 00           ENTER  0x66, 0 ; PROLOGUE
040C22  56                    PUSH   si ; STACK_PUSH
040C23  2B C0                 SUB    ax, ax ; ARITH
040C25  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
040C28  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
040C2B  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
040C2E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
040C32  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
040C36  2A E4                 SUB    ah, ah ; ARITH
040C38  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
040C3B  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
040C3F  2A ED                 SUB    ch, ch ; ARITH
040C41  89 4E A2              MOV    word ptr [bp - 0x5e], cx ; LOCAL_STORE
040C44  51                    PUSH   cx ; STACK_PUSH
040C45  50                    PUSH   ax ; STACK_PUSH
040C46  8B F3                 MOV    si, bx ; MOV
040C48  9A 0E 07 1F 18        LCALL  0x181f, 0x70e ; THUNK -> 0x037F:0x00F6 (thunk @file 0x01ACFE type B) overlay @file 0x02EC32
040C4D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040C50  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
040C53  89 56 9C              MOV    word ptr [bp - 0x64], dx ; LOCAL_STORE
040C56  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
040C59  FF 76 A4              PUSH   word ptr [bp - 0x5c] ; PUSH_GLOBAL
040C5C  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
040C61  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040C64  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
040C67  C7 46 9E 01 00        MOV    word ptr [bp - 0x62], 1 ; LOCAL_STORE
040C6C  2A C0                 SUB    al, al ; ARITH
040C6E  88 84 5A 31           MOV    byte ptr [si + 0x315a], al ; MOV
040C72  88 84 4C 31           MOV    byte ptr [si + 0x314c], al ; MOV
040C76  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
040C79  39 06 94 53           CMP    word ptr [0x5394], ax ; CMP
040C7D  74 1C                 JE     0x40c9b ; CJUMP
040C7F  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
040C84  74 2B                 JE     0x40cb1 ; CJUMP
040C86  83 3E 94 53 04        CMP    word ptr [0x5394], 4 ; CMP
040C8B  7C 05                 JL     0x40c92 ; CJUMP
040C8D  B8 00 80              MOV    ax, 0x8000 ; CONST_LOAD
040C90  EB 03                 JMP    0x40c95 ; JUMP
040C92  B8 00 40              MOV    ax, 0x4000 ; CONST_LOAD
040C95  85 06 82 53           TEST   word ptr [0x5382], ax ; LOGIC
040C99  74 16                 JE     0x40cb1 ; CJUMP
040C9B  6A 01                 PUSH   1 ; STACK_PUSH
040C9D  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
040CA0  FF 76 A4              PUSH   word ptr [bp - 0x5c] ; PUSH_GLOBAL
040CA3  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
040CA6  FF 76 A4              PUSH   word ptr [bp - 0x5c] ; PUSH_GLOBAL
040CA9  9A 52 03 1F 18        LCALL  0x181f, 0x352 ; THUNK -> 0x0984:0x02FC (thunk @file 0x01A942 type B) overlay @file 0x032212
040CAE  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
040CB1  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
040CB4  50                    PUSH   ax ; STACK_PUSH
040CB5  FF 36 94 53           PUSH   word ptr [0x5394] ; PUSH_GLOBAL
040CB9  0E                    PUSH   cs ; STACK_PUSH
040CBA  E8 6A 0B              CALL   0x41827 ; CALL_NEAR
040CBD  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040CC0  83 3E 94 53 04        CMP    word ptr [0x5394], 4 ; CMP
040CC5  7D 31                 JGE    0x40cf8 ; CJUMP
040CC7  6B 1E 94 53 34        IMUL   bx, word ptr [0x5394], 0x34 ; ARITH
040CCC  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
040CD1  75 25                 JNE    0x40cf8 ; CJUMP
040CD3  C7 06 5E 1F 05 00     MOV    word ptr [0x1f5e], 5 ; GLOBAL_LOAD
040CD9  6A 17                 PUSH   0x17 ; PUSH_CONST
040CDB  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
040CDF  8D 06 6F 14           LEA    ax, [0x146f] ; ADDR
040CE3  8D 56 AE              LEA    dx, [bp - 0x52] ; ADDR
040CE6  9A 20 01 1F 19        LCALL  0x191f, 0x120 ; THUNK -> 0x0000:0x37FC (thunk @file 0x01B710 type A) overlay @file 0x0290FC
040CEB  0B C0                 OR     ax, ax ; LOGIC
040CED  74 03                 JE     0x40cf2 ; CJUMP
040CEF  E9 2C 01              JMP    0x40e1e ; JUMP
040CF2  C7 06 5E 1F FF FF     MOV    word ptr [0x1f5e], 0xffff ; GLOBAL_LOAD
040CF8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
040CFB  9A 34 09 1F 18        LCALL  0x181f, 0x934 ; THUNK -> 0x0427:0x155E (thunk @file 0x01AF24 type B) overlay @file 0x032272
040D00  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
040D03  A1 8E 53              MOV    ax, word ptr [0x538e] ; GLOBAL_LOAD
040D06  69 1E 94 53 3C 01     IMUL   bx, word ptr [0x5394], 0x13c ; ARITH
040D0C  89 87 4E 88           MOV    word ptr [bx - 0x77b2], ax ; MOV
040D10  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
040D13  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
040D16  FF 76 A4              PUSH   word ptr [bp - 0x5c] ; PUSH_GLOBAL
040D19  FF 36 94 53           PUSH   word ptr [0x5394] ; PUSH_GLOBAL
040D1D  9A B2 09 1F 19        LCALL  0x191f, 0x9b2 ; THUNK -> 0x0000:0x1BA8 (thunk @file 0x01BFA2 type A) overlay @file 0x0274A8
040D22  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
040D25  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
040D28  0B C0                 OR     ax, ax ; LOGIC
040D2A  7D 03                 JGE    0x40d2f ; CJUMP
040D2C  E9 EF 00              JMP    0x40e1e ; JUMP
040D2F  83 3E 94 53 04        CMP    word ptr [0x5394], 4 ; CMP
040D34  7D 0C                 JGE    0x40d42 ; CJUMP
040D36  6B 1E 94 53 34        IMUL   bx, word ptr [0x5394], 0x34 ; ARITH
040D3B  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
040D40  74 12                 JE     0x40d54 ; CJUMP
040D42  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
040D45  50                    PUSH   ax ; STACK_PUSH
040D46  A1 42 85              MOV    ax, word ptr [0x8542] ; GLOBAL_LOAD
040D49  40                    INC    ax ; ARITH
040D4A  40                    INC    ax ; ARITH
040D4B  50                    PUSH   ax ; STACK_PUSH
040D4C  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
040D51  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040D54  6A 01                 PUSH   1 ; STACK_PUSH
040D56  6A 20                 PUSH   0x20 ; PUSH_CONST
040D58  9A BE 0B 1F 18        LCALL  0x181f, 0xbbe ; THUNK -> 0x05EB:0x1030 (thunk @file 0x01B1AE type B) overlay @file 0x028020
040D5D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040D60  6A 01                 PUSH   1 ; STACK_PUSH
040D62  6A 18                 PUSH   0x18 ; PUSH_CONST
040D64  9A BE 0B 1F 18        LCALL  0x181f, 0xbbe ; THUNK -> 0x05EB:0x1030 (thunk @file 0x01B1AE type B) overlay @file 0x028020
040D69  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040D6C  6A 01                 PUSH   1 ; STACK_PUSH
040D6E  6A 15                 PUSH   0x15 ; PUSH_CONST
040D70  9A BE 0B 1F 18        LCALL  0x181f, 0xbbe ; THUNK -> 0x05EB:0x1030 (thunk @file 0x01B1AE type B) overlay @file 0x028020
040D75  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040D78  6A 01                 PUSH   1 ; STACK_PUSH
040D7A  6A 1B                 PUSH   0x1b ; PUSH_CONST
040D7C  9A BE 0B 1F 18        LCALL  0x181f, 0xbbe ; THUNK -> 0x05EB:0x1030 (thunk @file 0x01B1AE type B) overlay @file 0x028020
040D81  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040D84  6A 01                 PUSH   1 ; STACK_PUSH
040D86  6A 27                 PUSH   0x27 ; PUSH_CONST
040D88  9A BE 0B 1F 18        LCALL  0x181f, 0xbbe ; THUNK -> 0x05EB:0x1030 (thunk @file 0x01B1AE type B) overlay @file 0x028020
040D8D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040D90  83 3E 94 53 04        CMP    word ptr [0x5394], 4 ; CMP
040D95  7D 1D                 JGE    0x40db4 ; CJUMP
040D97  6B 1E 94 53 34        IMUL   bx, word ptr [0x5394], 0x34 ; ARITH
040D9C  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
040DA1  75 11                 JNE    0x40db4 ; CJUMP
040DA3  68 20 98              PUSH   0x9820 ; PUSH_CONST
040DA6  A1 42 85              MOV    ax, word ptr [0x8542] ; GLOBAL_LOAD
040DA9  40                    INC    ax ; ARITH
040DAA  40                    INC    ax ; ARITH
040DAB  50                    PUSH   ax ; STACK_PUSH
040DAC  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
040DB1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040DB4  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
040DB7  39 06 94 53           CMP    word ptr [0x5394], ax ; CMP
040DBB  74 1C                 JE     0x40dd9 ; CJUMP
040DBD  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
040DC2  74 1F                 JE     0x40de3 ; CJUMP
040DC4  83 3E 94 53 04        CMP    word ptr [0x5394], 4 ; CMP
040DC9  7C 05                 JL     0x40dd0 ; CJUMP
040DCB  B8 00 80              MOV    ax, 0x8000 ; CONST_LOAD
040DCE  EB 03                 JMP    0x40dd3 ; JUMP
040DD0  B8 00 40              MOV    ax, 0x4000 ; CONST_LOAD
040DD3  85 06 82 53           TEST   word ptr [0x5382], ax ; LOGIC
040DD7  74 0A                 JE     0x40de3 ; CJUMP
040DD9  6A 01                 PUSH   1 ; STACK_PUSH
040DDB  9A 1C 0E 1F 18        LCALL  0x181f, 0xe1c ; THUNK -> 0x0000:0x00C0 (thunk @file 0x01B40C type A) overlay @file 0x0259C0
040DE0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
040DE3  83 3E 94 53 04        CMP    word ptr [0x5394], 4 ; CMP
040DE8  7D 34                 JGE    0x40e1e ; CJUMP
040DEA  6B 1E 94 53 34        IMUL   bx, word ptr [0x5394], 0x34 ; ARITH
040DEF  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
040DF4  75 28                 JNE    0x40e1e ; CJUMP
040DF6  B8 54 00              MOV    ax, 0x54 ; CONST_LOAD
040DF9  9A C0 04 1F 18        LCALL  0x181f, 0x4c0 ; THUNK -> 0x02D8:0x000E (thunk @file 0x01AAB0 type B)
040DFE  6A 02                 PUSH   2 ; STACK_PUSH
040E00  9A 24 05 1F 18        LCALL  0x181f, 0x524 ; THUNK -> 0x02FD:0x006C (thunk @file 0x01AB14 type B) overlay @file 0x0287EA
040E05  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
040E08  C6 06 37 03 00        MOV    byte ptr [0x337], 0 ; GLOBAL_LOAD
040E0D  C7 06 4E 03 00 00     MOV    word ptr [0x34e], 0 ; GLOBAL_LOAD
040E13  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
040E16  9A 08 06 1F 18        LCALL  0x181f, 0x608 ; THUNK -> 0x0000:0x6CD4 (thunk @file 0x01ABF8 type A) overlay @file 0x02C5D4
040E1B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
040E1E  5E                    POP    si ; STACK_POP
040E1F  C9                    LEAVE ; EPILOGUE
040E20  CB                    RETF ; RETURN
