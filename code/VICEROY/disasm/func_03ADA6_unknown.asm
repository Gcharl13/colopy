; ============================================================================
; func_03ADA6_unknown
; Region   : overlay
; Bytes    : file 0x03ADA6..0x03B2F8  (1362 bytes)
; Purpose  : Hall-of-Fame writer (HALLFAME.DAT)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; Tagged: "HALLFAME.DAT", "---", "INDEPENDENT"  (auto-named via string xrefs)
; ============================================================================

03ADA6  C8 60 01 00           ENTER  0x160, 0 ; PROLOGUE
03ADAA  57                    PUSH   di ; STACK_PUSH
03ADAB  56                    PUSH   si ; STACK_PUSH
03ADAC  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
03ADB1  68 EF 11              PUSH   0x11ef ; PUSH_CONST
03ADB4  68 F2 11              PUSH   0x11f2                       ; STRING: "HALLFAME.DAT"
03ADB7  9A DA 04 1D 0D        LCALL  0xd1d, 0x4da ; LCALL
03ADBC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03ADBF  89 86 A4 FE           MOV    word ptr [bp - 0x15c], ax ; LOCAL_STORE
03ADC3  0B C0                 OR     ax, ax ; LOGIC
03ADC5  74 31                 JE     0x3adf8 ; CJUMP
03ADC7  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
03ADCC  50                    PUSH   ax ; STACK_PUSH
03ADCD  6A 01                 PUSH   1 ; STACK_PUSH
03ADCF  68 D2 00              PUSH   0xd2 ; PUSH_CONST
03ADD2  8D 86 00 FF           LEA    ax, [bp - 0x100] ; ADDR
03ADD6  50                    PUSH   ax ; STACK_PUSH
03ADD7  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
03ADDC  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
03ADDF  0B C0                 OR     ax, ax ; LOGIC
03ADE1  75 03                 JNE    0x3ade6 ; CJUMP
03ADE3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03ADE6  FF B6 A4 FE           PUSH   word ptr [bp - 0x15c] ; PUSH_GLOBAL
03ADEA  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
03ADEF  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03ADF2  C7 86 A4 FE 00 00     MOV    word ptr [bp - 0x15c], 0 ; LOCAL_STORE
03ADF8  C7 86 A6 FE 00 00     MOV    word ptr [bp - 0x15a], 0 ; LOCAL_STORE
03ADFE  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
03AE02  74 07                 JE     0x3ae0b ; CJUMP
03AE04  83 BE A6 FE 05        CMP    word ptr [bp - 0x15a], 5 ; CMP
03AE09  75 2F                 JNE    0x3ae3a ; CJUMP
03AE0B  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; ARITH
03AE10  C6 82 00 FF 00        MOV    byte ptr [bp + si - 0x100], 0 ; LOCAL_STORE
03AE15  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
03AE18  89 82 18 FF           MOV    word ptr [bp + si - 0xe8], ax ; LOCAL_STORE
03AE1C  89 82 24 FF           MOV    word ptr [bp + si - 0xdc], ax ; LOCAL_STORE
03AE20  89 82 26 FF           MOV    word ptr [bp + si - 0xda], ax ; LOCAL_STORE
03AE24  2B C0                 SUB    ax, ax ; ARITH
03AE26  89 82 22 FF           MOV    word ptr [bp + si - 0xde], ax ; LOCAL_STORE
03AE2A  89 82 1E FF           MOV    word ptr [bp + si - 0xe2], ax ; LOCAL_STORE
03AE2E  89 82 20 FF           MOV    word ptr [bp + si - 0xe0], ax ; LOCAL_STORE
03AE32  89 82 1A FF           MOV    word ptr [bp + si - 0xe6], ax ; LOCAL_STORE
03AE36  89 82 1C FF           MOV    word ptr [bp + si - 0xe4], ax ; LOCAL_STORE
03AE3A  FF 86 A6 FE           INC    word ptr [bp - 0x15a] ; ARITH
03AE3E  83 BE A6 FE 06        CMP    word ptr [bp - 0x15a], 6 ; CMP
03AE43  7C B9                 JL     0x3adfe ; CJUMP
03AE45  C7 86 AC FE FF FF     MOV    word ptr [bp - 0x154], 0xffff ; LOCAL_STORE
03AE4B  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
03AE4F  74 4D                 JE     0x3ae9e ; CJUMP
03AE51  C7 86 A6 FE 00 00     MOV    word ptr [bp - 0x15a], 0 ; LOCAL_STORE
03AE57  EB 6D                 JMP    0x3aec6 ; JUMP
03AE59  90                    NOP ; NOP
03AE5A  6B B6 AA FE 2A        IMUL   si, word ptr [bp - 0x156], 0x2a ; ARITH
03AE5F  8D BA 00 FF           LEA    di, [bp + si - 0x100] ; ADDR
03AE63  8D B2 D6 FE           LEA    si, [bp + si - 0x12a] ; ADDR
03AE67  8C D0                 MOV    ax, ss ; MOV
03AE69  8E C0                 MOV    es, ax ; MOV
03AE6B  B9 15 00              MOV    cx, 0x15 ; CONST_LOAD
03AE6E  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
03AE70  FF 8E AA FE           DEC    word ptr [bp - 0x156] ; ARITH
03AE74  8B 86 A6 FE           MOV    ax, word ptr [bp - 0x15a] ; LOCAL_LOAD
03AE78  39 86 AA FE           CMP    word ptr [bp - 0x156], ax ; CMP
03AE7C  7F DC                 JG     0x3ae5a ; CJUMP
03AE7E  6B F0 2A              IMUL   si, ax, 0x2a ; ARITH
03AE81  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
03AE84  8D BA 00 FF           LEA    di, [bp + si - 0x100] ; ADDR
03AE88  8B F0                 MOV    si, ax ; MOV
03AE8A  16                    PUSH   ss ; STACK_PUSH
03AE8B  07                    POP    es ; STACK_POP
03AE8C  B9 15 00              MOV    cx, 0x15 ; CONST_LOAD
03AE8F  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
03AE91  8B 86 A6 FE           MOV    ax, word ptr [bp - 0x15a] ; LOCAL_LOAD
03AE95  89 86 AC FE           MOV    word ptr [bp - 0x154], ax ; LOCAL_STORE
03AE99  C7 46 06 00 00        MOV    word ptr [bp + 6], 0 ; LOCAL_STORE
03AE9E  6A 00                 PUSH   0 ; STACK_PUSH
03AEA0  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
03AEA4  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
03AEA8  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
03AEAC  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
03AEB0  68 FF 11              PUSH   0x11ff                       ; STRING: "WOODPANL"
03AEB3  9A 7A 08 1F 19        LCALL  0x191f, 0x87a ; THUNK -> 0x0000:0x000C (thunk @file 0x01BE6A type A) overlay @file 0x02590C
03AEB8  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
03AEBB  0B C0                 OR     ax, ax ; LOGIC
03AEBD  74 2F                 JE     0x3aeee ; CJUMP
03AEBF  E9 1F 04              JMP    0x3b2e1 ; JUMP
03AEC2  FF 86 A6 FE           INC    word ptr [bp - 0x15a] ; ARITH
03AEC6  83 BE A6 FE 06        CMP    word ptr [bp - 0x15a], 6 ; CMP
03AECB  7D D1                 JGE    0x3ae9e ; CJUMP
03AECD  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
03AED0  8B 47 26              MOV    ax, word ptr [bx + 0x26] ; MOV
03AED3  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; ARITH
03AED8  39 82 26 FF           CMP    word ptr [bp + si - 0xda], ax ; CMP
03AEDC  7C 07                 JL     0x3aee5 ; CJUMP
03AEDE  83 BE A6 FE 05        CMP    word ptr [bp - 0x15a], 5 ; CMP
03AEE3  75 DD                 JNE    0x3aec2 ; CJUMP
03AEE5  C7 86 AA FE 05 00     MOV    word ptr [bp - 0x156], 5 ; LOCAL_STORE
03AEEB  EB 87                 JMP    0x3ae74 ; JUMP
03AEED  90                    NOP ; NOP
03AEEE  A0 33 08              MOV    al, byte ptr [0x833] ; GLOBAL_LOAD
03AEF1  2A E4                 SUB    ah, ah ; ARITH
03AEF3  50                    PUSH   ax ; STACK_PUSH
03AEF4  A0 30 08              MOV    al, byte ptr [0x830] ; GLOBAL_LOAD
03AEF7  50                    PUSH   ax ; STACK_PUSH
03AEF8  6A 03                 PUSH   3 ; STACK_PUSH
03AEFA  68 40 01              PUSH   0x140 ; PUSH_CONST
03AEFD  6A 00                 PUSH   0 ; STACK_PUSH
03AEFF  FF 36 3A 2F           PUSH   word ptr [0x2f3a] ; PUSH_GLOBAL
03AF03  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
03AF08  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03AF0B  52                    PUSH   dx ; STACK_PUSH
03AF0C  50                    PUSH   ax ; STACK_PUSH
03AF0D  9A C8 01 1F 18        LCALL  0x181f, 0x1c8 ; THUNK -> 0x004B:0x0430 (thunk @file 0x01A7B8 type B) overlay @file 0x0607D8
03AF12  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
03AF15  C7 86 A8 FE 10 00     MOV    word ptr [bp - 0x158], 0x10 ; LOCAL_STORE
03AF1B  C7 86 AE FE 0A 00     MOV    word ptr [bp - 0x152], 0xa ; LOCAL_STORE
03AF21  C7 86 A6 FE 00 00     MOV    word ptr [bp - 0x15a], 0 ; LOCAL_STORE
03AF27  E9 CE 01              JMP    0x3b0f8 ; JUMP
03AF2A  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; ARITH
03AF2F  83 BA 1A FF 00        CMP    word ptr [bp + si - 0xe6], 0 ; CMP
03AF34  74 06                 JE     0x3af3c ; CJUMP
03AF36  FF 36 42 2F           PUSH   word ptr [0x2f42] ; PUSH_GLOBAL
03AF3A  EB 4E                 JMP    0x3af8a ; JUMP
03AF3C  FF 36 44 2F           PUSH   word ptr [0x2f44] ; PUSH_GLOBAL
03AF40  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AF44  50                    PUSH   ax ; STACK_PUSH
03AF45  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03AF4A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03AF4D  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AF51  50                    PUSH   ax ; STACK_PUSH
03AF52  9A B4 01 1F 18        LCALL  0x181f, 0x1b4 ; THUNK -> 0x004B:0x0032 (thunk @file 0x01A7A4 type B) overlay @file 0x0603DA
03AF57  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03AF5A  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; ARITH
03AF5F  FF B2 18 FF           PUSH   word ptr [bp + si - 0xe8] ; PUSH_GLOBAL
03AF63  9A 5E 06 1F 18        LCALL  0x181f, 0x65e ; THUNK -> 0x05B3:0x024E (thunk @file 0x01AC4E type B) overlay @file 0x05FE7A
03AF68  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03AF6B  50                    PUSH   ax ; STACK_PUSH
03AF6C  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AF70  50                    PUSH   ax ; STACK_PUSH
03AF71  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03AF76  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03AF79  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AF7D  50                    PUSH   ax ; STACK_PUSH
03AF7E  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03AF83  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03AF86  FF 36 78 2E           PUSH   word ptr [0x2e78] ; PUSH_GLOBAL
03AF8A  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AF8E  50                    PUSH   ax ; STACK_PUSH
03AF8F  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03AF94  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03AF97  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AF9B  50                    PUSH   ax ; STACK_PUSH
03AF9C  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03AFA1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03AFA4  FF 36 3C 2F           PUSH   word ptr [0x2f3c] ; PUSH_GLOBAL
03AFA8  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AFAC  50                    PUSH   ax ; STACK_PUSH
03AFAD  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03AFB2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03AFB5  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AFB9  50                    PUSH   ax ; STACK_PUSH
03AFBA  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03AFBF  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03AFC2  FF 36 3E 2F           PUSH   word ptr [0x2f3e] ; PUSH_GLOBAL
03AFC6  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AFCA  50                    PUSH   ax ; STACK_PUSH
03AFCB  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03AFD0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03AFD3  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AFD7  50                    PUSH   ax ; STACK_PUSH
03AFD8  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03AFDD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03AFE0  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; ARITH
03AFE5  FF B2 1E FF           PUSH   word ptr [bp + si - 0xe2] ; PUSH_GLOBAL
03AFE9  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AFED  16                    PUSH   ss ; STACK_PUSH
03AFEE  50                    PUSH   ax ; STACK_PUSH
03AFEF  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
03AFF4  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03AFF7  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03AFFB  50                    PUSH   ax ; STACK_PUSH
03AFFC  9A DC 01 1F 18        LCALL  0x181f, 0x1dc ; THUNK -> 0x004B:0x0052 (thunk @file 0x01A7CC type B) overlay @file 0x0603FA
03B001  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B004  FF 36 46 2F           PUSH   word ptr [0x2f46] ; PUSH_GLOBAL
03B008  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B00C  50                    PUSH   ax ; STACK_PUSH
03B00D  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03B012  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B015  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B019  50                    PUSH   ax ; STACK_PUSH
03B01A  9A BE 01 1F 18        LCALL  0x181f, 0x1be ; THUNK -> 0x004B:0x0042 (thunk @file 0x01A7AE type B) overlay @file 0x0603EA
03B01F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B022  FF B2 24 FF           PUSH   word ptr [bp + si - 0xdc] ; PUSH_GLOBAL
03B026  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B02A  16                    PUSH   ss ; STACK_PUSH
03B02B  50                    PUSH   ax ; STACK_PUSH
03B02C  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
03B031  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03B034  A0 33 08              MOV    al, byte ptr [0x833] ; GLOBAL_LOAD
03B037  2A E4                 SUB    ah, ah ; ARITH
03B039  50                    PUSH   ax ; STACK_PUSH
03B03A  FF B6 A0 FE           PUSH   word ptr [bp - 0x160] ; PUSH_GLOBAL
03B03E  FF B6 A8 FE           PUSH   word ptr [bp - 0x158] ; PUSH_GLOBAL
03B042  FF B6 A2 FE           PUSH   word ptr [bp - 0x15e] ; PUSH_GLOBAL
03B046  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B04A  16                    PUSH   ss ; STACK_PUSH
03B04B  50                    PUSH   ax ; STACK_PUSH
03B04C  9A 8C 01 1F 18        LCALL  0x181f, 0x18c ; THUNK -> 0x004B:0x039A (thunk @file 0x01A77C type B) overlay @file 0x060742
03B051  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
03B054  C4 1E 8A 26           LES    bx, ptr [0x268a] ; MOV_FAR
03B058  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
03B05B  2A E4                 SUB    ah, ah ; ARITH
03B05D  40                    INC    ax ; ARITH
03B05E  40                    INC    ax ; ARITH
03B05F  01 86 A8 FE           ADD    word ptr [bp - 0x158], ax ; ARITH
03B063  C6 86 B0 FE 00        MOV    byte ptr [bp - 0x150], 0 ; LOCAL_STORE
03B068  68 1A 12              PUSH   0x121a                       ; STRING: "--- "
03B06B  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B06F  50                    PUSH   ax ; STACK_PUSH
03B070  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
03B075  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B078  FF 36 48 2F           PUSH   word ptr [0x2f48] ; PUSH_GLOBAL
03B07C  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B080  50                    PUSH   ax ; STACK_PUSH
03B081  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03B086  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B089  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B08D  50                    PUSH   ax ; STACK_PUSH
03B08E  9A BE 01 1F 18        LCALL  0x181f, 0x1be ; THUNK -> 0x004B:0x0042 (thunk @file 0x01A7AE type B) overlay @file 0x0603EA
03B093  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B096  FF B2 26 FF           PUSH   word ptr [bp + si - 0xda] ; PUSH_GLOBAL
03B09A  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B09E  16                    PUSH   ss ; STACK_PUSH
03B09F  50                    PUSH   ax ; STACK_PUSH
03B0A0  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
03B0A5  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03B0A8  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B0AC  50                    PUSH   ax ; STACK_PUSH
03B0AD  9A 0A 01 1F 18        LCALL  0x181f, 0x10a ; THUNK -> 0x004B:0x0062 (thunk @file 0x01A6FA type B) overlay @file 0x06040A
03B0B2  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B0B5  68 1F 12              PUSH   0x121f                       ; STRING: " ---"
03B0B8  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B0BC  50                    PUSH   ax ; STACK_PUSH
03B0BD  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
03B0C2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B0C5  A0 33 08              MOV    al, byte ptr [0x833] ; GLOBAL_LOAD
03B0C8  2A E4                 SUB    ah, ah ; ARITH
03B0CA  50                    PUSH   ax ; STACK_PUSH
03B0CB  FF B6 A0 FE           PUSH   word ptr [bp - 0x160] ; PUSH_GLOBAL
03B0CF  FF B6 A8 FE           PUSH   word ptr [bp - 0x158] ; PUSH_GLOBAL
03B0D3  68 40 01              PUSH   0x140 ; PUSH_CONST
03B0D6  6A 00                 PUSH   0 ; STACK_PUSH
03B0D8  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B0DC  16                    PUSH   ss ; STACK_PUSH
03B0DD  50                    PUSH   ax ; STACK_PUSH
03B0DE  9A C8 01 1F 18        LCALL  0x181f, 0x1c8 ; THUNK -> 0x004B:0x0430 (thunk @file 0x01A7B8 type B) overlay @file 0x0607D8
03B0E3  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
03B0E6  C4 1E 8A 26           LES    bx, ptr [0x268a] ; MOV_FAR
03B0EA  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
03B0ED  2A E4                 SUB    ah, ah ; ARITH
03B0EF  40                    INC    ax ; ARITH
03B0F0  01 86 A8 FE           ADD    word ptr [bp - 0x158], ax ; ARITH
03B0F4  FF 86 A6 FE           INC    word ptr [bp - 0x15a] ; ARITH
03B0F8  83 BE A6 FE 05        CMP    word ptr [bp - 0x15a], 5 ; CMP
03B0FD  7C 03                 JL     0x3b102 ; CJUMP
03B0FF  E9 9A 01              JMP    0x3b29c ; JUMP
03B102  8B 86 A6 FE           MOV    ax, word ptr [bp - 0x15a] ; LOCAL_LOAD
03B106  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03B109  3D 04 00              CMP    ax, 4 ; CMP
03B10C  75 0C                 JNE    0x3b11a ; CJUMP
03B10E  83 BE AC FE 05        CMP    word ptr [bp - 0x154], 5 ; CMP
03B113  75 05                 JNE    0x3b11a ; CJUMP
03B115  C7 46 FC 05 00        MOV    word ptr [bp - 4], 5 ; LOCAL_STORE
03B11A  6B F0 2A              IMUL   si, ax, 0x2a ; ARITH
03B11D  83 BA 18 FF 00        CMP    word ptr [bp + si - 0xe8], 0 ; CMP
03B122  7C D0                 JL     0x3b0f4 ; CJUMP
03B124  A0 30 08              MOV    al, byte ptr [0x830] ; GLOBAL_LOAD
03B127  2A E4                 SUB    ah, ah ; ARITH
03B129  89 86 A0 FE           MOV    word ptr [bp - 0x160], ax ; LOCAL_STORE
03B12D  8B 86 AC FE           MOV    ax, word ptr [bp - 0x154] ; LOCAL_LOAD
03B131  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
03B134  75 09                 JNE    0x3b13f ; CJUMP
03B136  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
03B139  2A E4                 SUB    ah, ah ; ARITH
03B13B  89 86 A0 FE           MOV    word ptr [bp - 0x160], ax ; LOCAL_STORE
03B13F  83 86 A8 FE 04        ADD    word ptr [bp - 0x158], 4 ; ARITH
03B144  C6 86 B0 FE 00        MOV    byte ptr [bp - 0x150], 0 ; LOCAL_STORE
03B149  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
03B14C  40                    INC    ax ; ARITH
03B14D  50                    PUSH   ax ; STACK_PUSH
03B14E  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B152  16                    PUSH   ss ; STACK_PUSH
03B153  50                    PUSH   ax ; STACK_PUSH
03B154  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
03B159  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03B15C  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B160  50                    PUSH   ax ; STACK_PUSH
03B161  9A DC 01 1F 18        LCALL  0x181f, 0x1dc ; THUNK -> 0x004B:0x0052 (thunk @file 0x01A7CC type B) overlay @file 0x0603FA
03B166  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B169  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; ARITH
03B16E  8B 9A 22 FF           MOV    bx, word ptr [bp + si - 0xde] ; LOCAL_LOAD
03B172  D1 E3                 SHL    bx, 1 ; LOGIC
03B174  FF B7 94 83           PUSH   word ptr [bx - 0x7c6c] ; PUSH_GLOBAL
03B178  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B17C  50                    PUSH   ax ; STACK_PUSH
03B17D  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03B182  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B185  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B189  50                    PUSH   ax ; STACK_PUSH
03B18A  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03B18F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B192  8D 82 00 FF           LEA    ax, [bp + si - 0x100] ; ADDR
03B196  50                    PUSH   ax ; STACK_PUSH
03B197  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B19B  50                    PUSH   ax ; STACK_PUSH
03B19C  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
03B1A1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B1A4  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B1A8  50                    PUSH   ax ; STACK_PUSH
03B1A9  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03B1AE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B1B1  FF 36 E0 2D           PUSH   word ptr [0x2de0] ; PUSH_GLOBAL
03B1B5  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B1B9  50                    PUSH   ax ; STACK_PUSH
03B1BA  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03B1BF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B1C2  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B1C6  50                    PUSH   ax ; STACK_PUSH
03B1C7  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03B1CC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B1CF  83 BA 1A FF 00        CMP    word ptr [bp + si - 0xe6], 0 ; CMP
03B1D4  74 1E                 JE     0x3b1f4 ; CJUMP
03B1D6  FF 36 38 2F           PUSH   word ptr [0x2f38] ; PUSH_GLOBAL
03B1DA  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B1DE  50                    PUSH   ax ; STACK_PUSH
03B1DF  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03B1E4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B1E7  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B1EB  50                    PUSH   ax ; STACK_PUSH
03B1EC  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03B1F1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B1F4  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; ARITH
03B1F9  FF B2 18 FF           PUSH   word ptr [bp + si - 0xe8] ; PUSH_GLOBAL
03B1FD  9A 5E 06 1F 18        LCALL  0x181f, 0x65e ; THUNK -> 0x05B3:0x024E (thunk @file 0x01AC4E type B) overlay @file 0x05FE7A
03B202  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B205  50                    PUSH   ax ; STACK_PUSH
03B206  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B20A  50                    PUSH   ax ; STACK_PUSH
03B20B  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03B210  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B213  A0 33 08              MOV    al, byte ptr [0x833] ; GLOBAL_LOAD
03B216  2A E4                 SUB    ah, ah ; ARITH
03B218  50                    PUSH   ax ; STACK_PUSH
03B219  FF B6 A0 FE           PUSH   word ptr [bp - 0x160] ; PUSH_GLOBAL
03B21D  FF B6 A8 FE           PUSH   word ptr [bp - 0x158] ; PUSH_GLOBAL
03B221  FF B6 AE FE           PUSH   word ptr [bp - 0x152] ; PUSH_GLOBAL
03B225  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B229  16                    PUSH   ss ; STACK_PUSH
03B22A  50                    PUSH   ax ; STACK_PUSH
03B22B  9A 8C 01 1F 18        LCALL  0x181f, 0x18c ; THUNK -> 0x004B:0x039A (thunk @file 0x01A77C type B) overlay @file 0x060742
03B230  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
03B233  C4 1E 8A 26           LES    bx, ptr [0x268a] ; MOV_FAR
03B237  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
03B23A  2A E4                 SUB    ah, ah ; ARITH
03B23C  40                    INC    ax ; ARITH
03B23D  40                    INC    ax ; ARITH
03B23E  01 86 A8 FE           ADD    word ptr [bp - 0x158], ax ; ARITH
03B242  8B 86 AE FE           MOV    ax, word ptr [bp - 0x152] ; LOCAL_LOAD
03B246  05 0F 00              ADD    ax, 0xf ; ARITH
03B249  89 86 A2 FE           MOV    word ptr [bp - 0x15e], ax ; LOCAL_STORE
03B24D  C6 86 B0 FE 00        MOV    byte ptr [bp - 0x150], 0 ; LOCAL_STORE
03B252  83 BA 1C FF 00        CMP    word ptr [bp + si - 0xe4], 0 ; CMP
03B257  75 03                 JNE    0x3b25c ; CJUMP
03B259  E9 CE FC              JMP    0x3af2a ; JUMP
03B25C  FF 36 40 2F           PUSH   word ptr [0x2f40] ; PUSH_GLOBAL
03B260  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B264  50                    PUSH   ax ; STACK_PUSH
03B265  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03B26A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B26D  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B271  50                    PUSH   ax ; STACK_PUSH
03B272  9A B4 01 1F 18        LCALL  0x181f, 0x1b4 ; THUNK -> 0x004B:0x0032 (thunk @file 0x01A7A4 type B) overlay @file 0x0603DA
03B277  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B27A  FF B2 18 FF           PUSH   word ptr [bp + si - 0xe8] ; PUSH_GLOBAL
03B27E  68 08 12              PUSH   0x1208                       ; STRING: "INDEPENDENT"
03B281  68 14 12              PUSH   0x1214                       ; STRING: "NAMES"
03B284  9A 22 04 1F 18        LCALL  0x181f, 0x422 ; THUNK -> 0x0000:0x0208 (thunk @file 0x01AA12 type A) overlay @file 0x025B08
03B289  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03B28C  68 3C 83              PUSH   0x833c ; PUSH_CONST
03B28F  8D 86 B0 FE           LEA    ax, [bp - 0x150] ; ADDR
03B293  50                    PUSH   ax ; STACK_PUSH
03B294  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
03B299  E9 F8 FC              JMP    0x3af94 ; JUMP
03B29C  6A 00                 PUSH   0 ; STACK_PUSH
03B29E  68 40 01              PUSH   0x140 ; PUSH_CONST
03B2A1  68 C8 00              PUSH   0xc8 ; PUSH_CONST
03B2A4  2B C0                 SUB    ax, ax ; ARITH
03B2A6  99                    CDQ ; ARITH
03B2A7  2B DB                 SUB    bx, bx ; ARITH
03B2A9  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
03B2AE  9A EC 00 1F 18        LCALL  0x181f, 0xec ; THUNK -> 0x0262:0x00DA (thunk @file 0x01A6DC type B) overlay @file 0x021E0A
03B2B3  9A C0 03 1F 18        LCALL  0x181f, 0x3c0 ; THUNK -> 0x0262:0x0060 (thunk @file 0x01A9B0 type B) overlay @file 0x021D90
03B2B8  68 24 12              PUSH   0x1224 ; PUSH_CONST
03B2BB  68 27 12              PUSH   0x1227                       ; STRING: "HALLFAME.DAT"
03B2BE  9A DA 04 1D 0D        LCALL  0xd1d, 0x4da ; LCALL
03B2C3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B2C6  89 86 A4 FE           MOV    word ptr [bp - 0x15c], ax ; LOCAL_STORE
03B2CA  0B C0                 OR     ax, ax ; LOGIC
03B2CC  74 13                 JE     0x3b2e1 ; CJUMP
03B2CE  50                    PUSH   ax ; STACK_PUSH
03B2CF  6A 01                 PUSH   1 ; STACK_PUSH
03B2D1  68 D2 00              PUSH   0xd2 ; PUSH_CONST
03B2D4  8D 86 00 FF           LEA    ax, [bp - 0x100] ; ADDR
03B2D8  50                    PUSH   ax ; STACK_PUSH
03B2D9  9A 0C 06 1D 0D        LCALL  0xd1d, 0x60c ; LCALL
03B2DE  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
03B2E1  83 BE A4 FE 00        CMP    word ptr [bp - 0x15c], 0 ; CMP
03B2E6  74 0C                 JE     0x3b2f4 ; CJUMP
03B2E8  FF B6 A4 FE           PUSH   word ptr [bp - 0x15c] ; PUSH_GLOBAL
03B2EC  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
03B2F1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B2F4  5E                    POP    si ; STACK_POP
03B2F5  5F                    POP    di ; STACK_POP
03B2F6  C9                    LEAVE ; EPILOGUE
03B2F7  CB                    RETF ; RETURN
