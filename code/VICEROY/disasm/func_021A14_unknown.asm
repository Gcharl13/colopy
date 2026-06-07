; ============================================================================
; func_021A14_unknown
; Region   : overlay
; Bytes    : file 0x021A14..0x021C6E  (602 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021A14  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
021A18  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
021A1B  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
021A1E  83 3E 90 53 00        CMP    word ptr [0x5390], 0 ; CMP
021A23  74 03                 JE     0x21a28 ; CJUMP
021A25  E9 07 03              JMP    0x21d2f ; JUMP
021A28  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021A2C  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021A30  9A 5E 01 1F 19        LCALL  0x191f, 0x15e ; THUNK -> 0x0000:0x0582 (thunk @file 0x01B74E type A) overlay @file 0x025E82
021A35  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
021A38  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021A3C  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021A40  9A 52 01 1F 19        LCALL  0x191f, 0x152 ; THUNK -> 0x0000:0x05F6 (thunk @file 0x01B742 type A) overlay @file 0x025EF6
021A45  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
021A48  6B 5E F4 1C           IMUL   bx, word ptr [bp - 0xc], 0x1c ; ARITH
021A4C  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
021A50  2A E4                 SUB    ah, ah ; ARITH
021A52  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
021A55  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
021A59  2A ED                 SUB    ch, ch ; ARITH
021A5B  89 4E F8              MOV    word ptr [bp - 8], cx ; LOCAL_STORE
021A5E  51                    PUSH   cx ; STACK_PUSH
021A5F  50                    PUSH   ax ; STACK_PUSH
021A60  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
021A65  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
021A68  88 46 FC              MOV    byte ptr [bp - 4], al ; LOCAL_STORE
021A6B  2B C0                 SUB    ax, ax ; ARITH
021A6D  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
021A70  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
021A73  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
021A76  9A 78 0B 1F 18        LCALL  0x181f, 0xb78 ; THUNK -> 0x05EB:0x0902 (thunk @file 0x01B168 type B) overlay @file 0x0278F2
021A7B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
021A7E  0B C0                 OR     ax, ax ; LOGIC
021A80  7C 12                 JL     0x21a94 ; CJUMP
021A82  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
021A85  50                    PUSH   ax ; STACK_PUSH
021A86  8D 46 F6              LEA    ax, [bp - 0xa] ; ADDR
021A89  50                    PUSH   ax ; STACK_PUSH
021A8A  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
021A8D  0E                    PUSH   cs ; STACK_PUSH
021A8E  E8 37 31              CALL   0x24bc8 ; CALL_NEAR
021A91  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
021A94  6A 01                 PUSH   1 ; STACK_PUSH
021A96  68 17 03              PUSH   0x317 ; PUSH_CONST
021A99  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021A9D  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021AA1  9A 3A 01 1F 19        LCALL  0x191f, 0x13a ; THUNK -> 0x0000:0x05C6 (thunk @file 0x01B72A type A) overlay @file 0x025EC6
021AA6  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021AA9  83 7E F6 00           CMP    word ptr [bp - 0xa], 0 ; CMP
021AAD  75 1D                 JNE    0x21acc ; CJUMP
021AAF  6A 01                 PUSH   1 ; STACK_PUSH
021AB1  68 10 03              PUSH   0x310 ; PUSH_CONST
021AB4  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021AB8  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021ABC  9A 3A 01 1F 19        LCALL  0x191f, 0x13a ; THUNK -> 0x0000:0x05C6 (thunk @file 0x01B72A type A) overlay @file 0x025EC6
021AC1  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021AC4  6A 01                 PUSH   1 ; STACK_PUSH
021AC6  68 11 03              PUSH   0x311 ; PUSH_CONST
021AC9  EB 18                 JMP    0x21ae3 ; JUMP
021ACB  90                    NOP ; NOP
021ACC  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
021ACF  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
021AD2  9A BE 07 1F 18        LCALL  0x181f, 0x7be ; THUNK -> 0x05EB:0x0A76 (thunk @file 0x01ADAE type B) overlay @file 0x027A66
021AD7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
021ADA  0B C0                 OR     ax, ax ; LOGIC
021ADC  7C 14                 JL     0x21af2 ; CJUMP
021ADE  6A 01                 PUSH   1 ; STACK_PUSH
021AE0  68 10 03              PUSH   0x310 ; PUSH_CONST
021AE3  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021AE7  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021AEB  9A 3A 01 1F 19        LCALL  0x191f, 0x13a ; THUNK -> 0x0000:0x05C6 (thunk @file 0x01B72A type A) overlay @file 0x025EC6
021AF0  EB 32                 JMP    0x21b24 ; JUMP
021AF2  6A 01                 PUSH   1 ; STACK_PUSH
021AF4  68 11 03              PUSH   0x311 ; PUSH_CONST
021AF7  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021AFB  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021AFF  9A 3A 01 1F 19        LCALL  0x191f, 0x13a ; THUNK -> 0x0000:0x05C6 (thunk @file 0x01B72A type A) overlay @file 0x025EC6
021B04  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021B07  6B 5E F4 1C           IMUL   bx, word ptr [bp - 0xc], 0x1c ; ARITH
021B0B  80 BF 5B 31 1B        CMP    byte ptr [bx + 0x315b], 0x1b ; CMP
021B10  75 15                 JNE    0x21b27 ; CJUMP
021B12  6A 01                 PUSH   1 ; STACK_PUSH
021B14  68 10 03              PUSH   0x310 ; PUSH_CONST
021B17  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021B1B  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021B1F  9A 46 01 1F 19        LCALL  0x191f, 0x146 ; THUNK -> 0x0000:0x0552 (thunk @file 0x01B736 type A) overlay @file 0x025E52
021B24  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021B27  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
021B2B  75 3F                 JNE    0x21b6c ; CJUMP
021B2D  6A 01                 PUSH   1 ; STACK_PUSH
021B2F  68 12 03              PUSH   0x312 ; PUSH_CONST
021B32  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021B36  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021B3A  9A 46 01 1F 19        LCALL  0x191f, 0x146 ; THUNK -> 0x0000:0x0552 (thunk @file 0x01B736 type A) overlay @file 0x025E52
021B3F  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021B42  6A 01                 PUSH   1 ; STACK_PUSH
021B44  68 13 03              PUSH   0x313 ; PUSH_CONST
021B47  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021B4B  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021B4F  9A 46 01 1F 19        LCALL  0x191f, 0x146 ; THUNK -> 0x0000:0x0552 (thunk @file 0x01B736 type A) overlay @file 0x025E52
021B54  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021B57  6A 01                 PUSH   1 ; STACK_PUSH
021B59  68 14 03              PUSH   0x314 ; PUSH_CONST
021B5C  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021B60  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021B64  9A 46 01 1F 19        LCALL  0x191f, 0x146 ; THUNK -> 0x0000:0x0552 (thunk @file 0x01B736 type A) overlay @file 0x025E52
021B69  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021B6C  80 7E FC 08           CMP    byte ptr [bp - 4], 8 ; CMP
021B70  72 06                 JB     0x21b78 ; CJUMP
021B72  80 7E FC 10           CMP    byte ptr [bp - 4], 0x10 ; CMP
021B76  72 0C                 JB     0x21b84 ; CJUMP
021B78  80 7E FC 10           CMP    byte ptr [bp - 4], 0x10 ; CMP
021B7C  72 0E                 JB     0x21b8c ; CJUMP
021B7E  80 7E FC 18           CMP    byte ptr [bp - 4], 0x18 ; CMP
021B82  73 08                 JAE    0x21b8c ; CJUMP
021B84  6A 01                 PUSH   1 ; STACK_PUSH
021B86  68 13 03              PUSH   0x313 ; PUSH_CONST
021B89  EB 06                 JMP    0x21b91 ; JUMP
021B8B  90                    NOP ; NOP
021B8C  6A 01                 PUSH   1 ; STACK_PUSH
021B8E  68 12 03              PUSH   0x312 ; PUSH_CONST
021B91  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021B95  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021B99  9A 3A 01 1F 19        LCALL  0x191f, 0x13a ; THUNK -> 0x0000:0x05C6 (thunk @file 0x01B72A type A) overlay @file 0x025EC6
021B9E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021BA1  80 7E FC 1B           CMP    byte ptr [bp - 4], 0x1b ; CMP
021BA5  74 06                 JE     0x21bad ; CJUMP
021BA7  80 7E FC 1C           CMP    byte ptr [bp - 4], 0x1c ; CMP
021BAB  75 2A                 JNE    0x21bd7 ; CJUMP
021BAD  6A 01                 PUSH   1 ; STACK_PUSH
021BAF  68 13 03              PUSH   0x313 ; PUSH_CONST
021BB2  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021BB6  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021BBA  9A 3A 01 1F 19        LCALL  0x191f, 0x13a ; THUNK -> 0x0000:0x05C6 (thunk @file 0x01B72A type A) overlay @file 0x025EC6
021BBF  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021BC2  6A 01                 PUSH   1 ; STACK_PUSH
021BC4  68 12 03              PUSH   0x312 ; PUSH_CONST
021BC7  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021BCB  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021BCF  9A 3A 01 1F 19        LCALL  0x191f, 0x13a ; THUNK -> 0x0000:0x05C6 (thunk @file 0x01B72A type A) overlay @file 0x025EC6
021BD4  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021BD7  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
021BDC  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
021BE1  72 3F                 JB     0x21c22 ; CJUMP
021BE3  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
021BE8  77 38                 JA     0x21c22 ; CJUMP
021BEA  80 7E FC 1A           CMP    byte ptr [bp - 4], 0x1a ; CMP
021BEE  74 15                 JE     0x21c05 ; CJUMP
021BF0  6A 01                 PUSH   1 ; STACK_PUSH
021BF2  68 23 03              PUSH   0x323 ; PUSH_CONST
021BF5  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021BF9  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021BFD  9A 46 01 1F 19        LCALL  0x191f, 0x146 ; THUNK -> 0x0000:0x0552 (thunk @file 0x01B736 type A) overlay @file 0x025E52
021C02  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021C05  6A 01                 PUSH   1 ; STACK_PUSH
021C07  68 21 03              PUSH   0x321 ; PUSH_CONST
021C0A  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021C0E  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021C12  9A 3A 01 1F 19        LCALL  0x191f, 0x13a ; THUNK -> 0x0000:0x05C6 (thunk @file 0x01B72A type A) overlay @file 0x025EC6
021C17  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021C1A  6A 01                 PUSH   1 ; STACK_PUSH
021C1C  68 02 03              PUSH   0x302 ; PUSH_CONST
021C1F  EB 30                 JMP    0x21c51 ; JUMP
021C21  90                    NOP ; NOP
021C22  6A 01                 PUSH   1 ; STACK_PUSH
021C24  68 23 03              PUSH   0x323 ; PUSH_CONST
021C27  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021C2B  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021C2F  9A 3A 01 1F 19        LCALL  0x191f, 0x13a ; THUNK -> 0x0000:0x05C6 (thunk @file 0x01B72A type A) overlay @file 0x025EC6
021C34  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021C37  6A 01                 PUSH   1 ; STACK_PUSH
021C39  68 20 03              PUSH   0x320 ; PUSH_CONST
021C3C  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021C40  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021C44  9A 3A 01 1F 19        LCALL  0x191f, 0x13a ; THUNK -> 0x0000:0x05C6 (thunk @file 0x01B72A type A) overlay @file 0x025EC6
021C49  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021C4C  6A 01                 PUSH   1 ; STACK_PUSH
021C4E  68 03 03              PUSH   0x303 ; PUSH_CONST
021C51  FF 36 98 08           PUSH   word ptr [0x898] ; PUSH_GLOBAL
021C55  FF 36 96 08           PUSH   word ptr [0x896] ; PUSH_GLOBAL
021C59  9A 3A 01 1F 19        LCALL  0x191f, 0x13a ; THUNK -> 0x0000:0x05C6 (thunk @file 0x01B72A type A) overlay @file 0x025EC6
021C5E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
021C61  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
021C66  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
021C6A  2A FF                 SUB    bh, bh ; ARITH
021C6C  8B C3                 MOV    ax, bx ; MOV
