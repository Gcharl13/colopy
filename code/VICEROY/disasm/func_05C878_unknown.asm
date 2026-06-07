; ============================================================================
; func_05C878_unknown
; Region   : overlay
; Bytes    : file 0x05C878..0x05CA7E  (518 bytes)
; Purpose  : Treasure cashed in  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "CASHTREASURE", "KINGGALLEON", "LOOTCASH"  (auto-named via string xrefs)
; ============================================================================

05C878  C8 5E 00 00           ENTER  0x5e, 0 ; PROLOGUE
05C87C  57                    PUSH   di ; STACK_PUSH
05C87D  56                    PUSH   si ; STACK_PUSH
05C87E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
05C882  B0 64                 MOV    al, 0x64 ; CONST_LOAD
05C884  F6 A7 5B 31           MUL    byte ptr [bx + 0x315b] ; ARITH
05C888  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
05C88B  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
05C890  74 28                 JE     0x5c8ba ; CJUMP
05C892  6A 00                 PUSH   0 ; STACK_PUSH
05C894  50                    PUSH   ax ; STACK_PUSH
05C895  6A 00                 PUSH   0 ; STACK_PUSH
05C897  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
05C89C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05C89F  6A 02                 PUSH   2 ; STACK_PUSH
05C8A1  68 E0 1B              PUSH   0x1be0                       ; STRING: "CASHTREASURE"
05C8A4  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
05C8A9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05C8AC  6A 02                 PUSH   2 ; STACK_PUSH
05C8AE  9A B6 04 1F 18        LCALL  0x181f, 0x4b6 ; THUNK -> 0x029F:0x034C (thunk @file 0x01AAA6 type B) overlay @file 0x022374
05C8B3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05C8B6  E9 9C 01              JMP    0x5ca55 ; JUMP
05C8B9  90                    NOP ; NOP
05C8BA  8A 1E A6 53           MOV    bl, byte ptr [0x53a6] ; GLOBAL_LOAD
05C8BE  2A FF                 SUB    bh, bh ; ARITH
05C8C0  D1 E3                 SHL    bx, 1 ; LOGIC
05C8C2  FF B7 94 83           PUSH   word ptr [bx - 0x7c6c] ; PUSH_GLOBAL
05C8C6  6A 00                 PUSH   0 ; STACK_PUSH
05C8C8  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
05C8CD  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05C8D0  6B 46 08 34           IMUL   ax, word ptr [bp + 8], 0x34 ; ARITH
05C8D4  05 0E 54              ADD    ax, 0x540e ; ARITH
05C8D7  1E                    PUSH   ds ; STACK_PUSH
05C8D8  50                    PUSH   ax ; STACK_PUSH
05C8D9  6A 01                 PUSH   1 ; STACK_PUSH
05C8DB  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
05C8E0  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05C8E3  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05C8E6  6A 00                 PUSH   0 ; STACK_PUSH
05C8E8  6A 02                 PUSH   2 ; STACK_PUSH
05C8EA  9A C8 0A 1F 19        LCALL  0x191f, 0xac8 ; THUNK -> 0x0000:0x0404 (thunk @file 0x01C0B8 type A) overlay @file 0x025D04
05C8EF  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05C8F2  69 5E 08 3C 01        IMUL   bx, word ptr [bp + 8], 0x13c ; ARITH
05C8F7  8A 87 09 88           MOV    al, byte ptr [bx - 0x77f7] ; MOV
05C8FB  98                    CWDE ; ARITH
05C8FC  99                    CDQ ; ARITH
05C8FD  52                    PUSH   dx ; STACK_PUSH
05C8FE  50                    PUSH   ax ; STACK_PUSH
05C8FF  6A 00                 PUSH   0 ; STACK_PUSH
05C901  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
05C906  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05C909  68 ED 1B              PUSH   0x1bed                       ; STRING: "KINGGALLEON"
05C90C  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
05C90F  50                    PUSH   ax ; STACK_PUSH
05C910  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
05C915  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05C918  6A 0A                 PUSH   0xa ; PUSH_CONST
05C91A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05C91D  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
05C922  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05C925  0B C0                 OR     ax, ax ; LOGIC
05C927  74 05                 JE     0x5c92e ; CJUMP
05C929  68 F9 1B              PUSH   0x1bf9 ; PUSH_CONST
05C92C  EB 03                 JMP    0x5c931 ; JUMP
05C92E  68 FB 1B              PUSH   0x1bfb ; PUSH_CONST
05C931  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
05C934  50                    PUSH   ax ; STACK_PUSH
05C935  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
05C93A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05C93D  6A 3E                 PUSH   0x3e ; PUSH_CONST
05C93F  9A 8E 04 1F 18        LCALL  0x181f, 0x48e ; THUNK -> 0x029F:0x02CC (thunk @file 0x01AA7E type B) overlay @file 0x0222F4
05C944  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05C947  8D 5E B0              LEA    bx, [bp - 0x50] ; ADDR
05C94A  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
05C94F  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
05C952  48                    DEC    ax ; ARITH
05C953  74 03                 JE     0x5c958 ; CJUMP
05C955  E9 22 01              JMP    0x5ca7a ; JUMP
05C958  69 5E 08 3C 01        IMUL   bx, word ptr [bp + 8], 0x13c ; ARITH
05C95D  8A 87 09 88           MOV    al, byte ptr [bx - 0x77f7] ; MOV
05C961  98                    CWDE ; ARITH
05C962  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
05C965  6A 0A                 PUSH   0xa ; PUSH_CONST
05C967  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05C96A  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
05C96F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05C972  0B C0                 OR     ax, ax ; LOGIC
05C974  75 1D                 JNE    0x5c993 ; CJUMP
05C976  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
05C979  2A E4                 SUB    ah, ah ; ARITH
05C97B  05 0A 00              ADD    ax, 0xa ; ARITH
05C97E  8B C8                 MOV    cx, ax ; MOV
05C980  C1 E0 02              SHL    ax, 2 ; LOGIC
05C983  03 C1                 ADD    ax, cx ; ARITH
05C985  D1 66 A8              SHL    word ptr [bp - 0x58], 1 ; LOGIC
05C988  3B 46 A8              CMP    ax, word ptr [bp - 0x58] ; CMP
05C98B  7D 03                 JGE    0x5c990 ; CJUMP
05C98D  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
05C990  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
05C993  6A 00                 PUSH   0 ; STACK_PUSH
05C995  6A 64                 PUSH   0x64 ; PUSH_CONST
05C997  8B 46 A6              MOV    ax, word ptr [bp - 0x5a] ; LOCAL_LOAD
05C99A  2B D2                 SUB    dx, dx ; ARITH
05C99C  52                    PUSH   dx ; STACK_PUSH
05C99D  50                    PUSH   ax ; STACK_PUSH
05C99E  8B C8                 MOV    cx, ax ; MOV
05C9A0  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
05C9A3  3D 5A 00              CMP    ax, 0x5a ; CMP
05C9A6  7E 03                 JLE    0x5c9ab ; CJUMP
05C9A8  B8 5A 00              MOV    ax, 0x5a ; CONST_LOAD
05C9AB  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
05C9AE  8B DA                 MOV    bx, dx ; MOV
05C9B0  99                    CDQ ; ARITH
05C9B1  52                    PUSH   dx ; STACK_PUSH
05C9B2  50                    PUSH   ax ; STACK_PUSH
05C9B3  8B F0                 MOV    si, ax ; MOV
05C9B5  8B F9                 MOV    di, cx ; MOV
05C9B7  89 76 A2              MOV    word ptr [bp - 0x5e], si ; LOCAL_STORE
05C9BA  89 56 A4              MOV    word ptr [bp - 0x5c], dx ; LOCAL_STORE
05C9BD  8B F3                 MOV    si, bx ; MOV
05C9BF  9A 60 0F 1D 0D        LCALL  0xd1d, 0xf60 ; LCALL
05C9C4  52                    PUSH   dx ; STACK_PUSH
05C9C5  50                    PUSH   ax ; STACK_PUSH
05C9C6  9A C6 0E 1D 0D        LCALL  0xd1d, 0xec6 ; LCALL
05C9CB  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
05C9CE  89 56 AC              MOV    word ptr [bp - 0x54], dx ; LOCAL_STORE
05C9D1  56                    PUSH   si ; STACK_PUSH
05C9D2  57                    PUSH   di ; STACK_PUSH
05C9D3  56                    PUSH   si ; STACK_PUSH
05C9D4  8B F0                 MOV    si, ax ; MOV
05C9D6  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
05C9DB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05C9DE  FF 76 A4              PUSH   word ptr [bp - 0x5c] ; PUSH_GLOBAL
05C9E1  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
05C9E4  6A 01                 PUSH   1 ; STACK_PUSH
05C9E6  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
05C9EB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05C9EE  8B C6                 MOV    ax, si ; MOV
05C9F0  29 46 A6              SUB    word ptr [bp - 0x5a], ax ; ARITH
05C9F3  6A 00                 PUSH   0 ; STACK_PUSH
05C9F5  FF 76 A6              PUSH   word ptr [bp - 0x5a] ; PUSH_GLOBAL
05C9F8  6A 02                 PUSH   2 ; STACK_PUSH
05C9FA  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
05C9FF  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05CA02  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05CA05  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
05CA0A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05CA0D  50                    PUSH   ax ; STACK_PUSH
05CA0E  6A 00                 PUSH   0 ; STACK_PUSH
05CA10  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
05CA15  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05CA18  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
05CA1B  D1 E3                 SHL    bx, 1 ; LOGIC
05CA1D  FF B7 8C 83           PUSH   word ptr [bx - 0x7c74] ; PUSH_GLOBAL
05CA21  6A 01                 PUSH   1 ; STACK_PUSH
05CA23  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
05CA28  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05CA2B  6A 02                 PUSH   2 ; STACK_PUSH
05CA2D  9A B6 04 1F 18        LCALL  0x181f, 0x4b6 ; THUNK -> 0x029F:0x034C (thunk @file 0x01AAA6 type B) overlay @file 0x022374
05CA32  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05CA35  6A 02                 PUSH   2 ; STACK_PUSH
05CA37  68 FD 1B              PUSH   0x1bfd                       ; STRING: "LOOTCASH"
05CA3A  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
05CA3F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05CA42  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
05CA45  8B 56 AC              MOV    dx, word ptr [bp - 0x54] ; LOCAL_LOAD
05CA48  69 5E 08 3C 01        IMUL   bx, word ptr [bp + 8], 0x13c ; ARITH
05CA4D  01 87 2A 88           ADD    word ptr [bx - 0x77d6], ax ; ARITH
05CA51  11 97 2C 88           ADC    word ptr [bx - 0x77d4], dx ; ARITH
05CA55  8B 46 A6              MOV    ax, word ptr [bp - 0x5a] ; LOCAL_LOAD
05CA58  2B D2                 SUB    dx, dx ; ARITH
05CA5A  69 5E 08 3C 01        IMUL   bx, word ptr [bp + 8], 0x13c ; ARITH
05CA5F  01 87 32 88           ADD    word ptr [bx - 0x77ce], ax ; ARITH
05CA63  11 97 34 88           ADC    word ptr [bx - 0x77cc], dx ; ARITH
05CA67  01 87 2E 88           ADD    word ptr [bx - 0x77d2], ax ; ARITH
05CA6B  11 97 30 88           ADC    word ptr [bx - 0x77d0], dx ; ARITH
05CA6F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05CA72  9A 08 08 1F 18        LCALL  0x181f, 0x808 ; THUNK -> 0x0427:0x0824 (thunk @file 0x01ADF8 type B) overlay @file 0x031538
05CA77  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05CA7A  5E                    POP    si ; STACK_POP
05CA7B  5F                    POP    di ; STACK_POP
05CA7C  C9                    LEAVE ; EPILOGUE
05CA7D  CB                    RETF ; RETURN
