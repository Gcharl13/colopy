; ============================================================================
; func_021FF2_unknown
; Region   : overlay
; Bytes    : file 0x021FF2..0x02211D  (299 bytes)
; Purpose  : Treaty-status check / break  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "HAVETREATY"  (auto-named via string xrefs)
; ============================================================================

021FF2  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
021FF6  56                    PUSH   si ; STACK_PUSH
021FF7  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
021FFA  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
021FFD  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
022000  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
022004  25 0F 00              AND    ax, 0xf ; LOGIC
022007  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
02200A  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
02200E  2A E4                 SUB    ah, ah ; ARITH
022010  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
022013  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
022017  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
02201A  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
02201D  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
022020  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
022023  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
022028  72 0A                 JB     0x22034 ; CJUMP
02202A  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
02202F  77 03                 JA     0x22034 ; CJUMP
022031  E9 C5 00              JMP    0x220f9 ; JUMP
022034  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
022039  EB 14                 JMP    0x2204f ; JUMP
02203B  90                    NOP ; NOP
02203C  50                    PUSH   ax ; STACK_PUSH
02203D  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
022040  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
022045  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022048  A8 40                 TEST   al, 0x40 ; LOGIC
02204A  75 5E                 JNE    0x220aa ; CJUMP
02204C  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
02204F  83 7E FA 08           CMP    word ptr [bp - 6], 8 ; CMP
022053  7D 5B                 JGE    0x220b0 ; CJUMP
022055  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
022058  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
02205C  98                    CWDE ; ARITH
02205D  03 46 F2              ADD    ax, word ptr [bp - 0xe] ; ARITH
022060  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
022063  50                    PUSH   ax ; STACK_PUSH
022064  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
022068  98                    CWDE ; ARITH
022069  03 46 F6              ADD    ax, word ptr [bp - 0xa] ; ARITH
02206C  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02206F  50                    PUSH   ax ; STACK_PUSH
022070  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
022075  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022078  0B C0                 OR     ax, ax ; LOGIC
02207A  74 D0                 JE     0x2204c ; CJUMP
02207C  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02207F  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
022082  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
022087  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02208A  0B C0                 OR     ax, ax ; LOGIC
02208C  75 BE                 JNE    0x2204c ; CJUMP
02208E  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
022091  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
022094  9A 96 06 1F 18        LCALL  0x181f, 0x696 ; THUNK -> 0x037F:0x0358 (thunk @file 0x01AC86 type B) overlay @file 0x02EE94
022099  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02209C  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
02209F  0B C0                 OR     ax, ax ; LOGIC
0220A1  7C A9                 JL     0x2204c ; CJUMP
0220A3  3B 46 EC              CMP    ax, word ptr [bp - 0x14] ; CMP
0220A6  75 94                 JNE    0x2203c ; CJUMP
0220A8  EB A2                 JMP    0x2204c ; JUMP
0220AA  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
0220AD  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
0220B0  83 7E F4 00           CMP    word ptr [bp - 0xc], 0 ; CMP
0220B4  7C 43                 JL     0x220f9 ; CJUMP
0220B6  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
0220B9  9A 1A 0A 1F 18        LCALL  0x181f, 0xa1a ; THUNK -> 0x05B3:0x0198 (thunk @file 0x01B00A type B) overlay @file 0x05FDC4
0220BE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0220C1  50                    PUSH   ax ; STACK_PUSH
0220C2  6A 00                 PUSH   0 ; STACK_PUSH
0220C4  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
0220C9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0220CC  6A 01                 PUSH   1 ; STACK_PUSH
0220CE  68 32 09              PUSH   0x932                        ; STRING: "HAVETREATY"
0220D1  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
0220D6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0220D9  3D 02 00              CMP    ax, 2 ; CMP
0220DC  75 3C                 JNE    0x2211a ; CJUMP
0220DE  69 76 F4 3C 01        IMUL   si, word ptr [bp - 0xc], 0x13c ; ARITH
0220E3  8B 5E EC              MOV    bx, word ptr [bp - 0x14] ; LOCAL_LOAD
0220E6  80 88 3C 88 02        OR     byte ptr [bx + si - 0x77c4], 2 ; LOGIC
0220EB  6A 40                 PUSH   0x40 ; PUSH_CONST
0220ED  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
0220F0  53                    PUSH   bx ; STACK_PUSH
0220F1  9A 10 0A 1F 18        LCALL  0x181f, 0xa10 ; THUNK -> 0x05B3:0x00D0 (thunk @file 0x01B000 type B) overlay @file 0x05FCFC
0220F6  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0220F9  B8 58 00              MOV    ax, 0x58 ; CONST_LOAD
0220FC  9A C0 04 1F 18        LCALL  0x181f, 0x4c0 ; THUNK -> 0x02D8:0x000E (thunk @file 0x01AAB0 type B)
022101  6B 5E EE 1C           IMUL   bx, word ptr [bp - 0x12], 0x1c ; ARITH
022105  C6 87 4C 31 05        MOV    byte ptr [bx + 0x314c], 5 ; MOV
02210A  C6 87 5A 31 00        MOV    byte ptr [bx + 0x315a], 0 ; MOV
02210F  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
022112  9A 34 09 1F 18        LCALL  0x181f, 0x934 ; THUNK -> 0x0427:0x155E (thunk @file 0x01AF24 type B) overlay @file 0x032272
022117  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02211A  5E                    POP    si ; STACK_POP
02211B  C9                    LEAVE ; EPILOGUE
02211C  CB                    RETF ; RETURN
