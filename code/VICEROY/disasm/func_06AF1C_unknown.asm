; ============================================================================
; func_06AF1C_unknown
; Region   : overlay
; Bytes    : file 0x06AF1C..0x06B02A  (270 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "MISC"  (auto-named via string xrefs)
; ============================================================================

06AF1C  C8 58 00 00           ENTER  0x58, 0 ; PROLOGUE
06AF20  56                    PUSH   si ; STACK_PUSH
06AF21  0E                    PUSH   cs ; STACK_PUSH
06AF22  E8 6D 07              CALL   0x6b692 ; CALL_NEAR
06AF25  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
06AF28  2A E4                 SUB    ah, ah ; ARITH
06AF2A  50                    PUSH   ax ; STACK_PUSH
06AF2B  6A 05                 PUSH   5 ; STACK_PUSH
06AF2D  68 40 01              PUSH   0x140 ; PUSH_CONST
06AF30  6A 00                 PUSH   0 ; STACK_PUSH
06AF32  FF 36 92 2E           PUSH   word ptr [0x2e92] ; PUSH_GLOBAL
06AF36  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
06AF3B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06AF3E  52                    PUSH   dx ; STACK_PUSH
06AF3F  50                    PUSH   ax ; STACK_PUSH
06AF40  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
06AF45  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
06AF48  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
06AF4C  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
06AF4F  2A E4                 SUB    ah, ah ; ARITH
06AF51  05 07 00              ADD    ax, 7 ; ARITH
06AF54  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
06AF57  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
06AF5B  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06AF5E  50                    PUSH   ax ; STACK_PUSH
06AF5F  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
06AF64  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06AF67  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
06AF6A  D1 E3                 SHL    bx, 1 ; LOGIC
06AF6C  FF B7 5C 93           PUSH   word ptr [bx - 0x6ca4] ; PUSH_GLOBAL
06AF70  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06AF73  50                    PUSH   ax ; STACK_PUSH
06AF74  8B F3                 MOV    si, bx ; MOV
06AF76  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
06AF7B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06AF7E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06AF81  50                    PUSH   ax ; STACK_PUSH
06AF82  9A BE 01 1F 18        LCALL  0x181f, 0x1be ; THUNK -> 0x004B:0x0042 (thunk @file 0x01A7AE type B) overlay @file 0x0603EA
06AF87  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06AF8A  6A 06                 PUSH   6 ; STACK_PUSH
06AF8C  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06AF8F  50                    PUSH   ax ; STACK_PUSH
06AF90  0E                    PUSH   cs ; STACK_PUSH
06AF91  E8 EA 06              CALL   0x6b67e ; CALL_NEAR
06AF94  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06AF97  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06AF9A  50                    PUSH   ax ; STACK_PUSH
06AF9B  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
06AFA0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06AFA3  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
06AFA6  2A E4                 SUB    ah, ah ; ARITH
06AFA8  50                    PUSH   ax ; STACK_PUSH
06AFA9  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
06AFAC  68 40 01              PUSH   0x140 ; PUSH_CONST
06AFAF  6A 00                 PUSH   0 ; STACK_PUSH
06AFB1  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06AFB4  16                    PUSH   ss ; STACK_PUSH
06AFB5  50                    PUSH   ax ; STACK_PUSH
06AFB6  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
06AFBB  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
06AFBE  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
06AFC2  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
06AFC5  2A E4                 SUB    ah, ah ; ARITH
06AFC7  05 0E 00              ADD    ax, 0xe ; ARITH
06AFCA  01 46 AA              ADD    word ptr [bp - 0x56], ax ; ARITH
06AFCD  C7 46 AC 0A 00        MOV    word ptr [bp - 0x54], 0xa ; LOCAL_STORE
06AFD2  68 01 1F              PUSH   0x1f01                       ; STRING: "MISC"
06AFD5  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06AFD8  50                    PUSH   ax ; STACK_PUSH
06AFD9  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
06AFDE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06AFE1  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06AFE4  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06AFE7  16                    PUSH   ss ; STACK_PUSH
06AFE8  50                    PUSH   ax ; STACK_PUSH
06AFE9  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
06AFEE  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06AFF1  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
06AFF4  A3 5A 1F              MOV    word ptr [0x1f5a], ax ; GLOBAL_LOAD
06AFF7  FF B4 5C 93           PUSH   word ptr [si - 0x6ca4] ; PUSH_GLOBAL
06AFFB  6A 00                 PUSH   0 ; STACK_PUSH
06AFFD  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
06B002  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06B005  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06B008  50                    PUSH   ax ; STACK_PUSH
06B009  0E                    PUSH   cs ; STACK_PUSH
06B00A  E8 80 06              CALL   0x6b68d ; CALL_NEAR
06B00D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06B010  6A 00                 PUSH   0 ; STACK_PUSH
06B012  68 40 01              PUSH   0x140 ; PUSH_CONST
06B015  68 C8 00              PUSH   0xc8 ; PUSH_CONST
06B018  2B C0                 SUB    ax, ax ; ARITH
06B01A  99                    CDQ ; ARITH
06B01B  2B DB                 SUB    bx, bx ; ARITH
06B01D  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
06B022  9A C0 03 1F 18        LCALL  0x181f, 0x3c0 ; THUNK -> 0x0262:0x0060 (thunk @file 0x01A9B0 type B) overlay @file 0x021D90
06B027  5E                    POP    si ; STACK_POP
06B028  C9                    LEAVE ; EPILOGUE
06B029  CB                    RETF ; RETURN
