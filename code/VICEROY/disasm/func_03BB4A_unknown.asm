; ============================================================================
; func_03BB4A_unknown
; Region   : overlay
; Bytes    : file 0x03BB4A..0x03BC41  (247 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "CCBKGD"  (auto-named via string xrefs)
; ============================================================================

03BB4A  C8 00 03 00           ENTER  0x300, 0 ; PROLOGUE
03BB4E  8D 86 00 FD           LEA    ax, [bp - 0x300] ; ADDR
03BB52  16                    PUSH   ss ; STACK_PUSH
03BB53  50                    PUSH   ax ; STACK_PUSH
03BB54  2B C0                 SUB    ax, ax ; ARITH
03BB56  A3 72 03              MOV    word ptr [0x372], ax ; GLOBAL_LOAD
03BB59  50                    PUSH   ax ; STACK_PUSH
03BB5A  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
03BB5E  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
03BB62  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
03BB66  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
03BB6A  68 53 12              PUSH   0x1253                       ; STRING: "CCBKGD"
03BB6D  9A 4E 04 1F 18        LCALL  0x181f, 0x44e ; THUNK -> 0x0000:0x000E (thunk @file 0x01AA3E type A) overlay @file 0x02590E
03BB72  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
03BB75  0B C0                 OR     ax, ax ; LOGIC
03BB77  74 03                 JE     0x3bb7c ; CJUMP
03BB79  E9 AD 00              JMP    0x3bc29 ; JUMP
03BB7C  9A B6 03 1F 18        LCALL  0x181f, 0x3b6 ; THUNK -> 0x0262:0x0012 (thunk @file 0x01A9A6 type B) overlay @file 0x021D42
03BB81  8D 86 00 FD           LEA    ax, [bp - 0x300] ; ADDR
03BB85  16                    PUSH   ss ; STACK_PUSH
03BB86  50                    PUSH   ax ; STACK_PUSH
03BB87  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
03BB8C  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
03BB90  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
03BB94  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
03BB98  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
03BB9C  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
03BBA0  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
03BBA4  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
03BBA8  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
03BBAC  68 C8 00              PUSH   0xc8 ; PUSH_CONST
03BBAF  2B C0                 SUB    ax, ax ; ARITH
03BBB1  99                    CDQ ; ARITH
03BBB2  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
03BBB5  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
03BBBA  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
03BBBE  7C 0F                 JL     0x3bbcf ; CJUMP
03BBC0  6A 00                 PUSH   0 ; STACK_PUSH
03BBC2  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
03BBC5  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03BBC8  0E                    PUSH   cs ; STACK_PUSH
03BBC9  E8 49 08              CALL   0x3c415 ; CALL_NEAR
03BBCC  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03BBCF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03BBD2  0E                    PUSH   cs ; STACK_PUSH
03BBD3  E8 3A 08              CALL   0x3c410 ; CALL_NEAR
03BBD6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03BBD9  6A 00                 PUSH   0 ; STACK_PUSH
03BBDB  68 40 01              PUSH   0x140 ; PUSH_CONST
03BBDE  68 C8 00              PUSH   0xc8 ; PUSH_CONST
03BBE1  2B C0                 SUB    ax, ax ; ARITH
03BBE3  99                    CDQ ; ARITH
03BBE4  2B DB                 SUB    bx, bx ; ARITH
03BBE6  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
03BBEB  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
03BBEF  7C 23                 JL     0x3bc14 ; CJUMP
03BBF1  6A 01                 PUSH   1 ; STACK_PUSH
03BBF3  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
03BBF6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03BBF9  0E                    PUSH   cs ; STACK_PUSH
03BBFA  E8 18 08              CALL   0x3c415 ; CALL_NEAR
03BBFD  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03BC00  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03BC03  0E                    PUSH   cs ; STACK_PUSH
03BC04  E8 09 08              CALL   0x3c410 ; CALL_NEAR
03BC07  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03BC0A  6A 08                 PUSH   8 ; STACK_PUSH
03BC0C  9A EA 03 1F 18        LCALL  0x181f, 0x3ea ; THUNK -> 0x02D6:0x0000 (thunk @file 0x01A9DA type B)
03BC11  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03BC14  9A C0 03 1F 18        LCALL  0x181f, 0x3c0 ; THUNK -> 0x0262:0x0060 (thunk @file 0x01A9B0 type B) overlay @file 0x021D90
03BC19  9A B6 03 1F 18        LCALL  0x181f, 0x3b6 ; THUNK -> 0x0262:0x0012 (thunk @file 0x01A9A6 type B) overlay @file 0x021D42
03BC1E  68 00 A0              PUSH   0xa000 ; PUSH_CONST
03BC21  68 00 FC              PUSH   0xfc00 ; PUSH_CONST
03BC24  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
03BC29  8A 26 83 53           MOV    ah, byte ptr [0x5383] ; GLOBAL_LOAD
03BC2D  25 00 01              AND    ax, 0x100 ; LOGIC
03BC30  3D 01 00              CMP    ax, 1 ; CMP
03BC33  1B C0                 SBB    ax, ax ; ARITH
03BC35  F7 D8                 NEG    ax ; ARITH
03BC37  A3 72 03              MOV    word ptr [0x372], ax ; GLOBAL_LOAD
03BC3A  9A AC 0A 1F 19        LCALL  0x191f, 0xaac ; THUNK -> 0x0000:0x00C4 (thunk @file 0x01C09C type A) overlay @file 0x0259C4
03BC3F  C9                    LEAVE ; EPILOGUE
03BC40  CB                    RETF ; RETURN
