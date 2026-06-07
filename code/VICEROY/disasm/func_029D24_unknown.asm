; ============================================================================
; func_029D24_unknown
; Region   : overlay
; Bytes    : file 0x029D24..0x029DD4  (176 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029D24  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
029D28  56                    PUSH   si ; STACK_PUSH
029D29  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
029D2D  8D 06 B9 0C           LEA    ax, [0xcb9] ; ADDR
029D31  2B D2                 SUB    dx, dx ; ARITH
029D33  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
029D38  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
029D3B  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
029D3E  0B D0                 OR     dx, ax ; LOGIC
029D40  74 78                 JE     0x29dba ; CJUMP
029D42  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
029D47  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
029D4A  40                    INC    ax ; ARITH
029D4B  50                    PUSH   ax ; STACK_PUSH
029D4C  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
029D4F  D1 E3                 SHL    bx, 1 ; LOGIC
029D51  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
029D55  8B F0                 MOV    si, ax ; MOV
029D57  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
029D5C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
029D5F  52                    PUSH   dx ; STACK_PUSH
029D60  50                    PUSH   ax ; STACK_PUSH
029D61  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
029D64  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
029D67  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
029D6C  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
029D6F  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
029D72  9A FE 0C 1F 18        LCALL  0x181f, 0xcfe ; THUNK -> 0x05EB:0x0302 (thunk @file 0x01B2EE type B) overlay @file 0x0272F2
029D77  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
029D7A  8B D0                 MOV    dx, ax ; MOV
029D7C  8B C6                 MOV    ax, si ; MOV
029D7E  9A 62 02 1F 19        LCALL  0x191f, 0x262 ; THUNK -> 0x0000:0x3704 (thunk @file 0x01B852 type A) overlay @file 0x029004
029D83  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
029D86  83 7E FA 10           CMP    word ptr [bp - 6], 0x10 ; CMP
029D8A  7C BB                 JL     0x29d47 ; CJUMP
029D8C  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
029D8F  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
029D92  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
029D97  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
029D9C  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
029D9F  40                    INC    ax ; ARITH
029DA0  9A 06 03 1F 19        LCALL  0x191f, 0x306 ; THUNK -> 0x0000:0x372E (thunk @file 0x01B8F6 type A) overlay @file 0x02902E
029DA5  50                    PUSH   ax ; STACK_PUSH
029DA6  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
029DA9  9A 26 0D 1F 18        LCALL  0x181f, 0xd26 ; THUNK -> 0x05EB:0x0326 (thunk @file 0x01B316 type B) overlay @file 0x027316
029DAE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
029DB1  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
029DB4  83 7E FA 10           CMP    word ptr [bp - 6], 0x10 ; CMP
029DB8  7C E2                 JL     0x29d9c ; CJUMP
029DBA  0E                    PUSH   cs ; STACK_PUSH
029DBB  E8 DD 2C              CALL   0x2ca9b ; CALL_NEAR
029DBE  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
029DC1  0B 46 FC              OR     ax, word ptr [bp - 4] ; LOGIC
029DC4  74 0B                 JE     0x29dd1 ; CJUMP
029DC6  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
029DC9  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
029DCC  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
029DD1  5E                    POP    si ; STACK_POP
029DD2  C9                    LEAVE ; EPILOGUE
029DD3  CB                    RETF ; RETURN
