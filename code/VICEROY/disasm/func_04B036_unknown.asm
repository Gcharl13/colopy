; ============================================================================
; func_04B036_unknown
; Region   : overlay
; Bytes    : file 0x04B036..0x04B197  (353 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "NOCONTACT"  (auto-named via string xrefs)
; ============================================================================

04B036  C8 25 0F 00           ENTER  0xf25, 0 ; PROLOGUE
04B03A  3B 46 08              CMP    ax, word ptr [bp + 8] ; CMP
04B03D  75 D1                 JNE    0x4b010 ; CJUMP
04B03F  F6 C1 10              TEST   cl, 0x10 ; LOGIC
04B042  74 AA                 JE     0x4afee ; CJUMP
04B044  C7 46 F0 E8 03        MOV    word ptr [bp - 0x10], 0x3e8 ; LOCAL_STORE
04B049  EB A8                 JMP    0x4aff3 ; JUMP
04B04B  90                    NOP ; NOP
04B04C  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
04B04F  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
04B054  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04B057  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04B05B  80 BF 5B 31 18        CMP    byte ptr [bx + 0x315b], 0x18 ; CMP
04B060  75 09                 JNE    0x4b06b ; CJUMP
04B062  81 6E F4 DC 05        SUB    word ptr [bp - 0xc], 0x5dc ; ARITH
04B067  83 5E F6 00           SBB    word ptr [bp - 0xa], 0 ; ARITH
04B06B  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04B06F  F6 47 03 04           TEST   byte ptr [bx + 3], 4 ; LOGIC
04B073  74 09                 JE     0x4b07e ; CJUMP
04B075  81 6E F4 F4 01        SUB    word ptr [bp - 0xc], 0x1f4 ; ARITH
04B07A  83 5E F6 00           SBB    word ptr [bp - 0xa], 0 ; ARITH
04B07E  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
04B081  8B 56 F6              MOV    dx, word ptr [bp - 0xa] ; LOCAL_LOAD
04B084  0B D2                 OR     dx, dx ; LOGIC
04B086  7F 0C                 JG     0x4b094 ; CJUMP
04B088  7C 05                 JL     0x4b08f ; CJUMP
04B08A  3D F4 01              CMP    ax, 0x1f4 ; CMP
04B08D  73 05                 JAE    0x4b094 ; CJUMP
04B08F  2B D2                 SUB    dx, dx ; ARITH
04B091  B8 F4 01              MOV    ax, 0x1f4 ; CONST_LOAD
04B094  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
04B097  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
04B09A  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
04B09E  7C 03                 JL     0x4b0a3 ; CJUMP
04B0A0  E9 87 01              JMP    0x4b22a ; JUMP
04B0A3  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
04B0A7  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
04B0AC  74 03                 JE     0x4b0b1 ; CJUMP
04B0AE  E9 79 01              JMP    0x4b22a ; JUMP
04B0B1  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
04B0B6  74 0A                 JE     0x4b0c2 ; CJUMP
04B0B8  A1 D2 53              MOV    ax, word ptr [0x53d2] ; GLOBAL_LOAD
04B0BB  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
04B0BE  E9 9C 00              JMP    0x4b15d ; JUMP
04B0C1  90                    NOP ; NOP
04B0C2  A1 52 8D              MOV    ax, word ptr [0x8d52] ; GLOBAL_LOAD
04B0C5  A3 5C 1F              MOV    word ptr [0x1f5c], ax ; GLOBAL_LOAD
04B0C8  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04B0CB  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
04B0D0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04B0D3  50                    PUSH   ax ; STACK_PUSH
04B0D4  6A 00                 PUSH   0 ; STACK_PUSH
04B0D6  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
04B0DB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B0DE  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
04B0E2  8D 06 A9 16           LEA    ax, [0x16a9] ; ADDR
04B0E6  2B D2                 SUB    dx, dx ; ARITH
04B0E8  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
04B0ED  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
04B0F0  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
04B0F3  0B D0                 OR     dx, ax ; LOGIC
04B0F5  75 03                 JNE    0x4b0fa ; CJUMP
04B0F7  E9 0A 02              JMP    0x4b304 ; JUMP
04B0FA  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0 ; LOCAL_STORE
04B0FF  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
04B102  39 46 EE              CMP    word ptr [bp - 0x12], ax ; CMP
04B105  74 31                 JE     0x4b138 ; CJUMP
04B107  A1 D2 53              MOV    ax, word ptr [0x53d2] ; GLOBAL_LOAD
04B10A  39 46 EE              CMP    word ptr [bp - 0x12], ax ; CMP
04B10D  74 29                 JE     0x4b138 ; CJUMP
04B10F  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
04B112  40                    INC    ax ; ARITH
04B113  50                    PUSH   ax ; STACK_PUSH
04B114  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
04B117  9A 1A 0A 1F 18        LCALL  0x181f, 0xa1a ; THUNK -> 0x05B3:0x0198 (thunk @file 0x01B00A type B) overlay @file 0x05FDC4
04B11C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04B11F  50                    PUSH   ax ; STACK_PUSH
04B120  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
04B125  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04B128  52                    PUSH   dx ; STACK_PUSH
04B129  50                    PUSH   ax ; STACK_PUSH
04B12A  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
04B12D  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
04B130  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
04B135  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
04B138  FF 46 EE              INC    word ptr [bp - 0x12] ; ARITH
04B13B  83 7E EE 04           CMP    word ptr [bp - 0x12], 4 ; CMP
04B13F  7C BE                 JL     0x4b0ff ; CJUMP
04B141  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
04B144  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
04B147  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
04B14C  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
04B14F  3D 01 00              CMP    ax, 1 ; CMP
04B152  7D 03                 JGE    0x4b157 ; CJUMP
04B154  B8 01 00              MOV    ax, 1 ; MOV
04B157  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
04B15A  FF 4E EE              DEC    word ptr [bp - 0x12] ; ARITH
04B15D  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
04B160  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04B163  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
04B168  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B16B  A8 20                 TEST   al, 0x20 ; LOGIC
04B16D  75 29                 JNE    0x4b198 ; CJUMP
04B16F  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
04B172  9A 1A 0A 1F 18        LCALL  0x181f, 0xa1a ; THUNK -> 0x05B3:0x0198 (thunk @file 0x01B00A type B) overlay @file 0x05FDC4
04B177  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04B17A  50                    PUSH   ax ; STACK_PUSH
04B17B  6A 00                 PUSH   0 ; STACK_PUSH
04B17D  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
04B182  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B185  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
04B189  68 B7 16              PUSH   0x16b7                       ; STRING: "NOCONTACT"
04B18C  9A 9C 01 1F 19        LCALL  0x191f, 0x19c ; THUNK -> 0x0000:0x3760 (thunk @file 0x01B78C type A) overlay @file 0x029060
04B191  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B194  5E                    POP    si ; STACK_POP
04B195  C9                    LEAVE ; EPILOGUE
04B196  CB                    RETF ; RETURN
