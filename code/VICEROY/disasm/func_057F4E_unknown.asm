; ============================================================================
; func_057F4E_unknown
; Region   : overlay
; Bytes    : file 0x057F4E..0x0580B1  (355 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

057F4E  C8 D6 00 00           ENTER  0xd6, 0 ; PROLOGUE
057F52  57                    PUSH   di ; STACK_PUSH
057F53  56                    PUSH   si ; STACK_PUSH
057F54  C7 86 4E FF FF FF     MOV    word ptr [bp - 0xb2], 0xffff ; LOCAL_STORE
057F5A  2B C0                 SUB    ax, ax ; ARITH
057F5C  89 86 74 FF           MOV    word ptr [bp - 0x8c], ax ; LOCAL_STORE
057F60  89 86 34 FF           MOV    word ptr [bp - 0xcc], ax ; LOCAL_STORE
057F64  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
057F67  89 86 5A FF           MOV    word ptr [bp - 0xa6], ax ; LOCAL_STORE
057F6B  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
057F6E  89 86 2E FF           MOV    word ptr [bp - 0xd2], ax ; LOCAL_STORE
057F72  89 86 46 FF           MOV    word ptr [bp - 0xba], ax ; LOCAL_STORE
057F76  89 86 52 FF           MOV    word ptr [bp - 0xae], ax ; LOCAL_STORE
057F7A  89 86 44 FF           MOV    word ptr [bp - 0xbc], ax ; LOCAL_STORE
057F7E  89 86 66 FF           MOV    word ptr [bp - 0x9a], ax ; LOCAL_STORE
057F82  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
057F85  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
057F88  0E                    PUSH   cs ; STACK_PUSH
057F89  E8 4A 22              CALL   0x5a1d6 ; CALL_NEAR
057F8C  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
057F90  7D 0B                 JGE    0x57f9d ; CJUMP
057F92  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34 ; ARITH
057F96  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
057F9B  74 17                 JE     0x57fb4 ; CJUMP
057F9D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057FA0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057FA3  0E                    PUSH   cs ; STACK_PUSH
057FA4  E8 57 22              CALL   0x5a1fe ; CALL_NEAR
057FA7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057FAA  C7 86 74 FF 01 00     MOV    word ptr [bp - 0x8c], 1 ; LOCAL_STORE
057FB0  E9 3B 1B              JMP    0x59aee ; JUMP
057FB3  90                    NOP ; NOP
057FB4  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
057FB9  74 03                 JE     0x57fbe ; CJUMP
057FBB  E9 30 1B              JMP    0x59aee ; JUMP
057FBE  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
057FC1  89 86 46 FF           MOV    word ptr [bp - 0xba], ax ; LOCAL_STORE
057FC5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057FC8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057FCB  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
057FD0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057FD3  A8 20                 TEST   al, 0x20 ; LOGIC
057FD5  75 10                 JNE    0x57fe7 ; CJUMP
057FD7  C7 86 46 FF 01 00     MOV    word ptr [bp - 0xba], 1 ; LOCAL_STORE
057FDD  6A 0A                 PUSH   0xa ; PUSH_CONST
057FDF  9A 24 05 1F 18        LCALL  0x181f, 0x524 ; THUNK -> 0x02FD:0x006C (thunk @file 0x01AB14 type B) overlay @file 0x0287EA
057FE4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
057FE7  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
057FEA  D1 E3                 SHL    bx, 1 ; LOGIC
057FEC  8B 87 C8 53           MOV    ax, word ptr [bx + 0x53c8] ; MOV
057FF0  05 10 00              ADD    ax, 0x10 ; ARITH
057FF3  3B 06 8E 53           CMP    ax, word ptr [0x538e] ; CMP
057FF7  7F 16                 JG     0x5800f ; CJUMP
057FF9  C7 86 46 FF 01 00     MOV    word ptr [bp - 0xba], 1 ; LOCAL_STORE
057FFF  6A 10                 PUSH   0x10 ; PUSH_CONST
058001  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
058004  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
058007  9A 10 0A 1F 18        LCALL  0x181f, 0xa10 ; THUNK -> 0x05B3:0x00D0 (thunk @file 0x01B000 type B) overlay @file 0x05FCFC
05800C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05800F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
058012  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
058015  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
05801A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05801D  25 10 00              AND    ax, 0x10 ; LOGIC
058020  89 86 64 FF           MOV    word ptr [bp - 0x9c], ax ; LOCAL_STORE
058024  83 BE 46 FF 00        CMP    word ptr [bp - 0xba], 0 ; CMP
058029  75 03                 JNE    0x5802e ; CJUMP
05802B  E9 C0 1A              JMP    0x59aee ; JUMP
05802E  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
058031  0B C0                 OR     ax, ax ; LOGIC
058033  74 0B                 JE     0x58040 ; CJUMP
058035  48                    DEC    ax ; ARITH
058036  74 50                 JE     0x58088 ; CJUMP
058038  48                    DEC    ax ; ARITH
058039  74 53                 JE     0x5808e ; CJUMP
05803B  48                    DEC    ax ; ARITH
05803C  74 56                 JE     0x58094 ; CJUMP
05803E  EB 08                 JMP    0x58048 ; JUMP
058040  B8 20 80              MOV    ax, 0x8020 ; CONST_LOAD
058043  9A C0 04 1F 18        LCALL  0x181f, 0x4c0 ; THUNK -> 0x02D8:0x000E (thunk @file 0x01AAB0 type B)
058048  69 5E 08 3C 01        IMUL   bx, word ptr [bp + 8], 0x13c ; ARITH
05804D  F6 87 08 88 04        TEST   byte ptr [bx - 0x77f8], 4 ; LOGIC
058052  74 06                 JE     0x5805a ; CJUMP
058054  C7 86 66 FF 01 00     MOV    word ptr [bp - 0x9a], 1 ; LOCAL_STORE
05805A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05805D  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
058062  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
058065  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
058068  D1 E3                 SHL    bx, 1 ; LOGIC
05806A  8B 87 C8 53           MOV    ax, word ptr [bx + 0x53c8] ; MOV
05806E  89 86 76 FF           MOV    word ptr [bp - 0x8a], ax ; LOCAL_STORE
058072  A1 8E 53              MOV    ax, word ptr [0x538e] ; GLOBAL_LOAD
058075  89 87 C8 53           MOV    word ptr [bx + 0x53c8], ax ; MOV
058079  B8 01 00              MOV    ax, 1 ; MOV
05807C  89 86 74 FF           MOV    word ptr [bp - 0x8c], ax ; LOCAL_STORE
058080  89 86 36 FF           MOV    word ptr [bp - 0xca], ax ; LOCAL_STORE
058084  E9 25 01              JMP    0x581ac ; JUMP
058087  90                    NOP ; NOP
058088  B8 21 80              MOV    ax, 0x8021 ; CONST_LOAD
05808B  EB B6                 JMP    0x58043 ; JUMP
05808D  90                    NOP ; NOP
05808E  B8 22 80              MOV    ax, 0x8022 ; CONST_LOAD
058091  EB B0                 JMP    0x58043 ; JUMP
058093  90                    NOP ; NOP
058094  B8 23 80              MOV    ax, 0x8023 ; CONST_LOAD
058097  EB AA                 JMP    0x58043 ; JUMP
058099  90                    NOP ; NOP
05809A  2A C0                 SUB    al, al ; ARITH
05809C  C1 E3 04              SHL    bx, 4 ; LOGIC
05809F  03 9E 36 FF           ADD    bx, word ptr [bp - 0xca] ; ARITH
0580A3  38 87 E6 94           CMP    byte ptr [bx - 0x6b1a], al ; CMP
0580A7  76 3B                 JBE    0x580e4 ; CJUMP
0580A9  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0580AC  C1 E6 04              SHL    si, 4 ; LOGIC
0580AF  8B C3                 MOV    ax, bx ; MOV
