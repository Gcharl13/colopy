; ============================================================================
; func_04AC00_unknown
; Region   : overlay
; Bytes    : file 0x04AC00..0x04AD8D  (397 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "EXTORTLAUGH"  (auto-named via string xrefs)
; ============================================================================

04AC00  C8 2A 00 00           ENTER  0x2a, 0 ; PROLOGUE
04AC04  56                    PUSH   si ; STACK_PUSH
04AC05  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04AC09  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
04AC0D  2A E4                 SUB    ah, ah ; ARITH
04AC0F  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
04AC12  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
04AC16  2A ED                 SUB    ch, ch ; ARITH
04AC18  89 4E E2              MOV    word ptr [bp - 0x1e], cx ; LOCAL_STORE
04AC1B  51                    PUSH   cx ; STACK_PUSH
04AC1C  50                    PUSH   ax ; STACK_PUSH
04AC1D  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
04AC22  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04AC25  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
04AC28  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04AC2B  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
04AC2F  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
04AC34  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04AC37  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
04AC3A  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
04AC3D  C1 E6 04              SHL    si, 4 ; LOGIC
04AC40  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
04AC43  8A 80 B2 95           MOV    al, byte ptr [bx + si - 0x6a4e] ; MOV
04AC47  2A E4                 SUB    ah, ah ; ARITH
04AC49  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
04AC4C  D1 E3                 SHL    bx, 1 ; LOGIC
04AC4E  8B 8F 1C 94           MOV    cx, word ptr [bx - 0x6be4] ; MOV
04AC52  D1 E9                 SHR    cx, 1 ; LOGIC
04AC54  03 C1                 ADD    ax, cx ; ARITH
04AC56  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
04AC59  83 7E 08 02           CMP    word ptr [bp + 8], 2 ; CMP
04AC5D  75 08                 JNE    0x4ac67 ; CJUMP
04AC5F  D1 F8                 SAR    ax, 1 ; LOGIC
04AC61  03 46 E6              ADD    ax, word ptr [bp - 0x1a] ; ARITH
04AC64  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
04AC67  6A 0A                 PUSH   0xa ; PUSH_CONST
04AC69  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04AC6C  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
04AC71  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04AC74  0B C0                 OR     ax, ax ; LOGIC
04AC76  74 08                 JE     0x4ac80 ; CJUMP
04AC78  8B 46 E6              MOV    ax, word ptr [bp - 0x1a] ; LOCAL_LOAD
04AC7B  D1 F8                 SAR    ax, 1 ; LOGIC
04AC7D  01 46 E6              ADD    word ptr [bp - 0x1a], ax ; ARITH
04AC80  8B 36 52 8D           MOV    si, word ptr [0x8d52] ; GLOBAL_LOAD
04AC84  C1 E6 04              SHL    si, 4 ; LOGIC
04AC87  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
04AC8A  8A 80 CC 91           MOV    al, byte ptr [bx + si - 0x6e34] ; MOV
04AC8E  2A E4                 SUB    ah, ah ; ARITH
04AC90  8B 1E 52 8D           MOV    bx, word ptr [0x8d52] ; GLOBAL_LOAD
04AC94  8A 8F 84 91           MOV    cl, byte ptr [bx - 0x6e7c] ; MOV
04AC98  D0 E9                 SHR    cl, 1 ; LOGIC
04AC9A  2A ED                 SUB    ch, ch ; ARITH
04AC9C  03 C1                 ADD    ax, cx ; ARITH
04AC9E  D1 E0                 SHL    ax, 1 ; LOGIC
04ACA0  8B 4E D6              MOV    cx, word ptr [bp - 0x2a] ; LOCAL_LOAD
04ACA3  D1 F9                 SAR    cx, 1 ; LOGIC
04ACA5  03 C1                 ADD    ax, cx ; ARITH
04ACA7  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
04ACAA  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
04ACAE  7D 16                 JGE    0x4acc6 ; CJUMP
04ACB0  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
04ACB4  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
04ACB9  75 0B                 JNE    0x4acc6 ; CJUMP
04ACBB  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
04ACBE  2A E4                 SUB    ah, ah ; ARITH
04ACC0  40                    INC    ax ; ARITH
04ACC1  89 46 DC              MOV    word ptr [bp - 0x24], ax ; LOCAL_STORE
04ACC4  EB 05                 JMP    0x4accb ; JUMP
04ACC6  C7 46 DC 01 00        MOV    word ptr [bp - 0x24], 1 ; LOCAL_STORE
04ACCB  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
04ACCE  6A 00                 PUSH   0 ; STACK_PUSH
04ACD0  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
04ACD5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04ACD8  FF 76 E0              PUSH   word ptr [bp - 0x20] ; PUSH_GLOBAL
04ACDB  6A 00                 PUSH   0 ; STACK_PUSH
04ACDD  8B F0                 MOV    si, ax ; MOV
04ACDF  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
04ACE4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04ACE7  3B C6                 CMP    ax, si ; CMP
04ACE9  7D 05                 JGE    0x4acf0 ; CJUMP
04ACEB  B8 01 00              MOV    ax, 1 ; MOV
04ACEE  EB 02                 JMP    0x4acf2 ; JUMP
04ACF0  2B C0                 SUB    ax, ax ; ARITH
04ACF2  89 46 D8              MOV    word ptr [bp - 0x28], ax ; LOCAL_STORE
04ACF5  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
04ACF8  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04ACFB  FF 76 E2              PUSH   word ptr [bp - 0x1e] ; PUSH_GLOBAL
04ACFE  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
04AD01  9A 14 06 1F 18        LCALL  0x181f, 0x614 ; THUNK -> 0x05EB:0x0142 (thunk @file 0x01AC04 type B) overlay @file 0x027132
04AD06  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
04AD09  89 46 DA              MOV    word ptr [bp - 0x26], ax ; LOCAL_STORE
04AD0C  0B C0                 OR     ax, ax ; LOGIC
04AD0E  7D 05                 JGE    0x4ad15 ; CJUMP
04AD10  C7 46 D8 00 00        MOV    word ptr [bp - 0x28], 0 ; LOCAL_STORE
04AD15  83 7E D8 00           CMP    word ptr [bp - 0x28], 0 ; CMP
04AD19  75 08                 JNE    0x4ad23 ; CJUMP
04AD1B  8B 46 E0              MOV    ax, word ptr [bp - 0x20] ; LOCAL_LOAD
04AD1E  39 46 E6              CMP    word ptr [bp - 0x1a], ax ; CMP
04AD21  7E 06                 JLE    0x4ad29 ; CJUMP
04AD23  83 7E D6 4B           CMP    word ptr [bp - 0x2a], 0x4b ; CMP
04AD27  7C 3F                 JL     0x4ad68 ; CJUMP
04AD29  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
04AD2D  7C 03                 JL     0x4ad32 ; CJUMP
04AD2F  E9 14 02              JMP    0x4af46 ; JUMP
04AD32  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
04AD36  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
04AD3B  74 03                 JE     0x4ad40 ; CJUMP
04AD3D  E9 06 02              JMP    0x4af46 ; JUMP
04AD40  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04AD43  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
04AD48  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04AD4B  50                    PUSH   ax ; STACK_PUSH
04AD4C  6A 00                 PUSH   0 ; STACK_PUSH
04AD4E  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
04AD53  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04AD56  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
04AD5A  68 7D 16              PUSH   0x167d                       ; STRING: "EXTORTLAUGH"
04AD5D  9A 9C 01 1F 19        LCALL  0x191f, 0x19c ; THUNK -> 0x0000:0x3760 (thunk @file 0x01B78C type A) overlay @file 0x029060
04AD62  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04AD65  E9 DE 01              JMP    0x4af46 ; JUMP
04AD68  83 7E D8 00           CMP    word ptr [bp - 0x28], 0 ; CMP
04AD6C  75 66                 JNE    0x4add4 ; CJUMP
04AD6E  83 7E D6 32           CMP    word ptr [bp - 0x2a], 0x32 ; CMP
04AD72  7C 60                 JL     0x4add4 ; CJUMP
04AD74  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
04AD78  7C 03                 JL     0x4ad7d ; CJUMP
04AD7A  E9 C9 01              JMP    0x4af46 ; JUMP
04AD7D  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
04AD81  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
04AD86  74 03                 JE     0x4ad8b ; CJUMP
04AD88  E9 BB 01              JMP    0x4af46 ; JUMP
04AD8B  8B C3                 MOV    ax, bx ; MOV
