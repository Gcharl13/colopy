; ============================================================================
; func_030DF4_unknown
; Region   : overlay
; Bytes    : file 0x030DF4..0x030F6E  (378 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030DF4  C8 64 00 00           ENTER  0x64, 0 ; PROLOGUE
030DF8  56                    PUSH   si ; STACK_PUSH
030DF9  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
030DFD  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
030E00  D1 E3                 SHL    bx, 1 ; LOGIC
030E02  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
030E06  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030E09  50                    PUSH   ax ; STACK_PUSH
030E0A  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
030E0F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
030E12  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030E15  50                    PUSH   ax ; STACK_PUSH
030E16  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
030E1B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030E1E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030E21  50                    PUSH   ax ; STACK_PUSH
030E22  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
030E27  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030E2A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
030E2D  0E                    PUSH   cs ; STACK_PUSH
030E2E  E8 96 5A              CALL   0x368c7 ; CALL_NEAR
030E31  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030E34  0B C0                 OR     ax, ax ; LOGIC
030E36  74 12                 JE     0x30e4a ; CJUMP
030E38  FF 36 C0 2E           PUSH   word ptr [0x2ec0] ; PUSH_GLOBAL
030E3C  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030E3F  50                    PUSH   ax ; STACK_PUSH
030E40  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
030E45  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
030E48  EB 74                 JMP    0x30ebe ; JUMP
030E4A  FF 36 B4 2E           PUSH   word ptr [0x2eb4] ; PUSH_GLOBAL
030E4E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030E51  50                    PUSH   ax ; STACK_PUSH
030E52  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
030E57  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
030E5A  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030E5D  50                    PUSH   ax ; STACK_PUSH
030E5E  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
030E63  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030E66  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
030E69  0E                    PUSH   cs ; STACK_PUSH
030E6A  E8 A6 59              CALL   0x36813 ; CALL_NEAR
030E6D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030E70  50                    PUSH   ax ; STACK_PUSH
030E71  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030E74  16                    PUSH   ss ; STACK_PUSH
030E75  50                    PUSH   ax ; STACK_PUSH
030E76  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
030E7B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
030E7E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030E81  50                    PUSH   ax ; STACK_PUSH
030E82  9A B4 01 1F 18        LCALL  0x181f, 0x1b4 ; THUNK -> 0x004B:0x0032 (thunk @file 0x01A7A4 type B) overlay @file 0x0603DA
030E87  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030E8A  FF 36 B2 2E           PUSH   word ptr [0x2eb2] ; PUSH_GLOBAL
030E8E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030E91  50                    PUSH   ax ; STACK_PUSH
030E92  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
030E97  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
030E9A  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030E9D  50                    PUSH   ax ; STACK_PUSH
030E9E  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
030EA3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030EA6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
030EA9  0E                    PUSH   cs ; STACK_PUSH
030EAA  E8 E3 59              CALL   0x36890 ; CALL_NEAR
030EAD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030EB0  50                    PUSH   ax ; STACK_PUSH
030EB1  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030EB4  16                    PUSH   ss ; STACK_PUSH
030EB5  50                    PUSH   ax ; STACK_PUSH
030EB6  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
030EBB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
030EBE  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030EC1  50                    PUSH   ax ; STACK_PUSH
030EC2  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
030EC7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030ECA  C7 46 AE 01 00        MOV    word ptr [bp - 0x52], 1 ; LOCAL_STORE
030ECF  C7 46 AC B5 00        MOV    word ptr [bp - 0x54], 0xb5 ; LOCAL_STORE
030ED4  6B 46 06 13           IMUL   ax, word ptr [bp + 6], 0x13 ; ARITH
030ED8  05 0A 00              ADD    ax, 0xa ; ARITH
030EDB  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
030EDE  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
030EE2  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
030EE6  8D 4E B0              LEA    cx, [bp - 0x50] ; ADDR
030EE9  16                    PUSH   ss ; STACK_PUSH
030EEA  51                    PUSH   cx ; STACK_PUSH
030EEB  8B F0                 MOV    si, ax ; MOV
030EED  2B C0                 SUB    ax, ax ; ARITH
030EEF  9A 04 02 1F 18        LCALL  0x181f, 0x204 ; THUNK -> 0x0C2A:0x0006 (thunk @file 0x01A7F4 type B)
030EF4  48                    DEC    ax ; ARITH
030EF5  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
030EF8  40                    INC    ax ; ARITH
030EF9  40                    INC    ax ; ARITH
030EFA  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
030EFD  8B C8                 MOV    cx, ax ; MOV
030EFF  2D 31 01              SUB    ax, 0x131 ; ARITH
030F02  F7 D8                 NEG    ax ; ARITH
030F04  50                    PUSH   ax ; STACK_PUSH
030F05  6A 00                 PUSH   0 ; STACK_PUSH
030F07  8B C1                 MOV    ax, cx ; MOV
030F09  D1 F9                 SAR    cx, 1 ; LOGIC
030F0B  2B F1                 SUB    si, cx ; ARITH
030F0D  56                    PUSH   si ; STACK_PUSH
030F0E  8B F0                 MOV    si, ax ; MOV
030F10  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
030F15  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
030F18  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
030F1B  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
030F1F  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
030F23  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
030F27  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
030F2B  B8 07 00              MOV    ax, 7 ; MOV
030F2E  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
030F31  50                    PUSH   ax ; STACK_PUSH
030F32  6A 00                 PUSH   0 ; STACK_PUSH
030F34  BA C1 00              MOV    dx, 0xc1 ; CONST_LOAD
030F37  89 56 A8              MOV    word ptr [bp - 0x58], dx ; LOCAL_STORE
030F3A  8B DE                 MOV    bx, si ; MOV
030F3C  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
030F3F  9A BA 00 1F 18        LCALL  0x181f, 0xba ; THUNK -> 0x0B9E:0x000A (thunk @file 0x01A6AA type B)
030F44  6A 0F                 PUSH   0xf ; PUSH_CONST
030F46  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
030F49  BA 0F 00              MOV    dx, 0xf ; CONST_LOAD
030F4C  8B DA                 MOV    bx, dx ; MOV
030F4E  9A F0 01 1F 18        LCALL  0x181f, 0x1f0 ; THUNK -> 0x0C28:0x000A (thunk @file 0x01A7E0 type B)
030F53  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
030F57  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
030F5B  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030F5E  16                    PUSH   ss ; STACK_PUSH
030F5F  50                    PUSH   ax ; STACK_PUSH
030F60  6A 00                 PUSH   0 ; STACK_PUSH
030F62  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
030F65  40                    INC    ax ; ARITH
030F66  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
030F6A  BA C2 00              MOV    dx, 0xc2 ; CONST_LOAD
030F6D  9A                    DB     0x9A ; DATA_BYTE
