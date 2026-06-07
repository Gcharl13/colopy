; ============================================================================
; func_028D8C_unknown
; Region   : overlay
; Bytes    : file 0x028D8C..0x028E45  (185 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028D8C  C8 48 01 00           ENTER  0x148, 0 ; PROLOGUE
028D90  56                    PUSH   si ; STACK_PUSH
028D91  2B C0                 SUB    ax, ax ; ARITH
028D93  89 86 D4 FE           MOV    word ptr [bp - 0x12c], ax ; LOCAL_STORE
028D97  89 86 14 FF           MOV    word ptr [bp - 0xec], ax ; LOCAL_STORE
028D9B  89 86 0E FF           MOV    word ptr [bp - 0xf2], ax ; LOCAL_STORE
028D9F  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
028DA3  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
028DA6  8B C8                 MOV    cx, ax ; MOV
028DA8  98                    CWDE ; ARITH
028DA9  3B 06 7C 8D           CMP    ax, word ptr [0x8d7c] ; CMP
028DAD  7F 0F                 JG     0x28dbe ; CJUMP
028DAF  80 F9 20              CMP    cl, 0x20 ; CMP
028DB2  7C 0A                 JL     0x28dbe ; CJUMP
028DB4  B8 01 00              MOV    ax, 1 ; MOV
028DB7  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
028DBA  89 86 D4 FE           MOV    word ptr [bp - 0x12c], ax ; LOCAL_STORE
028DBE  C7 86 38 FF 01 00     MOV    word ptr [bp - 0xc8], 1 ; LOCAL_STORE
028DC4  FF 36 7C 8D           PUSH   word ptr [0x8d7c] ; PUSH_GLOBAL
028DC8  9A 54 0C 1F 18        LCALL  0x181f, 0xc54 ; THUNK -> 0x05EB:0x0E52 (thunk @file 0x01B244 type B) overlay @file 0x027E42
028DCD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
028DD0  50                    PUSH   ax ; STACK_PUSH
028DD1  9A 9A 0C 1F 18        LCALL  0x181f, 0xc9a ; THUNK -> 0x05EB:0x0002 (thunk @file 0x01B28A type B) overlay @file 0x026FF2
028DD6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
028DD9  0B C0                 OR     ax, ax ; LOGIC
028DDB  75 04                 JNE    0x28de1 ; CJUMP
028DDD  89 86 38 FF           MOV    word ptr [bp - 0xc8], ax ; LOCAL_STORE
028DE1  C7 06 34 03 00 00     MOV    word ptr [0x334], 0 ; GLOBAL_LOAD
028DE7  0E                    PUSH   cs ; STACK_PUSH
028DE8  E8 4C 3C              CALL   0x2ca37 ; CALL_NEAR
028DEB  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
028DEF  74 0F                 JE     0x28e00 ; CJUMP
028DF1  C7 86 08 FF 13 00     MOV    word ptr [bp - 0xf8], 0x13 ; LOCAL_STORE
028DF7  C7 86 BC FE 06 00     MOV    word ptr [bp - 0x144], 6 ; LOCAL_STORE
028DFD  EB 0D                 JMP    0x28e0c ; JUMP
028DFF  90                    NOP ; NOP
028E00  C7 86 08 FF 00 00     MOV    word ptr [bp - 0xf8], 0 ; LOCAL_STORE
028E06  C7 86 BC FE 19 00     MOV    word ptr [bp - 0x144], 0x19 ; LOCAL_STORE
028E0C  FF 36 7C 8D           PUSH   word ptr [0x8d7c] ; PUSH_GLOBAL
028E10  9A 0E 0C 1F 18        LCALL  0x181f, 0xc0e ; THUNK -> 0x05EB:0x0E18 (thunk @file 0x01B1FE type B) overlay @file 0x027E08
028E15  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
028E18  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
028E1B  3D 12 00              CMP    ax, 0x12 ; CMP
028E1E  75 06                 JNE    0x28e26 ; CJUMP
028E20  B8 01 00              MOV    ax, 1 ; MOV
028E23  EB 03                 JMP    0x28e28 ; JUMP
028E25  90                    NOP ; NOP
028E26  2B C0                 SUB    ax, ax ; ARITH
028E28  89 86 12 FF           MOV    word ptr [bp - 0xee], ax ; LOCAL_STORE
028E2C  6A 20                 PUSH   0x20 ; PUSH_CONST
028E2E  6A 00                 PUSH   0 ; STACK_PUSH
028E30  8D 86 6C FF           LEA    ax, [bp - 0x94] ; ADDR
028E34  50                    PUSH   ax ; STACK_PUSH
028E35  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae ; LCALL
028E3A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
028E3D  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
028E40  8D 86 C2 FE           LEA    ax, [bp - 0x13e] ; ADDR
028E44  50                    PUSH   ax ; STACK_PUSH
