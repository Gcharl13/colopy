; ============================================================================
; func_05CA7E_unknown
; Region   : overlay
; Bytes    : file 0x05CA7E..0x05CC2B  (429 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "HALF", "Bad defense"  (auto-named via string xrefs)
; ============================================================================

05CA7E  C8 DE 00 00           ENTER  0xde, 0 ; PROLOGUE
05CA82  57                    PUSH   di ; STACK_PUSH
05CA83  56                    PUSH   si ; STACK_PUSH
05CA84  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
05CA87  89 86 2A FF           MOV    word ptr [bp - 0xd6], ax ; LOCAL_STORE
05CA8B  89 86 50 FF           MOV    word ptr [bp - 0xb0], ax ; LOCAL_STORE
05CA8F  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
05CA92  2B C0                 SUB    ax, ax ; ARITH
05CA94  89 86 28 FF           MOV    word ptr [bp - 0xd8], ax ; LOCAL_STORE
05CA98  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
05CA9B  89 46 92              MOV    word ptr [bp - 0x6e], ax ; LOCAL_STORE
05CA9E  89 86 6A FF           MOV    word ptr [bp - 0x96], ax ; LOCAL_STORE
05CAA2  89 86 56 FF           MOV    word ptr [bp - 0xaa], ax ; LOCAL_STORE
05CAA6  89 46 90              MOV    word ptr [bp - 0x70], ax ; LOCAL_STORE
05CAA9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
05CAAC  89 46 86              MOV    word ptr [bp - 0x7a], ax ; LOCAL_STORE
05CAAF  89 86 38 FF           MOV    word ptr [bp - 0xc8], ax ; LOCAL_STORE
05CAB3  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
05CAB7  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
05CABB  2A E4                 SUB    ah, ah ; ARITH
05CABD  89 86 66 FF           MOV    word ptr [bp - 0x9a], ax ; LOCAL_STORE
05CAC1  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05CAC4  8B F3                 MOV    si, bx ; MOV
05CAC6  9A 0C 09 1F 18        LCALL  0x181f, 0x90c ; THUNK -> 0x0427:0x065A (thunk @file 0x01AEFC type B) overlay @file 0x03136E
05CACB  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05CACE  2A E4                 SUB    ah, ah ; ARITH
05CAD0  8A 8C 49 31           MOV    cl, byte ptr [si + 0x3149] ; MOV
05CAD4  2A ED                 SUB    ch, ch ; ARITH
05CAD6  2B C1                 SUB    ax, cx ; ARITH
05CAD8  89 86 68 FF           MOV    word ptr [bp - 0x98], ax ; LOCAL_STORE
05CADC  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0 ; CMP
05CAE0  74 05                 JE     0x5cae7 ; CJUMP
05CAE2  80 84 49 31 03        ADD    byte ptr [si + 0x3149], 3 ; ARITH
05CAE7  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
05CAEB  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
05CAEF  25 0F 00              AND    ax, 0xf ; LOGIC
05CAF2  89 86 7A FF           MOV    word ptr [bp - 0x86], ax ; LOCAL_STORE
05CAF6  8A 87 4A 31           MOV    al, byte ptr [bx + 0x314a] ; MOV
05CAFA  98                    CWDE ; ARITH
05CAFB  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
05CAFE  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
05CB03  72 0F                 JB     0x5cb14 ; CJUMP
05CB05  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
05CB0A  77 08                 JA     0x5cb14 ; CJUMP
05CB0C  C7 86 7C FF 01 00     MOV    word ptr [bp - 0x84], 1 ; LOCAL_STORE
05CB12  EB 06                 JMP    0x5cb1a ; JUMP
05CB14  C7 86 7C FF 00 00     MOV    word ptr [bp - 0x84], 0 ; LOCAL_STORE
05CB1A  FF B6 7A FF           PUSH   word ptr [bp - 0x86] ; PUSH_GLOBAL
05CB1E  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
05CB21  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
05CB24  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
05CB29  89 46 82              MOV    word ptr [bp - 0x7e], ax ; LOCAL_STORE
05CB2C  50                    PUSH   ax ; STACK_PUSH
05CB2D  0E                    PUSH   cs ; STACK_PUSH
05CB2E  E8 D9 1B              CALL   0x5e70a ; CALL_NEAR
05CB31  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05CB34  89 86 3A FF           MOV    word ptr [bp - 0xc6], ax ; LOCAL_STORE
05CB38  2B C0                 SUB    ax, ax ; ARITH
05CB3A  A3 00 8D              MOV    word ptr [0x8d00], ax ; GLOBAL_LOAD
05CB3D  A3 56 A1              MOV    word ptr [0xa156], ax ; GLOBAL_LOAD
05CB40  A3 02 8D              MOV    word ptr [0x8d02], ax ; GLOBAL_LOAD
05CB43  A3 58 A1              MOV    word ptr [0xa158], ax ; GLOBAL_LOAD
05CB46  83 BE 68 FF 03        CMP    word ptr [bp - 0x98], 3 ; CMP
05CB4B  7D 5F                 JGE    0x5cbac ; CJUMP
05CB4D  8B 86 68 FF           MOV    ax, word ptr [bp - 0x98] ; LOCAL_LOAD
05CB51  89 86 6A FF           MOV    word ptr [bp - 0x96], ax ; LOCAL_STORE
05CB55  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0 ; CMP
05CB59  74 39                 JE     0x5cb94 ; CJUMP
05CB5B  83 BE 7A FF 04        CMP    word ptr [bp - 0x86], 4 ; CMP
05CB60  7C 03                 JL     0x5cb65 ; CJUMP
05CB62  E9 A1 1B              JMP    0x5e706 ; JUMP
05CB65  6B 9E 7A FF 34        IMUL   bx, word ptr [bp - 0x86], 0x34 ; ARITH
05CB6A  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
05CB6F  74 03                 JE     0x5cb74 ; CJUMP
05CB71  E9 92 1B              JMP    0x5e706 ; JUMP
05CB74  99                    CDQ ; ARITH
05CB75  52                    PUSH   dx ; STACK_PUSH
05CB76  50                    PUSH   ax ; STACK_PUSH
05CB77  6A 00                 PUSH   0 ; STACK_PUSH
05CB79  9A AE 09 1F 18        LCALL  0x181f, 0x9ae ; THUNK -> 0x0000:0x042C (thunk @file 0x01AF9E type A) overlay @file 0x025D2C
05CB7E  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05CB81  6A 01                 PUSH   1 ; STACK_PUSH
05CB83  68 06 1C              PUSH   0x1c06                       ; STRING: "HALF"
05CB86  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
05CB8B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05CB8E  48                    DEC    ax ; ARITH
05CB8F  74 03                 JE     0x5cb94 ; CJUMP
05CB91  E9 72 1B              JMP    0x5e706 ; JUMP
05CB94  83 BE 68 FF 02        CMP    word ptr [bp - 0x98], 2 ; CMP
05CB99  75 05                 JNE    0x5cba0 ; CJUMP
05CB9B  80 0E 01 8D 01        OR     byte ptr [0x8d01], 1 ; LOGIC
05CBA0  83 BE 68 FF 01        CMP    word ptr [bp - 0x98], 1 ; CMP
05CBA5  75 05                 JNE    0x5cbac ; CJUMP
05CBA7  80 0E 56 A1 08        OR     byte ptr [0xa156], 8 ; LOGIC
05CBAC  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0 ; CMP
05CBB0  74 0B                 JE     0x5cbbd ; CJUMP
05CBB2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05CBB5  9A 34 09 1F 18        LCALL  0x181f, 0x934 ; THUNK -> 0x0427:0x155E (thunk @file 0x01AF24 type B) overlay @file 0x032272
05CBBA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05CBBD  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
05CBC0  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05CBC3  9A BE 06 1F 18        LCALL  0x181f, 0x6be ; THUNK -> 0x037F:0x03E4 (thunk @file 0x01ACAE type B) overlay @file 0x02EF20
05CBC8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05CBCB  89 86 2C FF           MOV    word ptr [bp - 0xd4], ax ; LOCAL_STORE
05CBCF  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
05CBD2  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05CBD5  9A BE 07 1F 18        LCALL  0x181f, 0x7be ; THUNK -> 0x05EB:0x0A76 (thunk @file 0x01ADAE type B) overlay @file 0x027A66
05CBDA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05CBDD  89 86 2A FF           MOV    word ptr [bp - 0xd6], ax ; LOCAL_STORE
05CBE1  83 BE 3A FF 00        CMP    word ptr [bp - 0xc6], 0 ; CMP
05CBE6  7C 03                 JL     0x5cbeb ; CJUMP
05CBE8  E9 A5 01              JMP    0x5cd90 ; JUMP
05CBEB  C7 46 92 01 00        MOV    word ptr [bp - 0x6e], 1 ; LOCAL_STORE
05CBF0  83 BE 2C FF 00        CMP    word ptr [bp - 0xd4], 0 ; CMP
05CBF5  7D 35                 JGE    0x5cc2c ; CJUMP
05CBF7  C7 86 72 FF 01 00     MOV    word ptr [bp - 0x8e], 1 ; LOCAL_STORE
05CBFD  FF B6 72 FF           PUSH   word ptr [bp - 0x8e] ; PUSH_GLOBAL
05CC01  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
05CC04  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05CC07  68 E1 1C              PUSH   0x1ce1                       ; STRING: "Bad defense"
05CC0A  9A 7E 07 1F 18        LCALL  0x181f, 0x77e ; THUNK -> 0x0000:0x00E2 (thunk @file 0x01AD6E type A) overlay @file 0x0259E2
05CC0F  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
05CC12  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
05CC15  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05CC18  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
05CC1D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05CC20  0B C0                 OR     ax, ax ; LOGIC
05CC22  74 03                 JE     0x5cc27 ; CJUMP
05CC24  E9 47 1A              JMP    0x5e66e ; JUMP
05CC27  5E                    POP    si ; STACK_POP
05CC28  5F                    POP    di ; STACK_POP
05CC29  C9                    LEAVE ; EPILOGUE
05CC2A  CB                    RETF ; RETURN
