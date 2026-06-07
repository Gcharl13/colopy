; ============================================================================
; func_038F2C_unknown
; Region   : overlay
; Bytes    : file 0x038F2C..0x0391BF  (659 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

038F2C  C8 66 00 00           ENTER  0x66, 0 ; PROLOGUE
038F30  56                    PUSH   si ; STACK_PUSH
038F31  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
038F34  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
038F39  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038F3C  C7 46 AA 02 00        MOV    word ptr [bp - 0x56], 2 ; LOCAL_STORE
038F41  C7 46 A8 14 00        MOV    word ptr [bp - 0x58], 0x14 ; LOCAL_STORE
038F46  0E                    PUSH   cs ; STACK_PUSH
038F47  E8 F0 0E              CALL   0x39e3a ; CALL_NEAR
038F4A  2B C0                 SUB    ax, ax ; ARITH
038F4C  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
038F4F  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
038F52  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
038F55  E9 31 01              JMP    0x39089 ; JUMP
038F58  6A 13                 PUSH   0x13 ; PUSH_CONST
038F5A  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
038F5F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038F62  0B C0                 OR     ax, ax ; LOGIC
038F64  74 10                 JE     0x38f76 ; CJUMP
038F66  FF 36 4E 2F           PUSH   word ptr [0x2f4e] ; PUSH_GLOBAL
038F6A  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
038F6D  50                    PUSH   ax ; STACK_PUSH
038F6E  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
038F73  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
038F76  68 92 00              PUSH   0x92 ; PUSH_CONST
038F79  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
038F7C  05 07 00              ADD    ax, 7 ; ARITH
038F7F  50                    PUSH   ax ; STACK_PUSH
038F80  8B 4E A0              MOV    cx, word ptr [bp - 0x60] ; LOCAL_LOAD
038F83  83 C1 03              ADD    cx, 3 ; ARITH
038F86  51                    PUSH   cx ; STACK_PUSH
038F87  8D 4E B0              LEA    cx, [bp - 0x50] ; ADDR
038F8A  16                    PUSH   ss ; STACK_PUSH
038F8B  51                    PUSH   cx ; STACK_PUSH
038F8C  8B F0                 MOV    si, ax ; MOV
038F8E  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
038F93  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
038F96  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
038F9A  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
038F9E  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
038FA1  40                    INC    ax ; ARITH
038FA2  40                    INC    ax ; ARITH
038FA3  50                    PUSH   ax ; STACK_PUSH
038FA4  B8 3F 00              MOV    ax, 0x3f ; CONST_LOAD
038FA7  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
038FAB  BA D2 00              MOV    dx, 0xd2 ; CONST_LOAD
038FAE  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
038FB3  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
038FB7  26 8B 87 32 03        MOV    ax, word ptr es:[bx + 0x332] ; MOV
038FBC  05 D4 00              ADD    ax, 0xd4 ; ARITH
038FBF  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
038FC2  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
038FC6  FF 36 EC 8D           PUSH   word ptr [0x8dec] ; PUSH_GLOBAL
038FCA  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
038FCD  16                    PUSH   ss ; STACK_PUSH
038FCE  50                    PUSH   ax ; STACK_PUSH
038FCF  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
038FD4  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
038FD7  68 92 00              PUSH   0x92 ; PUSH_CONST
038FDA  56                    PUSH   si ; STACK_PUSH
038FDB  8B 46 A0              MOV    ax, word ptr [bp - 0x60] ; LOCAL_LOAD
038FDE  05 03 00              ADD    ax, 3 ; ARITH
038FE1  50                    PUSH   ax ; STACK_PUSH
038FE2  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
038FE5  16                    PUSH   ss ; STACK_PUSH
038FE6  50                    PUSH   ax ; STACK_PUSH
038FE7  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
038FEC  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
038FEF  C7 46 A0 FA 00        MOV    word ptr [bp - 0x60], 0xfa ; LOCAL_STORE
038FF4  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0 ; LOCAL_STORE
038FF9  EB 37                 JMP    0x39032 ; JUMP
038FFB  90                    NOP ; NOP
038FFC  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
038FFF  9A 0E 0C 1F 18        LCALL  0x181f, 0xc0e ; THUNK -> 0x05EB:0x0E18 (thunk @file 0x01B1FE type B) overlay @file 0x027E08
039004  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
039007  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
03900A  3D 11 00              CMP    ax, 0x11 ; CMP
03900D  75 20                 JNE    0x3902f ; CJUMP
03900F  6A 07                 PUSH   7 ; STACK_PUSH
039011  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
039014  9A 74 0A 1F 18        LCALL  0x181f, 0xa74 ; THUNK -> 0x05EB:0x0F1C (thunk @file 0x01B064 type B) overlay @file 0x027F0C
039019  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03901C  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
03901F  8B 5E A8              MOV    bx, word ptr [bp - 0x58] ; LOCAL_LOAD
039022  43                    INC    bx ; ARITH
039023  8B 56 A0              MOV    dx, word ptr [bp - 0x60] ; LOCAL_LOAD
039026  9A 4A 02 1F 18        LCALL  0x181f, 0x24a ; THUNK -> 0x012B:0x015C (thunk @file 0x01A83A type B) overlay @file 0x0236C6
03902B  83 46 A0 0C           ADD    word ptr [bp - 0x60], 0xc ; ARITH
03902F  FF 46 AC              INC    word ptr [bp - 0x54] ; ARITH
039032  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
039036  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
039039  98                    CWDE ; ARITH
03903A  3B 46 AC              CMP    ax, word ptr [bp - 0x54] ; CMP
03903D  7F BD                 JG     0x38ffc ; CJUMP
03903F  83 46 A8 11           ADD    word ptr [bp - 0x58], 0x11 ; ARITH
039043  FF 46 9A              INC    word ptr [bp - 0x66] ; ARITH
039046  83 7E 9A 09           CMP    word ptr [bp - 0x66], 9 ; CMP
03904A  7C 3A                 JL     0x39086 ; CJUMP
03904C  6A FF                 PUSH   -1 ; STACK_PUSH
03904E  6A FE                 PUSH   -2 ; STACK_PUSH
039050  0E                    PUSH   cs ; STACK_PUSH
039051  E8 DC 0D              CALL   0x39e30 ; CALL_NEAR
039054  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
039057  6A 00                 PUSH   0 ; STACK_PUSH
039059  68 40 01              PUSH   0x140 ; PUSH_CONST
03905C  68 C8 00              PUSH   0xc8 ; PUSH_CONST
03905F  2B C0                 SUB    ax, ax ; ARITH
039061  99                    CDQ ; ARITH
039062  2B DB                 SUB    bx, bx ; ARITH
039064  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
039069  9A C0 03 1F 18        LCALL  0x181f, 0x3c0 ; THUNK -> 0x0262:0x0060 (thunk @file 0x01A9B0 type B) overlay @file 0x021D90
03906E  0E                    PUSH   cs ; STACK_PUSH
03906F  E8 C8 0D              CALL   0x39e3a ; CALL_NEAR
039072  C7 46 AA 02 00        MOV    word ptr [bp - 0x56], 2 ; LOCAL_STORE
039077  C7 46 A8 14 00        MOV    word ptr [bp - 0x58], 0x14 ; LOCAL_STORE
03907C  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0 ; LOCAL_STORE
039081  C7 46 AE 01 00        MOV    word ptr [bp - 0x52], 1 ; LOCAL_STORE
039086  FF 46 A4              INC    word ptr [bp - 0x5c] ; ARITH
039089  8B 46 A4              MOV    ax, word ptr [bp - 0x5c] ; LOCAL_LOAD
03908C  39 06 9E 53           CMP    word ptr [0x539e], ax ; CMP
039090  7F 03                 JG     0x39095 ; CJUMP
039092  E9 F9 00              JMP    0x3918e ; JUMP
039095  50                    PUSH   ax ; STACK_PUSH
039096  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
03909B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03909E  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
0390A1  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0390A5  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
0390A8  75 DC                 JNE    0x39086 ; CJUMP
0390AA  9A 72 0C 1F 18        LCALL  0x181f, 0xc72 ; THUNK -> 0x05EB:0x26E4 (thunk @file 0x01B262 type B) overlay @file 0x0296D4
0390AF  9A 22 0C 1F 18        LCALL  0x181f, 0xc22 ; THUNK -> 0x05EB:0x3956 (thunk @file 0x01B212 type B) overlay @file 0x02A946
0390B4  9A 04 0C 1F 18        LCALL  0x181f, 0xc04 ; THUNK -> 0x05EB:0x1F72 (thunk @file 0x01B1F4 type B) overlay @file 0x028F62
0390B9  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0390BD  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0390C1  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0390C5  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0390C9  6A 64                 PUSH   0x64 ; PUSH_CONST
0390CB  6A 01                 PUSH   1 ; STACK_PUSH
0390CD  6A 00                 PUSH   0 ; STACK_PUSH
0390CF  8B 56 AA              MOV    dx, word ptr [bp - 0x56] ; LOCAL_LOAD
0390D2  42                    INC    dx ; ARITH
0390D3  42                    INC    dx ; ARITH
0390D4  A1 C6 8D              MOV    ax, word ptr [0x8dc6] ; GLOBAL_LOAD
0390D7  8B 5E A8              MOV    bx, word ptr [bp - 0x58] ; LOCAL_LOAD
0390DA  9A A8 02 1F 18        LCALL  0x181f, 0x2a8 ; THUNK -> 0x012B:0x0C64 (thunk @file 0x01A898 type B) overlay @file 0x0241CE
0390DF  68 92 00              PUSH   0x92 ; PUSH_CONST
0390E2  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
0390E5  05 07 00              ADD    ax, 7 ; ARITH
0390E8  50                    PUSH   ax ; STACK_PUSH
0390E9  8B 4E AA              MOV    cx, word ptr [bp - 0x56] ; LOCAL_LOAD
0390EC  83 C1 17              ADD    cx, 0x17 ; ARITH
0390EF  51                    PUSH   cx ; STACK_PUSH
0390F0  8B 0E 42 85           MOV    cx, word ptr [0x8542] ; GLOBAL_LOAD
0390F4  41                    INC    cx ; ARITH
0390F5  41                    INC    cx ; ARITH
0390F6  1E                    PUSH   ds ; STACK_PUSH
0390F7  51                    PUSH   cx ; STACK_PUSH
0390F8  8B F0                 MOV    si, ax ; MOV
0390FA  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
0390FF  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
039102  89 76 9C              MOV    word ptr [bp - 0x64], si ; LOCAL_STORE
039105  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
039109  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
03910D  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
039110  40                    INC    ax ; ARITH
039111  40                    INC    ax ; ARITH
039112  50                    PUSH   ax ; STACK_PUSH
039113  B8 7C 00              MOV    ax, 0x7c ; CONST_LOAD
039116  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
03911A  BA 6E 00              MOV    dx, 0x6e ; CONST_LOAD
03911D  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
039122  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
039126  26 8B 87 0E 06        MOV    ax, word ptr es:[bx + 0x60e] ; MOV
03912B  05 70 00              ADD    ax, 0x70 ; ARITH
03912E  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
039131  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
039135  9A 86 0C 1F 18        LCALL  0x181f, 0xc86 ; THUNK -> 0x05EB:0x0274 (thunk @file 0x01B276 type B) overlay @file 0x027264
03913A  50                    PUSH   ax ; STACK_PUSH
03913B  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
03913E  16                    PUSH   ss ; STACK_PUSH
03913F  50                    PUSH   ax ; STACK_PUSH
039140  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
039145  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
039148  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
03914B  50                    PUSH   ax ; STACK_PUSH
03914C  9A 0A 01 1F 18        LCALL  0x181f, 0x10a ; THUNK -> 0x004B:0x0062 (thunk @file 0x01A6FA type B) overlay @file 0x06040A
039151  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
039154  68 92 00              PUSH   0x92 ; PUSH_CONST
039157  56                    PUSH   si ; STACK_PUSH
039158  8B 46 A0              MOV    ax, word ptr [bp - 0x60] ; LOCAL_LOAD
03915B  05 03 00              ADD    ax, 3 ; ARITH
03915E  50                    PUSH   ax ; STACK_PUSH
03915F  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
039162  16                    PUSH   ss ; STACK_PUSH
039163  50                    PUSH   ax ; STACK_PUSH
039164  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
039169  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
03916C  C7 46 A0 96 00        MOV    word ptr [bp - 0x60], 0x96 ; LOCAL_STORE
039171  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
039175  6A 14                 PUSH   0x14 ; PUSH_CONST
039177  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
03917C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03917F  0B C0                 OR     ax, ax ; LOGIC
039181  75 03                 JNE    0x39186 ; CJUMP
039183  E9 D2 FD              JMP    0x38f58 ; JUMP
039186  FF 36 72 90           PUSH   word ptr [0x9072] ; PUSH_GLOBAL
03918A  E9 DD FD              JMP    0x38f6a ; JUMP
03918D  90                    NOP ; NOP
03918E  83 7E 9A 00           CMP    word ptr [bp - 0x66], 0 ; CMP
039192  75 06                 JNE    0x3919a ; CJUMP
039194  83 7E AE 00           CMP    word ptr [bp - 0x52], 0 ; CMP
039198  75 22                 JNE    0x391bc ; CJUMP
03919A  6A FF                 PUSH   -1 ; STACK_PUSH
03919C  6A FE                 PUSH   -2 ; STACK_PUSH
03919E  0E                    PUSH   cs ; STACK_PUSH
03919F  E8 8E 0C              CALL   0x39e30 ; CALL_NEAR
0391A2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0391A5  6A 00                 PUSH   0 ; STACK_PUSH
0391A7  68 40 01              PUSH   0x140 ; PUSH_CONST
0391AA  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0391AD  2B C0                 SUB    ax, ax ; ARITH
0391AF  99                    CDQ ; ARITH
0391B0  2B DB                 SUB    bx, bx ; ARITH
0391B2  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
0391B7  9A C0 03 1F 18        LCALL  0x181f, 0x3c0 ; THUNK -> 0x0262:0x0060 (thunk @file 0x01A9B0 type B) overlay @file 0x021D90
0391BC  5E                    POP    si ; STACK_POP
0391BD  C9                    LEAVE ; EPILOGUE
0391BE  CB                    RETF ; RETURN
