; ============================================================================
; func_031366_unknown
; Region   : overlay
; Bytes    : file 0x031366..0x03144B  (229 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031366  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
03136A  8D 46 F6              LEA    ax, [bp - 0xa] ; ADDR
03136D  50                    PUSH   ax ; STACK_PUSH
03136E  8D 46 F8              LEA    ax, [bp - 8] ; ADDR
031371  50                    PUSH   ax ; STACK_PUSH
031372  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
031375  50                    PUSH   ax ; STACK_PUSH
031376  8D 4E FE              LEA    cx, [bp - 2] ; ADDR
031379  51                    PUSH   cx ; STACK_PUSH
03137A  8D 56 FC              LEA    dx, [bp - 4] ; ADDR
03137D  52                    PUSH   dx ; STACK_PUSH
03137E  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
031381  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
031384  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
031387  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
03138A  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
03138C  0E                    PUSH   cs ; STACK_PUSH
03138D  E8 0F 55              CALL   0x3689f ; CALL_NEAR
031390  83 C4 12              ADD    sp, 0x12 ; STACK_CLEANUP
031393  83 7E FC 02           CMP    word ptr [bp - 4], 2 ; CMP
031397  7C 03                 JL     0x3139c ; CJUMP
031399  E9 84 00              JMP    0x31420 ; JUMP
03139C  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
03139F  6A 10                 PUSH   0x10 ; PUSH_CONST
0313A1  8A 4E FC              MOV    cl, byte ptr [bp - 4] ; LOCAL_LOAD
0313A4  B8 64 00              MOV    ax, 0x64 ; CONST_LOAD
0313A7  D3 F8                 SAR    ax, cl ; LOGIC
0313A9  50                    PUSH   ax ; STACK_PUSH
0313AA  83 7E FC 01           CMP    word ptr [bp - 4], 1 ; CMP
0313AE  75 06                 JNE    0x313b6 ; CJUMP
0313B0  B8 04 00              MOV    ax, 4 ; MOV
0313B3  EB 03                 JMP    0x313b8 ; JUMP
0313B5  90                    NOP ; NOP
0313B6  2B C0                 SUB    ax, ax ; ARITH
0313B8  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
0313BB  2B D8                 SUB    bx, ax ; ARITH
0313BD  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0313C0  2B D2                 SUB    dx, dx ; ARITH
0313C2  9A BC 02 1F 18        LCALL  0x181f, 0x2bc ; THUNK -> 0x012B:0x01BA (thunk @file 0x01A8AC type B) overlay @file 0x023724
0313C7  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
0313CB  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
0313D0  73 03                 JAE    0x313d5 ; CJUMP
0313D2  E9 98 00              JMP    0x3146d ; JUMP
0313D5  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
0313DA  76 03                 JBE    0x313df ; CJUMP
0313DC  E9 8E 00              JMP    0x3146d ; JUMP
0313DF  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
0313E3  74 03                 JE     0x313e8 ; CJUMP
0313E5  E9 85 00              JMP    0x3146d ; JUMP
0313E8  83 7E 0C 02           CMP    word ptr [bp + 0xc], 2 ; CMP
0313EC  7D 7F                 JGE    0x3146d ; CJUMP
0313EE  80 BF 50 31 00        CMP    byte ptr [bx + 0x3150], 0 ; CMP
0313F3  74 78                 JE     0x3146d ; CJUMP
0313F5  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
0313F9  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
0313FD  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
031400  6A 00                 PUSH   0 ; STACK_PUSH
031402  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
031405  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
03140A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03140D  05 17 00              ADD    ax, 0x17 ; ARITH
031410  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
031414  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
031417  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
03141C  EB 4F                 JMP    0x3146d ; JUMP
03141E  90                    NOP ; NOP
03141F  90                    NOP ; NOP
031420  83 7E FC 03           CMP    word ptr [bp - 4], 3 ; CMP
031424  7D 47                 JGE    0x3146d ; CJUMP
031426  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
03142A  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
03142E  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
031431  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
031434  48                    DEC    ax ; ARITH
031435  50                    PUSH   ax ; STACK_PUSH
031436  8A 4E FC              MOV    cl, byte ptr [bp - 4] ; LOCAL_LOAD
031439  B8 64 00              MOV    ax, 0x64 ; CONST_LOAD
03143C  D3 F8                 SAR    ax, cl ; LOGIC
03143E  50                    PUSH   ax ; STACK_PUSH
03143F  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
031443  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
031447  2A FF                 SUB    bh, bh ; ARITH
031449  8B C3                 MOV    ax, bx ; MOV
