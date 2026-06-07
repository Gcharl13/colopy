; ============================================================================
; func_021EDE_unknown
; Region   : overlay
; Bytes    : file 0x021EDE..0x021FE6  (264 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021EDE  C8 5E 00 00           ENTER  0x5e, 0 ; PROLOGUE
021EE2  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
021EE5  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
021EE8  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
021EEB  80 BF 50 31 00        CMP    byte ptr [bx + 0x3150], 0 ; CMP
021EF0  75 03                 JNE    0x21ef5 ; CJUMP
021EF2  E9 E9 00              JMP    0x21fde ; JUMP
021EF5  2B D2                 SUB    dx, dx ; ARITH
021EF7  89 16 5E 1F           MOV    word ptr [0x1f5e], dx ; GLOBAL_LOAD
021EFB  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
021EFF  8D 06 28 09           LEA    ax, [0x928] ; ADDR
021F03  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
021F08  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
021F0B  89 56 AE              MOV    word ptr [bp - 0x52], dx ; LOCAL_STORE
021F0E  0B D0                 OR     dx, ax ; LOGIC
021F10  75 03                 JNE    0x21f15 ; CJUMP
021F12  E9 C9 00              JMP    0x21fde ; JUMP
021F15  6A 63                 PUSH   0x63 ; PUSH_CONST
021F17  FF 36 FA 2D           PUSH   word ptr [0x2dfa] ; PUSH_GLOBAL
021F1B  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
021F20  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
021F23  52                    PUSH   dx ; STACK_PUSH
021F24  50                    PUSH   ax ; STACK_PUSH
021F25  FF 76 AE              PUSH   word ptr [bp - 0x52] ; PUSH_GLOBAL
021F28  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
021F2B  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
021F30  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
021F33  C7 46 A6 00 00        MOV    word ptr [bp - 0x5a], 0 ; LOCAL_STORE
021F38  EB 70                 JMP    0x21faa ; JUMP
021F3A  FF 76 A6              PUSH   word ptr [bp - 0x5a] ; PUSH_GLOBAL
021F3D  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
021F40  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
021F45  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
021F48  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
021F4B  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
021F4F  FF 76 A6              PUSH   word ptr [bp - 0x5a] ; PUSH_GLOBAL
021F52  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
021F55  9A 68 0C 1F 18        LCALL  0x181f, 0xc68 ; THUNK -> 0x05EB:0x3040 (thunk @file 0x01B258 type B) overlay @file 0x02A030
021F5A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
021F5D  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
021F60  50                    PUSH   ax ; STACK_PUSH
021F61  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
021F64  16                    PUSH   ss ; STACK_PUSH
021F65  50                    PUSH   ax ; STACK_PUSH
021F66  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
021F6B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
021F6E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
021F71  50                    PUSH   ax ; STACK_PUSH
021F72  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
021F77  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
021F7A  8B 5E A4              MOV    bx, word ptr [bp - 0x5c] ; LOCAL_LOAD
021F7D  D1 E3                 SHL    bx, 1 ; LOGIC
021F7F  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
021F83  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
021F86  50                    PUSH   ax ; STACK_PUSH
021F87  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
021F8C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
021F8F  8B 46 A6              MOV    ax, word ptr [bp - 0x5a] ; LOCAL_LOAD
021F92  40                    INC    ax ; ARITH
021F93  50                    PUSH   ax ; STACK_PUSH
021F94  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
021F97  16                    PUSH   ss ; STACK_PUSH
021F98  50                    PUSH   ax ; STACK_PUSH
021F99  FF 76 AE              PUSH   word ptr [bp - 0x52] ; PUSH_GLOBAL
021F9C  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
021F9F  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
021FA4  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
021FA7  FF 46 A6              INC    word ptr [bp - 0x5a] ; ARITH
021FAA  6B 5E A2 1C           IMUL   bx, word ptr [bp - 0x5e], 0x1c ; ARITH
021FAE  8A 87 50 31           MOV    al, byte ptr [bx + 0x3150] ; MOV
021FB2  2A E4                 SUB    ah, ah ; ARITH
021FB4  3B 46 A6              CMP    ax, word ptr [bp - 0x5a] ; CMP
021FB7  7F 81                 JG     0x21f3a ; CJUMP
021FB9  FF 76 AE              PUSH   word ptr [bp - 0x52] ; PUSH_GLOBAL
021FBC  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
021FBF  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
021FC4  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
021FC7  0B C0                 OR     ax, ax ; LOGIC
021FC9  7E 13                 JLE    0x21fde ; CJUMP
021FCB  3D 63 00              CMP    ax, 0x63 ; CMP
021FCE  74 0E                 JE     0x21fde ; CJUMP
021FD0  FF 4E A8              DEC    word ptr [bp - 0x58] ; ARITH
021FD3  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
021FD6  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
021FD9  9A EC 0A 1F 18        LCALL  0x181f, 0xaec ; THUNK -> 0x05EB:0x317C (thunk @file 0x01B0DC type B) overlay @file 0x02A16C
021FDE  C7 06 5E 1F FF FF     MOV    word ptr [0x1f5e], 0xffff ; GLOBAL_LOAD
021FE4  C9                    LEAVE ; EPILOGUE
021FE5  CB                    RETF ; RETURN
