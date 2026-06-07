; ============================================================================
; func_0749E0_unknown
; Region   : overlay
; Bytes    : file 0x0749E0..0x074C39  (601 bytes)
; Purpose  : NAMES.TXT loader  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "SEASONS", "UNFORESTED", "FORESTED"  (auto-named via string xrefs)
; ============================================================================

0749E0  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
0749E4  57                    PUSH   di ; STACK_PUSH
0749E5  56                    PUSH   si ; STACK_PUSH
0749E6  6A 00                 PUSH   0 ; STACK_PUSH
0749E8  68 2C 1A              PUSH   0x1a2c ; PUSH_CONST
0749EB  9A 0E 00 1F 18        LCALL  0x181f, 0xe ; THUNK -> 0x0000:0x0000 (thunk @file 0x01A5FE type B) overlay @file 0x025900
0749F0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0749F3  68 AC 21              PUSH   0x21ac                       ; STRING: "SEASONS"
0749F6  68 82 08              PUSH   0x882                        ; STRING: "NAMES"
0749F9  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
0749FE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074A01  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074A06  9A 1C 09 1F 19        LCALL  0x191f, 0x91c ; THUNK -> 0x0000:0x0106 (thunk @file 0x01BF0C type A) overlay @file 0x025A06
074A0B  9A 22 0B 1F 1A        LCALL  0x1a1f, 0xb22 ; THUNK -> 0x0000:0x01C8 (thunk @file 0x01D112 type A) overlay @file 0x025AC8
074A10  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
074A13  D1 E3                 SHL    bx, 1 ; LOGIC
074A15  89 87 00 98           MOV    word ptr [bx - 0x6800], ax ; MOV
074A19  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
074A1C  83 7E F8 02           CMP    word ptr [bp - 8], 2 ; CMP
074A20  7C E4                 JL     0x74a06 ; CJUMP
074A22  68 B4 21              PUSH   0x21b4                       ; STRING: "UNFORESTED"
074A25  6A 00                 PUSH   0 ; STACK_PUSH
074A27  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
074A2C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074A2F  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074A34  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
074A37  0E                    PUSH   cs ; STACK_PUSH
074A38  E8 44 19              CALL   0x7637f ; CALL_NEAR
074A3B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
074A3E  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
074A41  83 7E F8 08           CMP    word ptr [bp - 8], 8 ; CMP
074A45  7C ED                 JL     0x74a34 ; CJUMP
074A47  68 BF 21              PUSH   0x21bf                       ; STRING: "FORESTED"
074A4A  6A 00                 PUSH   0 ; STACK_PUSH
074A4C  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
074A51  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074A54  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074A59  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
074A5C  05 08 00              ADD    ax, 8 ; ARITH
074A5F  50                    PUSH   ax ; STACK_PUSH
074A60  0E                    PUSH   cs ; STACK_PUSH
074A61  E8 1B 19              CALL   0x7637f ; CALL_NEAR
074A64  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
074A67  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
074A6A  C1 E3 04              SHL    bx, 4 ; LOGIC
074A6D  8D BF 74 30           LEA    di, [bx + 0x3074] ; ADDR
074A71  8D B7 F4 2F           LEA    si, [bx + 0x2ff4] ; ADDR
074A75  8C D8                 MOV    ax, ds ; MOV
074A77  8E C0                 MOV    es, ax ; MOV
074A79  B9 08 00              MOV    cx, 8 ; MOV
074A7C  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
074A7E  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
074A81  83 7E F8 08           CMP    word ptr [bp - 8], 8 ; CMP
074A85  7C D2                 JL     0x74a59 ; CJUMP
074A87  68 C8 21              PUSH   0x21c8                       ; STRING: "OTHER"
074A8A  6A 00                 PUSH   0 ; STACK_PUSH
074A8C  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
074A91  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074A94  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074A99  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
074A9C  05 18 00              ADD    ax, 0x18 ; ARITH
074A9F  50                    PUSH   ax ; STACK_PUSH
074AA0  0E                    PUSH   cs ; STACK_PUSH
074AA1  E8 DB 18              CALL   0x7637f ; CALL_NEAR
074AA4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
074AA7  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
074AAA  83 7E F8 05           CMP    word ptr [bp - 8], 5 ; CMP
074AAE  7C E9                 JL     0x74a99 ; CJUMP
074AB0  68 CE 21              PUSH   0x21ce                       ; STRING: "OTHER_NAMES"
074AB3  6A 00                 PUSH   0 ; STACK_PUSH
074AB5  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
074ABA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074ABD  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074AC2  9A 1C 09 1F 19        LCALL  0x191f, 0x91c ; THUNK -> 0x0000:0x0106 (thunk @file 0x01BF0C type A) overlay @file 0x025A06
074AC7  9A 22 0B 1F 1A        LCALL  0x1a1f, 0xb22 ; THUNK -> 0x0000:0x01C8 (thunk @file 0x01D112 type A) overlay @file 0x025AC8
074ACC  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
074ACF  D1 E3                 SHL    bx, 1 ; LOGIC
074AD1  89 87 B0 2D           MOV    word ptr [bx + 0x2db0], ax ; MOV
074AD5  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
074AD8  83 7E F8 05           CMP    word ptr [bp - 8], 5 ; CMP
074ADC  7C E4                 JL     0x74ac2 ; CJUMP
074ADE  68 DA 21              PUSH   0x21da                       ; STRING: "RESOURCE"
074AE1  6A 00                 PUSH   0 ; STACK_PUSH
074AE3  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
074AE8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074AEB  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074AF0  9A 1C 09 1F 19        LCALL  0x191f, 0x91c ; THUNK -> 0x0000:0x0106 (thunk @file 0x01BF0C type A) overlay @file 0x025A06
074AF5  9A 22 0B 1F 1A        LCALL  0x1a1f, 0xb22 ; THUNK -> 0x0000:0x01C8 (thunk @file 0x01D112 type A) overlay @file 0x025AC8
074AFA  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
074AFD  D1 E3                 SHL    bx, 1 ; LOGIC
074AFF  89 87 0C 93           MOV    word ptr [bx - 0x6cf4], ax ; MOV
074B03  9A 8A 08 1F 1A        LCALL  0x1a1f, 0x88a ; THUNK -> 0x0000:0x0198 (thunk @file 0x01CE7A type A) overlay @file 0x025A98
074B08  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
074B0B  88 87 B2 97           MOV    byte ptr [bx - 0x684e], al ; MOV
074B0F  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
074B12  83 7E F8 0E           CMP    word ptr [bp - 8], 0xe ; CMP
074B16  7C D8                 JL     0x74af0 ; CJUMP
074B18  68 E3 21              PUSH   0x21e3                       ; STRING: "COUNTRY"
074B1B  6A 00                 PUSH   0 ; STACK_PUSH
074B1D  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
074B22  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074B25  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074B2A  9A 1C 09 1F 19        LCALL  0x191f, 0x91c ; THUNK -> 0x0000:0x0106 (thunk @file 0x01BF0C type A) overlay @file 0x025A06
074B2F  9A 22 0B 1F 1A        LCALL  0x1a1f, 0xb22 ; THUNK -> 0x0000:0x01C8 (thunk @file 0x01D112 type A) overlay @file 0x025AC8
074B34  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
074B37  D1 E3                 SHL    bx, 1 ; LOGIC
074B39  89 87 42 8D           MOV    word ptr [bx - 0x72be], ax ; MOV
074B3D  9A 8A 08 1F 1A        LCALL  0x1a1f, 0x88a ; THUNK -> 0x0000:0x0198 (thunk @file 0x01CE7A type A) overlay @file 0x025A98
074B42  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
074B45  88 87 48 08           MOV    byte ptr [bx + 0x848], al ; MOV
074B49  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
074B4C  83 7E F8 04           CMP    word ptr [bp - 8], 4 ; CMP
074B50  7C D8                 JL     0x74b2a ; CJUMP
074B52  68 EB 21              PUSH   0x21eb                       ; STRING: "NATIONALITY"
074B55  6A 00                 PUSH   0 ; STACK_PUSH
074B57  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
074B5C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074B5F  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074B64  9A 16 0B 1F 1A        LCALL  0x1a1f, 0xb16 ; THUNK -> 0x0000:0x01B6 (thunk @file 0x01D106 type A) overlay @file 0x025AB6
074B69  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
074B6C  D1 E3                 SHL    bx, 1 ; LOGIC
074B6E  89 87 0A 8D           MOV    word ptr [bx - 0x72f6], ax ; MOV
074B72  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
074B75  83 7E F8 04           CMP    word ptr [bp - 8], 4 ; CMP
074B79  7C E9                 JL     0x74b64 ; CJUMP
074B7B  68 F7 21              PUSH   0x21f7                       ; STRING: "NATIONABBREV"
074B7E  6A 00                 PUSH   0 ; STACK_PUSH
074B80  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
074B85  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074B88  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074B8D  9A 16 0B 1F 1A        LCALL  0x1a1f, 0xb16 ; THUNK -> 0x0000:0x01B6 (thunk @file 0x01D106 type A) overlay @file 0x025AB6
074B92  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
074B95  D1 E3                 SHL    bx, 1 ; LOGIC
074B97  89 87 F0 97           MOV    word ptr [bx - 0x6810], ax ; MOV
074B9B  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
074B9E  83 7E F8 04           CMP    word ptr [bp - 8], 4 ; CMP
074BA2  7C E9                 JL     0x74b8d ; CJUMP
074BA4  68 04 22              PUSH   0x2204                       ; STRING: "HOMEPORT"
074BA7  6A 00                 PUSH   0 ; STACK_PUSH
074BA9  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
074BAE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074BB1  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074BB6  9A 16 0B 1F 1A        LCALL  0x1a1f, 0xb16 ; THUNK -> 0x0000:0x01B6 (thunk @file 0x01D106 type A) overlay @file 0x025AB6
074BBB  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
074BBE  D1 E3                 SHL    bx, 1 ; LOGIC
074BC0  89 87 8C 83           MOV    word ptr [bx - 0x7c74], ax ; MOV
074BC4  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
074BC7  83 7E F8 04           CMP    word ptr [bp - 8], 4 ; CMP
074BCB  7C E9                 JL     0x74bb6 ; CJUMP
074BCD  68 0D 22              PUSH   0x220d                       ; STRING: "COLONYNAME"
074BD0  6A 00                 PUSH   0 ; STACK_PUSH
074BD2  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
074BD7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074BDA  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074BDF  9A 1C 09 1F 19        LCALL  0x191f, 0x91c ; THUNK -> 0x0000:0x0106 (thunk @file 0x01BF0C type A) overlay @file 0x025A06
074BE4  1E                    PUSH   ds ; STACK_PUSH
074BE5  50                    PUSH   ax ; STACK_PUSH
074BE6  6B 46 F8 34           IMUL   ax, word ptr [bp - 8], 0x34 ; ARITH
074BEA  05 26 54              ADD    ax, 0x5426 ; ARITH
074BED  1E                    PUSH   ds ; STACK_PUSH
074BEE  50                    PUSH   ax ; STACK_PUSH
074BEF  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
074BF4  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
074BF7  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
074BFA  83 7E F8 04           CMP    word ptr [bp - 8], 4 ; CMP
074BFE  7C DF                 JL     0x74bdf ; CJUMP
074C00  68 18 22              PUSH   0x2218                       ; STRING: "LEADERNAME"
074C03  6A 00                 PUSH   0 ; STACK_PUSH
074C05  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
074C0A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
074C0D  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
074C12  9A 1C 09 1F 19        LCALL  0x191f, 0x91c ; THUNK -> 0x0000:0x0106 (thunk @file 0x01BF0C type A) overlay @file 0x025A06
074C17  9A C4 0F 1F 19        LCALL  0x191f, 0xfc4 ; THUNK -> 0x0000:0x015E (thunk @file 0x01C5B4 type A) overlay @file 0x025A5E
074C1C  1E                    PUSH   ds ; STACK_PUSH
074C1D  50                    PUSH   ax ; STACK_PUSH
074C1E  6B 46 F8 34           IMUL   ax, word ptr [bp - 8], 0x34 ; ARITH
074C22  05 0E 54              ADD    ax, 0x540e ; ARITH
074C25  1E                    PUSH   ds ; STACK_PUSH
074C26  50                    PUSH   ax ; STACK_PUSH
074C27  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
074C2C  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
074C2F  9A 8A 08 1F 1A        LCALL  0x1a1f, 0x88a ; THUNK -> 0x0000:0x0198 (thunk @file 0x01CE7A type A) overlay @file 0x025A98
074C34  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
074C37  8B CB                 MOV    cx, bx ; MOV
