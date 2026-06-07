; ============================================================================
; func_0354BE_unknown
; Region   : overlay
; Bytes    : file 0x0354BE..0x0355A5  (231 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0354BE  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
0354C2  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1 ; LOCAL_STORE
0354C7  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0354CA  3D 52 00              CMP    ax, 0x52 ; CMP
0354CD  75 03                 JNE    0x354d2 ; CJUMP
0354CF  E9 AA 02              JMP    0x3577c ; JUMP
0354D2  7E 03                 JLE    0x354d7 ; CJUMP
0354D4  E9 E9 02              JMP    0x357c0 ; JUMP
0354D7  3D 50 00              CMP    ax, 0x50 ; CMP
0354DA  75 03                 JNE    0x354df ; CJUMP
0354DC  E9 AB 02              JMP    0x3578a ; JUMP
0354DF  76 03                 JBE    0x354e4 ; CJUMP
0354E1  E9 D3 02              JMP    0x357b7 ; JUMP
0354E4  3C 31                 CMP    al, 0x31 ; CMP
0354E6  75 03                 JNE    0x354eb ; CJUMP
0354E8  E9 91 02              JMP    0x3577c ; JUMP
0354EB  7E 03                 JLE    0x354f0 ; CJUMP
0354ED  E9 AA 02              JMP    0x3579a ; JUMP
0354F0  2C 09                 SUB    al, 9 ; ARITH
0354F2  75 03                 JNE    0x354f7 ; CJUMP
0354F4  E9 59 01              JMP    0x35650 ; JUMP
0354F7  2C 12                 SUB    al, 0x12 ; ARITH
0354F9  74 11                 JE     0x3550c ; CJUMP
0354FB  2C 10                 SUB    al, 0x10 ; ARITH
0354FD  75 03                 JNE    0x35502 ; CJUMP
0354FF  E9 08 02              JMP    0x3570a ; JUMP
035502  2C 02                 SUB    al, 2 ; ARITH
035504  75 03                 JNE    0x35509 ; CJUMP
035506  E9 A9 01              JMP    0x356b2 ; JUMP
035509  E9 AB 02              JMP    0x357b7 ; JUMP
03550C  2B C0                 SUB    ax, ax ; ARITH
03550E  A3 38 9E              MOV    word ptr [0x9e38], ax ; GLOBAL_LOAD
035511  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
035514  83 7E F6 00           CMP    word ptr [bp - 0xa], 0 ; CMP
035518  74 04                 JE     0x3551e ; CJUMP
03551A  0E                    PUSH   cs ; STACK_PUSH
03551B  E8 0E 13              CALL   0x3682c ; CALL_NEAR
03551E  F6 06 83 53 20        TEST   byte ptr [0x5383], 0x20 ; LOGIC
035523  75 03                 JNE    0x35528 ; CJUMP
035525  E9 01 03              JMP    0x35829 ; JUMP
035528  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
03552B  3D 5D 00              CMP    ax, 0x5d ; CMP
03552E  75 03                 JNE    0x35533 ; CJUMP
035530  E9 21 03              JMP    0x35854 ; JUMP
035533  76 03                 JBE    0x35538 ; CJUMP
035535  E9 F1 02              JMP    0x35829 ; JUMP
035538  2C 24                 SUB    al, 0x24 ; ARITH
03553A  75 03                 JNE    0x3553f ; CJUMP
03553C  E9 D9 02              JMP    0x35818 ; JUMP
03553F  2C 37                 SUB    al, 0x37 ; ARITH
035541  75 03                 JNE    0x35546 ; CJUMP
035543  E9 04 03              JMP    0x3584a ; JUMP
035546  E9 E0 02              JMP    0x35829 ; JUMP
035549  90                    NOP ; NOP
03554A  A1 9A 0F              MOV    ax, word ptr [0xf9a] ; GLOBAL_LOAD
03554D  0B C0                 OR     ax, ax ; LOGIC
03554F  74 09                 JE     0x3555a ; CJUMP
035551  48                    DEC    ax ; ARITH
035552  74 1A                 JE     0x3556e ; CJUMP
035554  48                    DEC    ax ; ARITH
035555  74 29                 JE     0x35580 ; CJUMP
035557  EB 0F                 JMP    0x35568 ; JUMP
035559  90                    NOP ; NOP
03555A  A0 9E 0F              MOV    al, byte ptr [0xf9e] ; GLOBAL_LOAD
03555D  2A E4                 SUB    ah, ah ; ARITH
03555F  50                    PUSH   ax ; STACK_PUSH
035560  9A 34 09 1F 19        LCALL  0x191f, 0x934 ; THUNK -> 0x0000:0x05CE (thunk @file 0x01BF24 type A) overlay @file 0x025ECE
035565  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
035568  0E                    PUSH   cs ; STACK_PUSH
035569  E8 C4 13              CALL   0x36930 ; CALL_NEAR
03556C  EB A6                 JMP    0x35514 ; JUMP
03556E  83 3E A2 0F 00        CMP    word ptr [0xfa2], 0 ; CMP
035573  74 F3                 JE     0x35568 ; CJUMP
035575  FF 36 1C 9E           PUSH   word ptr [0x9e1c] ; PUSH_GLOBAL
035579  0E                    PUSH   cs ; STACK_PUSH
03557A  E8 86 13              CALL   0x36903 ; CALL_NEAR
03557D  EB 10                 JMP    0x3558f ; JUMP
03557F  90                    NOP ; NOP
035580  83 3E 2A 9E 00        CMP    word ptr [0x9e2a], 0 ; CMP
035585  74 E1                 JE     0x35568 ; CJUMP
035587  FF 36 2C 9E           PUSH   word ptr [0x9e2c] ; PUSH_GLOBAL
03558B  0E                    PUSH   cs ; STACK_PUSH
03558C  E8 A6 13              CALL   0x36935 ; CALL_NEAR
03558F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
035592  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
035595  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
035599  2A E4                 SUB    ah, ah ; ARITH
03559B  50                    PUSH   ax ; STACK_PUSH
03559C  9A 42 09 1F 19        LCALL  0x191f, 0x942 ; THUNK -> 0x0000:0x07E6 (thunk @file 0x01BF32 type A) overlay @file 0x0260E6
0355A1  EB C2                 JMP    0x35565 ; JUMP
0355A3  90                    NOP ; NOP
0355A4  8B                    DB     0x8B ; DATA_BYTE
