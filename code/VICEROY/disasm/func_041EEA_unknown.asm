; ============================================================================
; func_041EEA_unknown
; Region   : overlay
; Bytes    : file 0x041EEA..0x04210B  (545 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "LOOTCASH"  (auto-named via string xrefs)
; ============================================================================

041EEA  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
041EEE  57                    PUSH   di ; STACK_PUSH
041EEF  56                    PUSH   si ; STACK_PUSH
041EF0  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
041EF5  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
041EFA  6A E0                 PUSH   -0x20 ; STACK_PUSH
041EFC  6A E4                 PUSH   -0x1c ; STACK_PUSH
041EFE  0E                    PUSH   cs ; STACK_PUSH
041EFF  E8 14 02              CALL   0x42116 ; CALL_NEAR
041F02  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041F05  6A E4                 PUSH   -0x1c ; STACK_PUSH
041F07  6A E8                 PUSH   -0x18 ; STACK_PUSH
041F09  0E                    PUSH   cs ; STACK_PUSH
041F0A  E8 09 02              CALL   0x42116 ; CALL_NEAR
041F0D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041F10  A1 94 53              MOV    ax, word ptr [0x5394] ; GLOBAL_LOAD
041F13  2D 10 00              SUB    ax, 0x10 ; ARITH
041F16  8B D0                 MOV    dx, ax ; MOV
041F18  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
041F1D  EB 4F                 JMP    0x41f6e ; JUMP
041F1F  90                    NOP ; NOP
041F20  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
041F23  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
041F28  72 3C                 JB     0x41f66 ; CJUMP
041F2A  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
041F2F  77 35                 JA     0x41f66 ; CJUMP
041F31  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
041F35  7D 2F                 JGE    0x41f66 ; CJUMP
041F37  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
041F3A  39 06 94 53           CMP    word ptr [0x5394], ax ; CMP
041F3E  75 26                 JNE    0x41f66 ; CJUMP
041F40  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
041F43  8B F3                 MOV    si, bx ; MOV
041F45  9A FE 0D 1F 18        LCALL  0x181f, 0xdfe ; THUNK -> 0x0984:0x05B8 (thunk @file 0x01B3EE type B) overlay @file 0x0324CE
041F4A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
041F4D  80 BC 4C 31 02        CMP    byte ptr [si + 0x314c], 2 ; CMP
041F52  74 12                 JE     0x41f66 ; CJUMP
041F54  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
041F57  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
041F5A  80 BC 50 31 00        CMP    byte ptr [si + 0x3150], 0 ; CMP
041F5F  74 05                 JE     0x41f66 ; CJUMP
041F61  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1 ; LOCAL_STORE
041F66  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
041F69  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
041F6E  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
041F71  0B C0                 OR     ax, ax ; LOGIC
041F73  7D AB                 JGE    0x41f20 ; CJUMP
041F75  6A EC                 PUSH   -0x14 ; STACK_PUSH
041F77  6A F0                 PUSH   -0x10 ; STACK_PUSH
041F79  0E                    PUSH   cs ; STACK_PUSH
041F7A  E8 99 01              CALL   0x42116 ; CALL_NEAR
041F7D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041F80  6A F0                 PUSH   -0x10 ; STACK_PUSH
041F82  6A F4                 PUSH   -0xc ; STACK_PUSH
041F84  0E                    PUSH   cs ; STACK_PUSH
041F85  E8 8E 01              CALL   0x42116 ; CALL_NEAR
041F88  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041F8B  A1 94 53              MOV    ax, word ptr [0x5394] ; GLOBAL_LOAD
041F8E  2D 14 00              SUB    ax, 0x14 ; ARITH
041F91  8B D0                 MOV    dx, ax ; MOV
041F93  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
041F98  E9 29 01              JMP    0x420c4 ; JUMP
041F9B  90                    NOP ; NOP
041F9C  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
041FA1  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
041FA4  6B 5E F4 1C           IMUL   bx, word ptr [bp - 0xc], 0x1c ; ARITH
041FA8  80 BF 46 31 0A        CMP    byte ptr [bx + 0x3146], 0xa ; CMP
041FAD  74 03                 JE     0x41fb2 ; CJUMP
041FAF  E9 0F 01              JMP    0x420c1 ; JUMP
041FB2  B0 64                 MOV    al, 0x64 ; CONST_LOAD
041FB4  F6 A7 5B 31           MUL    byte ptr [bx + 0x315b] ; ARITH
041FB8  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
041FBB  6A 00                 PUSH   0 ; STACK_PUSH
041FBD  50                    PUSH   ax ; STACK_PUSH
041FBE  6A 00                 PUSH   0 ; STACK_PUSH
041FC0  8B F3                 MOV    si, bx ; MOV
041FC2  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
041FC7  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
041FCA  6A 00                 PUSH   0 ; STACK_PUSH
041FCC  6A 64                 PUSH   0x64 ; PUSH_CONST
041FCE  6A 00                 PUSH   0 ; STACK_PUSH
041FD0  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
041FD3  69 1E 94 53 3C 01     IMUL   bx, word ptr [0x5394], 0x13c ; ARITH
041FD9  8A 87 09 88           MOV    al, byte ptr [bx - 0x77f7] ; MOV
041FDD  3C 32                 CMP    al, 0x32 ; CMP
041FDF  7E 02                 JLE    0x41fe3 ; CJUMP
041FE1  B0 32                 MOV    al, 0x32 ; CONST_LOAD
041FE3  98                    CWDE ; ARITH
041FE4  99                    CDQ ; ARITH
041FE5  52                    PUSH   dx ; STACK_PUSH
041FE6  50                    PUSH   ax ; STACK_PUSH
041FE7  8B F8                 MOV    di, ax ; MOV
041FE9  89 7E EC              MOV    word ptr [bp - 0x14], di ; LOCAL_STORE
041FEC  89 56 EE              MOV    word ptr [bp - 0x12], dx ; LOCAL_STORE
041FEF  9A 60 0F 1D 0D        LCALL  0xd1d, 0xf60 ; LCALL
041FF4  52                    PUSH   dx ; STACK_PUSH
041FF5  50                    PUSH   ax ; STACK_PUSH
041FF6  9A C6 0E 1D 0D        LCALL  0xd1d, 0xec6 ; LCALL
041FFB  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
041FFE  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
042001  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
042004  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
042007  6A 01                 PUSH   1 ; STACK_PUSH
042009  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
04200E  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
042011  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
042014  29 46 F2              SUB    word ptr [bp - 0xe], ax ; ARITH
042017  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
04201A  2B D2                 SUB    dx, dx ; ARITH
04201C  52                    PUSH   dx ; STACK_PUSH
04201D  50                    PUSH   ax ; STACK_PUSH
04201E  6A 02                 PUSH   2 ; STACK_PUSH
042020  8B F8                 MOV    di, ax ; MOV
042022  89 7E E8              MOV    word ptr [bp - 0x18], di ; LOCAL_STORE
042025  89 56 EA              MOV    word ptr [bp - 0x16], dx ; LOCAL_STORE
042028  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
04202D  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
042030  8A 84 47 31           MOV    al, byte ptr [si + 0x3147] ; MOV
042034  25 0F 00              AND    ax, 0xf ; LOGIC
042037  50                    PUSH   ax ; STACK_PUSH
042038  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
04203D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
042040  50                    PUSH   ax ; STACK_PUSH
042041  6A 00                 PUSH   0 ; STACK_PUSH
042043  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
042048  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04204B  8A 9C 47 31           MOV    bl, byte ptr [si + 0x3147] ; MOV
04204F  83 E3 0F              AND    bx, 0xf ; LOGIC
042052  D1 E3                 SHL    bx, 1 ; LOGIC
042054  FF B7 8C 83           PUSH   word ptr [bx - 0x7c74] ; PUSH_GLOBAL
042058  6A 01                 PUSH   1 ; STACK_PUSH
04205A  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
04205F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
042062  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
042065  8B 56 EA              MOV    dx, word ptr [bp - 0x16] ; LOCAL_LOAD
042068  69 1E 94 53 3C 01     IMUL   bx, word ptr [0x5394], 0x13c ; ARITH
04206E  01 87 32 88           ADD    word ptr [bx - 0x77ce], ax ; ARITH
042072  11 97 34 88           ADC    word ptr [bx - 0x77cc], dx ; ARITH
042076  01 87 2E 88           ADD    word ptr [bx - 0x77d2], ax ; ARITH
04207A  11 97 30 88           ADC    word ptr [bx - 0x77d0], dx ; ARITH
04207E  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
042081  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
042084  01 87 2A 88           ADD    word ptr [bx - 0x77d6], ax ; ARITH
042088  11 97 2C 88           ADC    word ptr [bx - 0x77d4], dx ; ARITH
04208C  6A 24                 PUSH   0x24 ; PUSH_CONST
04208E  9A 8E 04 1F 18        LCALL  0x181f, 0x48e ; THUNK -> 0x029F:0x02CC (thunk @file 0x01AA7E type B) overlay @file 0x0222F4
042093  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
042096  6A 02                 PUSH   2 ; STACK_PUSH
042098  68 8E 14              PUSH   0x148e                       ; STRING: "LOOTCASH"
04209B  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
0420A0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0420A3  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
0420A6  9A 08 08 1F 18        LCALL  0x181f, 0x808 ; THUNK -> 0x0427:0x0824 (thunk @file 0x01ADF8 type B) overlay @file 0x031538
0420AB  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0420AE  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
0420B1  39 46 F0              CMP    word ptr [bp - 0x10], ax ; CMP
0420B4  7E 03                 JLE    0x420b9 ; CJUMP
0420B6  FF 4E F0              DEC    word ptr [bp - 0x10] ; ARITH
0420B9  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
0420BC  7E 03                 JLE    0x420c1 ; CJUMP
0420BE  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
0420C1  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
0420C4  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
0420C7  0B C0                 OR     ax, ax ; LOGIC
0420C9  7C 03                 JL     0x420ce ; CJUMP
0420CB  E9 CE FE              JMP    0x41f9c ; JUMP
0420CE  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0420D2  7C 2F                 JL     0x42103 ; CJUMP
0420D4  83 3E 94 53 04        CMP    word ptr [0x5394], 4 ; CMP
0420D9  7D 28                 JGE    0x42103 ; CJUMP
0420DB  6B 1E 94 53 34        IMUL   bx, word ptr [0x5394], 0x34 ; ARITH
0420E0  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
0420E5  75 1C                 JNE    0x42103 ; CJUMP
0420E7  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
0420EB  74 0A                 JE     0x420f7 ; CJUMP
0420ED  6A 09                 PUSH   9 ; STACK_PUSH
0420EF  9A 24 05 1F 18        LCALL  0x181f, 0x524 ; THUNK -> 0x02FD:0x006C (thunk @file 0x01AB14 type B) overlay @file 0x0287EA
0420F4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0420F7  C7 06 4C 01 01 00     MOV    word ptr [0x14c], 1 ; GLOBAL_LOAD
0420FD  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
042100  A3 4E 01              MOV    word ptr [0x14e], ax ; GLOBAL_LOAD
042103  0E                    PUSH   cs ; STACK_PUSH
042104  E8 0A 00              CALL   0x42111 ; CALL_NEAR
042107  5E                    POP    si ; STACK_POP
042108  5F                    POP    di ; STACK_POP
042109  C9                    LEAVE ; EPILOGUE
04210A  CB                    RETF ; RETURN
