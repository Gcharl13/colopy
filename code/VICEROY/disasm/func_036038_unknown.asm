; ============================================================================
; func_036038_unknown
; Region   : overlay
; Bytes    : file 0x036038..0x036138  (256 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "KINGNEWWAR"  (auto-named via string xrefs)
; ============================================================================

036038  C8 2D 06 00           ENTER  0x62d, 0 ; PROLOGUE
03603C  F7 D8                 NEG    ax ; ARITH
03603E  3B 46 F6              CMP    ax, word ptr [bp - 0xa] ; CMP
036041  7E 03                 JLE    0x36046 ; CJUMP
036043  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
036046  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
036049  8B C1                 MOV    ax, cx ; MOV
03604B  83 E9 05              SUB    cx, 5 ; ARITH
03604E  F7 D9                 NEG    cx ; ARITH
036050  69 C9 F4 01           IMUL   cx, cx, 0x1f4 ; ARITH
036054  3B 4E E8              CMP    cx, word ptr [bp - 0x18] ; CMP
036057  7E 03                 JLE    0x3605c ; CJUMP
036059  8B 4E E8              MOV    cx, word ptr [bp - 0x18] ; LOCAL_LOAD
03605C  89 4E E8              MOV    word ptr [bp - 0x18], cx ; LOCAL_STORE
03605F  8B D8                 MOV    bx, ax ; MOV
036061  D1 E3                 SHL    bx, 1 ; LOGIC
036063  FF B7 94 83           PUSH   word ptr [bx - 0x7c6c] ; PUSH_GLOBAL
036067  6A 00                 PUSH   0 ; STACK_PUSH
036069  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
03606E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
036071  6B 46 E6 34           IMUL   ax, word ptr [bp - 0x1a], 0x34 ; ARITH
036075  05 0E 54              ADD    ax, 0x540e ; ARITH
036078  1E                    PUSH   ds ; STACK_PUSH
036079  50                    PUSH   ax ; STACK_PUSH
03607A  6A 01                 PUSH   1 ; STACK_PUSH
03607C  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
036081  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
036084  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
036087  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
03608C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03608F  50                    PUSH   ax ; STACK_PUSH
036090  6A 02                 PUSH   2 ; STACK_PUSH
036092  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
036097  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03609A  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
03609D  99                    CDQ ; ARITH
03609E  52                    PUSH   dx ; STACK_PUSH
03609F  50                    PUSH   ax ; STACK_PUSH
0360A0  6A 00                 PUSH   0 ; STACK_PUSH
0360A2  8B F0                 MOV    si, ax ; MOV
0360A4  8B FA                 MOV    di, dx ; MOV
0360A6  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
0360AB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0360AE  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
0360B1  99                    CDQ ; ARITH
0360B2  52                    PUSH   dx ; STACK_PUSH
0360B3  50                    PUSH   ax ; STACK_PUSH
0360B4  6A 01                 PUSH   1 ; STACK_PUSH
0360B6  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
0360BB  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0360BE  68 34 11              PUSH   0x1134                       ; STRING: "KINGNEWWAR"
0360C1  9A D4 0A 1F 19        LCALL  0x191f, 0xad4 ; THUNK -> 0x0000:0x378A (thunk @file 0x01C0C4 type A) overlay @file 0x02908A
0360C6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0360C9  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
0360CD  01 77 2A              ADD    word ptr [bx + 0x2a], si ; ARITH
0360D0  11 7F 2C              ADC    word ptr [bx + 0x2c], di ; ARITH
0360D3  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
0360D8  EB 26                 JMP    0x36100 ; JUMP
0360DA  90                    NOP ; NOP
0360DB  90                    NOP ; NOP
0360DC  8B 46 E6              MOV    ax, word ptr [bp - 0x1a] ; LOCAL_LOAD
0360DF  2D 14 00              SUB    ax, 0x14 ; ARITH
0360E2  50                    PUSH   ax ; STACK_PUSH
0360E3  50                    PUSH   ax ; STACK_PUSH
0360E4  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
0360E7  6A 01                 PUSH   1 ; STACK_PUSH
0360E9  9A 5C 09 1F 18        LCALL  0x181f, 0x95c ; THUNK -> 0x0427:0x06B4 (thunk @file 0x01AF4C type B) overlay @file 0x0313C8
0360EE  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0360F1  0B C0                 OR     ax, ax ; LOGIC
0360F3  7C 13                 JL     0x36108 ; CJUMP
0360F5  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
0360F8  C6 87 5B 31 15        MOV    byte ptr [bx + 0x315b], 0x15 ; CONST_LOAD
0360FD  FF 46 F4              INC    word ptr [bp - 0xc] ; ARITH
036100  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
036103  39 46 F4              CMP    word ptr [bp - 0xc], ax ; CMP
036106  7C D4                 JL     0x360dc ; CJUMP
036108  6A 40                 PUSH   0x40 ; PUSH_CONST
03610A  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
03610D  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
036110  9A 10 0A 1F 18        LCALL  0x181f, 0xa10 ; THUNK -> 0x05B3:0x00D0 (thunk @file 0x01B000 type B) overlay @file 0x05FCFC
036115  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
036118  6A 10                 PUSH   0x10 ; PUSH_CONST
03611A  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
03611D  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
036120  9A 06 0A 1F 18        LCALL  0x181f, 0xa06 ; THUNK -> 0x05B3:0x0066 (thunk @file 0x01AFF6 type B) overlay @file 0x05FC92
036125  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
036128  A1 8E 53              MOV    ax, word ptr [0x538e] ; GLOBAL_LOAD
03612B  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
03612E  D1 E3                 SHL    bx, 1 ; LOGIC
036130  89 87 C8 53           MOV    word ptr [bx + 0x53c8], ax ; MOV
036134  5E                    POP    si ; STACK_POP
036135  5F                    POP    di ; STACK_POP
036136  C9                    LEAVE ; EPILOGUE
036137  CB                    RETF ; RETURN
