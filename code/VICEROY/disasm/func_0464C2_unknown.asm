; ============================================================================
; func_0464C2_unknown
; Region   : overlay
; Bytes    : file 0x0464C2..0x0465EE  (300 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0464C2  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0464C6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0464C9  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
0464CE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0464D1  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
0464D5  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
0464D8  2A E4                 SUB    ah, ah ; ARITH
0464DA  50                    PUSH   ax ; STACK_PUSH
0464DB  8A 07                 MOV    al, byte ptr [bx] ; MOV
0464DD  50                    PUSH   ax ; STACK_PUSH
0464DE  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0464E1  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0464E4  9A 7A 03 1F 18        LCALL  0x181f, 0x37a ; THUNK -> 0x024C:0x007C (thunk @file 0x01A96A type B) overlay @file 0x028802
0464E9  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0464EC  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0464EF  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
0464F3  7D 33                 JGE    0x46528 ; CJUMP
0464F5  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
0464F9  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
0464FE  75 28                 JNE    0x46528 ; CJUMP
046500  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
046503  2A E4                 SUB    ah, ah ; ARITH
046505  05 03 00              ADD    ax, 3 ; ARITH
046508  D1 E0                 SHL    ax, 1 ; LOGIC
04650A  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
04650E  8A 4F 02              MOV    cl, byte ptr [bx + 2] ; MOV
046511  2A ED                 SUB    ch, ch ; ARITH
046513  03 C1                 ADD    ax, cx ; ARITH
046515  8A 4F 05              MOV    cl, byte ptr [bx + 5] ; MOV
046518  03 C1                 ADD    ax, cx ; ARITH
04651A  2B 46 FC              SUB    ax, word ptr [bp - 4] ; ARITH
04651D  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
046520  C7 46 FA 41 00        MOV    word ptr [bp - 6], 0x41 ; LOCAL_STORE
046525  EB 25                 JMP    0x4654c ; JUMP
046527  90                    NOP ; NOP
046528  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
04652C  8A 47 02              MOV    al, byte ptr [bx + 2] ; MOV
04652F  2A E4                 SUB    ah, ah ; ARITH
046531  8A 4F 05              MOV    cl, byte ptr [bx + 5] ; MOV
046534  2A ED                 SUB    ch, ch ; ARITH
046536  03 C1                 ADD    ax, cx ; ARITH
046538  8A 0E A6 53           MOV    cl, byte ptr [0x53a6] ; GLOBAL_LOAD
04653C  2B C1                 SUB    ax, cx ; ARITH
04653E  2B 46 FC              SUB    ax, word ptr [bp - 4] ; ARITH
046541  05 0C 00              ADD    ax, 0xc ; ARITH
046544  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
046547  C7 46 FA 32 00        MOV    word ptr [bp - 6], 0x32 ; LOCAL_STORE
04654C  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
04654F  8A 87 10 94           MOV    al, byte ptr [bx - 0x6bf0] ; MOV
046553  2A E4                 SUB    ah, ah ; ARITH
046555  2D 0A 00              SUB    ax, 0xa ; ARITH
046558  F7 D8                 NEG    ax ; ARITH
04655A  D1 F8                 SAR    ax, 1 ; LOGIC
04655C  0B C0                 OR     ax, ax ; LOGIC
04655E  7D 02                 JGE    0x46562 ; CJUMP
046560  2B C0                 SUB    ax, ax ; ARITH
046562  29 46 FE              SUB    word ptr [bp - 2], ax ; ARITH
046565  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
046568  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04656B  9A 18 07 1F 18        LCALL  0x181f, 0x718 ; THUNK -> 0x037F:0x04B0 (thunk @file 0x01AD08 type B) overlay @file 0x02EFEC
046570  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
046573  40                    INC    ax ; ARITH
046574  74 03                 JE     0x46579 ; CJUMP
046576  D1 66 FE              SHL    word ptr [bp - 2], 1 ; LOGIC
046579  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
04657C  3D 01 00              CMP    ax, 1 ; CMP
04657F  7D 03                 JGE    0x46584 ; CJUMP
046581  B8 01 00              MOV    ax, 1 ; MOV
046584  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
046587  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
04658A  F7 6E FE              IMUL   word ptr [bp - 2] ; ARITH
04658D  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
046590  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
046594  7D 2B                 JGE    0x465c1 ; CJUMP
046596  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
04659A  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
04659F  75 20                 JNE    0x465c1 ; CJUMP
0465A1  FF 36 94 53           PUSH   word ptr [0x5394] ; PUSH_GLOBAL
0465A5  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
0465A9  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
0465AE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0465B1  50                    PUSH   ax ; STACK_PUSH
0465B2  9A 60 0A 1F 18        LCALL  0x181f, 0xa60 ; THUNK -> 0x05DC:0x00A2 (thunk @file 0x01B050 type B) overlay @file 0x021A84
0465B7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0465BA  40                    INC    ax ; ARITH
0465BB  F7 6E FE              IMUL   word ptr [bp - 2] ; ARITH
0465BE  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0465C1  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
0465C5  F6 47 03 04           TEST   byte ptr [bx + 3], 4 ; LOGIC
0465C9  74 05                 JE     0x465d0 ; CJUMP
0465CB  D1 F8                 SAR    ax, 1 ; LOGIC
0465CD  01 46 FE              ADD    word ptr [bp - 2], ax ; ARITH
0465D0  6A 02                 PUSH   2 ; STACK_PUSH
0465D2  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0465D5  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
0465DA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0465DD  0B C0                 OR     ax, ax ; LOGIC
0465DF  74 05                 JE     0x465e6 ; CJUMP
0465E1  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0465E6  D1 7E FE              SAR    word ptr [bp - 2], 1 ; LOGIC
0465E9  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0465EC  C9                    LEAVE ; EPILOGUE
0465ED  CB                    RETF ; RETURN
