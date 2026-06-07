; ============================================================================
; func_02A6A6_unknown
; Region   : overlay
; Bytes    : file 0x02A6A6..0x02A714  (110 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02A6A6  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
02A6AA  56                    PUSH   si ; STACK_PUSH
02A6AB  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
02A6B0  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
02A6B5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
02A6B8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02A6BB  9A 2C 0C 1F 18        LCALL  0x181f, 0xc2c ; THUNK -> 0x05EB:0x32A0 (thunk @file 0x01B21C type B) overlay @file 0x02A290
02A6C0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02A6C3  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
02A6C6  0B C0                 OR     ax, ax ; LOGIC
02A6C8  7D 4A                 JGE    0x2a714 ; CJUMP
02A6CA  83 3E 90 08 00        CMP    word ptr [0x890], 0 ; CMP
02A6CF  75 03                 JNE    0x2a6d4 ; CJUMP
02A6D1  E9 12 02              JMP    0x2a8e6 ; JUMP
02A6D4  6A 01                 PUSH   1 ; STACK_PUSH
02A6D6  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
02A6DB  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02A6DE  6A 09                 PUSH   9 ; STACK_PUSH
02A6E0  0E                    PUSH   cs ; STACK_PUSH
02A6E1  E8 D5 23              CALL   0x2cab9 ; CALL_NEAR
02A6E4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02A6E7  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
02A6EA  D1 E3                 SHL    bx, 1 ; LOGIC
02A6EC  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
02A6F0  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
02A6F5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02A6F8  6A 0A                 PUSH   0xa ; PUSH_CONST
02A6FA  0E                    PUSH   cs ; STACK_PUSH
02A6FB  E8 BB 23              CALL   0x2cab9 ; CALL_NEAR
02A6FE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02A701  6A 00                 PUSH   0 ; STACK_PUSH
02A703  6A 78                 PUSH   0x78 ; PUSH_CONST
02A705  6A 03                 PUSH   3 ; STACK_PUSH
02A707  0E                    PUSH   cs ; STACK_PUSH
02A708  E8 9F 23              CALL   0x2caaa ; CALL_NEAR
02A70B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02A70E  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
02A711  5E                    POP    si ; STACK_POP
02A712  C9                    LEAVE ; EPILOGUE
02A713  CB                    RETF ; RETURN
