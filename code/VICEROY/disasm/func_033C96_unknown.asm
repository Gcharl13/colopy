; ============================================================================
; func_033C96_unknown
; Region   : overlay
; Bytes    : file 0x033C96..0x033EB2  (540 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "ARMOPTIONS"  (auto-named via string xrefs)
; ============================================================================

033C96  C8 6C 00 00           ENTER  0x6c, 0 ; PROLOGUE
033C9A  2B C0                 SUB    ax, ax ; ARITH
033C9C  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
033C9F  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
033CA2  FF 36 2C 9E           PUSH   word ptr [0x9e2c] ; PUSH_GLOBAL
033CA6  0E                    PUSH   cs ; STACK_PUSH
033CA7  E8 8B 2C              CALL   0x36935 ; CALL_NEAR
033CAA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033CAD  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
033CB0  0B C0                 OR     ax, ax ; LOGIC
033CB2  7D 03                 JGE    0x33cb7 ; CJUMP
033CB4  E9 09 05              JMP    0x341c0 ; JUMP
033CB7  6A 0F                 PUSH   0xf ; PUSH_CONST
033CB9  0E                    PUSH   cs ; STACK_PUSH
033CBA  E8 D3 2B              CALL   0x36890 ; CALL_NEAR
033CBD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033CC0  6B C0 32              IMUL   ax, ax, 0x32 ; ARITH
033CC3  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
033CC6  6A 0E                 PUSH   0xe ; PUSH_CONST
033CC8  0E                    PUSH   cs ; STACK_PUSH
033CC9  E8 C4 2B              CALL   0x36890 ; CALL_NEAR
033CCC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033CCF  6B C0 64              IMUL   ax, ax, 0x64 ; ARITH
033CD2  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
033CD5  6A 08                 PUSH   8 ; STACK_PUSH
033CD7  0E                    PUSH   cs ; STACK_PUSH
033CD8  E8 B5 2B              CALL   0x36890 ; CALL_NEAR
033CDB  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033CDE  6B C0 32              IMUL   ax, ax, 0x32 ; ARITH
033CE1  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
033CE4  6A 0F                 PUSH   0xf ; PUSH_CONST
033CE6  0E                    PUSH   cs ; STACK_PUSH
033CE7  E8 29 2B              CALL   0x36813 ; CALL_NEAR
033CEA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033CED  6B C0 32              IMUL   ax, ax, 0x32 ; ARITH
033CF0  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
033CF3  6A 0E                 PUSH   0xe ; PUSH_CONST
033CF5  0E                    PUSH   cs ; STACK_PUSH
033CF6  E8 1A 2B              CALL   0x36813 ; CALL_NEAR
033CF9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033CFC  6B C0 64              IMUL   ax, ax, 0x64 ; ARITH
033CFF  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
033D02  6A 08                 PUSH   8 ; STACK_PUSH
033D04  0E                    PUSH   cs ; STACK_PUSH
033D05  E8 0B 2B              CALL   0x36813 ; CALL_NEAR
033D08  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033D0B  6B C0 32              IMUL   ax, ax, 0x32 ; ARITH
033D0E  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
033D11  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
033D15  8D 06 4A 10           LEA    ax, [0x104a] ; ADDR
033D19  2B D2                 SUB    dx, dx ; ARITH
033D1B  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
033D20  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
033D23  89 56 AC              MOV    word ptr [bp - 0x54], dx ; LOCAL_STORE
033D26  0B D0                 OR     dx, ax ; LOGIC
033D28  75 03                 JNE    0x33d2d ; CJUMP
033D2A  E9 93 04              JMP    0x341c0 ; JUMP
033D2D  6B 5E 94 1C           IMUL   bx, word ptr [bp - 0x6c], 0x1c ; ARITH
033D31  80 BF 46 31 01        CMP    byte ptr [bx + 0x3146], 1 ; CMP
033D36  74 07                 JE     0x33d3f ; CJUMP
033D38  80 BF 46 31 04        CMP    byte ptr [bx + 0x3146], 4 ; CMP
033D3D  75 05                 JNE    0x33d44 ; CJUMP
033D3F  8B 46 A2              MOV    ax, word ptr [bp - 0x5e] ; LOCAL_LOAD
033D42  EB 03                 JMP    0x33d47 ; JUMP
033D44  8B 46 9C              MOV    ax, word ptr [bp - 0x64] ; LOCAL_LOAD
033D47  99                    CDQ ; ARITH
033D48  52                    PUSH   dx ; STACK_PUSH
033D49  50                    PUSH   ax ; STACK_PUSH
033D4A  6A 00                 PUSH   0 ; STACK_PUSH
033D4C  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
033D51  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
033D54  6B 5E 94 1C           IMUL   bx, word ptr [bp - 0x6c], 0x1c ; ARITH
033D58  80 BF 46 31 02        CMP    byte ptr [bx + 0x3146], 2 ; CMP
033D5D  75 05                 JNE    0x33d64 ; CJUMP
033D5F  8B 46 A4              MOV    ax, word ptr [bp - 0x5c] ; LOCAL_LOAD
033D62  EB 03                 JMP    0x33d67 ; JUMP
033D64  8B 46 9E              MOV    ax, word ptr [bp - 0x62] ; LOCAL_LOAD
033D67  99                    CDQ ; ARITH
033D68  52                    PUSH   dx ; STACK_PUSH
033D69  50                    PUSH   ax ; STACK_PUSH
033D6A  6A 01                 PUSH   1 ; STACK_PUSH
033D6C  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
033D71  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
033D74  6B 5E 94 1C           IMUL   bx, word ptr [bp - 0x6c], 0x1c ; ARITH
033D78  80 BF 46 31 05        CMP    byte ptr [bx + 0x3146], 5 ; CMP
033D7D  74 07                 JE     0x33d86 ; CJUMP
033D7F  80 BF 46 31 04        CMP    byte ptr [bx + 0x3146], 4 ; CMP
033D84  75 06                 JNE    0x33d8c ; CJUMP
033D86  8B 46 A6              MOV    ax, word ptr [bp - 0x5a] ; LOCAL_LOAD
033D89  EB 04                 JMP    0x33d8f ; JUMP
033D8B  90                    NOP ; NOP
033D8C  8B 46 A0              MOV    ax, word ptr [bp - 0x60] ; LOCAL_LOAD
033D8F  99                    CDQ ; ARITH
033D90  52                    PUSH   dx ; STACK_PUSH
033D91  50                    PUSH   ax ; STACK_PUSH
033D92  6A 02                 PUSH   2 ; STACK_PUSH
033D94  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
033D99  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
033D9C  C4 5E AA              LES    bx, ptr [bp - 0x56] ; MOV_FAR
033D9F  26 80 4F 0A 03        OR     byte ptr es:[bx + 0xa], 3 ; LOGIC
033DA4  68 54 10              PUSH   0x1054                       ; STRING: "ARMOPTIONS"
033DA7  68 7C 08              PUSH   0x87c ; PUSH_CONST
033DAA  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
033DAF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
033DB2  0B C0                 OR     ax, ax ; LOGIC
033DB4  74 03                 JE     0x33db9 ; CJUMP
033DB6  E9 07 04              JMP    0x341c0 ; JUMP
033DB9  50                    PUSH   ax ; STACK_PUSH
033DBA  50                    PUSH   ax ; STACK_PUSH
033DBB  50                    PUSH   ax ; STACK_PUSH
033DBC  FF 76 94              PUSH   word ptr [bp - 0x6c] ; PUSH_GLOBAL
033DBF  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
033DC3  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
033DC7  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
033DCA  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
033DCD  9A 30 02 1F 19        LCALL  0x191f, 0x230 ; THUNK -> 0x0000:0x0F3C (thunk @file 0x01B820 type A) overlay @file 0x02683C
033DD2  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
033DD5  C7 46 98 01 00        MOV    word ptr [bp - 0x68], 1 ; LOCAL_STORE
033DDA  E9 F1 01              JMP    0x33fce ; JUMP
033DDD  90                    NOP ; NOP
033DDE  6B 5E 94 1C           IMUL   bx, word ptr [bp - 0x6c], 0x1c ; ARITH
033DE2  80 BF 4C 31 01        CMP    byte ptr [bx + 0x314c], 1 ; CMP
033DE7  74 1E                 JE     0x33e07 ; CJUMP
033DE9  2B C0                 SUB    ax, ax ; ARITH
033DEB  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
033DEE  E9 91 01              JMP    0x33f82 ; JUMP
033DF1  90                    NOP ; NOP
033DF2  6B 5E 94 1C           IMUL   bx, word ptr [bp - 0x6c], 0x1c ; ARITH
033DF6  80 BF 4C 31 01        CMP    byte ptr [bx + 0x314c], 1 ; CMP
033DFB  74 EC                 JE     0x33de9 ; CJUMP
033DFD  EB 08                 JMP    0x33e07 ; JUMP
033DFF  90                    NOP ; NOP
033E00  83 3E 2C 9E 00        CMP    word ptr [0x9e2c], 0 ; CMP
033E05  7E E2                 JLE    0x33de9 ; CJUMP
033E07  B8 01 00              MOV    ax, 1 ; MOV
033E0A  EB DF                 JMP    0x33deb ; JUMP
033E0C  6B 5E 94 1C           IMUL   bx, word ptr [bp - 0x6c], 0x1c ; ARITH
033E10  80 BF 46 31 00        CMP    byte ptr [bx + 0x3146], 0 ; CMP
033E15  74 07                 JE     0x33e1e ; CJUMP
033E17  80 BF 46 31 05        CMP    byte ptr [bx + 0x3146], 5 ; CMP
033E1C  75 08                 JNE    0x33e26 ; CJUMP
033E1E  C7 46 9A 01 00        MOV    word ptr [bp - 0x66], 1 ; LOCAL_STORE
033E23  EB 06                 JMP    0x33e2b ; JUMP
033E25  90                    NOP ; NOP
033E26  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0 ; LOCAL_STORE
033E2B  6B 5E 94 1C           IMUL   bx, word ptr [bp - 0x6c], 0x1c ; ARITH
033E2F  80 BF 5B 31 1B        CMP    byte ptr [bx + 0x315b], 0x1b ; CMP
033E34  75 05                 JNE    0x33e3b ; CJUMP
033E36  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0 ; LOCAL_STORE
033E3B  8B 46 9C              MOV    ax, word ptr [bp - 0x64] ; LOCAL_LOAD
033E3E  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
033E41  6A 0F                 PUSH   0xf ; PUSH_CONST
033E43  0E                    PUSH   cs ; STACK_PUSH
033E44  E8 80 2A              CALL   0x368c7 ; CALL_NEAR
033E47  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033E4A  0B C0                 OR     ax, ax ; LOGIC
033E4C  75 03                 JNE    0x33e51 ; CJUMP
033E4E  E9 31 01              JMP    0x33f82 ; JUMP
033E51  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0 ; LOCAL_STORE
033E56  E9 29 01              JMP    0x33f82 ; JUMP
033E59  90                    NOP ; NOP
033E5A  6B 5E 94 1C           IMUL   bx, word ptr [bp - 0x6c], 0x1c ; ARITH
033E5E  80 BF 46 31 01        CMP    byte ptr [bx + 0x3146], 1 ; CMP
033E63  74 07                 JE     0x33e6c ; CJUMP
033E65  80 BF 46 31 04        CMP    byte ptr [bx + 0x3146], 4 ; CMP
033E6A  75 08                 JNE    0x33e74 ; CJUMP
033E6C  C7 46 9A 01 00        MOV    word ptr [bp - 0x66], 1 ; LOCAL_STORE
033E71  EB CE                 JMP    0x33e41 ; JUMP
033E73  90                    NOP ; NOP
033E74  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0 ; LOCAL_STORE
033E79  EB C6                 JMP    0x33e41 ; JUMP
033E7B  90                    NOP ; NOP
033E7C  6B 5E 94 1C           IMUL   bx, word ptr [bp - 0x6c], 0x1c ; ARITH
033E80  80 BF 46 31 01        CMP    byte ptr [bx + 0x3146], 1 ; CMP
033E85  1B C0                 SBB    ax, ax ; ARITH
033E87  F7 D8                 NEG    ax ; ARITH
033E89  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
033E8C  80 BF 5B 31 1B        CMP    byte ptr [bx + 0x315b], 0x1b ; CMP
033E91  75 05                 JNE    0x33e98 ; CJUMP
033E93  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0 ; LOCAL_STORE
033E98  6A 0E                 PUSH   0xe ; PUSH_CONST
033E9A  0E                    PUSH   cs ; STACK_PUSH
033E9B  E8 29 2A              CALL   0x368c7 ; CALL_NEAR
033E9E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033EA1  0B C0                 OR     ax, ax ; LOGIC
033EA3  74 05                 JE     0x33eaa ; CJUMP
033EA5  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0 ; LOCAL_STORE
033EAA  8B 46 9E              MOV    ax, word ptr [bp - 0x62] ; LOCAL_LOAD
033EAD  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
033EB0  E9                    DB     0xE9 ; DATA_BYTE
033EB1  CF                    DB     0xCF ; DATA_BYTE
