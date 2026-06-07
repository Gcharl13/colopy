; ============================================================================
; func_076E50_unknown
; Region   : overlay
; Bytes    : file 0x076E50..0x076F47  (247 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "LEVN00"  (auto-named via string xrefs)
; ============================================================================

076E50  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
076E54  50                    PUSH   ax ; STACK_PUSH
076E55  53                    PUSH   bx ; STACK_PUSH
076E56  57                    PUSH   di ; STACK_PUSH
076E57  56                    PUSH   si ; STACK_PUSH
076E58  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
076E5B  8B 7E 0A              MOV    di, word ptr [bp + 0xa] ; LOCAL_LOAD
076E5E  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
076E63  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
076E68  6A 0D                 PUSH   0xd ; PUSH_CONST
076E6A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
076E6D  56                    PUSH   si ; STACK_PUSH
076E6E  1E                    PUSH   ds ; STACK_PUSH
076E6F  68 4C 24              PUSH   0x244c ; PUSH_CONST
076E72  9A C0 10 1D 0D        LCALL  0xd1d, 0x10c0 ; LCALL
076E77  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
076E7A  8E 46 0C              MOV    es, word ptr [bp + 0xc] ; LOCAL_LOAD
076E7D  26 C7 05 00 00        MOV    word ptr es:[di], 0 ; MOV
076E82  6A 72                 PUSH   0x72                         ; STRING: "LEVN00"
076E84  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
076E87  9A 46 0D 1D 0D        LCALL  0xd1d, 0xd46 ; LCALL
076E8C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
076E8F  50                    PUSH   ax ; STACK_PUSH
076E90  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
076E95  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
076E98  3D 01 00              CMP    ax, 1 ; CMP
076E9B  1B C0                 SBB    ax, ax ; ARITH
076E9D  40                    INC    ax ; ARITH
076E9E  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
076EA1  8E 46 0C              MOV    es, word ptr [bp + 0xc] ; LOCAL_LOAD
076EA4  26 C6 45 04 00        MOV    byte ptr es:[di + 4], 0 ; MOV
076EA9  26 C7 45 08 FF FF     MOV    word ptr es:[di + 8], 0xffff ; CONST_LOAD
076EAF  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
076EB2  50                    PUSH   ax ; STACK_PUSH
076EB3  56                    PUSH   si ; STACK_PUSH
076EB4  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
076EB7  8C C6                 MOV    si, es ; MOV
076EB9  9A 86 0E 1F 18        LCALL  0x181f, 0xe86 ; THUNK -> 0x09F6:0x00FA (thunk @file 0x01B476 type B) overlay @file 0x030D60
076EBE  8E C6                 MOV    es, si ; MOV
076EC0  26 89 45 06           MOV    word ptr es:[di + 6], ax ; MOV
076EC4  0B C0                 OR     ax, ax ; LOGIC
076EC6  75 03                 JNE    0x76ecb ; CJUMP
076EC8  E9 69 01              JMP    0x77034 ; JUMP
076ECB  8E 46 0C              MOV    es, word ptr [bp + 0xc] ; LOCAL_LOAD
076ECE  26 C7 45 18 00 00     MOV    word ptr es:[di + 0x18], 0 ; MOV
076ED4  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
076ED7  26 89 45 02           MOV    word ptr es:[di + 2], ax ; MOV
076EDB  0B C0                 OR     ax, ax ; LOGIC
076EDD  75 03                 JNE    0x76ee2 ; CJUMP
076EDF  E9 E6 00              JMP    0x76fc8 ; JUMP
076EE2  8D 46 F6              LEA    ax, [bp - 0xa] ; ADDR
076EE5  50                    PUSH   ax ; STACK_PUSH
076EE6  8E 46 0C              MOV    es, word ptr [bp + 0xc] ; LOCAL_LOAD
076EE9  26 FF 75 06           PUSH   word ptr es:[di + 6] ; STACK_PUSH
076EED  8C C6                 MOV    si, es ; MOV
076EEF  9A A2 09 1D 0D        LCALL  0xd1d, 0x9a2 ; LCALL
076EF4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
076EF7  8D 45 1A              LEA    ax, [di + 0x1a] ; ADDR
076EFA  56                    PUSH   si ; STACK_PUSH
076EFB  50                    PUSH   ax ; STACK_PUSH
076EFC  6A 00                 PUSH   0 ; STACK_PUSH
076EFE  6A 01                 PUSH   1 ; STACK_PUSH
076F00  8E C6                 MOV    es, si ; MOV
076F02  26 8B 5D 06           MOV    bx, word ptr es:[di + 6] ; MOV
076F06  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
076F09  99                    CDQ ; ARITH
076F0A  9A B4 0C 1F 1A        LCALL  0x1a1f, 0xcb4 ; THUNK -> 0x0B01:0x000E (thunk @file 0x01D2A4 type B)
076F0F  0B D0                 OR     dx, ax ; LOGIC
076F11  75 03                 JNE    0x76f16 ; CJUMP
076F13  E9 1E 01              JMP    0x77034 ; JUMP
076F16  6A 0C                 PUSH   0xc ; PUSH_CONST
076F18  1E                    PUSH   ds ; STACK_PUSH
076F19  68 0A 24              PUSH   0x240a ; PUSH_CONST
076F1C  8B C7                 MOV    ax, di ; MOV
076F1E  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
076F21  05 1A 00              ADD    ax, 0x1a ; ARITH
076F24  52                    PUSH   dx ; STACK_PUSH
076F25  50                    PUSH   ax ; STACK_PUSH
076F26  9A 84 10 1D 0D        LCALL  0xd1d, 0x1084 ; LCALL
076F2B  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
076F2E  0B C0                 OR     ax, ax ; LOGIC
076F30  74 03                 JE     0x76f35 ; CJUMP
076F32  E9 FF 00              JMP    0x77034 ; JUMP
076F35  8B C7                 MOV    ax, di ; MOV
076F37  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
076F3A  05 2A 00              ADD    ax, 0x2a ; ARITH
076F3D  52                    PUSH   dx ; STACK_PUSH
076F3E  50                    PUSH   ax ; STACK_PUSH
076F3F  6A 00                 PUSH   0 ; STACK_PUSH
076F41  6A 01                 PUSH   1 ; STACK_PUSH
076F43  8E C2                 MOV    es, dx ; MOV
076F45  8B F7                 MOV    si, di ; MOV
