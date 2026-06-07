; ============================================================================
; func_032914_unknown
; Region   : overlay
; Bytes    : file 0x032914..0x0329A8  (148 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032914  C8 64 00 00           ENTER  0x64, 0 ; PROLOGUE
032918  57                    PUSH   di ; STACK_PUSH
032919  56                    PUSH   si ; STACK_PUSH
03291A  C7 46 AC 01 00        MOV    word ptr [bp - 0x54], 1 ; LOCAL_STORE
03291F  C7 46 AA 64 00        MOV    word ptr [bp - 0x56], 0x64 ; LOCAL_STORE
032924  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
032927  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03292A  9A 2C 0C 1F 18        LCALL  0x181f, 0xc2c ; THUNK -> 0x05EB:0x32A0 (thunk @file 0x01B21C type B) overlay @file 0x02A290
03292F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
032932  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
032935  0B C0                 OR     ax, ax ; LOGIC
032937  7D 47                 JGE    0x32980 ; CJUMP
032939  83 3E 92 08 00        CMP    word ptr [0x892], 0 ; CMP
03293E  75 03                 JNE    0x32943 ; CJUMP
032940  E9 61 04              JMP    0x32da4 ; JUMP
032943  6A 01                 PUSH   1 ; STACK_PUSH
032945  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
03294A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03294D  6A 09                 PUSH   9 ; STACK_PUSH
03294F  0E                    PUSH   cs ; STACK_PUSH
032950  E8 01 3F              CALL   0x36854 ; CALL_NEAR
032953  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
032956  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
032959  D1 E3                 SHL    bx, 1 ; LOGIC
03295B  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
03295F  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
032964  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
032967  6A 0A                 PUSH   0xa ; PUSH_CONST
032969  0E                    PUSH   cs ; STACK_PUSH
03296A  E8 E7 3E              CALL   0x36854 ; CALL_NEAR
03296D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
032970  6A 00                 PUSH   0 ; STACK_PUSH
032972  6A 78                 PUSH   0x78 ; PUSH_CONST
032974  6A 03                 PUSH   3 ; STACK_PUSH
032976  0E                    PUSH   cs ; STACK_PUSH
032977  E8 C6 3E              CALL   0x36840 ; CALL_NEAR
03297A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03297D  E9 24 04              JMP    0x32da4 ; JUMP
032980  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
032984  75 03                 JNE    0x32989 ; CJUMP
032986  E9 AE 00              JMP    0x32a37 ; JUMP
032989  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
03298C  D1 E3                 SHL    bx, 1 ; LOGIC
03298E  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
032992  6A 00                 PUSH   0 ; STACK_PUSH
032994  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
032999  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03299C  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
0329A0  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
0329A4  2A FF                 SUB    bh, bh ; ARITH
0329A6  8B C3                 MOV    ax, bx ; MOV
