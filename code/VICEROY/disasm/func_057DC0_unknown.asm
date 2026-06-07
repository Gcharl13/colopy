; ============================================================================
; func_057DC0_unknown
; Region   : overlay
; Bytes    : file 0x057DC0..0x057ED7  (279 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "SIGNTREATY"  (auto-named via string xrefs)
; ============================================================================

057DC0  55                    PUSH   bp ; STACK_PUSH
057DC1  8B EC                 MOV    bp, sp ; MOV
057DC3  56                    PUSH   si ; STACK_PUSH
057DC4  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
057DC9  74 03                 JE     0x57dce ; CJUMP
057DCB  E9 7C 01              JMP    0x57f4a ; JUMP
057DCE  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
057DD1  03 06 8E 53           ADD    ax, word ptr [0x538e] ; ARITH
057DD5  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
057DD8  B9 03 00              MOV    cx, 3 ; MOV
057DDB  99                    CDQ ; ARITH
057DDC  F7 F9                 IDIV   cx ; ARITH
057DDE  0B D2                 OR     dx, dx ; LOGIC
057DE0  74 15                 JE     0x57df7 ; CJUMP
057DE2  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057DE5  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057DE8  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
057DED  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057DF0  A8 20                 TEST   al, 0x20 ; LOGIC
057DF2  74 03                 JE     0x57df7 ; CJUMP
057DF4  E9 53 01              JMP    0x57f4a ; JUMP
057DF7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057DFA  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057DFD  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
057E02  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057E05  A8 02                 TEST   al, 2 ; LOGIC
057E07  74 03                 JE     0x57e0c ; CJUMP
057E09  E9 3E 01              JMP    0x57f4a ; JUMP
057E0C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057E0F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057E12  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
057E17  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057E1A  A8 02                 TEST   al, 2 ; LOGIC
057E1C  74 03                 JE     0x57e21 ; CJUMP
057E1E  E9 29 01              JMP    0x57f4a ; JUMP
057E21  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057E24  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
057E29  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
057E2C  50                    PUSH   ax ; STACK_PUSH
057E2D  6A 00                 PUSH   0 ; STACK_PUSH
057E2F  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
057E34  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057E37  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057E3A  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
057E3F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
057E42  50                    PUSH   ax ; STACK_PUSH
057E43  6A 01                 PUSH   1 ; STACK_PUSH
057E45  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
057E4A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057E4D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057E50  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057E53  0E                    PUSH   cs ; STACK_PUSH
057E54  E8 B1 23              CALL   0x5a208 ; CALL_NEAR
057E57  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057E5A  0B C0                 OR     ax, ax ; LOGIC
057E5C  75 7A                 JNE    0x57ed8 ; CJUMP
057E5E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057E61  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057E64  0E                    PUSH   cs ; STACK_PUSH
057E65  E8 A0 23              CALL   0x5a208 ; CALL_NEAR
057E68  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057E6B  0B C0                 OR     ax, ax ; LOGIC
057E6D  75 69                 JNE    0x57ed8 ; CJUMP
057E6F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057E72  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057E75  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
057E7A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057E7D  A8 40                 TEST   al, 0x40 ; LOGIC
057E7F  74 03                 JE     0x57e84 ; CJUMP
057E81  E9 C6 00              JMP    0x57f4a ; JUMP
057E84  6A 02                 PUSH   2 ; STACK_PUSH
057E86  68 8D 18              PUSH   0x188d                       ; STRING: "SIGNTREATY"
057E89  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
057E8E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057E91  6A 40                 PUSH   0x40 ; PUSH_CONST
057E93  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057E96  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057E99  9A 06 0A 1F 18        LCALL  0x181f, 0xa06 ; THUNK -> 0x05B3:0x0066 (thunk @file 0x01AFF6 type B) overlay @file 0x05FC92
057E9E  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
057EA1  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057EA4  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057EA7  0E                    PUSH   cs ; STACK_PUSH
057EA8  E8 35 23              CALL   0x5a1e0 ; CALL_NEAR
057EAB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057EAE  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057EB1  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057EB4  0E                    PUSH   cs ; STACK_PUSH
057EB5  E8 28 23              CALL   0x5a1e0 ; CALL_NEAR
057EB8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057EBB  B0 01                 MOV    al, 1 ; MOV
057EBD  69 76 06 3C 01        IMUL   si, word ptr [bp + 6], 0x13c ; ARITH
057EC2  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
057EC5  88 80 48 88           MOV    byte ptr [bx + si - 0x77b8], al ; MOV
057EC9  69 F3 3C 01           IMUL   si, bx, 0x13c ; ARITH
057ECD  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
057ED0  88 80 48 88           MOV    byte ptr [bx + si - 0x77b8], al ; MOV
057ED4  5E                    POP    si ; STACK_POP
057ED5  C9                    LEAVE ; EPILOGUE
057ED6  CB                    RETF ; RETURN
