; ============================================================================
; func_04198E_unknown
; Region   : overlay
; Bytes    : file 0x04198E..0x041B24  (406 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04198E  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
041992  56                    PUSH   si ; STACK_PUSH
041993  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0 ; LOCAL_STORE
041998  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04199C  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
0419A0  2A E4                 SUB    ah, ah ; ARITH
0419A2  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0419A5  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
0419A9  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0419AC  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
0419B0  25 0F 00              AND    ax, 0xf ; LOGIC
0419B3  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
0419B6  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0419BB  E9 40 01              JMP    0x41afe ; JUMP
0419BE  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0419C1  D1 E0                 SHL    ax, 1 ; LOGIC
0419C3  01 46 F0              ADD    word ptr [bp - 0x10], ax ; ARITH
0419C6  83 7E EE 00           CMP    word ptr [bp - 0x12], 0 ; CMP
0419CA  75 48                 JNE    0x41a14 ; CJUMP
0419CC  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0419CF  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
0419D2  3B 46 F0              CMP    ax, word ptr [bp - 0x10] ; CMP
0419D5  7C 3D                 JL     0x41a14 ; CJUMP
0419D7  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
0419DA  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
0419DD  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
0419E2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0419E5  3D 1A 00              CMP    ax, 0x1a ; CMP
0419E8  75 D4                 JNE    0x419be ; CJUMP
0419EA  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
0419ED  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
0419F0  9A 82 06 1F 18        LCALL  0x181f, 0x682 ; THUNK -> 0x037F:0x0314 (thunk @file 0x01AC72 type B) overlay @file 0x02EE50
0419F5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0419F8  0B C0                 OR     ax, ax ; LOGIC
0419FA  7C 05                 JL     0x41a01 ; CJUMP
0419FC  3B 46 EC              CMP    ax, word ptr [bp - 0x14] ; CMP
0419FF  75 BD                 JNE    0x419be ; CJUMP
041A01  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1 ; LOCAL_STORE
041A06  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
041A09  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
041A0C  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
041A0F  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
041A12  EB AA                 JMP    0x419be ; JUMP
041A14  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
041A17  83 7E EE 00           CMP    word ptr [bp - 0x12], 0 ; CMP
041A1B  75 17                 JNE    0x41a34 ; CJUMP
041A1D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
041A20  03 46 FC              ADD    ax, word ptr [bp - 4] ; ARITH
041A23  3B 46 F2              CMP    ax, word ptr [bp - 0xe] ; CMP
041A26  7E 0C                 JLE    0x41a34 ; CJUMP
041A28  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
041A2B  2B 46 FE              SUB    ax, word ptr [bp - 2] ; ARITH
041A2E  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
041A31  EB 93                 JMP    0x419c6 ; JUMP
041A33  90                    NOP ; NOP
041A34  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
041A37  03 46 FC              ADD    ax, word ptr [bp - 4] ; ARITH
041A3A  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
041A3D  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
041A40  2B 46 FE              SUB    ax, word ptr [bp - 2] ; ARITH
041A43  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
041A46  EB 49                 JMP    0x41a91 ; JUMP
041A48  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
041A4B  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
041A4E  3B 46 F0              CMP    ax, word ptr [bp - 0x10] ; CMP
041A51  7C 44                 JL     0x41a97 ; CJUMP
041A53  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
041A56  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
041A59  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
041A5E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041A61  3D 1A 00              CMP    ax, 0x1a ; CMP
041A64  75 28                 JNE    0x41a8e ; CJUMP
041A66  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
041A69  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
041A6C  9A 82 06 1F 18        LCALL  0x181f, 0x682 ; THUNK -> 0x037F:0x0314 (thunk @file 0x01AC72 type B) overlay @file 0x02EE50
041A71  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041A74  0B C0                 OR     ax, ax ; LOGIC
041A76  7C 05                 JL     0x41a7d ; CJUMP
041A78  3B 46 EC              CMP    ax, word ptr [bp - 0x14] ; CMP
041A7B  75 11                 JNE    0x41a8e ; CJUMP
041A7D  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1 ; LOCAL_STORE
041A82  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
041A85  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
041A88  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
041A8B  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
041A8E  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
041A91  83 7E EE 00           CMP    word ptr [bp - 0x12], 0 ; CMP
041A95  74 B1                 JE     0x41a48 ; CJUMP
041A97  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
041A9A  2B 46 FE              SUB    ax, word ptr [bp - 2] ; ARITH
041A9D  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
041AA0  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
041AA3  2B 46 FE              SUB    ax, word ptr [bp - 2] ; ARITH
041AA6  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
041AA9  EB 4A                 JMP    0x41af5 ; JUMP
041AAB  90                    NOP ; NOP
041AAC  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
041AAF  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
041AB2  3B 46 F0              CMP    ax, word ptr [bp - 0x10] ; CMP
041AB5  7C 44                 JL     0x41afb ; CJUMP
041AB7  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
041ABA  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
041ABD  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
041AC2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041AC5  3D 1A 00              CMP    ax, 0x1a ; CMP
041AC8  75 28                 JNE    0x41af2 ; CJUMP
041ACA  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
041ACD  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
041AD0  9A 82 06 1F 18        LCALL  0x181f, 0x682 ; THUNK -> 0x037F:0x0314 (thunk @file 0x01AC72 type B) overlay @file 0x02EE50
041AD5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041AD8  0B C0                 OR     ax, ax ; LOGIC
041ADA  7C 05                 JL     0x41ae1 ; CJUMP
041ADC  3B 46 EC              CMP    ax, word ptr [bp - 0x14] ; CMP
041ADF  75 11                 JNE    0x41af2 ; CJUMP
041AE1  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1 ; LOCAL_STORE
041AE6  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
041AE9  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
041AEC  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
041AEF  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
041AF2  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
041AF5  83 7E EE 00           CMP    word ptr [bp - 0x12], 0 ; CMP
041AF9  74 B1                 JE     0x41aac ; CJUMP
041AFB  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
041AFE  83 7E EE 00           CMP    word ptr [bp - 0x12], 0 ; CMP
041B02  75 14                 JNE    0x41b18 ; CJUMP
041B04  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
041B07  39 06 3A 85           CMP    word ptr [0x853a], ax ; CMP
041B0B  7E 0B                 JLE    0x41b18 ; CJUMP
041B0D  2B 46 FC              SUB    ax, word ptr [bp - 4] ; ARITH
041B10  F7 D8                 NEG    ax ; ARITH
041B12  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
041B15  E9 FF FE              JMP    0x41a17 ; JUMP
041B18  83 7E EE 00           CMP    word ptr [bp - 0x12], 0 ; CMP
041B1C  74 54                 JE     0x41b72 ; CJUMP
041B1E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
041B22  8B C3                 MOV    ax, bx ; MOV
