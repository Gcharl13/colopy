; ============================================================================
; func_03471E_unknown
; Region   : overlay
; Bytes    : file 0x03471E..0x0349F3  (725 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03471E  C8 D6 00 00           ENTER  0xd6, 0 ; PROLOGUE
034722  56                    PUSH   si ; STACK_PUSH
034723  C7 46 92 01 00        MOV    word ptr [bp - 0x6e], 1 ; LOCAL_STORE
034728  C7 46 8C 14 00        MOV    word ptr [bp - 0x74], 0x14 ; LOCAL_STORE
03472D  2B C0                 SUB    ax, ax ; ARITH
03472F  89 46 90              MOV    word ptr [bp - 0x70], ax ; LOCAL_STORE
034732  89 46 8E              MOV    word ptr [bp - 0x72], ax ; LOCAL_STORE
034735  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
034738  89 86 2E FF           MOV    word ptr [bp - 0xd2], ax ; LOCAL_STORE
03473C  89 86 30 FF           MOV    word ptr [bp - 0xd0], ax ; LOCAL_STORE
034740  EB 30                 JMP    0x34772 ; JUMP
034742  8B 9E 30 FF           MOV    bx, word ptr [bp - 0xd0] ; LOCAL_LOAD
034746  C1 E3 03              SHL    bx, 3 ; LOGIC
034749  83 BF A8 8E 00        CMP    word ptr [bx - 0x7158], 0 ; CMP
03474E  7E 1E                 JLE    0x3476e ; CJUMP
034750  8B 87 A8 8E           MOV    ax, word ptr [bx - 0x7158] ; MOV
034754  8B B6 2E FF           MOV    si, word ptr [bp - 0xd2] ; LOCAL_LOAD
034758  D1 E6                 SHL    si, 1 ; LOGIC
03475A  89 82 54 FF           MOV    word ptr [bp + si - 0xac], ax ; LOCAL_STORE
03475E  8A 86 30 FF           MOV    al, byte ptr [bp - 0xd0] ; LOCAL_LOAD
034762  8B B6 2E FF           MOV    si, word ptr [bp - 0xd2] ; LOCAL_LOAD
034766  88 82 36 FF           MOV    byte ptr [bp + si - 0xca], al ; LOCAL_STORE
03476A  FF 86 2E FF           INC    word ptr [bp - 0xd2] ; ARITH
03476E  FF 86 30 FF           INC    word ptr [bp - 0xd0] ; ARITH
034772  83 BE 30 FF 1C        CMP    word ptr [bp - 0xd0], 0x1c ; CMP
034777  7C C9                 JL     0x34742 ; CJUMP
034779  8D 86 36 FF           LEA    ax, [bp - 0xca] ; ADDR
03477D  16                    PUSH   ss ; STACK_PUSH
03477E  50                    PUSH   ax ; STACK_PUSH
03477F  8D 86 54 FF           LEA    ax, [bp - 0xac] ; ADDR
034783  16                    PUSH   ss ; STACK_PUSH
034784  50                    PUSH   ax ; STACK_PUSH
034785  8B 86 2E FF           MOV    ax, word ptr [bp - 0xd2] ; LOCAL_LOAD
034789  9A D0 0E 1F 19        LCALL  0x191f, 0xed0 ; THUNK -> 0x0CF8:0x000A (thunk @file 0x01C4C0 type B)
03478E  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
034792  8D 06 73 10           LEA    ax, [0x1073] ; ADDR
034796  2B D2                 SUB    dx, dx ; ARITH
034798  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
03479D  89 46 8E              MOV    word ptr [bp - 0x72], ax ; LOCAL_STORE
0347A0  89 56 90              MOV    word ptr [bp - 0x70], dx ; LOCAL_STORE
0347A3  0B D0                 OR     dx, ax ; LOGIC
0347A5  75 03                 JNE    0x347aa ; CJUMP
0347A7  E9 33 02              JMP    0x349dd ; JUMP
0347AA  C4 5E 8E              LES    bx, ptr [bp - 0x72] ; MOV_FAR
0347AD  26 80 4F 0A 01        OR     byte ptr es:[bx + 0xa], 1 ; LOGIC
0347B2  26 C7 47 22 08 00     MOV    word ptr es:[bx + 0x22], 8 ; MOV
0347B8  C7 86 34 FF 00 00     MOV    word ptr [bp - 0xcc], 0 ; LOCAL_STORE
0347BE  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0347C2  75 08                 JNE    0x347cc ; CJUMP
0347C4  6A 01                 PUSH   1 ; STACK_PUSH
0347C6  FF 36 C0 2D           PUSH   word ptr [0x2dc0] ; PUSH_GLOBAL
0347CA  EB 06                 JMP    0x347d2 ; JUMP
0347CC  6A 62                 PUSH   0x62 ; PUSH_CONST
0347CE  FF 36 AA 93           PUSH   word ptr [0x93aa] ; PUSH_GLOBAL
0347D2  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
0347D7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0347DA  52                    PUSH   dx ; STACK_PUSH
0347DB  50                    PUSH   ax ; STACK_PUSH
0347DC  FF 76 90              PUSH   word ptr [bp - 0x70] ; PUSH_GLOBAL
0347DF  FF 76 8E              PUSH   word ptr [bp - 0x72] ; PUSH_GLOBAL
0347E2  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
0347E7  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
0347EA  C7 86 30 FF 00 00     MOV    word ptr [bp - 0xd0], 0 ; LOCAL_STORE
0347F0  E9 03 01              JMP    0x348f6 ; JUMP
0347F3  90                    NOP ; NOP
0347F4  8B B6 30 FF           MOV    si, word ptr [bp - 0xd0] ; LOCAL_LOAD
0347F8  8A 82 36 FF           MOV    al, byte ptr [bp + si - 0xca] ; LOCAL_LOAD
0347FC  2A E4                 SUB    ah, ah ; ARITH
0347FE  89 86 52 FF           MOV    word ptr [bp - 0xae], ax ; LOCAL_STORE
034802  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
034805  F7 6E 8C              IMUL   word ptr [bp - 0x74] ; ARITH
034808  3B 86 34 FF           CMP    ax, word ptr [bp - 0xcc] ; CMP
03480C  7E 03                 JLE    0x34811 ; CJUMP
03480E  E9 DD 00              JMP    0x348ee ; JUMP
034811  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
034814  40                    INC    ax ; ARITH
034815  F7 6E 8C              IMUL   word ptr [bp - 0x74] ; ARITH
034818  3B 86 34 FF           CMP    ax, word ptr [bp - 0xcc] ; CMP
03481C  7F 03                 JG     0x34821 ; CJUMP
03481E  E9 CD 00              JMP    0x348ee ; JUMP
034821  C6 46 AA 00           MOV    byte ptr [bp - 0x56], 0 ; LOCAL_STORE
034825  8B 9E 52 FF           MOV    bx, word ptr [bp - 0xae] ; LOCAL_LOAD
034829  C1 E3 03              SHL    bx, 3 ; LOGIC
03482C  FF B7 A4 8E           PUSH   word ptr [bx - 0x715c] ; PUSH_GLOBAL
034830  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
034833  50                    PUSH   ax ; STACK_PUSH
034834  8B F3                 MOV    si, bx ; MOV
034836  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03483B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03483E  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
034841  50                    PUSH   ax ; STACK_PUSH
034842  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
034847  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03484A  68 7F 10              PUSH   0x107f                       ; STRING: "|   "
03484D  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
034850  50                    PUSH   ax ; STACK_PUSH
034851  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
034856  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
034859  FF 36 D4 2D           PUSH   word ptr [0x2dd4] ; PUSH_GLOBAL
03485D  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
034860  50                    PUSH   ax ; STACK_PUSH
034861  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
034866  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
034869  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
03486C  50                    PUSH   ax ; STACK_PUSH
03486D  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
034872  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
034875  6A 0A                 PUSH   0xa ; PUSH_CONST
034877  8D 46 94              LEA    ax, [bp - 0x6c] ; ADDR
03487A  50                    PUSH   ax ; STACK_PUSH
03487B  8B 8C A8 8E           MOV    cx, word ptr [si - 0x7158] ; MOV
03487F  89 8E 32 FF           MOV    word ptr [bp - 0xce], cx ; LOCAL_STORE
034883  51                    PUSH   cx ; STACK_PUSH
034884  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
034889  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03488C  8D 46 94              LEA    ax, [bp - 0x6c] ; ADDR
03488F  50                    PUSH   ax ; STACK_PUSH
034890  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
034893  50                    PUSH   ax ; STACK_PUSH
034894  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
034899  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03489C  FF 36 D6 2D           PUSH   word ptr [0x2dd6] ; PUSH_GLOBAL
0348A0  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
0348A3  50                    PUSH   ax ; STACK_PUSH
0348A4  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
0348A9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0348AC  8B 86 52 FF           MOV    ax, word ptr [bp - 0xae] ; LOCAL_LOAD
0348B0  40                    INC    ax ; ARITH
0348B1  40                    INC    ax ; ARITH
0348B2  50                    PUSH   ax ; STACK_PUSH
0348B3  8D 4E AA              LEA    cx, [bp - 0x56] ; ADDR
0348B6  16                    PUSH   ss ; STACK_PUSH
0348B7  51                    PUSH   cx ; STACK_PUSH
0348B8  FF 76 90              PUSH   word ptr [bp - 0x70] ; PUSH_GLOBAL
0348BB  FF 76 8E              PUSH   word ptr [bp - 0x72] ; PUSH_GLOBAL
0348BE  8B F0                 MOV    si, ax ; MOV
0348C0  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
0348C5  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
0348C8  8B 86 32 FF           MOV    ax, word ptr [bp - 0xce] ; LOCAL_LOAD
0348CC  99                    CDQ ; ARITH
0348CD  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
0348D1  39 57 2C              CMP    word ptr [bx + 0x2c], dx ; CMP
0348D4  7F 18                 JG     0x348ee ; CJUMP
0348D6  7C 05                 JL     0x348dd ; CJUMP
0348D8  39 47 2A              CMP    word ptr [bx + 0x2a], ax ; CMP
0348DB  73 11                 JAE    0x348ee ; CJUMP
0348DD  6A 01                 PUSH   1 ; STACK_PUSH
0348DF  56                    PUSH   si ; STACK_PUSH
0348E0  FF 76 90              PUSH   word ptr [bp - 0x70] ; PUSH_GLOBAL
0348E3  FF 76 8E              PUSH   word ptr [bp - 0x72] ; PUSH_GLOBAL
0348E6  9A B6 01 1F 19        LCALL  0x191f, 0x1b6 ; THUNK -> 0x0000:0x08FA (thunk @file 0x01B7A6 type A) overlay @file 0x0261FA
0348EB  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0348EE  FF 86 34 FF           INC    word ptr [bp - 0xcc] ; ARITH
0348F2  FF 86 30 FF           INC    word ptr [bp - 0xd0] ; ARITH
0348F6  8B 86 2E FF           MOV    ax, word ptr [bp - 0xd2] ; LOCAL_LOAD
0348FA  39 86 30 FF           CMP    word ptr [bp - 0xd0], ax ; CMP
0348FE  7D 03                 JGE    0x34903 ; CJUMP
034900  E9 F1 FE              JMP    0x347f4 ; JUMP
034903  8B 46 92              MOV    ax, word ptr [bp - 0x6e] ; LOCAL_LOAD
034906  48                    DEC    ax ; ARITH
034907  3B 46 FE              CMP    ax, word ptr [bp - 2] ; CMP
03490A  7E 1E                 JLE    0x3492a ; CJUMP
03490C  6A 63                 PUSH   0x63 ; PUSH_CONST
03490E  FF 36 AA 93           PUSH   word ptr [0x93aa] ; PUSH_GLOBAL
034912  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
034917  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03491A  52                    PUSH   dx ; STACK_PUSH
03491B  50                    PUSH   ax ; STACK_PUSH
03491C  FF 76 90              PUSH   word ptr [bp - 0x70] ; PUSH_GLOBAL
03491F  FF 76 8E              PUSH   word ptr [bp - 0x72] ; PUSH_GLOBAL
034922  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
034927  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
03492A  C7 06 66 1F 01 00     MOV    word ptr [0x1f66], 1 ; GLOBAL_LOAD
034930  FF 76 90              PUSH   word ptr [bp - 0x70] ; PUSH_GLOBAL
034933  FF 76 8E              PUSH   word ptr [bp - 0x72] ; PUSH_GLOBAL
034936  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
03493B  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
03493E  FF 76 90              PUSH   word ptr [bp - 0x70] ; PUSH_GLOBAL
034941  FF 76 8E              PUSH   word ptr [bp - 0x72] ; PUSH_GLOBAL
034944  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
034949  2B C0                 SUB    ax, ax ; ARITH
03494B  89 46 90              MOV    word ptr [bp - 0x70], ax ; LOCAL_STORE
03494E  89 46 8E              MOV    word ptr [bp - 0x72], ax ; LOCAL_STORE
034951  83 7E A8 02           CMP    word ptr [bp - 0x58], 2 ; CMP
034955  7D 03                 JGE    0x3495a ; CJUMP
034957  E9 83 00              JMP    0x349dd ; JUMP
03495A  83 7E A8 62           CMP    word ptr [bp - 0x58], 0x62 ; CMP
03495E  75 03                 JNE    0x34963 ; CJUMP
034960  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
034963  83 7E A8 63           CMP    word ptr [bp - 0x58], 0x63 ; CMP
034967  75 03                 JNE    0x3496c ; CJUMP
034969  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
03496C  39 06 68 1F           CMP    word ptr [0x1f68], ax ; CMP
034970  74 22                 JE     0x34994 ; CJUMP
034972  83 7E A8 62           CMP    word ptr [bp - 0x58], 0x62 ; CMP
034976  74 1C                 JE     0x34994 ; CJUMP
034978  83 7E A8 63           CMP    word ptr [bp - 0x58], 0x63 ; CMP
03497C  74 16                 JE     0x34994 ; CJUMP
03497E  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
034981  48                    DEC    ax ; ARITH
034982  48                    DEC    ax ; ARITH
034983  50                    PUSH   ax ; STACK_PUSH
034984  9A DE 08 1F 19        LCALL  0x191f, 0x8de ; THUNK -> 0x0000:0x1820 (thunk @file 0x01BECE type A) overlay @file 0x027120
034989  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03498C  0E                    PUSH   cs ; STACK_PUSH
03498D  E8 A0 1F              CALL   0x36930 ; CALL_NEAR
034990  E9 FB FD              JMP    0x3478e ; JUMP
034993  90                    NOP ; NOP
034994  83 7E A8 62           CMP    word ptr [bp - 0x58], 0x62 ; CMP
034998  7C 03                 JL     0x3499d ; CJUMP
03499A  E9 F1 FD              JMP    0x3478e ; JUMP
03499D  8B 5E A8              MOV    bx, word ptr [bp - 0x58] ; LOCAL_LOAD
0349A0  4B                    DEC    bx ; ARITH
0349A1  4B                    DEC    bx ; ARITH
0349A2  89 5E FC              MOV    word ptr [bp - 4], bx ; LOCAL_STORE
0349A5  C1 E3 03              SHL    bx, 3 ; LOGIC
0349A8  8B 87 A8 8E           MOV    ax, word ptr [bx - 0x7158] ; MOV
0349AC  89 86 32 FF           MOV    word ptr [bp - 0xce], ax ; LOCAL_STORE
0349B0  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
0349B3  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0349B6  50                    PUSH   ax ; STACK_PUSH
0349B7  0E                    PUSH   cs ; STACK_PUSH
0349B8  E8 76 1E              CALL   0x36831 ; CALL_NEAR
0349BB  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0349BE  89 86 2C FF           MOV    word ptr [bp - 0xd4], ax ; LOCAL_STORE
0349C2  0B C0                 OR     ax, ax ; LOGIC
0349C4  7C 17                 JL     0x349dd ; CJUMP
0349C6  8B 86 32 FF           MOV    ax, word ptr [bp - 0xce] ; LOCAL_LOAD
0349CA  99                    CDQ ; ARITH
0349CB  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
0349CF  29 47 2A              SUB    word ptr [bx + 0x2a], ax ; ARITH
0349D2  19 57 2C              SBB    word ptr [bx + 0x2c], dx ; ARITH
0349D5  0E                    PUSH   cs ; STACK_PUSH
0349D6  E8 99 1E              CALL   0x36872 ; CALL_NEAR
0349D9  0E                    PUSH   cs ; STACK_PUSH
0349DA  E8 4F 1E              CALL   0x3682c ; CALL_NEAR
0349DD  8B 46 90              MOV    ax, word ptr [bp - 0x70] ; LOCAL_LOAD
0349E0  0B 46 8E              OR     ax, word ptr [bp - 0x72] ; LOGIC
0349E3  74 0B                 JE     0x349f0 ; CJUMP
0349E5  FF 76 90              PUSH   word ptr [bp - 0x70] ; PUSH_GLOBAL
0349E8  FF 76 8E              PUSH   word ptr [bp - 0x72] ; PUSH_GLOBAL
0349EB  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
0349F0  5E                    POP    si ; STACK_POP
0349F1  C9                    LEAVE ; EPILOGUE
0349F2  CB                    RETF ; RETURN
