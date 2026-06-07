; ============================================================================
; func_064A10_unknown
; Region   : overlay
; Bytes    : file 0x064A10..0x065110  (1792 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064A10  C8 3C 00 00           ENTER  0x3c, 0 ; PROLOGUE
064A14  57                    PUSH   di ; STACK_PUSH
064A15  56                    PUSH   si ; STACK_PUSH
064A16  68 FF 7F              PUSH   0x7fff ; PUSH_CONST
064A19  6A 01                 PUSH   1 ; STACK_PUSH
064A1B  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064A20  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064A23  A3 90 01              MOV    word ptr [0x190], ax ; GLOBAL_LOAD
064A26  C7 06 92 01 00 00     MOV    word ptr [0x192], 0 ; GLOBAL_LOAD
064A2C  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
064A30  74 03                 JE     0x64a35 ; CJUMP
064A32  E9 0C 0F              JMP    0x65941 ; JUMP
064A35  C7 06 22 2D 00 00     MOV    word ptr [0x2d22], 0 ; GLOBAL_LOAD
064A3B  FF 36 AE 85           PUSH   word ptr [0x85ae] ; PUSH_GLOBAL
064A3F  FF 36 AC 85           PUSH   word ptr [0x85ac] ; PUSH_GLOBAL
064A43  FF 36 AA 85           PUSH   word ptr [0x85aa] ; PUSH_GLOBAL
064A47  FF 36 A8 85           PUSH   word ptr [0x85a8] ; PUSH_GLOBAL
064A4B  B0 19                 MOV    al, 0x19 ; CONST_LOAD
064A4D  9A 84 04 1F 18        LCALL  0x181f, 0x484 ; THUNK -> 0x0B8D:0x0004 (thunk @file 0x01AA74 type B)
064A52  FF 36 B6 85           PUSH   word ptr [0x85b6] ; PUSH_GLOBAL
064A56  FF 36 B4 85           PUSH   word ptr [0x85b4] ; PUSH_GLOBAL
064A5A  FF 36 B2 85           PUSH   word ptr [0x85b2] ; PUSH_GLOBAL
064A5E  FF 36 B0 85           PUSH   word ptr [0x85b0] ; PUSH_GLOBAL
064A62  2A C0                 SUB    al, al ; ARITH
064A64  9A 84 04 1F 18        LCALL  0x181f, 0x484 ; THUNK -> 0x0B8D:0x0004 (thunk @file 0x01AA74 type B)
064A69  C6 06 20 2D 03        MOV    byte ptr [0x2d20], 3 ; GLOBAL_LOAD
064A6E  A0 3A 85              MOV    al, byte ptr [0x853a] ; GLOBAL_LOAD
064A71  2C 06                 SUB    al, 6 ; ARITH
064A73  A2 1E 2D              MOV    byte ptr [0x2d1e], al ; GLOBAL_LOAD
064A76  C6 06 21 2D 00        MOV    byte ptr [0x2d21], 0 ; GLOBAL_LOAD
064A7B  A0 3C 85              MOV    al, byte ptr [0x853c] ; GLOBAL_LOAD
064A7E  A2 1F 2D              MOV    byte ptr [0x2d1f], al ; GLOBAL_LOAD
064A81  6A 01                 PUSH   1 ; STACK_PUSH
064A83  6A 00                 PUSH   0 ; STACK_PUSH
064A85  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064A8A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064A8D  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
064A90  0B C0                 OR     ax, ax ; LOGIC
064A92  74 08                 JE     0x64a9c ; CJUMP
064A94  C6 06 21 2D 05        MOV    byte ptr [0x2d21], 5 ; GLOBAL_LOAD
064A99  EB 09                 JMP    0x64aa4 ; JUMP
064A9B  90                    NOP ; NOP
064A9C  A0 3C 85              MOV    al, byte ptr [0x853c] ; GLOBAL_LOAD
064A9F  2C 06                 SUB    al, 6 ; ARITH
064AA1  A2 1F 2D              MOV    byte ptr [0x2d1f], al ; GLOBAL_LOAD
064AA4  6A 00                 PUSH   0 ; STACK_PUSH
064AA6  0E                    PUSH   cs ; STACK_PUSH
064AA7  E8 68 12              CALL   0x65d12 ; CALL_NEAR
064AAA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
064AAD  A1 80 1E              MOV    ax, word ptr [0x1e80] ; GLOBAL_LOAD
064AB0  03 06 7E 1E           ADD    ax, word ptr [0x1e7e] ; ARITH
064AB4  40                    INC    ax ; ARITH
064AB5  69 C0 40 01           IMUL   ax, ax, 0x140 ; ARITH
064AB9  3B 06 22 2D           CMP    ax, word ptr [0x2d22] ; CMP
064ABD  7F E5                 JG     0x64aa4 ; CJUMP
064ABF  9A DC 07 1F 1A        LCALL  0x1a1f, 0x7dc ; THUNK -> 0x0000:0x0000 (thunk @file 0x01CDCC type A) overlay @file 0x025900
064AC4  2B C0                 SUB    ax, ax ; ARITH
064AC6  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
064AC9  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
064ACC  EB 12                 JMP    0x64ae0 ; JUMP
064ACE  8B 5E DE              MOV    bx, word ptr [bp - 0x22] ; LOCAL_LOAD
064AD1  D1 E3                 SHL    bx, 1 ; LOGIC
064AD3  83 BF C8 85 00        CMP    word ptr [bx - 0x7a38], 0 ; CMP
064AD8  74 03                 JE     0x64add ; CJUMP
064ADA  FF 46 E6              INC    word ptr [bp - 0x1a] ; ARITH
064ADD  FF 46 DE              INC    word ptr [bp - 0x22] ; ARITH
064AE0  83 7E DE 10           CMP    word ptr [bp - 0x22], 0x10 ; CMP
064AE4  7C E8                 JL     0x64ace ; CJUMP
064AE6  B8 0F 00              MOV    ax, 0xf ; CONST_LOAD
064AE9  2B 46 E6              SUB    ax, word ptr [bp - 0x1a] ; ARITH
064AEC  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
064AEF  0B C0                 OR     ax, ax ; LOGIC
064AF1  7E 35                 JLE    0x64b28 ; CJUMP
064AF3  83 3E 80 1E 00        CMP    word ptr [0x1e80], 0 ; CMP
064AF8  7E 13                 JLE    0x64b0d ; CJUMP
064AFA  50                    PUSH   ax ; STACK_PUSH
064AFB  6A 00                 PUSH   0 ; STACK_PUSH
064AFD  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064B02  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064B05  2B 46 D6              SUB    ax, word ptr [bp - 0x2a] ; ARITH
064B08  F7 D8                 NEG    ax ; ARITH
064B0A  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
064B0D  C7 46 DE 00 00        MOV    word ptr [bp - 0x22], 0 ; LOCAL_STORE
064B12  EB 0C                 JMP    0x64b20 ; JUMP
064B14  6A 01                 PUSH   1 ; STACK_PUSH
064B16  0E                    PUSH   cs ; STACK_PUSH
064B17  E8 F8 11              CALL   0x65d12 ; CALL_NEAR
064B1A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
064B1D  FF 46 DE              INC    word ptr [bp - 0x22] ; ARITH
064B20  8B 46 DE              MOV    ax, word ptr [bp - 0x22] ; LOCAL_LOAD
064B23  39 46 D6              CMP    word ptr [bp - 0x2a], ax ; CMP
064B26  7F EC                 JG     0x64b14 ; CJUMP
064B28  C7 46 DC 01 00        MOV    word ptr [bp - 0x24], 1 ; LOCAL_STORE
064B2D  E9 2D 01              JMP    0x64c5d ; JUMP
064B30  FF 46 E2              INC    word ptr [bp - 0x1e] ; ARITH
064B33  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
064B36  48                    DEC    ax ; ARITH
064B37  3B 46 E2              CMP    ax, word ptr [bp - 0x1e] ; CMP
064B3A  7F 03                 JG     0x64b3f ; CJUMP
064B3C  E9 1B 01              JMP    0x64c5a ; JUMP
064B3F  C7 46 D2 00 00        MOV    word ptr [bp - 0x2e], 0 ; LOCAL_STORE
064B44  FF 36 B6 85           PUSH   word ptr [0x85b6] ; PUSH_GLOBAL
064B48  FF 36 B4 85           PUSH   word ptr [0x85b4] ; PUSH_GLOBAL
064B4C  FF 36 B2 85           PUSH   word ptr [0x85b2] ; PUSH_GLOBAL
064B50  FF 36 B0 85           PUSH   word ptr [0x85b0] ; PUSH_GLOBAL
064B54  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
064B57  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
064B5A  9A 68 08 1F 1A        LCALL  0x1a1f, 0x868 ; THUNK -> 0x0BBB:0x0006 (thunk @file 0x01CE58 type B)
064B5F  0A C0                 OR     al, al ; LOGIC
064B61  74 05                 JE     0x64b68 ; CJUMP
064B63  C7 46 D2 01 00        MOV    word ptr [bp - 0x2e], 1 ; LOCAL_STORE
064B68  FF 36 B6 85           PUSH   word ptr [0x85b6] ; PUSH_GLOBAL
064B6C  FF 36 B4 85           PUSH   word ptr [0x85b4] ; PUSH_GLOBAL
064B70  FF 36 B2 85           PUSH   word ptr [0x85b2] ; PUSH_GLOBAL
064B74  FF 36 B0 85           PUSH   word ptr [0x85b0] ; PUSH_GLOBAL
064B78  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
064B7B  40                    INC    ax ; ARITH
064B7C  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
064B7F  9A 68 08 1F 1A        LCALL  0x1a1f, 0x868 ; THUNK -> 0x0BBB:0x0006 (thunk @file 0x01CE58 type B)
064B84  0A C0                 OR     al, al ; LOGIC
064B86  74 04                 JE     0x64b8c ; CJUMP
064B88  80 4E D2 02           OR     byte ptr [bp - 0x2e], 2 ; LOGIC
064B8C  FF 36 B6 85           PUSH   word ptr [0x85b6] ; PUSH_GLOBAL
064B90  FF 36 B4 85           PUSH   word ptr [0x85b4] ; PUSH_GLOBAL
064B94  FF 36 B2 85           PUSH   word ptr [0x85b2] ; PUSH_GLOBAL
064B98  FF 36 B0 85           PUSH   word ptr [0x85b0] ; PUSH_GLOBAL
064B9C  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
064B9F  42                    INC    dx ; ARITH
064BA0  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
064BA3  9A 68 08 1F 1A        LCALL  0x1a1f, 0x868 ; THUNK -> 0x0BBB:0x0006 (thunk @file 0x01CE58 type B)
064BA8  0A C0                 OR     al, al ; LOGIC
064BAA  74 04                 JE     0x64bb0 ; CJUMP
064BAC  80 4E D2 04           OR     byte ptr [bp - 0x2e], 4 ; LOGIC
064BB0  FF 36 B6 85           PUSH   word ptr [0x85b6] ; PUSH_GLOBAL
064BB4  FF 36 B4 85           PUSH   word ptr [0x85b4] ; PUSH_GLOBAL
064BB8  FF 36 B2 85           PUSH   word ptr [0x85b2] ; PUSH_GLOBAL
064BBC  FF 36 B0 85           PUSH   word ptr [0x85b0] ; PUSH_GLOBAL
064BC0  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
064BC3  40                    INC    ax ; ARITH
064BC4  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
064BC7  42                    INC    dx ; ARITH
064BC8  9A 68 08 1F 1A        LCALL  0x1a1f, 0x868 ; THUNK -> 0x0BBB:0x0006 (thunk @file 0x01CE58 type B)
064BCD  0A C0                 OR     al, al ; LOGIC
064BCF  74 04                 JE     0x64bd5 ; CJUMP
064BD1  80 4E D2 08           OR     byte ptr [bp - 0x2e], 8 ; LOGIC
064BD5  83 7E D2 06           CMP    word ptr [bp - 0x2e], 6 ; CMP
064BD9  74 09                 JE     0x64be4 ; CJUMP
064BDB  83 7E D2 09           CMP    word ptr [bp - 0x2e], 9 ; CMP
064BDF  74 03                 JE     0x64be4 ; CJUMP
064BE1  E9 4C FF              JMP    0x64b30 ; JUMP
064BE4  FF 36 B6 85           PUSH   word ptr [0x85b6] ; PUSH_GLOBAL
064BE8  FF 36 B4 85           PUSH   word ptr [0x85b4] ; PUSH_GLOBAL
064BEC  FF 36 B2 85           PUSH   word ptr [0x85b2] ; PUSH_GLOBAL
064BF0  FF 36 B0 85           PUSH   word ptr [0x85b0] ; PUSH_GLOBAL
064BF4  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
064BF7  40                    INC    ax ; ARITH
064BF8  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
064BFB  BB 01 00              MOV    bx, 1 ; MOV
064BFE  8B F0                 MOV    si, ax ; MOV
064C00  9A 72 08 1F 1A        LCALL  0x1a1f, 0x872 ; THUNK -> 0x0BB9:0x000A (thunk @file 0x01CE62 type B)
064C05  FF 36 B6 85           PUSH   word ptr [0x85b6] ; PUSH_GLOBAL
064C09  FF 36 B4 85           PUSH   word ptr [0x85b4] ; PUSH_GLOBAL
064C0D  FF 36 B2 85           PUSH   word ptr [0x85b2] ; PUSH_GLOBAL
064C11  FF 36 B0 85           PUSH   word ptr [0x85b0] ; PUSH_GLOBAL
064C15  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
064C18  42                    INC    dx ; ARITH
064C19  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
064C1C  BB 01 00              MOV    bx, 1 ; MOV
064C1F  8B FA                 MOV    di, dx ; MOV
064C21  9A 72 08 1F 1A        LCALL  0x1a1f, 0x872 ; THUNK -> 0x0BB9:0x000A (thunk @file 0x01CE62 type B)
064C26  FF 36 B6 85           PUSH   word ptr [0x85b6] ; PUSH_GLOBAL
064C2A  FF 36 B4 85           PUSH   word ptr [0x85b4] ; PUSH_GLOBAL
064C2E  FF 36 B2 85           PUSH   word ptr [0x85b2] ; PUSH_GLOBAL
064C32  FF 36 B0 85           PUSH   word ptr [0x85b0] ; PUSH_GLOBAL
064C36  8B C6                 MOV    ax, si ; MOV
064C38  8B D7                 MOV    dx, di ; MOV
064C3A  BB 01 00              MOV    bx, 1 ; MOV
064C3D  9A 72 08 1F 1A        LCALL  0x1a1f, 0x872 ; THUNK -> 0x0BB9:0x000A (thunk @file 0x01CE62 type B)
064C42  83 7E E2 00           CMP    word ptr [bp - 0x1e], 0 ; CMP
064C46  74 03                 JE     0x64c4b ; CJUMP
064C48  FF 4E E2              DEC    word ptr [bp - 0x1e] ; ARITH
064C4B  83 7E DC 00           CMP    word ptr [bp - 0x24], 0 ; CMP
064C4F  75 03                 JNE    0x64c54 ; CJUMP
064C51  E9 DC FE              JMP    0x64b30 ; JUMP
064C54  FF 4E DC              DEC    word ptr [bp - 0x24] ; ARITH
064C57  E9 D6 FE              JMP    0x64b30 ; JUMP
064C5A  FF 46 DC              INC    word ptr [bp - 0x24] ; ARITH
064C5D  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
064C60  48                    DEC    ax ; ARITH
064C61  3B 46 DC              CMP    ax, word ptr [bp - 0x24] ; CMP
064C64  7E 08                 JLE    0x64c6e ; CJUMP
064C66  C7 46 E2 01 00        MOV    word ptr [bp - 0x1e], 1 ; LOCAL_STORE
064C6B  E9 C5 FE              JMP    0x64b33 ; JUMP
064C6E  9A AC 03 1F 18        LCALL  0x181f, 0x3ac ; THUNK -> 0x0262:0x02FE (thunk @file 0x01A99C type B) overlay @file 0x02202E
064C73  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0 ; LOCAL_STORE
064C78  E9 41 01              JMP    0x64dbc ; JUMP
064C7B  90                    NOP ; NOP
064C7C  6A 10                 PUSH   0x10 ; PUSH_CONST
064C7E  6A 01                 PUSH   1 ; STACK_PUSH
064C80  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064C85  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064C88  8B C8                 MOV    cx, ax ; MOV
064C8A  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
064C8D  D1 F8                 SAR    ax, 1 ; LOGIC
064C8F  2B C1                 SUB    ax, cx ; ARITH
064C91  2B 46 DC              SUB    ax, word ptr [bp - 0x24] ; ARITH
064C94  05 08 00              ADD    ax, 8 ; ARITH
064C97  F7 D0                 NOT    ax ; LOGIC
064C99  40                    INC    ax ; ARITH
064C9A  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
064C9D  B8 01 00              MOV    ax, 1 ; MOV
064CA0  2B 06 82 1E           SUB    ax, word ptr [0x1e82] ; ARITH
064CA4  D1 E0                 SHL    ax, 1 ; LOGIC
064CA6  01 46 FA              ADD    word ptr [bp - 6], ax ; ARITH
064CA9  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
064CAC  0B C0                 OR     ax, ax ; LOGIC
064CAE  7D 02                 JGE    0x64cb2 ; CJUMP
064CB0  2B C0                 SUB    ax, ax ; ARITH
064CB2  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
064CB5  C1 7E FA 02           SAR    word ptr [bp - 6], 2 ; LOGIC
064CB9  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
064CBC  EB 30                 JMP    0x64cee ; JUMP
064CBE  C7 46 D2 05 00        MOV    word ptr [bp - 0x2e], 5 ; LOCAL_STORE
064CC3  EB 43                 JMP    0x64d08 ; JUMP
064CC5  90                    NOP ; NOP
064CC6  C7 46 D2 04 00        MOV    word ptr [bp - 0x2e], 4 ; LOCAL_STORE
064CCB  EB 3B                 JMP    0x64d08 ; JUMP
064CCD  90                    NOP ; NOP
064CCE  C7 46 D2 01 00        MOV    word ptr [bp - 0x2e], 1 ; LOCAL_STORE
064CD3  EB 33                 JMP    0x64d08 ; JUMP
064CD5  90                    NOP ; NOP
064CD6  C7 46 D2 03 00        MOV    word ptr [bp - 0x2e], 3 ; LOCAL_STORE
064CDB  EB 2B                 JMP    0x64d08 ; JUMP
064CDD  90                    NOP ; NOP
064CDE  C7 46 D2 02 00        MOV    word ptr [bp - 0x2e], 2 ; LOCAL_STORE
064CE3  EB 23                 JMP    0x64d08 ; JUMP
064CE5  90                    NOP ; NOP
064CE6  C7 46 D2 00 00        MOV    word ptr [bp - 0x2e], 0 ; LOCAL_STORE
064CEB  EB 1B                 JMP    0x64d08 ; JUMP
064CED  90                    NOP ; NOP
064CEE  3D 05 00              CMP    ax, 5 ; CMP
064CF1  77 F3                 JA     0x64ce6 ; CJUMP
064CF3  D1 E0                 SHL    ax, 1 ; LOGIC
064CF5  93                    XCHG   bx, ax ; MOV
064CF6  2E FF A7 AC 0B        JMP    word ptr cs:[bx + 0xbac] ; JUMP
064CFB  90                    NOP ; NOP
064CFC  6E                    OUTSB  dx, byte ptr [si] ; IO
064CFD  0B 76 0B              OR     si, word ptr [bp + 0xb] ; LOGIC
064D00  7E 0B                 JLE    0x64d0d ; CJUMP
064D02  86 0B                 XCHG   byte ptr [bp + di], cl ; MOV
064D04  8E 0B                 MOV    cs, word ptr [bp + di] ; LOCAL_LOAD
064D06  8E 0B                 MOV    cs, word ptr [bp + di] ; LOCAL_LOAD
064D08  83 7E EA 00           CMP    word ptr [bp - 0x16], 0 ; CMP
064D0C  75 05                 JNE    0x64d13 ; CJUMP
064D0E  C7 46 D2 19 00        MOV    word ptr [bp - 0x2e], 0x19 ; LOCAL_STORE
064D13  83 7E EA 02           CMP    word ptr [bp - 0x16], 2 ; CMP
064D17  7C 04                 JL     0x64d1d ; CJUMP
064D19  80 4E D2 20           OR     byte ptr [bp - 0x2e], 0x20 ; LOGIC
064D1D  83 7E EA 03           CMP    word ptr [bp - 0x16], 3 ; CMP
064D21  7C 04                 JL     0x64d27 ; CJUMP
064D23  80 4E D2 80           OR     byte ptr [bp - 0x2e], 0x80 ; LOGIC
064D27  FF 36 AE 85           PUSH   word ptr [0x85ae] ; PUSH_GLOBAL
064D2B  FF 36 AC 85           PUSH   word ptr [0x85ac] ; PUSH_GLOBAL
064D2F  FF 36 AA 85           PUSH   word ptr [0x85aa] ; PUSH_GLOBAL
064D33  FF 36 A8 85           PUSH   word ptr [0x85a8] ; PUSH_GLOBAL
064D37  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
064D3A  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
064D3D  8B 5E D2              MOV    bx, word ptr [bp - 0x2e] ; LOCAL_LOAD
064D40  9A 72 08 1F 1A        LCALL  0x1a1f, 0x872 ; THUNK -> 0x0BB9:0x000A (thunk @file 0x01CE62 type B)
064D45  FF 46 E2              INC    word ptr [bp - 0x1e] ; ARITH
064D48  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
064D4B  39 46 E2              CMP    word ptr [bp - 0x1e], ax ; CMP
064D4E  7D 64                 JGE    0x64db4 ; CJUMP
064D50  FF 36 B6 85           PUSH   word ptr [0x85b6] ; PUSH_GLOBAL
064D54  FF 36 B4 85           PUSH   word ptr [0x85b4] ; PUSH_GLOBAL
064D58  FF 36 B2 85           PUSH   word ptr [0x85b2] ; PUSH_GLOBAL
064D5C  FF 36 B0 85           PUSH   word ptr [0x85b0] ; PUSH_GLOBAL
064D60  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
064D63  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
064D66  9A 68 08 1F 1A        LCALL  0x1a1f, 0x868 ; THUNK -> 0x0BBB:0x0006 (thunk @file 0x01CE58 type B)
064D6B  2A E4                 SUB    ah, ah ; ARITH
064D6D  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
064D70  C7 46 D2 19 00        MOV    word ptr [bp - 0x2e], 0x19 ; LOCAL_STORE
064D75  6A 10                 PUSH   0x10 ; PUSH_CONST
064D77  6A 01                 PUSH   1 ; STACK_PUSH
064D79  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064D7E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064D81  8B 0E 3C 85           MOV    cx, word ptr [0x853c] ; GLOBAL_LOAD
064D85  D1 F9                 SAR    cx, 1 ; LOGIC
064D87  2B C8                 SUB    cx, ax ; ARITH
064D89  2B 4E DC              SUB    cx, word ptr [bp - 0x24] ; ARITH
064D8C  83 C1 08              ADD    cx, 8 ; ARITH
064D8F  0B C9                 OR     cx, cx ; LOGIC
064D91  7F 03                 JG     0x64d96 ; CJUMP
064D93  E9 E6 FE              JMP    0x64c7c ; JUMP
064D96  6A 10                 PUSH   0x10 ; PUSH_CONST
064D98  6A 01                 PUSH   1 ; STACK_PUSH
064D9A  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064D9F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064DA2  8B C8                 MOV    cx, ax ; MOV
064DA4  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
064DA7  D1 F8                 SAR    ax, 1 ; LOGIC
064DA9  2B C1                 SUB    ax, cx ; ARITH
064DAB  2B 46 DC              SUB    ax, word ptr [bp - 0x24] ; ARITH
064DAE  05 08 00              ADD    ax, 8 ; ARITH
064DB1  E9 E6 FE              JMP    0x64c9a ; JUMP
064DB4  9A AC 03 1F 18        LCALL  0x181f, 0x3ac ; THUNK -> 0x0262:0x02FE (thunk @file 0x01A99C type B) overlay @file 0x02202E
064DB9  FF 46 DC              INC    word ptr [bp - 0x24] ; ARITH
064DBC  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
064DBF  39 46 DC              CMP    word ptr [bp - 0x24], ax ; CMP
064DC2  7D 08                 JGE    0x64dcc ; CJUMP
064DC4  C7 46 E2 00 00        MOV    word ptr [bp - 0x1e], 0 ; LOCAL_STORE
064DC9  E9 7C FF              JMP    0x64d48 ; JUMP
064DCC  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0 ; LOCAL_STORE
064DD1  E9 26 03              JMP    0x650fa ; JUMP
064DD4  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
064DD7  D1 F8                 SAR    ax, 1 ; LOGIC
064DD9  2B 46 DC              SUB    ax, word ptr [bp - 0x24] ; ARITH
064DDC  F7 D0                 NOT    ax ; LOGIC
064DDE  40                    INC    ax ; ARITH
064DDF  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
064DE2  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
064DE5  C1 F8 02              SAR    ax, 2 ; LOGIC
064DE8  2B 46 FA              SUB    ax, word ptr [bp - 6] ; ARITH
064DEB  89 46 CC              MOV    word ptr [bp - 0x34], ax ; LOCAL_STORE
064DEE  0B C0                 OR     ax, ax ; LOGIC
064DF0  7F 0C                 JG     0x64dfe ; CJUMP
064DF2  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
064DF5  C1 F8 02              SAR    ax, 2 ; LOGIC
064DF8  2B 46 FA              SUB    ax, word ptr [bp - 6] ; ARITH
064DFB  F7 D0                 NOT    ax ; LOGIC
064DFD  40                    INC    ax ; ARITH
064DFE  8B 0E 84 1E           MOV    cx, word ptr [0x1e84] ; GLOBAL_LOAD
064E02  C1 E1 02              SHL    cx, 2 ; LOGIC
064E05  03 C1                 ADD    ax, cx ; ARITH
064E07  50                    PUSH   ax ; STACK_PUSH
064E08  6A 00                 PUSH   0 ; STACK_PUSH
064E0A  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064E0F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064E12  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
064E15  C7 46 E2 00 00        MOV    word ptr [bp - 0x1e], 0 ; LOCAL_STORE
064E1A  E9 67 01              JMP    0x64f84 ; JUMP
064E1D  90                    NOP ; NOP
064E1E  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
064E21  C1 F8 02              SAR    ax, 2 ; LOGIC
064E24  2B 46 FA              SUB    ax, word ptr [bp - 6] ; ARITH
064E27  F7 D0                 NOT    ax ; LOGIC
064E29  40                    INC    ax ; ARITH
064E2A  8B 0E 84 1E           MOV    cx, word ptr [0x1e84] ; GLOBAL_LOAD
064E2E  C1 E1 02              SHL    cx, 2 ; LOGIC
064E31  03 C1                 ADD    ax, cx ; ARITH
064E33  3B 46 F0              CMP    ax, word ptr [bp - 0x10] ; CMP
064E36  7F 03                 JG     0x64e3b ; CJUMP
064E38  E9 1E 01              JMP    0x64f59 ; JUMP
064E3B  E9 18 01              JMP    0x64f56 ; JUMP
064E3E  F6 46 EA 80           TEST   byte ptr [bp - 0x16], 0x80 ; LOGIC
064E42  74 08                 JE     0x64e4c ; CJUMP
064E44  83 6E F0 03           SUB    word ptr [bp - 0x10], 3 ; ARITH
064E48  E9 B9 00              JMP    0x64f04 ; JUMP
064E4B  90                    NOP ; NOP
064E4C  F6 46 EA 20           TEST   byte ptr [bp - 0x16], 0x20 ; LOGIC
064E50  74 08                 JE     0x64e5a ; CJUMP
064E52  80 66 EA 5F           AND    byte ptr [bp - 0x16], 0x5f ; LOGIC
064E56  E9 AB 00              JMP    0x64f04 ; JUMP
064E59  90                    NOP ; NOP
064E5A  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
064E5E  7D 74                 JGE    0x64ed4 ; CJUMP
064E60  0B C0                 OR     ax, ax ; LOGIC
064E62  74 50                 JE     0x64eb4 ; CJUMP
064E64  48                    DEC    ax ; ARITH
064E65  48                    DEC    ax ; ARITH
064E66  74 44                 JE     0x64eac ; CJUMP
064E68  48                    DEC    ax ; ARITH
064E69  74 0F                 JE     0x64e7a ; CJUMP
064E6B  48                    DEC    ax ; ARITH
064E6C  74 03                 JE     0x64e71 ; CJUMP
064E6E  E9 93 00              JMP    0x64f04 ; JUMP
064E71  C7 46 EE 03 00        MOV    word ptr [bp - 0x12], 3 ; LOCAL_STORE
064E76  E9 8B 00              JMP    0x64f04 ; JUMP
064E79  90                    NOP ; NOP
064E7A  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
064E7E  7E 06                 JLE    0x64e86 ; CJUMP
064E80  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
064E83  EB 07                 JMP    0x64e8c ; JUMP
064E85  90                    NOP ; NOP
064E86  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
064E89  F7 D0                 NOT    ax ; LOGIC
064E8B  40                    INC    ax ; ARITH
064E8C  50                    PUSH   ax ; STACK_PUSH
064E8D  6A 00                 PUSH   0 ; STACK_PUSH
064E8F  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064E94  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064E97  0B C0                 OR     ax, ax ; LOGIC
064E99  74 07                 JE     0x64ea2 ; CJUMP
064E9B  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1 ; LOCAL_STORE
064EA0  EB 62                 JMP    0x64f04 ; JUMP
064EA2  C7 46 EE 02 00        MOV    word ptr [bp - 0x12], 2 ; LOCAL_STORE
064EA7  FF 4E F0              DEC    word ptr [bp - 0x10] ; ARITH
064EAA  EB 58                 JMP    0x64f04 ; JUMP
064EAC  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0 ; LOCAL_STORE
064EB1  EB 51                 JMP    0x64f04 ; JUMP
064EB3  90                    NOP ; NOP
064EB4  FF 36 B6 85           PUSH   word ptr [0x85b6] ; PUSH_GLOBAL
064EB8  FF 36 B4 85           PUSH   word ptr [0x85b4] ; PUSH_GLOBAL
064EBC  FF 36 B2 85           PUSH   word ptr [0x85b2] ; PUSH_GLOBAL
064EC0  FF 36 B0 85           PUSH   word ptr [0x85b0] ; PUSH_GLOBAL
064EC4  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
064EC7  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
064ECA  BB 02 00              MOV    bx, 2 ; MOV
064ECD  9A 72 08 1F 1A        LCALL  0x1a1f, 0x872 ; THUNK -> 0x0BB9:0x000A (thunk @file 0x01CE62 type B)
064ED2  EB 30                 JMP    0x64f04 ; JUMP
064ED4  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
064ED8  7E 2A                 JLE    0x64f04 ; CJUMP
064EDA  0B C0                 OR     ax, ax ; LOGIC
064EDC  74 6A                 JE     0x64f48 ; CJUMP
064EDE  48                    DEC    ax ; ARITH
064EDF  48                    DEC    ax ; ARITH
064EE0  74 8F                 JE     0x64e71 ; CJUMP
064EE2  48                    DEC    ax ; ARITH
064EE3  74 5B                 JE     0x64f40 ; CJUMP
064EE5  48                    DEC    ax ; ARITH
064EE6  74 3C                 JE     0x64f24 ; CJUMP
064EE8  48                    DEC    ax ; ARITH
064EE9  75 19                 JNE    0x64f04 ; CJUMP
064EEB  83 6E F0 02           SUB    word ptr [bp - 0x10], 2 ; ARITH
064EEF  6A 03                 PUSH   3 ; STACK_PUSH
064EF1  6A 00                 PUSH   0 ; STACK_PUSH
064EF3  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064EF8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064EFB  0B C0                 OR     ax, ax ; LOGIC
064EFD  75 05                 JNE    0x64f04 ; CJUMP
064EFF  C7 46 EE 07 00        MOV    word ptr [bp - 0x12], 7 ; LOCAL_STORE
064F04  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
064F08  7E 46                 JLE    0x64f50 ; CJUMP
064F0A  A1 84 1E              MOV    ax, word ptr [0x1e84] ; GLOBAL_LOAD
064F0D  D1 E0                 SHL    ax, 1 ; LOGIC
064F0F  2D 07 00              SUB    ax, 7 ; ARITH
064F12  F7 D8                 NEG    ax ; ARITH
064F14  50                    PUSH   ax ; STACK_PUSH
064F15  6A 01                 PUSH   1 ; STACK_PUSH
064F17  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064F1C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064F1F  29 46 F0              SUB    word ptr [bp - 0x10], ax ; ARITH
064F22  EB 35                 JMP    0x64f59 ; JUMP
064F24  83 6E F0 02           SUB    word ptr [bp - 0x10], 2 ; ARITH
064F28  6A 03                 PUSH   3 ; STACK_PUSH
064F2A  6A 00                 PUSH   0 ; STACK_PUSH
064F2C  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064F31  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064F34  0B C0                 OR     ax, ax ; LOGIC
064F36  75 CC                 JNE    0x64f04 ; CJUMP
064F38  C7 46 EE 06 00        MOV    word ptr [bp - 0x12], 6 ; LOCAL_STORE
064F3D  EB C5                 JMP    0x64f04 ; JUMP
064F3F  90                    NOP ; NOP
064F40  C7 46 EE 04 00        MOV    word ptr [bp - 0x12], 4 ; LOCAL_STORE
064F45  EB BD                 JMP    0x64f04 ; JUMP
064F47  90                    NOP ; NOP
064F48  C7 46 EE 02 00        MOV    word ptr [bp - 0x12], 2 ; LOCAL_STORE
064F4D  EB B5                 JMP    0x64f04 ; JUMP
064F4F  90                    NOP ; NOP
064F50  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
064F54  7D 03                 JGE    0x64f59 ; CJUMP
064F56  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
064F59  FF 36 AE 85           PUSH   word ptr [0x85ae] ; PUSH_GLOBAL
064F5D  FF 36 AC 85           PUSH   word ptr [0x85ac] ; PUSH_GLOBAL
064F61  FF 36 AA 85           PUSH   word ptr [0x85aa] ; PUSH_GLOBAL
064F65  FF 36 A8 85           PUSH   word ptr [0x85a8] ; PUSH_GLOBAL
064F69  8A 5E EA              MOV    bl, byte ptr [bp - 0x16] ; LOCAL_LOAD
064F6C  81 E3 E0 00           AND    bx, 0xe0 ; LOGIC
064F70  0B 5E EE              OR     bx, word ptr [bp - 0x12] ; LOGIC
064F73  89 5E EA              MOV    word ptr [bp - 0x16], bx ; LOCAL_STORE
064F76  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
064F79  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
064F7C  9A 72 08 1F 1A        LCALL  0x1a1f, 0x872 ; THUNK -> 0x0BB9:0x000A (thunk @file 0x01CE62 type B)
064F81  FF 46 E2              INC    word ptr [bp - 0x1e] ; ARITH
064F84  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
064F87  39 46 E2              CMP    word ptr [bp - 0x1e], ax ; CMP
064F8A  7D 46                 JGE    0x64fd2 ; CJUMP
064F8C  FF 36 AE 85           PUSH   word ptr [0x85ae] ; PUSH_GLOBAL
064F90  FF 36 AC 85           PUSH   word ptr [0x85ac] ; PUSH_GLOBAL
064F94  FF 36 AA 85           PUSH   word ptr [0x85aa] ; PUSH_GLOBAL
064F98  FF 36 A8 85           PUSH   word ptr [0x85a8] ; PUSH_GLOBAL
064F9C  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
064F9F  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
064FA2  9A 68 08 1F 1A        LCALL  0x1a1f, 0x868 ; THUNK -> 0x0BBB:0x0006 (thunk @file 0x01CE58 type B)
064FA7  2A E4                 SUB    ah, ah ; ARITH
064FA9  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
064FAC  25 1F 00              AND    ax, 0x1f ; LOGIC
064FAF  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
064FB2  83 7E EA 19           CMP    word ptr [bp - 0x16], 0x19 ; CMP
064FB6  74 03                 JE     0x64fbb ; CJUMP
064FB8  E9 83 FE              JMP    0x64e3e ; JUMP
064FBB  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
064FBE  C1 F8 02              SAR    ax, 2 ; LOGIC
064FC1  2B 46 FA              SUB    ax, word ptr [bp - 6] ; ARITH
064FC4  89 46 CE              MOV    word ptr [bp - 0x32], ax ; LOCAL_STORE
064FC7  0B C0                 OR     ax, ax ; LOGIC
064FC9  7F 03                 JG     0x64fce ; CJUMP
064FCB  E9 50 FE              JMP    0x64e1e ; JUMP
064FCE  E9 59 FE              JMP    0x64e2a ; JUMP
064FD1  90                    NOP ; NOP
064FD2  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
064FD7  48                    DEC    ax ; ARITH
064FD8  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
064FDB  E9 D0 00              JMP    0x650ae ; JUMP
064FDE  F6 46 EA 80           TEST   byte ptr [bp - 0x16], 0x80 ; LOGIC
064FE2  74 06                 JE     0x64fea ; CJUMP
064FE4  83 6E F0 03           SUB    word ptr [bp - 0x10], 3 ; ARITH
064FE8  EB 70                 JMP    0x6505a ; JUMP
064FEA  F6 46 EA 20           TEST   byte ptr [bp - 0x16], 0x20 ; LOGIC
064FEE  74 06                 JE     0x64ff6 ; CJUMP
064FF0  80 66 EA 5F           AND    byte ptr [bp - 0x16], 0x5f ; LOGIC
064FF4  EB 64                 JMP    0x6505a ; JUMP
064FF6  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
064FFA  7C 5E                 JL     0x6505a ; CJUMP
064FFC  7E 5C                 JLE    0x6505a ; CJUMP
064FFE  EB 40                 JMP    0x65040 ; JUMP
065000  83 6E F0 02           SUB    word ptr [bp - 0x10], 2 ; ARITH
065004  C7 46 EE 07 00        MOV    word ptr [bp - 0x12], 7 ; LOCAL_STORE
065009  EB 4F                 JMP    0x6505a ; JUMP
06500B  90                    NOP ; NOP
06500C  83 6E F0 02           SUB    word ptr [bp - 0x10], 2 ; ARITH
065010  6A 01                 PUSH   1 ; STACK_PUSH
065012  6A 00                 PUSH   0 ; STACK_PUSH
065014  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
065019  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06501C  0B C0                 OR     ax, ax ; LOGIC
06501E  75 3A                 JNE    0x6505a ; CJUMP
065020  C7 46 EE 06 00        MOV    word ptr [bp - 0x12], 6 ; LOCAL_STORE
065025  EB 33                 JMP    0x6505a ; JUMP
065027  90                    NOP ; NOP
065028  C7 46 EE 04 00        MOV    word ptr [bp - 0x12], 4 ; LOCAL_STORE
06502D  EB 2B                 JMP    0x6505a ; JUMP
06502F  90                    NOP ; NOP
065030  C7 46 EE 03 00        MOV    word ptr [bp - 0x12], 3 ; LOCAL_STORE
065035  EB 23                 JMP    0x6505a ; JUMP
065037  90                    NOP ; NOP
065038  C7 46 EE 02 00        MOV    word ptr [bp - 0x12], 2 ; LOCAL_STORE
06503D  EB 1B                 JMP    0x6505a ; JUMP
06503F  90                    NOP ; NOP
065040  3D 05 00              CMP    ax, 5 ; CMP
065043  77 15                 JA     0x6505a ; CJUMP
065045  D1 E0                 SHL    ax, 1 ; LOGIC
065047  93                    XCHG   bx, ax ; MOV
065048  2E FF A7 FE 0E        JMP    word ptr cs:[bx + 0xefe] ; JUMP
06504D  90                    NOP ; NOP
06504E  E8 0E E0              CALL   0x6305f ; CALL_NEAR
065051  0E                    PUSH   cs ; STACK_PUSH
065052  E0 0E                 LOOPNE 0x65062 ; CJUMP
065054  D8 0E BC 0E           FMUL   dword ptr [0xebc]            ; UNKNOWN
065058  B0 0E                 MOV    al, 0xe ; CONST_LOAD
06505A  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
06505E  7E 1A                 JLE    0x6507a ; CJUMP
065060  A1 84 1E              MOV    ax, word ptr [0x1e84] ; GLOBAL_LOAD
065063  D1 E0                 SHL    ax, 1 ; LOGIC
065065  2D 07 00              SUB    ax, 7 ; ARITH
065068  F7 D8                 NEG    ax ; ARITH
06506A  50                    PUSH   ax ; STACK_PUSH
06506B  6A 01                 PUSH   1 ; STACK_PUSH
06506D  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
065072  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
065075  29 46 F0              SUB    word ptr [bp - 0x10], ax ; ARITH
065078  EB 09                 JMP    0x65083 ; JUMP
06507A  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
06507E  7D 03                 JGE    0x65083 ; CJUMP
065080  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
065083  FF 36 AE 85           PUSH   word ptr [0x85ae] ; PUSH_GLOBAL
065087  FF 36 AC 85           PUSH   word ptr [0x85ac] ; PUSH_GLOBAL
06508B  FF 36 AA 85           PUSH   word ptr [0x85aa] ; PUSH_GLOBAL
06508F  FF 36 A8 85           PUSH   word ptr [0x85a8] ; PUSH_GLOBAL
065093  8A 5E EA              MOV    bl, byte ptr [bp - 0x16] ; LOCAL_LOAD
065096  81 E3 E0 00           AND    bx, 0xe0 ; LOGIC
06509A  0B 5E EE              OR     bx, word ptr [bp - 0x12] ; LOGIC
06509D  89 5E EA              MOV    word ptr [bp - 0x16], bx ; LOCAL_STORE
0650A0  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
0650A3  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
0650A6  9A 72 08 1F 1A        LCALL  0x1a1f, 0x872 ; THUNK -> 0x0BB9:0x000A (thunk @file 0x01CE62 type B)
0650AB  FF 4E E2              DEC    word ptr [bp - 0x1e] ; ARITH
0650AE  83 7E E2 00           CMP    word ptr [bp - 0x1e], 0 ; CMP
0650B2  7C 3E                 JL     0x650f2 ; CJUMP
0650B4  FF 36 AE 85           PUSH   word ptr [0x85ae] ; PUSH_GLOBAL
0650B8  FF 36 AC 85           PUSH   word ptr [0x85ac] ; PUSH_GLOBAL
0650BC  FF 36 AA 85           PUSH   word ptr [0x85aa] ; PUSH_GLOBAL
0650C0  FF 36 A8 85           PUSH   word ptr [0x85a8] ; PUSH_GLOBAL
0650C4  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
0650C7  8B 56 DC              MOV    dx, word ptr [bp - 0x24] ; LOCAL_LOAD
0650CA  9A 68 08 1F 1A        LCALL  0x1a1f, 0x868 ; THUNK -> 0x0BBB:0x0006 (thunk @file 0x01CE58 type B)
0650CF  2A E4                 SUB    ah, ah ; ARITH
0650D1  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
0650D4  25 1F 00              AND    ax, 0x1f ; LOGIC
0650D7  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
0650DA  3D 19 00              CMP    ax, 0x19 ; CMP
0650DD  74 03                 JE     0x650e2 ; CJUMP
0650DF  E9 FC FE              JMP    0x64fde ; JUMP
0650E2  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
0650E5  D1 F8                 SAR    ax, 1 ; LOGIC
0650E7  03 06 84 1E           ADD    ax, word ptr [0x1e84] ; ARITH
0650EB  3B 46 F0              CMP    ax, word ptr [bp - 0x10] ; CMP
0650EE  7E 93                 JLE    0x65083 ; CJUMP
0650F0  EB 8E                 JMP    0x65080 ; JUMP
0650F2  9A AC 03 1F 18        LCALL  0x181f, 0x3ac ; THUNK -> 0x0262:0x02FE (thunk @file 0x01A99C type B) overlay @file 0x02202E
0650F7  FF 46 DC              INC    word ptr [bp - 0x24] ; ARITH
0650FA  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
0650FD  39 46 DC              CMP    word ptr [bp - 0x24], ax ; CMP
065100  7D 12                 JGE    0x65114 ; CJUMP
065102  D1 F8                 SAR    ax, 1 ; LOGIC
065104  2B 46 DC              SUB    ax, word ptr [bp - 0x24] ; ARITH
065107  89 46 CE              MOV    word ptr [bp - 0x32], ax ; LOCAL_STORE
06510A  0B C0                 OR     ax, ax ; LOGIC
06510C  7F 03                 JG     0x65111 ; CJUMP
06510E  E9                    DB     0xE9 ; DATA_BYTE
06510F  C3                    DB     0xC3 ; DATA_BYTE
