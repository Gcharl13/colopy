; ============================================================================
; func_0605F6_unknown
; Region   : overlay
; Bytes    : file 0x0605F6..0x060769  (371 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0605F6  C8 5C 00 00           ENTER  0x5c, 0 ; PROLOGUE
0605FA  56                    PUSH   si ; STACK_PUSH
0605FB  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
060600  C7 46 A6 00 00        MOV    word ptr [bp - 0x5a], 0 ; LOCAL_STORE
060605  2B C0                 SUB    ax, ax ; ARITH
060607  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
06060A  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
06060D  83 3E A0 53 01        CMP    word ptr [0x53a0], 1 ; CMP
060612  7D 12                 JGE    0x60626 ; CJUMP
060614  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
060618  8D 06 0E 1D           LEA    ax, [0x1d0e] ; ADDR
06061C  2B D2                 SUB    dx, dx ; ARITH
06061E  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
060623  E9 2A 01              JMP    0x60750 ; JUMP
060626  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
06062A  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06062D  2B D2                 SUB    dx, dx ; ARITH
06062F  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
060634  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
060637  89 56 AA              MOV    word ptr [bp - 0x56], dx ; LOCAL_STORE
06063A  0B D0                 OR     dx, ax ; LOGIC
06063C  75 03                 JNE    0x60641 ; CJUMP
06063E  E9 0F 01              JMP    0x60750 ; JUMP
060641  C4 5E A8              LES    bx, ptr [bp - 0x58] ; MOV_FAR
060644  26 80 4F 0A 01        OR     byte ptr es:[bx + 0xa], 1 ; LOGIC
060649  26 C7 47 22 0A 00     MOV    word ptr es:[bx + 0x22], 0xa ; CONST_LOAD
06064F  C7 46 A4 00 00        MOV    word ptr [bp - 0x5c], 0 ; LOCAL_STORE
060654  EB 76                 JMP    0x606cc ; JUMP
060656  2A C0                 SUB    al, al ; ARITH
060658  C4 1E 14 9E           LES    bx, ptr [0x9e14] ; MOV_FAR
06065C  26 3A 47 20           CMP    al, byte ptr es:[bx + 0x20] ; CMP
060660  75 67                 JNE    0x606c9 ; CJUMP
060662  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
060666  8B 46 A4              MOV    ax, word ptr [bp - 0x5c] ; LOCAL_LOAD
060669  40                    INC    ax ; ARITH
06066A  50                    PUSH   ax ; STACK_PUSH
06066B  8D 4E AE              LEA    cx, [bp - 0x52] ; ADDR
06066E  16                    PUSH   ss ; STACK_PUSH
06066F  51                    PUSH   cx ; STACK_PUSH
060670  8B F0                 MOV    si, ax ; MOV
060672  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
060677  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06067A  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06067D  50                    PUSH   ax ; STACK_PUSH
06067E  9A DC 01 1F 18        LCALL  0x181f, 0x1dc ; THUNK -> 0x004B:0x0052 (thunk @file 0x01A7CC type B) overlay @file 0x0603FA
060683  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060686  FF 36 16 9E           PUSH   word ptr [0x9e16] ; PUSH_GLOBAL
06068A  FF 36 14 9E           PUSH   word ptr [0x9e14] ; PUSH_GLOBAL
06068E  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
060691  16                    PUSH   ss ; STACK_PUSH
060692  50                    PUSH   ax ; STACK_PUSH
060693  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
060698  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
06069B  56                    PUSH   si ; STACK_PUSH
06069C  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06069F  16                    PUSH   ss ; STACK_PUSH
0606A0  50                    PUSH   ax ; STACK_PUSH
0606A1  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
0606A4  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
0606A7  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
0606AC  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
0606AF  FF 46 A6              INC    word ptr [bp - 0x5a] ; ARITH
0606B2  8B 46 A4              MOV    ax, word ptr [bp - 0x5c] ; LOCAL_LOAD
0606B5  39 46 08              CMP    word ptr [bp + 8], ax ; CMP
0606B8  75 0F                 JNE    0x606c9 ; CJUMP
0606BA  56                    PUSH   si ; STACK_PUSH
0606BB  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
0606BE  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
0606C1  9A EC 08 1F 19        LCALL  0x191f, 0x8ec ; THUNK -> 0x0000:0x09E2 (thunk @file 0x01BEDC type A) overlay @file 0x0262E2
0606C6  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0606C9  FF 46 A4              INC    word ptr [bp - 0x5c] ; ARITH
0606CC  8B 46 A4              MOV    ax, word ptr [bp - 0x5c] ; LOCAL_LOAD
0606CF  39 06 A0 53           CMP    word ptr [0x53a0], ax ; CMP
0606D3  7E 1F                 JLE    0x606f4 ; CJUMP
0606D5  50                    PUSH   ax ; STACK_PUSH
0606D6  0E                    PUSH   cs ; STACK_PUSH
0606D7  E8 16 0D              CALL   0x613f0 ; CALL_NEAR
0606DA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0606DD  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0606E1  75 03                 JNE    0x606e6 ; CJUMP
0606E3  E9 7C FF              JMP    0x60662 ; JUMP
0606E6  83 7E 06 02           CMP    word ptr [bp + 6], 2 ; CMP
0606EA  74 03                 JE     0x606ef ; CJUMP
0606EC  E9 67 FF              JMP    0x60656 ; JUMP
0606EF  B0 01                 MOV    al, 1 ; MOV
0606F1  E9 64 FF              JMP    0x60658 ; JUMP
0606F4  83 7E A6 00           CMP    word ptr [bp - 0x5a], 0 ; CMP
0606F8  75 40                 JNE    0x6073a ; CJUMP
0606FA  83 7E 06 02           CMP    word ptr [bp + 6], 2 ; CMP
0606FE  75 06                 JNE    0x60706 ; CJUMP
060700  B8 01 00              MOV    ax, 1 ; MOV
060703  EB 03                 JMP    0x60708 ; JUMP
060705  90                    NOP ; NOP
060706  2B C0                 SUB    ax, ax ; ARITH
060708  C4 1E 14 9E           LES    bx, ptr [0x9e14] ; MOV_FAR
06070C  26 8A 4F 20           MOV    cl, byte ptr es:[bx + 0x20] ; MOV
060710  2A ED                 SUB    ch, ch ; ARITH
060712  3B C1                 CMP    ax, cx ; CMP
060714  75 06                 JNE    0x6071c ; CJUMP
060716  BB 03 00              MOV    bx, 3 ; MOV
060719  EB 04                 JMP    0x6071f ; JUMP
06071B  90                    NOP ; NOP
06071C  BB 04 00              MOV    bx, 4 ; MOV
06071F  D1 E3                 SHL    bx, 1 ; LOGIC
060721  FF B7 DE 93           PUSH   word ptr [bx - 0x6c22] ; PUSH_GLOBAL
060725  6A 00                 PUSH   0 ; STACK_PUSH
060727  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
06072C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06072F  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
060733  8D 06 18 1D           LEA    ax, [0x1d18] ; ADDR
060737  E9 E2 FE              JMP    0x6061c ; JUMP
06073A  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
06073D  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
060740  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
060745  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
060748  0B C0                 OR     ax, ax ; LOGIC
06074A  7E 04                 JLE    0x60750 ; CJUMP
06074C  48                    DEC    ax ; ARITH
06074D  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
060750  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
060753  0B 46 A8              OR     ax, word ptr [bp - 0x58] ; LOGIC
060756  74 0B                 JE     0x60763 ; CJUMP
060758  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
06075B  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
06075E  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
060763  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
060766  5E                    POP    si ; STACK_POP
060767  C9                    LEAVE ; EPILOGUE
060768  CB                    RETF ; RETURN
