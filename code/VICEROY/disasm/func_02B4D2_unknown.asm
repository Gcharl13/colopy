; ============================================================================
; func_02B4D2_unknown
; Region   : overlay
; Bytes    : file 0x02B4D2..0x02B6D7  (517 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B4D2  C8 1E 00 00           ENTER  0x1e, 0 ; PROLOGUE
02B4D6  B8 01 00              MOV    ax, 1 ; MOV
02B4D9  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
02B4DC  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
02B4DF  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
02B4E4  2B C0                 SUB    ax, ax ; ARITH
02B4E6  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
02B4E9  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
02B4EC  9A E2 0A 1F 18        LCALL  0x181f, 0xae2 ; THUNK -> 0x05EB:0x38BA (thunk @file 0x01B0D2 type B) overlay @file 0x02A8AA
02B4F1  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
02B4F4  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
02B4F7  8B 0E 9E 08           MOV    cx, word ptr [0x89e] ; GLOBAL_LOAD
02B4FB  8B 16 A0 08           MOV    dx, word ptr [0x8a0] ; GLOBAL_LOAD
02B4FF  89 4E E8              MOV    word ptr [bp - 0x18], cx ; LOCAL_STORE
02B502  89 56 EA              MOV    word ptr [bp - 0x16], dx ; LOCAL_STORE
02B505  3D 0E 00              CMP    ax, 0xe ; CMP
02B508  7E 0F                 JLE    0x2b519 ; CJUMP
02B50A  3D 16 00              CMP    ax, 0x16 ; CMP
02B50D  7E 0A                 JLE    0x2b519 ; CJUMP
02B50F  C7 46 F8 02 00        MOV    word ptr [bp - 8], 2 ; LOCAL_STORE
02B514  C7 46 EC 10 00        MOV    word ptr [bp - 0x14], 0x10 ; LOCAL_STORE
02B519  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
02B51E  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
02B521  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
02B524  68 00 08              PUSH   0x800 ; PUSH_CONST
02B527  9A 3C 02 1F 19        LCALL  0x191f, 0x23c ; THUNK -> 0x0000:0x06D0 (thunk @file 0x01B82C type A) overlay @file 0x025FD0
02B52C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02B52F  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
02B532  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
02B535  0B D0                 OR     dx, ax ; LOGIC
02B537  75 03                 JNE    0x2b53c ; CJUMP
02B539  E9 EE 01              JMP    0x2b72a ; JUMP
02B53C  C4 5E F4              LES    bx, ptr [bp - 0xc] ; MOV_FAR
02B53F  26 80 4F 0A 01        OR     byte ptr es:[bx + 0xa], 1 ; LOGIC
02B544  FF 36 A6 93           PUSH   word ptr [0x93a6] ; PUSH_GLOBAL
02B548  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
02B54D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02B550  52                    PUSH   dx ; STACK_PUSH
02B551  50                    PUSH   ax ; STACK_PUSH
02B552  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B555  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B558  9A C6 08 1F 19        LCALL  0x191f, 0x8c6 ; THUNK -> 0x0000:0x0C32 (thunk @file 0x01BEB6 type A) overlay @file 0x026532
02B55D  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
02B560  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
02B564  7E 1E                 JLE    0x2b584 ; CJUMP
02B566  6A 62                 PUSH   0x62 ; PUSH_CONST
02B568  FF 36 AA 93           PUSH   word ptr [0x93aa] ; PUSH_GLOBAL
02B56C  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
02B571  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02B574  52                    PUSH   dx ; STACK_PUSH
02B575  50                    PUSH   ax ; STACK_PUSH
02B576  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B579  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B57C  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
02B581  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
02B584  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
02B587  F7 6E FE              IMUL   word ptr [bp - 2] ; ARITH
02B58A  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
02B58D  C7 46 E6 00 00        MOV    word ptr [bp - 0x1a], 0 ; LOCAL_STORE
02B592  EB 5F                 JMP    0x2b5f3 ; JUMP
02B594  03 46 E4              ADD    ax, word ptr [bp - 0x1c] ; ARITH
02B597  50                    PUSH   ax ; STACK_PUSH
02B598  9A 64 0B 1F 18        LCALL  0x181f, 0xb64 ; THUNK -> 0x05EB:0x38E8 (thunk @file 0x01B154 type B) overlay @file 0x02A8D8
02B59D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02B5A0  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
02B5A3  3D FF FF              CMP    ax, 0xffff ; CMP
02B5A6  7C 48                 JL     0x2b5f0 ; CJUMP
02B5A8  50                    PUSH   ax ; STACK_PUSH
02B5A9  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B5AC  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B5AF  0E                    PUSH   cs ; STACK_PUSH
02B5B0  E8 7F 14              CALL   0x2ca32 ; CALL_NEAR
02B5B3  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02B5B6  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02B5BA  8A 87 94 00           MOV    al, byte ptr [bx + 0x94] ; MOV
02B5BE  98                    CWDE ; ARITH
02B5BF  3B 46 E2              CMP    ax, word ptr [bp - 0x1e] ; CMP
02B5C2  75 2C                 JNE    0x2b5f0 ; CJUMP
02B5C4  40                    INC    ax ; ARITH
02B5C5  40                    INC    ax ; ARITH
02B5C6  50                    PUSH   ax ; STACK_PUSH
02B5C7  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B5CA  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B5CD  9A EC 08 1F 19        LCALL  0x191f, 0x8ec ; THUNK -> 0x0000:0x09E2 (thunk @file 0x01BEDC type A) overlay @file 0x0262E2
02B5D2  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02B5D5  6A 01                 PUSH   1 ; STACK_PUSH
02B5D7  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
02B5DA  40                    INC    ax ; ARITH
02B5DB  40                    INC    ax ; ARITH
02B5DC  50                    PUSH   ax ; STACK_PUSH
02B5DD  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B5E0  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B5E3  9A 3C 03 1F 19        LCALL  0x191f, 0x33c ; THUNK -> 0x0000:0x092A (thunk @file 0x01B92C type A) overlay @file 0x02622A
02B5E8  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
02B5EB  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
02B5F0  FF 46 E6              INC    word ptr [bp - 0x1a] ; ARITH
02B5F3  8B 46 E6              MOV    ax, word ptr [bp - 0x1a] ; LOCAL_LOAD
02B5F6  39 46 EC              CMP    word ptr [bp - 0x14], ax ; CMP
02B5F9  7F 99                 JG     0x2b594 ; CJUMP
02B5FB  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
02B5FE  48                    DEC    ax ; ARITH
02B5FF  3B 46 FE              CMP    ax, word ptr [bp - 2] ; CMP
02B602  7E 4B                 JLE    0x2b64f ; CJUMP
02B604  6A 63                 PUSH   0x63 ; PUSH_CONST
02B606  FF 36 AA 93           PUSH   word ptr [0x93aa] ; PUSH_GLOBAL
02B60A  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
02B60F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02B612  52                    PUSH   dx ; STACK_PUSH
02B613  50                    PUSH   ax ; STACK_PUSH
02B614  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B617  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B61A  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
02B61F  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
02B622  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
02B626  75 27                 JNE    0x2b64f ; CJUMP
02B628  6A 65                 PUSH   0x65 ; PUSH_CONST
02B62A  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B62D  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B630  9A EC 08 1F 19        LCALL  0x191f, 0x8ec ; THUNK -> 0x0000:0x09E2 (thunk @file 0x01BEDC type A) overlay @file 0x0262E2
02B635  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02B638  6A 01                 PUSH   1 ; STACK_PUSH
02B63A  6A 65                 PUSH   0x65 ; PUSH_CONST
02B63C  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B63F  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B642  9A 3C 03 1F 19        LCALL  0x191f, 0x33c ; THUNK -> 0x0000:0x092A (thunk @file 0x01B92C type A) overlay @file 0x02622A
02B647  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
02B64A  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
02B64F  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
02B653  75 28                 JNE    0x2b67d ; CJUMP
02B655  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
02B659  74 22                 JE     0x2b67d ; CJUMP
02B65B  6A 64                 PUSH   0x64 ; PUSH_CONST
02B65D  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B660  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B663  9A EC 08 1F 19        LCALL  0x191f, 0x8ec ; THUNK -> 0x0000:0x09E2 (thunk @file 0x01BEDC type A) overlay @file 0x0262E2
02B668  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02B66B  6A 01                 PUSH   1 ; STACK_PUSH
02B66D  6A 64                 PUSH   0x64 ; PUSH_CONST
02B66F  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B672  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B675  9A 3C 03 1F 19        LCALL  0x191f, 0x33c ; THUNK -> 0x0000:0x092A (thunk @file 0x01B92C type A) overlay @file 0x02622A
02B67A  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
02B67D  C7 06 66 1F 01 00     MOV    word ptr [0x1f66], 1 ; GLOBAL_LOAD
02B683  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B686  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B689  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
02B68E  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02B691  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
02B694  0B 46 F4              OR     ax, word ptr [bp - 0xc] ; LOGIC
02B697  74 0B                 JE     0x2b6a4 ; CJUMP
02B699  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
02B69C  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
02B69F  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
02B6A4  2B C0                 SUB    ax, ax ; ARITH
02B6A6  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
02B6A9  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
02B6AC  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
02B6AF  2D 62 00              SUB    ax, 0x62 ; ARITH
02B6B2  74 38                 JE     0x2b6ec ; CJUMP
02B6B4  48                    DEC    ax ; ARITH
02B6B5  74 3B                 JE     0x2b6f2 ; CJUMP
02B6B7  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
02B6BC  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
02B6C0  7E 5F                 JLE    0x2b721 ; CJUMP
02B6C2  83 3E 68 1F 00        CMP    word ptr [0x1f68], 0 ; CMP
02B6C7  74 47                 JE     0x2b710 ; CJUMP
02B6C9  8D 46 E2              LEA    ax, [bp - 0x1e] ; ADDR
02B6CC  50                    PUSH   ax ; STACK_PUSH
02B6CD  8B 4E FC              MOV    cx, word ptr [bp - 4] ; LOCAL_LOAD
02B6D0  49                    DEC    cx ; ARITH
02B6D1  49                    DEC    cx ; ARITH
02B6D2  51                    PUSH   cx ; STACK_PUSH
02B6D3  9A                    DB     0x9A ; DATA_BYTE
02B6D4  C2                    DB     0xC2 ; DATA_BYTE
02B6D5  0C                    DB     0x0C ; DATA_BYTE
02B6D6  1F                    DB     0x1F ; DATA_BYTE
