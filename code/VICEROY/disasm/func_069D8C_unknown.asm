; ============================================================================
; func_069D8C_unknown
; Region   : overlay
; Bytes    : file 0x069D8C..0x06A20D  (1153 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069D8C  C8 A8 00 00           ENTER  0xa8, 0 ; PROLOGUE
069D90  57                    PUSH   di ; STACK_PUSH
069D91  56                    PUSH   si ; STACK_PUSH
069D92  0E                    PUSH   cs ; STACK_PUSH
069D93  E8 FC 18              CALL   0x6b692 ; CALL_NEAR
069D96  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
069D99  2A E4                 SUB    ah, ah ; ARITH
069D9B  50                    PUSH   ax ; STACK_PUSH
069D9C  6A 05                 PUSH   5 ; STACK_PUSH
069D9E  68 40 01              PUSH   0x140 ; PUSH_CONST
069DA1  6A 00                 PUSH   0 ; STACK_PUSH
069DA3  FF 36 92 2E           PUSH   word ptr [0x2e92] ; PUSH_GLOBAL
069DA7  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
069DAC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069DAF  52                    PUSH   dx ; STACK_PUSH
069DB0  50                    PUSH   ax ; STACK_PUSH
069DB1  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
069DB6  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
069DB9  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
069DBD  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
069DC0  2A E4                 SUB    ah, ah ; ARITH
069DC2  05 07 00              ADD    ax, 7 ; ARITH
069DC5  89 86 78 FF           MOV    word ptr [bp - 0x88], ax ; LOCAL_STORE
069DC9  C6 46 84 00           MOV    byte ptr [bp - 0x7c], 0 ; LOCAL_STORE
069DCD  8D 46 84              LEA    ax, [bp - 0x7c] ; ADDR
069DD0  50                    PUSH   ax ; STACK_PUSH
069DD1  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
069DD6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069DD9  C6 46 D4 00           MOV    byte ptr [bp - 0x2c], 0 ; LOCAL_STORE
069DDD  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
069DE0  C1 E3 04              SHL    bx, 4 ; LOGIC
069DE3  FF B7 74 2F           PUSH   word ptr [bx + 0x2f74] ; PUSH_GLOBAL
069DE7  8D 46 D4              LEA    ax, [bp - 0x2c] ; ADDR
069DEA  50                    PUSH   ax ; STACK_PUSH
069DEB  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
069DF0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
069DF3  83 7E 06 08           CMP    word ptr [bp + 6], 8 ; CMP
069DF7  7C 22                 JL     0x69e1b ; CJUMP
069DF9  83 7E 06 10           CMP    word ptr [bp + 6], 0x10 ; CMP
069DFD  7D 1C                 JGE    0x69e1b ; CJUMP
069DFF  8D 46 D4              LEA    ax, [bp - 0x2c] ; ADDR
069E02  50                    PUSH   ax ; STACK_PUSH
069E03  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
069E08  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069E0B  FF 36 B0 2D           PUSH   word ptr [0x2db0] ; PUSH_GLOBAL
069E0F  8D 46 D4              LEA    ax, [bp - 0x2c] ; ADDR
069E12  50                    PUSH   ax ; STACK_PUSH
069E13  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
069E18  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
069E1B  8D 46 D4              LEA    ax, [bp - 0x2c] ; ADDR
069E1E  50                    PUSH   ax ; STACK_PUSH
069E1F  8D 46 84              LEA    ax, [bp - 0x7c] ; ADDR
069E22  50                    PUSH   ax ; STACK_PUSH
069E23  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
069E28  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
069E2B  8D 46 84              LEA    ax, [bp - 0x7c] ; ADDR
069E2E  50                    PUSH   ax ; STACK_PUSH
069E2F  9A BE 01 1F 18        LCALL  0x181f, 0x1be ; THUNK -> 0x004B:0x0042 (thunk @file 0x01A7AE type B) overlay @file 0x0603EA
069E34  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069E37  6A 02                 PUSH   2 ; STACK_PUSH
069E39  8D 46 84              LEA    ax, [bp - 0x7c] ; ADDR
069E3C  50                    PUSH   ax ; STACK_PUSH
069E3D  0E                    PUSH   cs ; STACK_PUSH
069E3E  E8 3D 18              CALL   0x6b67e ; CALL_NEAR
069E41  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
069E44  8D 46 84              LEA    ax, [bp - 0x7c] ; ADDR
069E47  50                    PUSH   ax ; STACK_PUSH
069E48  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
069E4D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069E50  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
069E53  2A E4                 SUB    ah, ah ; ARITH
069E55  50                    PUSH   ax ; STACK_PUSH
069E56  FF B6 78 FF           PUSH   word ptr [bp - 0x88] ; PUSH_GLOBAL
069E5A  68 40 01              PUSH   0x140 ; PUSH_CONST
069E5D  6A 00                 PUSH   0 ; STACK_PUSH
069E5F  8D 46 84              LEA    ax, [bp - 0x7c] ; ADDR
069E62  16                    PUSH   ss ; STACK_PUSH
069E63  50                    PUSH   ax ; STACK_PUSH
069E64  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
069E69  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
069E6C  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
069E70  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
069E73  2A E4                 SUB    ah, ah ; ARITH
069E75  40                    INC    ax ; ARITH
069E76  40                    INC    ax ; ARITH
069E77  01 86 78 FF           ADD    word ptr [bp - 0x88], ax ; ARITH
069E7B  C7 86 7C FF 07 00     MOV    word ptr [bp - 0x84], 7 ; LOCAL_STORE
069E81  83 7E 06 1B           CMP    word ptr [bp + 6], 0x1b ; CMP
069E85  74 06                 JE     0x69e8d ; CJUMP
069E87  83 7E 06 1C           CMP    word ptr [bp + 6], 0x1c ; CMP
069E8B  75 07                 JNE    0x69e94 ; CJUMP
069E8D  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
069E92  EB 05                 JMP    0x69e99 ; JUMP
069E94  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
069E99  83 7E 06 19           CMP    word ptr [bp + 6], 0x19 ; CMP
069E9D  74 06                 JE     0x69ea5 ; CJUMP
069E9F  83 7E 06 1A           CMP    word ptr [bp + 6], 0x1a ; CMP
069EA3  75 09                 JNE    0x69eae ; CJUMP
069EA5  C7 86 6E FF 01 00     MOV    word ptr [bp - 0x92], 1 ; LOCAL_STORE
069EAB  EB 07                 JMP    0x69eb4 ; JUMP
069EAD  90                    NOP ; NOP
069EAE  C7 86 6E FF 00 00     MOV    word ptr [bp - 0x92], 0 ; LOCAL_STORE
069EB4  83 7E 06 18           CMP    word ptr [bp + 6], 0x18 ; CMP
069EB8  75 06                 JNE    0x69ec0 ; CJUMP
069EBA  B8 01 00              MOV    ax, 1 ; MOV
069EBD  EB 03                 JMP    0x69ec2 ; JUMP
069EBF  90                    NOP ; NOP
069EC0  2B C0                 SUB    ax, ax ; ARITH
069EC2  89 86 7A FF           MOV    word ptr [bp - 0x86], ax ; LOCAL_STORE
069EC6  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
069ECA  74 08                 JE     0x69ed4 ; CJUMP
069ECC  C7 86 62 FF 03 00     MOV    word ptr [bp - 0x9e], 3 ; LOCAL_STORE
069ED2  EB 16                 JMP    0x69eea ; JUMP
069ED4  83 7E 06 18           CMP    word ptr [bp + 6], 0x18 ; CMP
069ED8  7C 06                 JL     0x69ee0 ; CJUMP
069EDA  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
069EDD  EB 07                 JMP    0x69ee6 ; JUMP
069EDF  90                    NOP ; NOP
069EE0  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
069EE3  25 07 00              AND    ax, 7 ; LOGIC
069EE6  89 86 62 FF           MOV    word ptr [bp - 0x9e], ax ; LOCAL_STORE
069EEA  C7 86 5A FF 00 00     MOV    word ptr [bp - 0xa6], 0 ; LOCAL_STORE
069EF0  83 7E 06 08           CMP    word ptr [bp + 6], 8 ; CMP
069EF4  7C 06                 JL     0x69efc ; CJUMP
069EF6  83 7E 06 10           CMP    word ptr [bp + 6], 0x10 ; CMP
069EFA  7C 0C                 JL     0x69f08 ; CJUMP
069EFC  83 7E 06 10           CMP    word ptr [bp + 6], 0x10 ; CMP
069F00  7C 0E                 JL     0x69f10 ; CJUMP
069F02  83 7E 06 18           CMP    word ptr [bp + 6], 0x18 ; CMP
069F06  7D 08                 JGE    0x69f10 ; CJUMP
069F08  C7 46 80 01 00        MOV    word ptr [bp - 0x80], 1 ; LOCAL_STORE
069F0D  EB 06                 JMP    0x69f15 ; JUMP
069F0F  90                    NOP ; NOP
069F10  C7 46 80 00 00        MOV    word ptr [bp - 0x80], 0 ; LOCAL_STORE
069F15  83 7E 80 00           CMP    word ptr [bp - 0x80], 0 ; CMP
069F19  74 13                 JE     0x69f2e ; CJUMP
069F1B  83 BE 62 FF 01        CMP    word ptr [bp - 0x9e], 1 ; CMP
069F20  75 0C                 JNE    0x69f2e ; CJUMP
069F22  C7 86 5A FF 01 00     MOV    word ptr [bp - 0xa6], 1 ; LOCAL_STORE
069F28  C7 86 62 FF 11 00     MOV    word ptr [bp - 0x9e], 0x11 ; LOCAL_STORE
069F2E  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
069F31  D1 E3                 SHL    bx, 1 ; LOGIC
069F33  8B 87 92 01           MOV    ax, word ptr [bx + 0x192] ; MOV
069F37  89 86 72 FF           MOV    word ptr [bp - 0x8e], ax ; LOCAL_STORE
069F3B  8B 86 7C FF           MOV    ax, word ptr [bp - 0x84] ; LOCAL_LOAD
069F3F  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
069F42  05 33 00              ADD    ax, 0x33 ; ARITH
069F45  89 86 66 FF           MOV    word ptr [bp - 0x9a], ax ; LOCAL_STORE
069F49  8B 8E 78 FF           MOV    cx, word ptr [bp - 0x88] ; LOCAL_LOAD
069F4D  89 4E 82              MOV    word ptr [bp - 0x7e], cx ; LOCAL_STORE
069F50  83 C1 33              ADD    cx, 0x33 ; ARITH
069F53  89 8E 5E FF           MOV    word ptr [bp - 0xa2], cx ; LOCAL_STORE
069F57  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
069F5B  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
069F5F  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
069F63  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
069F67  51                    PUSH   cx ; STACK_PUSH
069F68  8A 16 39 08           MOV    dl, byte ptr [0x839] ; GLOBAL_LOAD
069F6C  52                    PUSH   dx ; STACK_PUSH
069F6D  8B D8                 MOV    bx, ax ; MOV
069F6F  8B 96 78 FF           MOV    dx, word ptr [bp - 0x88] ; LOCAL_LOAD
069F73  8B F0                 MOV    si, ax ; MOV
069F75  8B 86 7C FF           MOV    ax, word ptr [bp - 0x84] ; LOCAL_LOAD
069F79  8B F9                 MOV    di, cx ; MOV
069F7B  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
069F80  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
069F84  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
069F88  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
069F8C  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
069F90  8D 45 FF              LEA    ax, [di - 1] ; ADDR
069F93  50                    PUSH   ax ; STACK_PUSH
069F94  A0 37 08              MOV    al, byte ptr [0x837] ; GLOBAL_LOAD
069F97  50                    PUSH   ax ; STACK_PUSH
069F98  8B 86 7C FF           MOV    ax, word ptr [bp - 0x84] ; LOCAL_LOAD
069F9C  40                    INC    ax ; ARITH
069F9D  8D 5C FF              LEA    bx, [si - 1] ; ADDR
069FA0  8B 96 78 FF           MOV    dx, word ptr [bp - 0x88] ; LOCAL_LOAD
069FA4  42                    INC    dx ; ARITH
069FA5  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
069FAA  C7 86 6C FF 00 00     MOV    word ptr [bp - 0x94], 0 ; LOCAL_STORE
069FB0  E9 85 02              JMP    0x6a238 ; JUMP
069FB3  90                    NOP ; NOP
069FB4  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
069FB8  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
069FBC  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
069FBF  B8 41 00              MOV    ax, 0x41 ; CONST_LOAD
069FC2  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
069FC6  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
069FC9  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
069FCE  83 BE 70 FF 01        CMP    word ptr [bp - 0x90], 1 ; CMP
069FD3  75 21                 JNE    0x69ff6 ; CJUMP
069FD5  83 BE 6C FF 02        CMP    word ptr [bp - 0x94], 2 ; CMP
069FDA  75 1A                 JNE    0x69ff6 ; CJUMP
069FDC  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
069FE0  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
069FE4  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
069FE7  B8 96 00              MOV    ax, 0x96 ; CONST_LOAD
069FEA  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
069FEE  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
069FF1  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
069FF6  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
069FFA  75 4D                 JNE    0x6a049 ; CJUMP
069FFC  83 BE 6E FF 00        CMP    word ptr [bp - 0x92], 0 ; CMP
06A001  75 46                 JNE    0x6a049 ; CJUMP
06A003  83 BE 7A FF 00        CMP    word ptr [bp - 0x86], 0 ; CMP
06A008  75 3F                 JNE    0x6a049 ; CJUMP
06A00A  83 BE 70 FF 00        CMP    word ptr [bp - 0x90], 0 ; CMP
06A00F  75 38                 JNE    0x6a049 ; CJUMP
06A011  83 BE 6C FF 01        CMP    word ptr [bp - 0x94], 1 ; CMP
06A016  75 10                 JNE    0x6a028 ; CJUMP
06A018  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
06A01C  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
06A020  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
06A023  B8 17 00              MOV    ax, 0x17 ; CONST_LOAD
06A026  EB 15                 JMP    0x6a03d ; JUMP
06A028  83 BE 6C FF 02        CMP    word ptr [bp - 0x94], 2 ; CMP
06A02D  75 1A                 JNE    0x6a049 ; CJUMP
06A02F  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
06A033  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
06A037  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
06A03A  B8 1B 00              MOV    ax, 0x1b ; CONST_LOAD
06A03D  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06A041  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
06A044  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06A049  83 BE 6E FF 00        CMP    word ptr [bp - 0x92], 0 ; CMP
06A04E  75 73                 JNE    0x6a0c3 ; CJUMP
06A050  83 BE 70 FF 02        CMP    word ptr [bp - 0x90], 2 ; CMP
06A055  75 6C                 JNE    0x6a0c3 ; CJUMP
06A057  83 BE 6C FF 00        CMP    word ptr [bp - 0x94], 0 ; CMP
06A05C  75 2A                 JNE    0x6a088 ; CJUMP
06A05E  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
06A062  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
06A066  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
06A069  B8 53 00              MOV    ax, 0x53 ; CONST_LOAD
06A06C  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06A070  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
06A073  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06A078  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
06A07C  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
06A080  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
06A083  B8 56 00              MOV    ax, 0x56 ; CONST_LOAD
06A086  EB 2F                 JMP    0x6a0b7 ; JUMP
06A088  83 BE 6C FF 01        CMP    word ptr [bp - 0x94], 1 ; CMP
06A08D  75 34                 JNE    0x6a0c3 ; CJUMP
06A08F  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
06A093  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
06A097  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
06A09A  B8 52 00              MOV    ax, 0x52 ; CONST_LOAD
06A09D  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06A0A1  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
06A0A4  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06A0A9  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
06A0AD  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
06A0B1  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
06A0B4  B8 55 00              MOV    ax, 0x55 ; CONST_LOAD
06A0B7  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06A0BB  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
06A0BE  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06A0C3  83 BE 70 FF 01        CMP    word ptr [bp - 0x90], 1 ; CMP
06A0C8  75 2C                 JNE    0x6a0f6 ; CJUMP
06A0CA  83 BE 6C FF 01        CMP    word ptr [bp - 0x94], 1 ; CMP
06A0CF  75 25                 JNE    0x6a0f6 ; CJUMP
06A0D1  83 BE 72 FF FF        CMP    word ptr [bp - 0x8e], -1 ; CMP
06A0D6  74 1E                 JE     0x6a0f6 ; CJUMP
06A0D8  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
06A0DC  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
06A0E0  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
06A0E3  8B 86 72 FF           MOV    ax, word ptr [bp - 0x8e] ; LOCAL_LOAD
06A0E7  05 5A 00              ADD    ax, 0x5a ; ARITH
06A0EA  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06A0EE  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
06A0F1  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06A0F6  FF 86 70 FF           INC    word ptr [bp - 0x90] ; ARITH
06A0FA  83 BE 70 FF 03        CMP    word ptr [bp - 0x90], 3 ; CMP
06A0FF  7C 03                 JL     0x6a104 ; CJUMP
06A101  E9 30 01              JMP    0x6a234 ; JUMP
06A104  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
06A107  8B 86 70 FF           MOV    ax, word ptr [bp - 0x90] ; LOCAL_LOAD
06A10B  C1 E0 04              SHL    ax, 4 ; LOGIC
06A10E  03 86 7C FF           ADD    ax, word ptr [bp - 0x84] ; ARITH
06A112  40                    INC    ax ; ARITH
06A113  40                    INC    ax ; ARITH
06A114  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06A117  50                    PUSH   ax ; STACK_PUSH
06A118  68 A8 2D              PUSH   0x2da8 ; PUSH_CONST
06A11B  FF B6 62 FF           PUSH   word ptr [bp - 0x9e] ; PUSH_GLOBAL
06A11F  FF 36 6E 01           PUSH   word ptr [0x16e] ; PUSH_GLOBAL
06A123  FF 36 6C 01           PUSH   word ptr [0x16c] ; PUSH_GLOBAL
06A127  9A 5E 02 1F 18        LCALL  0x181f, 0x25e ; THUNK -> 0x0101:0x0050 (thunk @file 0x01A84E type B) overlay @file 0x06044C
06A12C  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
06A12F  83 7E 80 00           CMP    word ptr [bp - 0x80], 0 ; CMP
06A133  74 35                 JE     0x6a16a ; CJUMP
06A135  83 BE 5A FF 00        CMP    word ptr [bp - 0xa6], 0 ; CMP
06A13A  75 2E                 JNE    0x6a16a ; CJUMP
06A13C  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
06A140  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
06A144  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
06A147  8B B6 6C FF           MOV    si, word ptr [bp - 0x94] ; LOCAL_LOAD
06A14B  8B C6                 MOV    ax, si ; MOV
06A14D  D1 E6                 SHL    si, 1 ; LOGIC
06A14F  03 F0                 ADD    si, ax ; ARITH
06A151  8B 9E 70 FF           MOV    bx, word ptr [bp - 0x90] ; LOCAL_LOAD
06A155  8A 80 E4 1E           MOV    al, byte ptr [bx + si + 0x1ee4] ; MOV
06A159  2A E4                 SUB    ah, ah ; ARITH
06A15B  05 41 00              ADD    ax, 0x41 ; ARITH
06A15E  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06A162  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
06A165  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06A16A  83 7E 06 1C           CMP    word ptr [bp + 6], 0x1c ; CMP
06A16E  75 2E                 JNE    0x6a19e ; CJUMP
06A170  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
06A174  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
06A178  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
06A17B  8B B6 6C FF           MOV    si, word ptr [bp - 0x94] ; LOCAL_LOAD
06A17F  8B C6                 MOV    ax, si ; MOV
06A181  D1 E6                 SHL    si, 1 ; LOGIC
06A183  03 F0                 ADD    si, ax ; ARITH
06A185  8B 9E 70 FF           MOV    bx, word ptr [bp - 0x90] ; LOCAL_LOAD
06A189  8A 80 E4 1E           MOV    al, byte ptr [bx + si + 0x1ee4] ; MOV
06A18D  2A E4                 SUB    ah, ah ; ARITH
06A18F  05 31 00              ADD    ax, 0x31 ; ARITH
06A192  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06A196  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
06A199  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06A19E  83 7E 06 1B           CMP    word ptr [bp + 6], 0x1b ; CMP
06A1A2  75 2E                 JNE    0x6a1d2 ; CJUMP
06A1A4  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
06A1A8  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
06A1AC  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
06A1AF  8B B6 6C FF           MOV    si, word ptr [bp - 0x94] ; LOCAL_LOAD
06A1B3  8B C6                 MOV    ax, si ; MOV
06A1B5  D1 E6                 SHL    si, 1 ; LOGIC
06A1B7  03 F0                 ADD    si, ax ; ARITH
06A1B9  8B 9E 70 FF           MOV    bx, word ptr [bp - 0x90] ; LOCAL_LOAD
06A1BD  8A 80 E4 1E           MOV    al, byte ptr [bx + si + 0x1ee4] ; MOV
06A1C1  2A E4                 SUB    ah, ah ; ARITH
06A1C3  05 21 00              ADD    ax, 0x21 ; ARITH
06A1C6  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06A1CA  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
06A1CD  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06A1D2  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
06A1D6  74 03                 JE     0x6a1db ; CJUMP
06A1D8  E9 1B FE              JMP    0x69ff6 ; JUMP
06A1DB  83 BE 6E FF 00        CMP    word ptr [bp - 0x92], 0 ; CMP
06A1E0  74 03                 JE     0x6a1e5 ; CJUMP
06A1E2  E9 11 FE              JMP    0x69ff6 ; JUMP
06A1E5  83 7E 80 00           CMP    word ptr [bp - 0x80], 0 ; CMP
06A1E9  74 03                 JE     0x6a1ee ; CJUMP
06A1EB  E9 08 FE              JMP    0x69ff6 ; JUMP
06A1EE  83 BE 7A FF 00        CMP    word ptr [bp - 0x86], 0 ; CMP
06A1F3  74 03                 JE     0x6a1f8 ; CJUMP
06A1F5  E9 FE FD              JMP    0x69ff6 ; JUMP
06A1F8  83 BE 70 FF 01        CMP    word ptr [bp - 0x90], 1 ; CMP
06A1FD  75 03                 JNE    0x6a202 ; CJUMP
06A1FF  E9 CC FD              JMP    0x69fce ; JUMP
06A202  83 BE 6C FF 01        CMP    word ptr [bp - 0x94], 1 ; CMP
06A207  75 03                 JNE    0x6a20c ; CJUMP
06A209  E9 C2 FD              JMP    0x69fce ; JUMP
06A20C  83                    DB     0x83 ; DATA_BYTE
