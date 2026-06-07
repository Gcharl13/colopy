; ============================================================================
; func_06A700_unknown
; Region   : overlay
; Bytes    : file 0x06A700..0x06A932  (562 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06A700  C8 6A 00 00           ENTER  0x6a, 0 ; PROLOGUE
06A704  56                    PUSH   si ; STACK_PUSH
06A705  0E                    PUSH   cs ; STACK_PUSH
06A706  E8 89 0F              CALL   0x6b692 ; CALL_NEAR
06A709  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
06A70C  2A E4                 SUB    ah, ah ; ARITH
06A70E  50                    PUSH   ax ; STACK_PUSH
06A70F  6A 05                 PUSH   5 ; STACK_PUSH
06A711  68 40 01              PUSH   0x140 ; PUSH_CONST
06A714  2B C0                 SUB    ax, ax ; ARITH
06A716  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
06A719  50                    PUSH   ax ; STACK_PUSH
06A71A  FF 36 92 2E           PUSH   word ptr [0x2e92] ; PUSH_GLOBAL
06A71E  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
06A723  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06A726  52                    PUSH   dx ; STACK_PUSH
06A727  50                    PUSH   ax ; STACK_PUSH
06A728  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
06A72D  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
06A730  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
06A734  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
06A737  2A E4                 SUB    ah, ah ; ARITH
06A739  05 07 00              ADD    ax, 7 ; ARITH
06A73C  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
06A73F  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0 ; LOCAL_STORE
06A743  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
06A746  50                    PUSH   ax ; STACK_PUSH
06A747  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
06A74C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06A74F  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
06A752  C1 E3 03              SHL    bx, 3 ; LOGIC
06A755  FF B7 A2 8E           PUSH   word ptr [bx - 0x715e] ; PUSH_GLOBAL
06A759  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
06A75C  50                    PUSH   ax ; STACK_PUSH
06A75D  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
06A762  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06A765  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
06A768  50                    PUSH   ax ; STACK_PUSH
06A769  9A BE 01 1F 18        LCALL  0x181f, 0x1be ; THUNK -> 0x004B:0x0042 (thunk @file 0x01A7AE type B) overlay @file 0x0603EA
06A76E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06A771  6A 03                 PUSH   3 ; STACK_PUSH
06A773  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
06A776  50                    PUSH   ax ; STACK_PUSH
06A777  0E                    PUSH   cs ; STACK_PUSH
06A778  E8 03 0F              CALL   0x6b67e ; CALL_NEAR
06A77B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06A77E  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
06A781  50                    PUSH   ax ; STACK_PUSH
06A782  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
06A787  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06A78A  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
06A78D  2A E4                 SUB    ah, ah ; ARITH
06A78F  50                    PUSH   ax ; STACK_PUSH
06A790  FF 76 A6              PUSH   word ptr [bp - 0x5a] ; PUSH_GLOBAL
06A793  68 40 01              PUSH   0x140 ; PUSH_CONST
06A796  6A 00                 PUSH   0 ; STACK_PUSH
06A798  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
06A79B  16                    PUSH   ss ; STACK_PUSH
06A79C  50                    PUSH   ax ; STACK_PUSH
06A79D  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
06A7A2  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
06A7A5  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
06A7A9  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
06A7AC  2A E4                 SUB    ah, ah ; ARITH
06A7AE  40                    INC    ax ; ARITH
06A7AF  40                    INC    ax ; ARITH
06A7B0  01 46 A6              ADD    word ptr [bp - 0x5a], ax ; ARITH
06A7B3  FF 46 A6              INC    word ptr [bp - 0x5a] ; ARITH
06A7B6  C7 46 A8 0A 00        MOV    word ptr [bp - 0x58], 0xa ; LOCAL_STORE
06A7BB  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06A7BE  9A 00 0B 1F 18        LCALL  0x181f, 0xb00 ; THUNK -> 0x05EB:0x0AEC (thunk @file 0x01B0F0 type B) overlay @file 0x027ADC
06A7C3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06A7C6  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06A7C9  0B C0                 OR     ax, ax ; LOGIC
06A7CB  7D 04                 JGE    0x6a7d1 ; CJUMP
06A7CD  83 46 A6 0B           ADD    word ptr [bp - 0x5a], 0xb ; ARITH
06A7D1  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
06A7D4  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
06A7D7  2B C0                 SUB    ax, ax ; ARITH
06A7D9  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
06A7DC  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
06A7DF  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
06A7E2  7C 24                 JL     0x6a808 ; CJUMP
06A7E4  C7 46 A4 01 00        MOV    word ptr [bp - 0x5c], 1 ; LOCAL_STORE
06A7E9  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
06A7EC  8B C6                 MOV    ax, si ; MOV
06A7EE  D1 E6                 SHL    si, 1 ; LOGIC
06A7F0  03 F0                 ADD    si, ax ; ARITH
06A7F2  C1 E6 02              SHL    si, 2 ; LOGIC
06A7F5  C4 1E 42 08           LES    bx, ptr [0x842] ; MOV_FAR
06A7F9  26 8B 40 4C           MOV    ax, word ptr es:[bx + si + 0x4c] ; MOV
06A7FD  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
06A800  D1 F8                 SAR    ax, 1 ; LOGIC
06A802  2D 07 00              SUB    ax, 7 ; ARITH
06A805  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
06A808  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06A80B  05 52 00              ADD    ax, 0x52 ; ARITH
06A80E  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
06A811  83 7E 06 1B           CMP    word ptr [bp + 6], 0x1b ; CMP
06A815  75 05                 JNE    0x6a81c ; CJUMP
06A817  C7 46 A0 43 00        MOV    word ptr [bp - 0x60], 0x43 ; LOCAL_STORE
06A81C  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
06A820  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
06A824  8B 46 96              MOV    ax, word ptr [bp - 0x6a] ; LOCAL_LOAD
06A827  03 46 A6              ADD    ax, word ptr [bp - 0x5a] ; ARITH
06A82A  50                    PUSH   ax ; STACK_PUSH
06A82B  8B F0                 MOV    si, ax ; MOV
06A82D  8B 46 A0              MOV    ax, word ptr [bp - 0x60] ; LOCAL_LOAD
06A830  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06A834  8B 56 98              MOV    dx, word ptr [bp - 0x68] ; LOCAL_LOAD
06A837  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06A83C  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0 ; LOCAL_STORE
06A840  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
06A843  C1 E3 03              SHL    bx, 3 ; LOGIC
06A846  FF B7 A4 8E           PUSH   word ptr [bx - 0x715c] ; PUSH_GLOBAL
06A84A  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
06A84D  50                    PUSH   ax ; STACK_PUSH
06A84E  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
06A853  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06A856  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
06A859  2A E4                 SUB    ah, ah ; ARITH
06A85B  50                    PUSH   ax ; STACK_PUSH
06A85C  8D 44 06              LEA    ax, [si + 6] ; ADDR
06A85F  50                    PUSH   ax ; STACK_PUSH
06A860  83 46 98 0E           ADD    word ptr [bp - 0x68], 0xe ; ARITH
06A864  FF 76 98              PUSH   word ptr [bp - 0x68] ; PUSH_GLOBAL
06A867  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
06A86A  16                    PUSH   ss ; STACK_PUSH
06A86B  50                    PUSH   ax ; STACK_PUSH
06A86C  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
06A871  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
06A874  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
06A877  83 46 98 18           ADD    word ptr [bp - 0x68], 0x18 ; ARITH
06A87B  8B 46 98              MOV    ax, word ptr [bp - 0x68] ; LOCAL_LOAD
06A87E  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
06A881  8B 4E A6              MOV    cx, word ptr [bp - 0x5a] ; LOCAL_LOAD
06A884  89 4E 9E              MOV    word ptr [bp - 0x62], cx ; LOCAL_STORE
06A887  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06A88A  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
06A88E  7D 03                 JGE    0x6a893 ; CJUMP
06A890  E9 AE 00              JMP    0x6a941 ; JUMP
06A893  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
06A898  E9 A6 00              JMP    0x6a941 ; JUMP
06A89B  90                    NOP ; NOP
06A89C  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
06A89F  8B C6                 MOV    ax, si ; MOV
06A8A1  D1 E6                 SHL    si, 1 ; LOGIC
06A8A3  03 F0                 ADD    si, ax ; ARITH
06A8A5  C1 E6 02              SHL    si, 2 ; LOGIC
06A8A8  C4 1E 42 08           LES    bx, ptr [0x842] ; MOV_FAR
06A8AC  26 8B 40 4C           MOV    ax, word ptr es:[bx + si + 0x4c] ; MOV
06A8B0  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
06A8B3  D1 F8                 SAR    ax, 1 ; LOGIC
06A8B5  2D 07 00              SUB    ax, 7 ; ARITH
06A8B8  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
06A8BB  06                    PUSH   es ; STACK_PUSH
06A8BC  53                    PUSH   bx ; STACK_PUSH
06A8BD  FF 76 A6              PUSH   word ptr [bp - 0x5a] ; PUSH_GLOBAL
06A8C0  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
06A8C3  40                    INC    ax ; ARITH
06A8C4  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06A8C8  8B 56 A2              MOV    dx, word ptr [bp - 0x5e] ; LOCAL_LOAD
06A8CB  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06A8D0  C4 1E 42 08           LES    bx, ptr [0x842] ; MOV_FAR
06A8D4  26 8B 40 4A           MOV    ax, word ptr es:[bx + si + 0x4a] ; MOV
06A8D8  03 46 A2              ADD    ax, word ptr [bp - 0x5e] ; ARITH
06A8DB  05 03 00              ADD    ax, 3 ; ARITH
06A8DE  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
06A8E1  C6 46 AC 00           MOV    byte ptr [bp - 0x54], 0 ; LOCAL_STORE
06A8E5  FF B4 82 8F           PUSH   word ptr [si - 0x707e] ; PUSH_GLOBAL
06A8E9  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
06A8EC  50                    PUSH   ax ; STACK_PUSH
06A8ED  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
06A8F2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06A8F5  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
06A8F8  2A E4                 SUB    ah, ah ; ARITH
06A8FA  50                    PUSH   ax ; STACK_PUSH
06A8FB  8B 46 96              MOV    ax, word ptr [bp - 0x6a] ; LOCAL_LOAD
06A8FE  03 46 A6              ADD    ax, word ptr [bp - 0x5a] ; ARITH
06A901  05 06 00              ADD    ax, 6 ; ARITH
06A904  50                    PUSH   ax ; STACK_PUSH
06A905  FF 76 98              PUSH   word ptr [bp - 0x68] ; PUSH_GLOBAL
06A908  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
06A90B  16                    PUSH   ss ; STACK_PUSH
06A90C  50                    PUSH   ax ; STACK_PUSH
06A90D  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
06A912  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
06A915  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
06A918  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
06A91C  7D 06                 JGE    0x6a924 ; CJUMP
06A91E  05 18 00              ADD    ax, 0x18 ; ARITH
06A921  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06A924  8B 46 9A              MOV    ax, word ptr [bp - 0x66] ; LOCAL_LOAD
06A927  05 04 00              ADD    ax, 4 ; ARITH
06A92A  01 46 A6              ADD    word ptr [bp - 0x5a], ax ; ARITH
06A92D  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
06A930  8B C3                 MOV    ax, bx ; MOV
