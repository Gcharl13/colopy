; ============================================================================
; func_070A1A_unknown
; Region   : overlay
; Bytes    : file 0x070A1A..0x070BCE  (436 bytes)
; Purpose  : Nation selection screen  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "NATIONS"  (auto-named via string xrefs)
; ============================================================================

070A1A  C8 14 03 00           ENTER  0x314, 0 ; PROLOGUE
070A1E  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1 ; LOCAL_STORE
070A23  8D 86 EE FC           LEA    ax, [bp - 0x312] ; ADDR
070A27  16                    PUSH   ss ; STACK_PUSH
070A28  50                    PUSH   ax ; STACK_PUSH
070A29  2B C0                 SUB    ax, ax ; ARITH
070A2B  A3 0A A6              MOV    word ptr [0xa60a], ax ; GLOBAL_LOAD
070A2E  50                    PUSH   ax ; STACK_PUSH
070A2F  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
070A33  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
070A37  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
070A3B  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
070A3F  68 43 20              PUSH   0x2043                       ; STRING: "NATIONS"
070A42  9A 4E 04 1F 18        LCALL  0x181f, 0x44e ; THUNK -> 0x0000:0x000E (thunk @file 0x01AA3E type A) overlay @file 0x02590E
070A47  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
070A4A  0B C0                 OR     ax, ax ; LOGIC
070A4C  74 2C                 JE     0x70a7a ; CJUMP
070A4E  C7 06 5C 1F 04 00     MOV    word ptr [0x1f5c], 4 ; GLOBAL_LOAD
070A54  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
070A58  8D 06 4B 20           LEA    ax, [0x204b] ; ADDR
070A5C  2B D2                 SUB    dx, dx ; ARITH
070A5E  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
070A63  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
070A66  0B C0                 OR     ax, ax ; LOGIC
070A68  7F 03                 JG     0x70a6d ; CJUMP
070A6A  E9 BA 01              JMP    0x70c27 ; JUMP
070A6D  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
070A70  FE C8                 DEC    al ; ARITH
070A72  2A E4                 SUB    ah, ah ; ARITH
070A74  A3 98 53              MOV    word ptr [0x5398], ax ; GLOBAL_LOAD
070A77  E9 A8 01              JMP    0x70c22 ; JUMP
070A7A  9A B6 03 1F 18        LCALL  0x181f, 0x3b6 ; THUNK -> 0x0262:0x0012 (thunk @file 0x01A9A6 type B) overlay @file 0x021D42
070A7F  8D 86 EE FC           LEA    ax, [bp - 0x312] ; ADDR
070A83  16                    PUSH   ss ; STACK_PUSH
070A84  50                    PUSH   ax ; STACK_PUSH
070A85  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
070A8A  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
070A8E  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
070A92  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
070A96  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
070A9A  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
070A9E  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
070AA2  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
070AA6  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
070AAA  68 C8 00              PUSH   0xc8 ; PUSH_CONST
070AAD  2B C0                 SUB    ax, ax ; ARITH
070AAF  99                    CDQ ; ARITH
070AB0  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
070AB3  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
070AB8  6A 00                 PUSH   0 ; STACK_PUSH
070ABA  68 40 01              PUSH   0x140 ; PUSH_CONST
070ABD  68 C8 00              PUSH   0xc8 ; PUSH_CONST
070AC0  2B C0                 SUB    ax, ax ; ARITH
070AC2  99                    CDQ ; ARITH
070AC3  2B DB                 SUB    bx, bx ; ARITH
070AC5  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
070ACA  0E                    PUSH   cs ; STACK_PUSH
070ACB  E8 6E 01              CALL   0x70c3c ; CALL_NEAR
070ACE  9A 7A 04 1F 18        LCALL  0x181f, 0x47a ; THUNK -> 0x0ACB:0x0030 (thunk @file 0x01AA6A type B) overlay @file 0x0318D2
070AD3  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1 ; LOCAL_STORE
070AD8  2B C0                 SUB    ax, ax ; ARITH
070ADA  9A 66 04 1F 18        LCALL  0x181f, 0x466 ; THUNK -> 0x0ACB:0x0056 (thunk @file 0x01AA56 type B) overlay @file 0x0318F8
070ADF  A1 0A A6              MOV    ax, word ptr [0xa60a] ; GLOBAL_LOAD
070AE2  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
070AE5  9A F6 00 1F 18        LCALL  0x181f, 0xf6 ; THUNK -> 0x0AE7:0x0002 (thunk @file 0x01A6E6 type B) overlay @file 0x026FF2
070AEA  0B C0                 OR     ax, ax ; LOGIC
070AEC  74 2E                 JE     0x70b1c ; CJUMP
070AEE  9A E0 03 1F 18        LCALL  0x181f, 0x3e0 ; THUNK -> 0x0AE7:0x0016 (thunk @file 0x01A9D0 type B) overlay @file 0x027006
070AF3  89 86 EC FC           MOV    word ptr [bp - 0x314], ax ; LOCAL_STORE
070AF7  3D 20 00              CMP    ax, 0x20 ; CMP
070AFA  74 76                 JE     0x70b72 ; CJUMP
070AFC  7E 03                 JLE    0x70b01 ; CJUMP
070AFE  E9 85 00              JMP    0x70b86 ; JUMP
070B01  3D 1B 00              CMP    ax, 0x1b ; CMP
070B04  75 03                 JNE    0x70b09 ; CJUMP
070B06  E9 1E 01              JMP    0x70c27 ; JUMP
070B09  77 11                 JA     0x70b1c ; CJUMP
070B0B  2C 08                 SUB    al, 8 ; ARITH
070B0D  74 29                 JE     0x70b38 ; CJUMP
070B0F  FE C8                 DEC    al ; ARITH
070B11  74 5F                 JE     0x70b72 ; CJUMP
070B13  2C 04                 SUB    al, 4 ; ARITH
070B15  75 05                 JNE    0x70b1c ; CJUMP
070B17  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
070B1C  83 3E F0 07 00        CMP    word ptr [0x7f0], 0 ; CMP
070B21  75 03                 JNE    0x70b26 ; CJUMP
070B23  E9 E9 00              JMP    0x70c0f ; JUMP
070B26  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
070B2B  75 03                 JNE    0x70b30 ; CJUMP
070B2D  E9 DF 00              JMP    0x70c0f ; JUMP
070B30  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
070B35  EB 68                 JMP    0x70b9f ; JUMP
070B37  90                    NOP ; NOP
070B38  81 BE EC FC 48 01     CMP    word ptr [bp - 0x314], 0x148 ; CMP
070B3E  74 3A                 JE     0x70b7a ; CJUMP
070B40  B8 03 00              MOV    ax, 3 ; MOV
070B43  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
070B46  8B 0E 98 53           MOV    cx, word ptr [0x5398] ; GLOBAL_LOAD
070B4A  89 4E FA              MOV    word ptr [bp - 6], cx ; LOCAL_STORE
070B4D  03 C1                 ADD    ax, cx ; ARITH
070B4F  B9 04 00              MOV    cx, 4 ; MOV
070B52  99                    CDQ ; ARITH
070B53  F7 F9                 IDIV   cx ; ARITH
070B55  2A F6                 SUB    dh, dh ; ARITH
070B57  89 16 98 53           MOV    word ptr [0x5398], dx ; GLOBAL_LOAD
070B5B  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
070B5E  0E                    PUSH   cs ; STACK_PUSH
070B5F  E8 FD 00              CALL   0x70c5f ; CALL_NEAR
070B62  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
070B65  FF 36 98 53           PUSH   word ptr [0x5398] ; PUSH_GLOBAL
070B69  0E                    PUSH   cs ; STACK_PUSH
070B6A  E8 F2 00              CALL   0x70c5f ; CALL_NEAR
070B6D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
070B70  EB AA                 JMP    0x70b1c ; JUMP
070B72  81 BE EC FC 50 01     CMP    word ptr [bp - 0x314], 0x150 ; CMP
070B78  75 06                 JNE    0x70b80 ; CJUMP
070B7A  B8 02 00              MOV    ax, 2 ; MOV
070B7D  EB C4                 JMP    0x70b43 ; JUMP
070B7F  90                    NOP ; NOP
070B80  B8 01 00              MOV    ax, 1 ; MOV
070B83  EB BE                 JMP    0x70b43 ; JUMP
070B85  90                    NOP ; NOP
070B86  2D 48 01              SUB    ax, 0x148 ; ARITH
070B89  74 AD                 JE     0x70b38 ; CJUMP
070B8B  2D 03 00              SUB    ax, 3 ; ARITH
070B8E  74 A8                 JE     0x70b38 ; CJUMP
070B90  48                    DEC    ax ; ARITH
070B91  48                    DEC    ax ; ARITH
070B92  74 DE                 JE     0x70b72 ; CJUMP
070B94  2D 03 00              SUB    ax, 3 ; ARITH
070B97  74 D9                 JE     0x70b72 ; CJUMP
070B99  EB 81                 JMP    0x70b1c ; JUMP
070B9B  90                    NOP ; NOP
070B9C  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
070B9F  83 3E 1E 20 01        CMP    word ptr [0x201e], 1 ; CMP
070BA4  1B C0                 SBB    ax, ax ; ARITH
070BA6  05 05 00              ADD    ax, 5 ; ARITH
070BA9  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
070BAC  7E 4E                 JLE    0x70bfc ; CJUMP
070BAE  8D 46 EE              LEA    ax, [bp - 0x12] ; ADDR
070BB1  50                    PUSH   ax ; STACK_PUSH
070BB2  8D 4E F2              LEA    cx, [bp - 0xe] ; ADDR
070BB5  51                    PUSH   cx ; STACK_PUSH
070BB6  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
070BB9  0E                    PUSH   cs ; STACK_PUSH
070BBA  E8 9D 00              CALL   0x70c5a ; CALL_NEAR
070BBD  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
070BC0  6A 52                 PUSH   0x52 ; PUSH_CONST
070BC2  6A 58                 PUSH   0x58 ; PUSH_CONST
070BC4  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
070BC7  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
070BCA  9A                    DB     0x9A ; DATA_BYTE
070BCB  CA                    DB     0xCA ; DATA_BYTE
070BCC  03                    DB     0x03 ; DATA_BYTE
070BCD  1F                    DB     0x1F ; DATA_BYTE
