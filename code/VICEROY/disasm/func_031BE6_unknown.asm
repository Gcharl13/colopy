; ============================================================================
; func_031BE6_unknown
; Region   : overlay
; Bytes    : file 0x031BE6..0x031DC7  (481 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031BE6  C8 B6 00 00           ENTER  0xb6, 0 ; PROLOGUE
031BEA  57                    PUSH   di ; STACK_PUSH
031BEB  56                    PUSH   si ; STACK_PUSH
031BEC  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
031BEF  25 01 00              AND    ax, 1 ; LOGIC
031BF2  74 1C                 JE     0x31c10 ; CJUMP
031BF4  C6 86 58 FF 00        MOV    byte ptr [bp - 0xa8], 0 ; LOCAL_STORE
031BF9  C7 86 56 FF 0F 00     MOV    word ptr [bp - 0xaa], 0xf ; LOCAL_STORE
031BFF  C6 86 4E FF 30        MOV    byte ptr [bp - 0xb2], 0x30 ; LOCAL_STORE
031C04  C6 46 FE 39           MOV    byte ptr [bp - 2], 0x39 ; LOCAL_STORE
031C08  C6 86 50 FF 07        MOV    byte ptr [bp - 0xb0], 7 ; LOCAL_STORE
031C0D  EB 1A                 JMP    0x31c29 ; JUMP
031C0F  90                    NOP ; NOP
031C10  C6 86 58 FF 0F        MOV    byte ptr [bp - 0xa8], 0xf ; LOCAL_STORE
031C15  C7 86 56 FF FF FF     MOV    word ptr [bp - 0xaa], 0xffff ; LOCAL_STORE
031C1B  C6 86 4E FF 39        MOV    byte ptr [bp - 0xb2], 0x39 ; LOCAL_STORE
031C20  C6 46 FE 30           MOV    byte ptr [bp - 2], 0x30 ; LOCAL_STORE
031C24  C6 86 50 FF 0E        MOV    byte ptr [bp - 0xb0], 0xe ; LOCAL_STORE
031C29  8D 86 52 FF           LEA    ax, [bp - 0xae] ; ADDR
031C2D  50                    PUSH   ax ; STACK_PUSH
031C2E  8D 8E 54 FF           LEA    cx, [bp - 0xac] ; ADDR
031C32  51                    PUSH   cx ; STACK_PUSH
031C33  8D 56 FA              LEA    dx, [bp - 6] ; ADDR
031C36  52                    PUSH   dx ; STACK_PUSH
031C37  FF 76 04              PUSH   word ptr [bp + 4] ; STACK_PUSH
031C3A  E8 73 FF              CALL   0x31bb0 ; CALL_NEAR
031C3D  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
031C40  8B 86 54 FF           MOV    ax, word ptr [bp - 0xac] ; LOCAL_LOAD
031C44  2B 46 FA              SUB    ax, word ptr [bp - 6] ; ARITH
031C47  D1 F8                 SAR    ax, 1 ; LOGIC
031C49  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
031C4C  89 86 4C FF           MOV    word ptr [bp - 0xb4], ax ; LOCAL_STORE
031C50  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
031C53  40                    INC    ax ; ARITH
031C54  40                    INC    ax ; ARITH
031C55  89 86 4A FF           MOV    word ptr [bp - 0xb6], ax ; LOCAL_STORE
031C59  F6 46 0A 02           TEST   byte ptr [bp + 0xa], 2 ; LOGIC
031C5D  74 03                 JE     0x31c62 ; CJUMP
031C5F  E9 DD 00              JMP    0x31d3f ; JUMP
031C62  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
031C66  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
031C6A  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
031C6E  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
031C72  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
031C75  50                    PUSH   ax ; STACK_PUSH
031C76  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
031C79  8B 96 54 FF           MOV    dx, word ptr [bp - 0xac] ; LOCAL_LOAD
031C7D  03 D0                 ADD    dx, ax ; ARITH
031C7F  8B 9E 52 FF           MOV    bx, word ptr [bp - 0xae] ; LOCAL_LOAD
031C83  03 5E 08              ADD    bx, word ptr [bp + 8] ; ARITH
031C86  4B                    DEC    bx ; ARITH
031C87  4A                    DEC    dx ; ARITH
031C88  8B F0                 MOV    si, ax ; MOV
031C8A  9A BC 08 1F 19        LCALL  0x191f, 0x8bc ; THUNK -> 0x0BBC:0x000C (thunk @file 0x01BEAC type B)
031C8F  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
031C93  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
031C97  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
031C9B  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
031C9F  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
031CA2  50                    PUSH   ax ; STACK_PUSH
031CA3  8B 86 54 FF           MOV    ax, word ptr [bp - 0xac] ; LOCAL_LOAD
031CA7  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
031CAA  48                    DEC    ax ; ARITH
031CAB  8B 9E 52 FF           MOV    bx, word ptr [bp - 0xae] ; LOCAL_LOAD
031CAF  03 5E 08              ADD    bx, word ptr [bp + 8] ; ARITH
031CB2  4B                    DEC    bx ; ARITH
031CB3  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
031CB6  8B FA                 MOV    di, dx ; MOV
031CB8  9A B2 08 1F 19        LCALL  0x191f, 0x8b2 ; THUNK -> 0x0BC3:0x0006 (thunk @file 0x01BEA2 type B)
031CBD  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
031CC1  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
031CC5  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
031CC9  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
031CCD  8A 86 4E FF           MOV    al, byte ptr [bp - 0xb2] ; LOCAL_LOAD
031CD1  50                    PUSH   ax ; STACK_PUSH
031CD2  8B DF                 MOV    bx, di ; MOV
031CD4  8B C6                 MOV    ax, si ; MOV
031CD6  8B 96 54 FF           MOV    dx, word ptr [bp - 0xac] ; LOCAL_LOAD
031CDA  03 56 06              ADD    dx, word ptr [bp + 6] ; ARITH
031CDD  4A                    DEC    dx ; ARITH
031CDE  9A BC 08 1F 19        LCALL  0x191f, 0x8bc ; THUNK -> 0x0BBC:0x000C (thunk @file 0x01BEAC type B)
031CE3  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
031CE7  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
031CEB  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
031CEF  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
031CF3  8A 86 4E FF           MOV    al, byte ptr [bp - 0xb2] ; LOCAL_LOAD
031CF7  50                    PUSH   ax ; STACK_PUSH
031CF8  8B C6                 MOV    ax, si ; MOV
031CFA  8B 9E 52 FF           MOV    bx, word ptr [bp - 0xae] ; LOCAL_LOAD
031CFE  03 5E 08              ADD    bx, word ptr [bp + 8] ; ARITH
031D01  4B                    DEC    bx ; ARITH
031D02  8B D7                 MOV    dx, di ; MOV
031D04  9A B2 08 1F 19        LCALL  0x191f, 0x8b2 ; THUNK -> 0x0BC3:0x0006 (thunk @file 0x01BEA2 type B)
031D09  83 BE 56 FF 00        CMP    word ptr [bp - 0xaa], 0 ; CMP
031D0E  7C 2F                 JL     0x31d3f ; CJUMP
031D10  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
031D14  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
031D18  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
031D1C  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
031D20  8B 86 52 FF           MOV    ax, word ptr [bp - 0xae] ; LOCAL_LOAD
031D24  48                    DEC    ax ; ARITH
031D25  48                    DEC    ax ; ARITH
031D26  50                    PUSH   ax ; STACK_PUSH
031D27  8A 86 56 FF           MOV    al, byte ptr [bp - 0xaa] ; LOCAL_LOAD
031D2B  50                    PUSH   ax ; STACK_PUSH
031D2C  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
031D2F  40                    INC    ax ; ARITH
031D30  8B 9E 54 FF           MOV    bx, word ptr [bp - 0xac] ; LOCAL_LOAD
031D34  4B                    DEC    bx ; ARITH
031D35  4B                    DEC    bx ; ARITH
031D36  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
031D39  42                    INC    dx ; ARITH
031D3A  9A BA 00 1F 18        LCALL  0x181f, 0xba ; THUNK -> 0x0B9E:0x000A (thunk @file 0x01A6AA type B)
031D3F  FF 76 04              PUSH   word ptr [bp + 4] ; STACK_PUSH
031D42  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
031D47  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031D4A  52                    PUSH   dx ; STACK_PUSH
031D4B  50                    PUSH   ax ; STACK_PUSH
031D4C  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
031D4F  16                    PUSH   ss ; STACK_PUSH
031D50  50                    PUSH   ax ; STACK_PUSH
031D51  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
031D56  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
031D59  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
031D5C  50                    PUSH   ax ; STACK_PUSH
031D5D  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
031D62  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031D65  0B C0                 OR     ax, ax ; LOGIC
031D67  74 13                 JE     0x31d7c ; CJUMP
031D69  8D 46 AB              LEA    ax, [bp - 0x55] ; ADDR
031D6C  50                    PUSH   ax ; STACK_PUSH
031D6D  8D 86 5A FF           LEA    ax, [bp - 0xa6] ; ADDR
031D71  50                    PUSH   ax ; STACK_PUSH
031D72  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
031D77  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
031D7A  EB 05                 JMP    0x31d81 ; JUMP
031D7C  C6 86 5A FF 00        MOV    byte ptr [bp - 0xa6], 0 ; LOCAL_STORE
031D81  C6 46 AB 00           MOV    byte ptr [bp - 0x55], 0 ; LOCAL_STORE
031D85  8A 86 58 FF           MOV    al, byte ptr [bp - 0xa8] ; LOCAL_LOAD
031D89  2A E4                 SUB    ah, ah ; ARITH
031D8B  50                    PUSH   ax ; STACK_PUSH
031D8C  FF B6 4A FF           PUSH   word ptr [bp - 0xb6] ; PUSH_GLOBAL
031D90  8A 86 50 FF           MOV    al, byte ptr [bp - 0xb0] ; LOCAL_LOAD
031D94  50                    PUSH   ax ; STACK_PUSH
031D95  FF B6 4A FF           PUSH   word ptr [bp - 0xb6] ; PUSH_GLOBAL
031D99  FF B6 4C FF           PUSH   word ptr [bp - 0xb4] ; PUSH_GLOBAL
031D9D  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
031DA0  16                    PUSH   ss ; STACK_PUSH
031DA1  50                    PUSH   ax ; STACK_PUSH
031DA2  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
031DA7  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
031DAA  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
031DAD  50                    PUSH   ax ; STACK_PUSH
031DAE  8D 86 5A FF           LEA    ax, [bp - 0xa6] ; ADDR
031DB2  16                    PUSH   ss ; STACK_PUSH
031DB3  50                    PUSH   ax ; STACK_PUSH
031DB4  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
031DB9  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
031DBC  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
031DBF  8B 86 52 FF           MOV    ax, word ptr [bp - 0xae] ; LOCAL_LOAD
031DC3  5E                    POP    si ; STACK_POP
031DC4  5F                    POP    di ; STACK_POP
031DC5  C9                    LEAVE ; EPILOGUE
031DC6  C3                    RET ; RETURN
