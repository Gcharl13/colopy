; ============================================================================
; func_045D00_unknown
; Region   : overlay
; Bytes    : file 0x045D00..0x045D91  (145 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "INDIANBURN"  (auto-named via string xrefs)
; ============================================================================

045D00  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
045D04  2B C0                 SUB    ax, ax ; ARITH
045D06  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
045D09  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
045D0C  EB 27                 JMP    0x45d35 ; JUMP
045D0E  6B D8 12              IMUL   bx, ax, 0x12 ; ARITH
045D11  8A 87 EE 54           MOV    al, byte ptr [bx + 0x54ee] ; MOV
045D15  2A 46 06              SUB    al, byte ptr [bp + 6] ; ARITH
045D18  3C 04                 CMP    al, 4 ; CMP
045D1A  75 16                 JNE    0x45d32 ; CJUMP
045D1C  8A 87 F1 54           MOV    al, byte ptr [bx + 0x54f1] ; MOV
045D20  25 0F 00              AND    ax, 0xf ; LOGIC
045D23  3B 46 08              CMP    ax, word ptr [bp + 8] ; CMP
045D26  75 0A                 JNE    0x45d32 ; CJUMP
045D28  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
045D2D  C6 87 F1 54 FF        MOV    byte ptr [bx + 0x54f1], 0xff ; CONST_LOAD
045D32  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
045D35  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
045D38  39 06 9A 53           CMP    word ptr [0x539a], ax ; CMP
045D3C  7F D0                 JG     0x45d0e ; CJUMP
045D3E  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
045D42  74 4B                 JE     0x45d8f ; CJUMP
045D44  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
045D47  05 04 00              ADD    ax, 4 ; ARITH
045D4A  50                    PUSH   ax ; STACK_PUSH
045D4B  9A 1A 0A 1F 18        LCALL  0x181f, 0xa1a ; THUNK -> 0x05B3:0x0198 (thunk @file 0x01B00A type B) overlay @file 0x05FDC4
045D50  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
045D53  50                    PUSH   ax ; STACK_PUSH
045D54  6A 00                 PUSH   0 ; STACK_PUSH
045D56  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
045D5B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
045D5E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
045D61  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
045D66  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
045D69  50                    PUSH   ax ; STACK_PUSH
045D6A  6A 01                 PUSH   1 ; STACK_PUSH
045D6C  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
045D71  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
045D74  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
045D78  7D 15                 JGE    0x45d8f ; CJUMP
045D7A  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
045D7E  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
045D83  75 0A                 JNE    0x45d8f ; CJUMP
045D85  6A 01                 PUSH   1 ; STACK_PUSH
045D87  68 C8 14              PUSH   0x14c8                       ; STRING: "INDIANBURN"
045D8A  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
045D8F  C9                    LEAVE ; EPILOGUE
045D90  CB                    RETF ; RETURN
