; ============================================================================
; func_072CC2_unknown
; Region   : overlay
; Bytes    : file 0x072CC2..0x072F7A  (696 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "(EMPTY)"  (auto-named via string xrefs)
; ============================================================================

072CC2  C8 76 02 00           ENTER  0x276, 0 ; PROLOGUE
072CC6  56                    PUSH   si ; STACK_PUSH
072CC7  C7 86 E2 FE 00 00     MOV    word ptr [bp - 0x11e], 0 ; LOCAL_STORE
072CCD  2B C0                 SUB    ax, ax ; ARITH
072CCF  89 86 EC FE           MOV    word ptr [bp - 0x114], ax ; LOCAL_STORE
072CD3  89 86 EA FE           MOV    word ptr [bp - 0x116], ax ; LOCAL_STORE
072CD7  FF 36 A2 1F           PUSH   word ptr [0x1fa2] ; PUSH_GLOBAL
072CDB  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
072CDF  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
072CE3  9A C4 07 1F 1A        LCALL  0x1a1f, 0x7c4 ; THUNK -> 0x0000:0x3084 (thunk @file 0x01CDB4 type A) overlay @file 0x028984
072CE8  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
072CEB  2B D2                 SUB    dx, dx ; ARITH
072CED  89 96 E0 FE           MOV    word ptr [bp - 0x120], dx ; LOCAL_STORE
072CF1  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
072CF5  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
072CF8  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
072CFD  89 86 EA FE           MOV    word ptr [bp - 0x116], ax ; LOCAL_STORE
072D01  89 96 EC FE           MOV    word ptr [bp - 0x114], dx ; LOCAL_STORE
072D05  0B D0                 OR     dx, ax ; LOGIC
072D07  75 03                 JNE    0x72d0c ; CJUMP
072D09  E9 4F 02              JMP    0x72f5b ; JUMP
072D0C  C4 9E EA FE           LES    bx, ptr [bp - 0x116] ; MOV_FAR
072D10  26 80 4F 0A 01        OR     byte ptr es:[bx + 0xa], 1 ; LOGIC
072D15  C7 86 E4 FE 00 00     MOV    word ptr [bp - 0x11c], 0 ; LOCAL_STORE
072D1B  E9 B0 01              JMP    0x72ece ; JUMP
072D1E  8B 9E E4 FE           MOV    bx, word ptr [bp - 0x11c] ; LOCAL_LOAD
072D22  C6 87 0C A6 01        MOV    byte ptr [bx - 0x59f4], 1 ; MOV
072D27  C7 86 E6 FE FF FF     MOV    word ptr [bp - 0x11a], 0xffff ; LOCAL_STORE
072D2D  C7 86 E8 FE 00 00     MOV    word ptr [bp - 0x118], 0 ; LOCAL_STORE
072D33  EB 20                 JMP    0x72d55 ; JUMP
072D35  90                    NOP ; NOP
072D36  83 BE E8 FE 04        CMP    word ptr [bp - 0x118], 4 ; CMP
072D3B  7D 1F                 JGE    0x72d5c ; CJUMP
072D3D  6B B6 E8 FE 34        IMUL   si, word ptr [bp - 0x118], 0x34 ; ARITH
072D42  80 BA BD FD 00        CMP    byte ptr [bp + si - 0x243], 0 ; CMP
072D47  75 08                 JNE    0x72d51 ; CJUMP
072D49  8B 86 E8 FE           MOV    ax, word ptr [bp - 0x118] ; LOCAL_LOAD
072D4D  89 86 E6 FE           MOV    word ptr [bp - 0x11a], ax ; LOCAL_STORE
072D51  FF 86 E8 FE           INC    word ptr [bp - 0x118] ; ARITH
072D55  83 BE E6 FE 00        CMP    word ptr [bp - 0x11a], 0 ; CMP
072D5A  7C DA                 JL     0x72d36 ; CJUMP
072D5C  83 BE E6 FE 00        CMP    word ptr [bp - 0x11a], 0 ; CMP
072D61  7D 06                 JGE    0x72d69 ; CJUMP
072D63  C7 86 E6 FE 00 00     MOV    word ptr [bp - 0x11a], 0 ; LOCAL_STORE
072D69  C6 86 EE FE 00        MOV    byte ptr [bp - 0x112], 0 ; LOCAL_STORE
072D6E  8A 5E 98              MOV    bl, byte ptr [bp - 0x68] ; LOCAL_LOAD
072D71  2A FF                 SUB    bh, bh ; ARITH
072D73  D1 E3                 SHL    bx, 1 ; LOGIC
072D75  FF B7 94 83           PUSH   word ptr [bx - 0x7c6c] ; PUSH_GLOBAL
072D79  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072D7D  50                    PUSH   ax ; STACK_PUSH
072D7E  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
072D83  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
072D86  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072D8A  50                    PUSH   ax ; STACK_PUSH
072D8B  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
072D90  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
072D93  6B B6 E6 FE 34        IMUL   si, word ptr [bp - 0x11a], 0x34 ; ARITH
072D98  8D 82 8C FD           LEA    ax, [bp + si - 0x274] ; ADDR
072D9C  50                    PUSH   ax ; STACK_PUSH
072D9D  8D 86 5C FE           LEA    ax, [bp - 0x1a4] ; ADDR
072DA1  50                    PUSH   ax ; STACK_PUSH
072DA2  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
072DA7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
072DAA  EB 2E                 JMP    0x72dda ; JUMP
072DAC  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
072DB0  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
072DB4  8D 86 5C FE           LEA    ax, [bp - 0x1a4] ; ADDR
072DB8  16                    PUSH   ss ; STACK_PUSH
072DB9  50                    PUSH   ax ; STACK_PUSH
072DBA  2B C0                 SUB    ax, ax ; ARITH
072DBC  9A 04 02 1F 18        LCALL  0x181f, 0x204 ; THUNK -> 0x0C2A:0x0006 (thunk @file 0x01A7F4 type B)
072DC1  3D 64 00              CMP    ax, 0x64 ; CMP
072DC4  7E 25                 JLE    0x72deb ; CJUMP
072DC6  8D 86 5C FE           LEA    ax, [bp - 0x1a4] ; ADDR
072DCA  50                    PUSH   ax ; STACK_PUSH
072DCB  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
072DD0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
072DD3  8B F0                 MOV    si, ax ; MOV
072DD5  C6 82 5B FE 00        MOV    byte ptr [bp + si - 0x1a5], 0 ; LOCAL_STORE
072DDA  8D 86 5C FE           LEA    ax, [bp - 0x1a4] ; ADDR
072DDE  50                    PUSH   ax ; STACK_PUSH
072DDF  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
072DE4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
072DE7  0B C0                 OR     ax, ax ; LOGIC
072DE9  75 C1                 JNE    0x72dac ; CJUMP
072DEB  8D 86 5C FE           LEA    ax, [bp - 0x1a4] ; ADDR
072DEF  50                    PUSH   ax ; STACK_PUSH
072DF0  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072DF4  50                    PUSH   ax ; STACK_PUSH
072DF5  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
072DFA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
072DFD  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072E01  50                    PUSH   ax ; STACK_PUSH
072E02  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
072E07  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
072E0A  FF 36 E0 2D           PUSH   word ptr [0x2de0] ; PUSH_GLOBAL
072E0E  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072E12  50                    PUSH   ax ; STACK_PUSH
072E13  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
072E18  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
072E1B  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072E1F  50                    PUSH   ax ; STACK_PUSH
072E20  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
072E25  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
072E28  8B 9E E6 FE           MOV    bx, word ptr [bp - 0x11a] ; LOCAL_LOAD
072E2C  D1 E3                 SHL    bx, 1 ; LOGIC
072E2E  FF B7 0A 8D           PUSH   word ptr [bx - 0x72f6] ; PUSH_GLOBAL
072E32  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072E36  50                    PUSH   ax ; STACK_PUSH
072E37  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
072E3C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
072E3F  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072E43  50                    PUSH   ax ; STACK_PUSH
072E44  9A B4 01 1F 18        LCALL  0x181f, 0x1b4 ; THUNK -> 0x004B:0x0032 (thunk @file 0x01A7A4 type B) overlay @file 0x0603DA
072E49  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
072E4C  8B 9E 7E FF           MOV    bx, word ptr [bp - 0x82] ; LOCAL_LOAD
072E50  D1 E3                 SHL    bx, 1 ; LOGIC
072E52  FF B7 00 98           PUSH   word ptr [bx - 0x6800] ; PUSH_GLOBAL
072E56  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
072E5B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
072E5E  52                    PUSH   dx ; STACK_PUSH
072E5F  50                    PUSH   ax ; STACK_PUSH
072E60  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072E64  16                    PUSH   ss ; STACK_PUSH
072E65  50                    PUSH   ax ; STACK_PUSH
072E66  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
072E6B  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
072E6E  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072E72  50                    PUSH   ax ; STACK_PUSH
072E73  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
072E78  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
072E7B  FF B6 7C FF           PUSH   word ptr [bp - 0x84] ; PUSH_GLOBAL
072E7F  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072E83  16                    PUSH   ss ; STACK_PUSH
072E84  50                    PUSH   ax ; STACK_PUSH
072E85  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
072E8A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
072E8D  8B 86 E4 FE           MOV    ax, word ptr [bp - 0x11c] ; LOCAL_LOAD
072E91  40                    INC    ax ; ARITH
072E92  50                    PUSH   ax ; STACK_PUSH
072E93  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072E97  16                    PUSH   ss ; STACK_PUSH
072E98  50                    PUSH   ax ; STACK_PUSH
072E99  FF B6 EC FE           PUSH   word ptr [bp - 0x114] ; PUSH_GLOBAL
072E9D  FF B6 EA FE           PUSH   word ptr [bp - 0x116] ; PUSH_GLOBAL
072EA1  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
072EA6  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
072EA9  FF 36 A0 1F           PUSH   word ptr [0x1fa0] ; PUSH_GLOBAL
072EAD  FF 36 9E 1F           PUSH   word ptr [0x1f9e] ; PUSH_GLOBAL
072EB1  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072EB5  16                    PUSH   ss ; STACK_PUSH
072EB6  50                    PUSH   ax ; STACK_PUSH
072EB7  B8 01 00              MOV    ax, 1 ; MOV
072EBA  9A 04 02 1F 18        LCALL  0x181f, 0x204 ; THUNK -> 0x0C2A:0x0006 (thunk @file 0x01A7F4 type B)
072EBF  3D 30 01              CMP    ax, 0x130 ; CMP
072EC2  7E 06                 JLE    0x72eca ; CJUMP
072EC4  C7 86 E0 FE 01 00     MOV    word ptr [bp - 0x120], 1 ; LOCAL_STORE
072ECA  FF 86 E4 FE           INC    word ptr [bp - 0x11c] ; ARITH
072ECE  83 BE E0 FE 00        CMP    word ptr [bp - 0x120], 0 ; CMP
072ED3  75 53                 JNE    0x72f28 ; CJUMP
072ED5  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
072ED8  39 86 E4 FE           CMP    word ptr [bp - 0x11c], ax ; CMP
072EDC  7D 4A                 JGE    0x72f28 ; CJUMP
072EDE  FF B6 E4 FE           PUSH   word ptr [bp - 0x11c] ; PUSH_GLOBAL
072EE2  8D 86 5C FE           LEA    ax, [bp - 0x1a4] ; ADDR
072EE6  50                    PUSH   ax ; STACK_PUSH
072EE7  0E                    PUSH   cs ; STACK_PUSH
072EE8  E8 7B 03              CALL   0x73266 ; CALL_NEAR
072EEB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
072EEE  8D 86 8C FD           LEA    ax, [bp - 0x274] ; ADDR
072EF2  50                    PUSH   ax ; STACK_PUSH
072EF3  8D 86 72 FF           LEA    ax, [bp - 0x8e] ; ADDR
072EF7  50                    PUSH   ax ; STACK_PUSH
072EF8  8D 86 5C FE           LEA    ax, [bp - 0x1a4] ; ADDR
072EFC  50                    PUSH   ax ; STACK_PUSH
072EFD  9A 04 0D 1F 1A        LCALL  0x1a1f, 0xd04 ; THUNK -> 0x0000:0x0840 (thunk @file 0x01D2F4 type A) overlay @file 0x026140
072F02  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
072F05  0B C0                 OR     ax, ax ; LOGIC
072F07  75 03                 JNE    0x72f0c ; CJUMP
072F09  E9 12 FE              JMP    0x72d1e ; JUMP
072F0C  68 EE 20              PUSH   0x20ee                       ; STRING: "(EMPTY)"
072F0F  8D 86 EE FE           LEA    ax, [bp - 0x112] ; ADDR
072F13  50                    PUSH   ax ; STACK_PUSH
072F14  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
072F19  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
072F1C  8B 9E E4 FE           MOV    bx, word ptr [bp - 0x11c] ; LOCAL_LOAD
072F20  C6 87 0C A6 00        MOV    byte ptr [bx - 0x59f4], 0 ; MOV
072F25  E9 65 FF              JMP    0x72e8d ; JUMP
072F28  83 BE E0 FE 00        CMP    word ptr [bp - 0x120], 0 ; CMP
072F2D  74 17                 JE     0x72f46 ; CJUMP
072F2F  FF B6 EC FE           PUSH   word ptr [bp - 0x114] ; PUSH_GLOBAL
072F33  FF B6 EA FE           PUSH   word ptr [bp - 0x116] ; PUSH_GLOBAL
072F37  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
072F3C  2B C0                 SUB    ax, ax ; ARITH
072F3E  89 86 EC FE           MOV    word ptr [bp - 0x114], ax ; LOCAL_STORE
072F42  89 86 EA FE           MOV    word ptr [bp - 0x116], ax ; LOCAL_STORE
072F46  FF 86 E2 FE           INC    word ptr [bp - 0x11e] ; ARITH
072F4A  83 BE E0 FE 00        CMP    word ptr [bp - 0x120], 0 ; CMP
072F4F  74 0A                 JE     0x72f5b ; CJUMP
072F51  83 BE E2 FE 01        CMP    word ptr [bp - 0x11e], 1 ; CMP
072F56  7F 03                 JG     0x72f5b ; CJUMP
072F58  E9 90 FD              JMP    0x72ceb ; JUMP
072F5B  FF 36 A2 1F           PUSH   word ptr [0x1fa2] ; PUSH_GLOBAL
072F5F  FF 36 8C 26           PUSH   word ptr [0x268c] ; PUSH_GLOBAL
072F63  FF 36 8A 26           PUSH   word ptr [0x268a] ; PUSH_GLOBAL
072F67  9A C4 07 1F 1A        LCALL  0x1a1f, 0x7c4 ; THUNK -> 0x0000:0x3084 (thunk @file 0x01CDB4 type A) overlay @file 0x028984
072F6C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
072F6F  8B 86 EA FE           MOV    ax, word ptr [bp - 0x116] ; LOCAL_LOAD
072F73  8B 96 EC FE           MOV    dx, word ptr [bp - 0x114] ; LOCAL_LOAD
072F77  5E                    POP    si ; STACK_POP
072F78  C9                    LEAVE ; EPILOGUE
072F79  CB                    RETF ; RETURN
