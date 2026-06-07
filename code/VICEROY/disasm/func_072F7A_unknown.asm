; ============================================================================
; func_072F7A_unknown
; Region   : overlay
; Bytes    : file 0x072F7A..0x073158  (478 bytes)
; Purpose  : Save game prompt  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "SAVEGAME"  (auto-named via string xrefs)
; ============================================================================

072F7A  C8 5C 00 00           ENTER  0x5c, 0 ; PROLOGUE
072F7E  6A 08                 PUSH   8 ; STACK_PUSH
072F80  68 F6 20              PUSH   0x20f6                       ; STRING: "SAVEGAME"
072F83  0E                    PUSH   cs ; STACK_PUSH
072F84  E8 E4 02              CALL   0x7326b ; CALL_NEAR
072F87  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
072F8A  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
072F8D  89 56 AC              MOV    word ptr [bp - 0x54], dx ; LOCAL_STORE
072F90  0B D0                 OR     dx, ax ; LOGIC
072F92  75 03                 JNE    0x72f97 ; CJUMP
072F94  E9 AC 01              JMP    0x73143 ; JUMP
072F97  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
072F9A  50                    PUSH   ax ; STACK_PUSH
072F9B  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
072FA0  48                    DEC    ax ; ARITH
072FA1  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
072FA4  0B C0                 OR     ax, ax ; LOGIC
072FA6  7D 03                 JGE    0x72fab ; CJUMP
072FA8  E9 98 01              JMP    0x73143 ; JUMP
072FAB  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
072FAE  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
072FB1  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
072FB6  2B C0                 SUB    ax, ax ; ARITH
072FB8  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
072FBB  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
072FBE  FF 76 AE              PUSH   word ptr [bp - 0x52] ; PUSH_GLOBAL
072FC1  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
072FC4  50                    PUSH   ax ; STACK_PUSH
072FC5  0E                    PUSH   cs ; STACK_PUSH
072FC6  E8 9D 02              CALL   0x73266 ; CALL_NEAR
072FC9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
072FCC  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
072FCF  50                    PUSH   ax ; STACK_PUSH
072FD0  9A F6 0C 1F 1A        LCALL  0x1a1f, 0xcf6 ; THUNK -> 0x0000:0x0288 (thunk @file 0x01D2E6 type A) overlay @file 0x025B88
072FD5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
072FD8  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
072FDB  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
072FDE  16                    PUSH   ss ; STACK_PUSH
072FDF  50                    PUSH   ax ; STACK_PUSH
072FE0  1E                    PUSH   ds ; STACK_PUSH
072FE1  68 D2 9C              PUSH   0x9cd2 ; PUSH_CONST
072FE4  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
072FE9  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
072FEC  83 7E A6 00           CMP    word ptr [bp - 0x5a], 0 ; CMP
072FF0  74 03                 JE     0x72ff5 ; CJUMP
072FF2  E9 2F 01              JMP    0x73124 ; JUMP
072FF5  C7 46 A4 FF FF        MOV    word ptr [bp - 0x5c], 0xffff ; LOCAL_STORE
072FFA  C7 46 A8 00 00        MOV    word ptr [bp - 0x58], 0 ; LOCAL_STORE
072FFF  EB 1B                 JMP    0x7301c ; JUMP
073001  90                    NOP ; NOP
073002  83 7E A8 04           CMP    word ptr [bp - 0x58], 4 ; CMP
073006  7D 1A                 JGE    0x73022 ; CJUMP
073008  6B 5E A8 34           IMUL   bx, word ptr [bp - 0x58], 0x34 ; ARITH
07300C  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
073011  75 06                 JNE    0x73019 ; CJUMP
073013  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
073016  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
073019  FF 46 A8              INC    word ptr [bp - 0x58] ; ARITH
07301C  83 7E A4 00           CMP    word ptr [bp - 0x5c], 0 ; CMP
073020  7C E0                 JL     0x73002 ; CJUMP
073022  83 7E A4 00           CMP    word ptr [bp - 0x5c], 0 ; CMP
073026  7D 05                 JGE    0x7302d ; CJUMP
073028  C7 46 A4 00 00        MOV    word ptr [bp - 0x5c], 0 ; LOCAL_STORE
07302D  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
073031  8A 1E A6 53           MOV    bl, byte ptr [0x53a6] ; GLOBAL_LOAD
073035  2A FF                 SUB    bh, bh ; ARITH
073037  D1 E3                 SHL    bx, 1 ; LOGIC
073039  FF B7 94 83           PUSH   word ptr [bx - 0x7c6c] ; PUSH_GLOBAL
07303D  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
073040  50                    PUSH   ax ; STACK_PUSH
073041  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
073046  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
073049  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
07304C  50                    PUSH   ax ; STACK_PUSH
07304D  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
073052  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
073055  6B 46 A4 34           IMUL   ax, word ptr [bp - 0x5c], 0x34 ; ARITH
073059  05 0E 54              ADD    ax, 0x540e ; ARITH
07305C  1E                    PUSH   ds ; STACK_PUSH
07305D  50                    PUSH   ax ; STACK_PUSH
07305E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
073061  16                    PUSH   ss ; STACK_PUSH
073062  50                    PUSH   ax ; STACK_PUSH
073063  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
073068  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
07306B  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
07306E  50                    PUSH   ax ; STACK_PUSH
07306F  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
073074  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
073077  FF 36 E0 2D           PUSH   word ptr [0x2de0] ; PUSH_GLOBAL
07307B  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
07307E  50                    PUSH   ax ; STACK_PUSH
07307F  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
073084  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
073087  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
07308A  50                    PUSH   ax ; STACK_PUSH
07308B  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
073090  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
073093  8B 5E A4              MOV    bx, word ptr [bp - 0x5c] ; LOCAL_LOAD
073096  D1 E3                 SHL    bx, 1 ; LOGIC
073098  FF B7 0A 8D           PUSH   word ptr [bx - 0x72f6] ; PUSH_GLOBAL
07309C  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
07309F  50                    PUSH   ax ; STACK_PUSH
0730A0  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
0730A5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0730A8  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0730AB  50                    PUSH   ax ; STACK_PUSH
0730AC  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
0730B1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0730B4  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0730B7  50                    PUSH   ax ; STACK_PUSH
0730B8  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
0730BD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0730C0  8B 1E 8C 53           MOV    bx, word ptr [0x538c] ; GLOBAL_LOAD
0730C4  D1 E3                 SHL    bx, 1 ; LOGIC
0730C6  FF B7 00 98           PUSH   word ptr [bx - 0x6800] ; PUSH_GLOBAL
0730CA  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
0730CF  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0730D2  52                    PUSH   dx ; STACK_PUSH
0730D3  50                    PUSH   ax ; STACK_PUSH
0730D4  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0730D7  16                    PUSH   ss ; STACK_PUSH
0730D8  50                    PUSH   ax ; STACK_PUSH
0730D9  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
0730DE  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0730E1  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0730E4  50                    PUSH   ax ; STACK_PUSH
0730E5  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
0730EA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0730ED  FF 36 8A 53           PUSH   word ptr [0x538a] ; PUSH_GLOBAL
0730F1  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0730F4  16                    PUSH   ss ; STACK_PUSH
0730F5  50                    PUSH   ax ; STACK_PUSH
0730F6  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
0730FB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0730FE  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
073101  50                    PUSH   ax ; STACK_PUSH
073102  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
073107  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
07310A  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
07310D  16                    PUSH   ss ; STACK_PUSH
07310E  50                    PUSH   ax ; STACK_PUSH
07310F  6A 01                 PUSH   1 ; STACK_PUSH
073111  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
073116  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
073119  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
07311D  8D 06 FF 20           LEA    ax, [0x20ff] ; ADDR
073121  EB 19                 JMP    0x7313c ; JUMP
073123  90                    NOP ; NOP
073124  83 7E A6 02           CMP    word ptr [bp - 0x5a], 2 ; CMP
073128  75 0A                 JNE    0x73134 ; CJUMP
07312A  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
07312E  8D 06 08 21           LEA    ax, [0x2108] ; ADDR
073132  EB 08                 JMP    0x7313c ; JUMP
073134  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
073138  8D 06 10 21           LEA    ax, [0x2110] ; ADDR
07313C  2B D2                 SUB    dx, dx ; ARITH
07313E  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
073143  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
073146  0B 46 AA              OR     ax, word ptr [bp - 0x56] ; LOGIC
073149  74 0B                 JE     0x73156 ; CJUMP
07314B  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
07314E  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
073151  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
073156  C9                    LEAVE ; EPILOGUE
073157  CB                    RETF ; RETURN
