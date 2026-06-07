; ============================================================================
; func_038A50_unknown
; Region   : overlay
; Bytes    : file 0x038A50..0x038BC6  (374 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

038A50  C8 8C 00 00           ENTER  0x8c, 0 ; PROLOGUE
038A54  56                    PUSH   si ; STACK_PUSH
038A55  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
038A58  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
038A5D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038A60  6A 05                 PUSH   5 ; STACK_PUSH
038A62  0E                    PUSH   cs ; STACK_PUSH
038A63  E8 ED 13              CALL   0x39e53 ; CALL_NEAR
038A66  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038A69  68 90 00              PUSH   0x90 ; PUSH_CONST
038A6C  6A 05                 PUSH   5 ; STACK_PUSH
038A6E  68 40 01              PUSH   0x140 ; PUSH_CONST
038A71  6A 00                 PUSH   0 ; STACK_PUSH
038A73  FF 36 1E 2E           PUSH   word ptr [0x2e1e] ; PUSH_GLOBAL
038A77  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
038A7C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038A7F  52                    PUSH   dx ; STACK_PUSH
038A80  50                    PUSH   ax ; STACK_PUSH
038A81  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
038A86  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
038A89  68 91 00              PUSH   0x91 ; PUSH_CONST
038A8C  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
038A90  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
038A93  2A E4                 SUB    ah, ah ; ARITH
038A95  05 06 00              ADD    ax, 6 ; ARITH
038A98  50                    PUSH   ax ; STACK_PUSH
038A99  68 40 01              PUSH   0x140 ; PUSH_CONST
038A9C  6A 00                 PUSH   0 ; STACK_PUSH
038A9E  FF 36 56 2F           PUSH   word ptr [0x2f56] ; PUSH_GLOBAL
038AA2  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
038AA7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038AAA  52                    PUSH   dx ; STACK_PUSH
038AAB  50                    PUSH   ax ; STACK_PUSH
038AAC  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
038AB1  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
038AB4  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
038AB8  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
038ABC  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
038AC0  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
038AC4  6A 77                 PUSH   0x77 ; PUSH_CONST
038AC6  B8 43 00              MOV    ax, 0x43 ; CONST_LOAD
038AC9  BA 19 00              MOV    dx, 0x19 ; CONST_LOAD
038ACC  BB A1 00              MOV    bx, 0xa1 ; CONST_LOAD
038ACF  9A B2 08 1F 19        LCALL  0x191f, 0x8b2 ; THUNK -> 0x0BC3:0x0006 (thunk @file 0x01BEA2 type B)
038AD4  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0 ; LOCAL_STORE
038AD8  FF 36 2E 2E           PUSH   word ptr [0x2e2e] ; PUSH_GLOBAL
038ADC  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
038ADF  50                    PUSH   ax ; STACK_PUSH
038AE0  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
038AE5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
038AE8  68 92 00              PUSH   0x92 ; PUSH_CONST
038AEB  B8 19 00              MOV    ax, 0x19 ; CONST_LOAD
038AEE  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
038AF1  89 86 78 FF           MOV    word ptr [bp - 0x88], ax ; LOCAL_STORE
038AF5  50                    PUSH   ax ; STACK_PUSH
038AF6  6A 4C                 PUSH   0x4c ; PUSH_CONST
038AF8  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
038AFB  16                    PUSH   ss ; STACK_PUSH
038AFC  50                    PUSH   ax ; STACK_PUSH
038AFD  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
038B02  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
038B05  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0 ; LOCAL_STORE
038B09  FF 36 30 2E           PUSH   word ptr [0x2e30] ; PUSH_GLOBAL
038B0D  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
038B10  50                    PUSH   ax ; STACK_PUSH
038B11  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
038B16  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
038B19  68 92 00              PUSH   0x92 ; PUSH_CONST
038B1C  6A 19                 PUSH   0x19 ; PUSH_CONST
038B1E  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
038B22  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
038B26  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
038B29  16                    PUSH   ss ; STACK_PUSH
038B2A  50                    PUSH   ax ; STACK_PUSH
038B2B  2B C0                 SUB    ax, ax ; ARITH
038B2D  9A 04 02 1F 18        LCALL  0x181f, 0x204 ; THUNK -> 0x0C2A:0x0006 (thunk @file 0x01A7F4 type B)
038B32  48                    DEC    ax ; ARITH
038B33  89 86 74 FF           MOV    word ptr [bp - 0x8c], ax ; LOCAL_STORE
038B37  2D 90 00              SUB    ax, 0x90 ; ARITH
038B3A  F7 D8                 NEG    ax ; ARITH
038B3C  50                    PUSH   ax ; STACK_PUSH
038B3D  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
038B40  16                    PUSH   ss ; STACK_PUSH
038B41  50                    PUSH   ax ; STACK_PUSH
038B42  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
038B47  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
038B4A  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0 ; LOCAL_STORE
038B4E  FF 36 50 2F           PUSH   word ptr [0x2f50] ; PUSH_GLOBAL
038B52  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
038B55  50                    PUSH   ax ; STACK_PUSH
038B56  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
038B5B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
038B5E  68 92 00              PUSH   0x92 ; PUSH_CONST
038B61  6A 19                 PUSH   0x19 ; PUSH_CONST
038B63  B8 AA 00              MOV    ax, 0xaa ; CONST_LOAD
038B66  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
038B69  50                    PUSH   ax ; STACK_PUSH
038B6A  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
038B6D  16                    PUSH   ss ; STACK_PUSH
038B6E  50                    PUSH   ax ; STACK_PUSH
038B6F  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
038B74  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
038B77  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0 ; LOCAL_STORE
038B7B  FF 36 52 2F           PUSH   word ptr [0x2f52] ; PUSH_GLOBAL
038B7F  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
038B82  50                    PUSH   ax ; STACK_PUSH
038B83  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
038B88  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
038B8B  68 92 00              PUSH   0x92 ; PUSH_CONST
038B8E  6A 19                 PUSH   0x19 ; PUSH_CONST
038B90  B8 DC 00              MOV    ax, 0xdc ; CONST_LOAD
038B93  89 86 7A FF           MOV    word ptr [bp - 0x86], ax ; LOCAL_STORE
038B97  50                    PUSH   ax ; STACK_PUSH
038B98  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
038B9B  16                    PUSH   ss ; STACK_PUSH
038B9C  50                    PUSH   ax ; STACK_PUSH
038B9D  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
038BA2  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
038BA5  C7 86 7C FF 00 00     MOV    word ptr [bp - 0x84], 0 ; LOCAL_STORE
038BAB  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
038BAF  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
038BB3  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
038BB7  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
038BBB  6A 77                 PUSH   0x77 ; PUSH_CONST
038BBD  8B 9E 7C FF           MOV    bx, word ptr [bp - 0x84] ; LOCAL_LOAD
038BC1  C1 E3 03              SHL    bx, 3 ; LOGIC
038BC4  83                    DB     0x83 ; DATA_BYTE
038BC5  C3                    DB     0xC3 ; DATA_BYTE
