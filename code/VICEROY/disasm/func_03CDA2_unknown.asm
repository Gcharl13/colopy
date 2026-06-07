; ============================================================================
; func_03CDA2_unknown
; Region   : overlay
; Bytes    : file 0x03CDA2..0x03CEB3  (273 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CDA2  C8 82 00 00           ENTER  0x82, 0 ; PROLOGUE
03CDA6  56                    PUSH   si ; STACK_PUSH
03CDA7  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
03CDAC  83 3E DE 53 00        CMP    word ptr [0x53de], 0 ; CMP
03CDB1  74 35                 JE     0x3cde8 ; CJUMP
03CDB3  A1 DA 53              MOV    ax, word ptr [0x53da] ; GLOBAL_LOAD
03CDB6  03 06 DC 53           ADD    ax, word ptr [0x53dc] ; ARITH
03CDBA  03 06 E0 53           ADD    ax, word ptr [0x53e0] ; ARITH
03CDBE  03 06 DE 53           ADD    ax, word ptr [0x53de] ; ARITH
03CDC2  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03CDC5  3D 04 00              CMP    ax, 4 ; CMP
03CDC8  7E 06                 JLE    0x3cdd0 ; CJUMP
03CDCA  3B 06 DE 53           CMP    ax, word ptr [0x53de] ; CMP
03CDCE  75 05                 JNE    0x3cdd5 ; CJUMP
03CDD0  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
03CDD5  39 06 DE 53           CMP    word ptr [0x53de], ax ; CMP
03CDD9  75 03                 JNE    0x3cdde ; CJUMP
03CDDB  E9 10 07              JMP    0x3d4ee ; JUMP
03CDDE  2B C0                 SUB    ax, ax ; ARITH
03CDE0  89 46 D8              MOV    word ptr [bp - 0x28], ax ; LOCAL_STORE
03CDE3  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
03CDE6  EB 19                 JMP    0x3ce01 ; JUMP
03CDE8  6B 1E D2 53 13        IMUL   bx, word ptr [0x53d2], 0x13 ; ARITH
03CDED  80 BF 5E 92 00        CMP    byte ptr [bx - 0x6da2], 0 ; CMP
03CDF2  74 03                 JE     0x3cdf7 ; CJUMP
03CDF4  E9 F7 06              JMP    0x3d4ee ; JUMP
03CDF7  FF 06 DE 53           INC    word ptr [0x53de] ; ARITH
03CDFB  E9 F0 06              JMP    0x3d4ee ; JUMP
03CDFE  FF 46 98              INC    word ptr [bp - 0x68] ; ARITH
03CE01  8B 46 98              MOV    ax, word ptr [bp - 0x68] ; LOCAL_LOAD
03CE04  39 06 9E 53           CMP    word ptr [0x539e], ax ; CMP
03CE08  7F 03                 JG     0x3ce0d ; CJUMP
03CE0A  E9 89 00              JMP    0x3ce96 ; JUMP
03CE0D  50                    PUSH   ax ; STACK_PUSH
03CE0E  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
03CE13  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03CE16  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
03CE19  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03CE1D  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
03CE20  75 DC                 JNE    0x3cdfe ; CJUMP
03CE22  F6 47 1C 40           TEST   byte ptr [bx + 0x1c], 0x40 ; LOGIC
03CE26  74 D6                 JE     0x3cdfe ; CJUMP
03CE28  83 7E D8 0A           CMP    word ptr [bp - 0x28], 0xa ; CMP
03CE2C  7D D0                 JGE    0x3cdfe ; CJUMP
03CE2E  9A 86 0C 1F 18        LCALL  0x181f, 0xc86 ; THUNK -> 0x05EB:0x0274 (thunk @file 0x01B276 type B) overlay @file 0x027264
03CE33  2D 64 00              SUB    ax, 0x64 ; ARITH
03CE36  F7 D8                 NEG    ax ; ARITH
03CE38  89 46 BC              MOV    word ptr [bp - 0x44], ax ; LOCAL_STORE
03CE3B  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03CE3F  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
03CE42  98                    CWDE ; ARITH
03CE43  8B 4E BC              MOV    cx, word ptr [bp - 0x44] ; LOCAL_LOAD
03CE46  83 C1 19              ADD    cx, 0x19 ; ARITH
03CE49  F7 E9                 IMUL   cx ; ARITH
03CE4B  89 46 CE              MOV    word ptr [bp - 0x32], ax ; LOCAL_STORE
03CE4E  6A 0A                 PUSH   0xa ; PUSH_CONST
03CE50  8A 07                 MOV    al, byte ptr [bx] ; MOV
03CE52  2A E4                 SUB    ah, ah ; ARITH
03CE54  8A 57 01              MOV    dl, byte ptr [bx + 1] ; MOV
03CE57  2A F6                 SUB    dh, dh ; ARITH
03CE59  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
03CE5E  89 46 B6              MOV    word ptr [bp - 0x4a], ax ; LOCAL_STORE
03CE61  50                    PUSH   ax ; STACK_PUSH
03CE62  9A BC 08 1F 18        LCALL  0x181f, 0x8bc ; THUNK -> 0x0427:0x0D38 (thunk @file 0x01AEAC type B) overlay @file 0x031A4C
03CE67  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03CE6A  6B C0 B5              IMUL   ax, ax, -0x4b ; ARITH
03CE6D  01 46 CE              ADD    word ptr [bp - 0x32], ax ; ARITH
03CE70  8B 46 CE              MOV    ax, word ptr [bp - 0x32] ; LOCAL_LOAD
03CE73  3B 46 BC              CMP    ax, word ptr [bp - 0x44] ; CMP
03CE76  7D 03                 JGE    0x3ce7b ; CJUMP
03CE78  8B 46 BC              MOV    ax, word ptr [bp - 0x44] ; LOCAL_LOAD
03CE7B  89 46 CE              MOV    word ptr [bp - 0x32], ax ; LOCAL_STORE
03CE7E  8B 76 D8              MOV    si, word ptr [bp - 0x28] ; LOCAL_LOAD
03CE81  D1 E6                 SHL    si, 1 ; LOGIC
03CE83  89 42 A2              MOV    word ptr [bp + si - 0x5e], ax ; LOCAL_STORE
03CE86  8A 46 98              MOV    al, byte ptr [bp - 0x68] ; LOCAL_LOAD
03CE89  8B 76 D8              MOV    si, word ptr [bp - 0x28] ; LOCAL_LOAD
03CE8C  88 42 C0              MOV    byte ptr [bp + si - 0x40], al ; LOCAL_STORE
03CE8F  FF 46 D8              INC    word ptr [bp - 0x28] ; ARITH
03CE92  E9 69 FF              JMP    0x3cdfe ; JUMP
03CE95  90                    NOP ; NOP
03CE96  83 7E D8 00           CMP    word ptr [bp - 0x28], 0 ; CMP
03CE9A  74 12                 JE     0x3ceae ; CJUMP
03CE9C  8D 46 C0              LEA    ax, [bp - 0x40] ; ADDR
03CE9F  16                    PUSH   ss ; STACK_PUSH
03CEA0  50                    PUSH   ax ; STACK_PUSH
03CEA1  8D 46 A2              LEA    ax, [bp - 0x5e] ; ADDR
03CEA4  16                    PUSH   ss ; STACK_PUSH
03CEA5  50                    PUSH   ax ; STACK_PUSH
03CEA6  8B 46 D8              MOV    ax, word ptr [bp - 0x28] ; LOCAL_LOAD
03CEA9  9A D0 0E 1F 19        LCALL  0x191f, 0xed0 ; THUNK -> 0x0CF8:0x000A (thunk @file 0x01C4C0 type B)
03CEAE  C7 46 CA 00 00        MOV    word ptr [bp - 0x36], 0 ; LOCAL_STORE
