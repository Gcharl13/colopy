; ============================================================================
; func_026DD4_unknown
; Region   : overlay
; Bytes    : file 0x026DD4..0x026FF1  (541 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026DD4  C8 62 00 00           ENTER  0x62, 0 ; PROLOGUE
026DD8  C7 46 AA 00 00        MOV    word ptr [bp - 0x56], 0 ; LOCAL_STORE
026DDD  A0 36 03              MOV    al, byte ptr [0x336] ; GLOBAL_LOAD
026DE0  2A E4                 SUB    ah, ah ; ARITH
026DE2  A3 70 00              MOV    word ptr [0x70], ax ; GLOBAL_LOAD
026DE5  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
026DE8  40                    INC    ax ; ARITH
026DE9  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
026DEC  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
026DF0  75 13                 JNE    0x26e05 ; CJUMP
026DF2  6A 00                 PUSH   0 ; STACK_PUSH
026DF4  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
026DF9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026DFC  0B C0                 OR     ax, ax ; LOGIC
026DFE  75 05                 JNE    0x26e05 ; CJUMP
026E00  C7 46 A8 11 00        MOV    word ptr [bp - 0x58], 0x11 ; LOCAL_STORE
026E05  83 7E 06 0F           CMP    word ptr [bp + 6], 0xf ; CMP
026E09  74 06                 JE     0x26e11 ; CJUMP
026E0B  83 7E 06 11           CMP    word ptr [bp + 6], 0x11 ; CMP
026E0F  75 28                 JNE    0x26e39 ; CJUMP
026E11  6A 0F                 PUSH   0xf ; PUSH_CONST
026E13  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
026E18  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026E1B  0B C0                 OR     ax, ax ; LOGIC
026E1D  74 15                 JE     0x26e34 ; CJUMP
026E1F  6A 11                 PUSH   0x11 ; PUSH_CONST
026E21  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
026E26  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026E29  0B C0                 OR     ax, ax ; LOGIC
026E2B  74 0C                 JE     0x26e39 ; CJUMP
026E2D  C7 46 A8 30 00        MOV    word ptr [bp - 0x58], 0x30 ; LOCAL_STORE
026E32  EB 05                 JMP    0x26e39 ; JUMP
026E34  C7 46 A8 2F 00        MOV    word ptr [bp - 0x58], 0x2f ; LOCAL_STORE
026E39  FF 36 44 08           PUSH   word ptr [0x844] ; PUSH_GLOBAL
026E3D  FF 36 42 08           PUSH   word ptr [0x842] ; PUSH_GLOBAL
026E41  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
026E44  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
026E47  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
026E4B  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
026E4E  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
026E53  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
026E56  9A CE 0A 1F 18        LCALL  0x181f, 0xace ; THUNK -> 0x05EB:0x14D6 (thunk @file 0x01B0BE type B) overlay @file 0x0284C6
026E5B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026E5E  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
026E61  83 7E 06 0F           CMP    word ptr [bp + 6], 0xf ; CMP
026E65  75 13                 JNE    0x26e7a ; CJUMP
026E67  6A 11                 PUSH   0x11 ; PUSH_CONST
026E69  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
026E6E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026E71  0B C0                 OR     ax, ax ; LOGIC
026E73  74 05                 JE     0x26e7a ; CJUMP
026E75  C7 46 06 11 00        MOV    word ptr [bp + 6], 0x11 ; LOCAL_STORE
026E7A  83 7E A0 00           CMP    word ptr [bp - 0x60], 0 ; CMP
026E7E  7D 15                 JGE    0x26e95 ; CJUMP
026E80  83 7E 06 13           CMP    word ptr [bp + 6], 0x13 ; CMP
026E84  74 0F                 JE     0x26e95 ; CJUMP
026E86  83 7E 06 14           CMP    word ptr [bp + 6], 0x14 ; CMP
026E8A  74 09                 JE     0x26e95 ; CJUMP
026E8C  83 7E 06 11           CMP    word ptr [bp + 6], 0x11 ; CMP
026E90  74 03                 JE     0x26e95 ; CJUMP
026E92  E9 D0 00              JMP    0x26f65 ; JUMP
026E95  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
026E98  9A AA 0B 1F 18        LCALL  0x181f, 0xbaa ; THUNK -> 0x05EB:0x1568 (thunk @file 0x01B19A type B) overlay @file 0x028558
026E9D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026EA0  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
026EA3  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
026EA6  50                    PUSH   ax ; STACK_PUSH
026EA7  8D 46 A2              LEA    ax, [bp - 0x5e] ; ADDR
026EAA  50                    PUSH   ax ; STACK_PUSH
026EAB  8D 46 9E              LEA    ax, [bp - 0x62] ; ADDR
026EAE  50                    PUSH   ax ; STACK_PUSH
026EAF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
026EB2  0E                    PUSH   cs ; STACK_PUSH
026EB3  E8 90 5B              CALL   0x2ca46 ; CALL_NEAR
026EB6  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
026EB9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
026EBC  83 7E 06 11           CMP    word ptr [bp + 6], 0x11 ; CMP
026EC0  75 05                 JNE    0x26ec7 ; CJUMP
026EC2  C7 46 AA 09 00        MOV    word ptr [bp - 0x56], 9 ; LOCAL_STORE
026EC7  0B C0                 OR     ax, ax ; LOGIC
026EC9  74 31                 JE     0x26efc ; CJUMP
026ECB  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
026ECE  8A 87 4E 02           MOV    al, byte ptr [bx + 0x24e] ; MOV
026ED2  98                    CWDE ; ARITH
026ED3  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
026ED6  50                    PUSH   ax ; STACK_PUSH
026ED7  8A 87 54 02           MOV    al, byte ptr [bx + 0x254] ; MOV
026EDB  98                    CWDE ; ARITH
026EDC  03 46 0A              ADD    ax, word ptr [bp + 0xa] ; ARITH
026EDF  03 46 AA              ADD    ax, word ptr [bp - 0x56] ; ARITH
026EE2  50                    PUSH   ax ; STACK_PUSH
026EE3  8A 87 5A 02           MOV    al, byte ptr [bx + 0x25a] ; MOV
026EE7  98                    CWDE ; ARITH
026EE8  50                    PUSH   ax ; STACK_PUSH
026EE9  50                    PUSH   ax ; STACK_PUSH
026EEA  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
026EED  6A 00                 PUSH   0 ; STACK_PUSH
026EEF  8B 46 A2              MOV    ax, word ptr [bp - 0x5e] ; LOCAL_LOAD
026EF2  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
026EF5  8B DA                 MOV    bx, dx ; MOV
026EF7  9A 36 02 1F 18        LCALL  0x181f, 0x236 ; THUNK -> 0x0097:0x0174 (thunk @file 0x01A826 type B) overlay @file 0x027240
026EFC  83 7E A6 00           CMP    word ptr [bp - 0x5a], 0 ; CMP
026F00  74 63                 JE     0x26f65 ; CJUMP
026F02  7E 30                 JLE    0x26f34 ; CJUMP
026F04  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
026F07  9A 88 0A 1F 18        LCALL  0x181f, 0xa88 ; THUNK -> 0x05EB:0x14AA (thunk @file 0x01B078 type B) overlay @file 0x02849A
026F0C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026F0F  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
026F12  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
026F15  8A 87 42 02           MOV    al, byte ptr [bx + 0x242] ; MOV
026F19  98                    CWDE ; ARITH
026F1A  03 46 0A              ADD    ax, word ptr [bp + 0xa] ; ARITH
026F1D  50                    PUSH   ax ; STACK_PUSH
026F1E  8A 87 3C 02           MOV    al, byte ptr [bx + 0x23c] ; MOV
026F22  98                    CWDE ; ARITH
026F23  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
026F26  50                    PUSH   ax ; STACK_PUSH
026F27  FF 76 A0              PUSH   word ptr [bp - 0x60] ; PUSH_GLOBAL
026F2A  0E                    PUSH   cs ; STACK_PUSH
026F2B  E8 27 5B              CALL   0x2ca55 ; CALL_NEAR
026F2E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
026F31  EB 32                 JMP    0x26f65 ; JUMP
026F33  90                    NOP ; NOP
026F34  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
026F37  9A 88 0A 1F 18        LCALL  0x181f, 0xa88 ; THUNK -> 0x05EB:0x14AA (thunk @file 0x01B078 type B) overlay @file 0x02849A
026F3C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026F3F  0B C0                 OR     ax, ax ; LOGIC
026F41  75 22                 JNE    0x26f65 ; CJUMP
026F43  8B 46 A6              MOV    ax, word ptr [bp - 0x5a] ; LOCAL_LOAD
026F46  F7 D8                 NEG    ax ; ARITH
026F48  50                    PUSH   ax ; STACK_PUSH
026F49  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
026F4C  8A 87 42 02           MOV    al, byte ptr [bx + 0x242] ; MOV
026F50  98                    CWDE ; ARITH
026F51  03 46 0A              ADD    ax, word ptr [bp + 0xa] ; ARITH
026F54  50                    PUSH   ax ; STACK_PUSH
026F55  8A 87 3C 02           MOV    al, byte ptr [bx + 0x23c] ; MOV
026F59  98                    CWDE ; ARITH
026F5A  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
026F5D  50                    PUSH   ax ; STACK_PUSH
026F5E  0E                    PUSH   cs ; STACK_PUSH
026F5F  E8 53 5A              CALL   0x2c9b5 ; CALL_NEAR
026F62  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
026F65  83 7E 06 11           CMP    word ptr [bp + 6], 0x11 ; CMP
026F69  75 13                 JNE    0x26f7e ; CJUMP
026F6B  6A 0F                 PUSH   0xf ; PUSH_CONST
026F6D  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
026F72  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026F75  0B C0                 OR     ax, ax ; LOGIC
026F77  74 05                 JE     0x26f7e ; CJUMP
026F79  C7 46 06 0F 00        MOV    word ptr [bp + 6], 0xf ; LOCAL_STORE
026F7E  C7 46 A4 00 00        MOV    word ptr [bp - 0x5c], 0 ; LOCAL_STORE
026F83  83 7E 06 0F           CMP    word ptr [bp + 6], 0xf ; CMP
026F87  75 0D                 JNE    0x26f96 ; CJUMP
026F89  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
026F8D  8A 87 95 00           MOV    al, byte ptr [bx + 0x95] ; MOV
026F91  2A E4                 SUB    ah, ah ; ARITH
026F93  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
026F96  83 7E 06 1E           CMP    word ptr [bp + 6], 0x1e ; CMP
026F9A  75 0D                 JNE    0x26fa9 ; CJUMP
026F9C  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
026FA0  8A 87 96 00           MOV    al, byte ptr [bx + 0x96] ; MOV
026FA4  2A E4                 SUB    ah, ah ; ARITH
026FA6  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
026FA9  83 7E A4 01           CMP    word ptr [bp - 0x5c], 1 ; CMP
026FAD  7E 3A                 JLE    0x26fe9 ; CJUMP
026FAF  6A 0A                 PUSH   0xa ; PUSH_CONST
026FB1  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
026FB4  50                    PUSH   ax ; STACK_PUSH
026FB5  FF 76 A4              PUSH   word ptr [bp - 0x5c] ; PUSH_GLOBAL
026FB8  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
026FBD  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
026FC0  6A 0F                 PUSH   0xf ; PUSH_CONST
026FC2  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
026FC5  8A 87 36 02           MOV    al, byte ptr [bx + 0x236] ; MOV
026FC9  D0 F8                 SAR    al, 1 ; LOGIC
026FCB  98                    CWDE ; ARITH
026FCC  03 46 0A              ADD    ax, word ptr [bp + 0xa] ; ARITH
026FCF  2D 03 00              SUB    ax, 3 ; ARITH
026FD2  50                    PUSH   ax ; STACK_PUSH
026FD3  8A 87 30 02           MOV    al, byte ptr [bx + 0x230] ; MOV
026FD7  D0 F8                 SAR    al, 1 ; LOGIC
026FD9  98                    CWDE ; ARITH
026FDA  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
026FDD  48                    DEC    ax ; ARITH
026FDE  50                    PUSH   ax ; STACK_PUSH
026FDF  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
026FE2  16                    PUSH   ss ; STACK_PUSH
026FE3  50                    PUSH   ax ; STACK_PUSH
026FE4  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
026FE9  C7 06 70 00 00 00     MOV    word ptr [0x70], 0 ; GLOBAL_LOAD
026FEF  C9                    LEAVE ; EPILOGUE
026FF0  CB                    RETF ; RETURN
