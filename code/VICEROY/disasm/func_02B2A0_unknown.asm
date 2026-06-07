; ============================================================================
; func_02B2A0_unknown
; Region   : overlay
; Bytes    : file 0x02B2A0..0x02B367  (199 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B2A0  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
02B2A4  81 3E EA 07 9E 00     CMP    word ptr [0x7ea], 0x9e ; CMP
02B2AA  7C 20                 JL     0x2b2cc ; CJUMP
02B2AC  6A 59                 PUSH   0x59 ; PUSH_CONST
02B2AE  2B C0                 SUB    ax, ax ; ARITH
02B2B0  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02B2B3  50                    PUSH   ax ; STACK_PUSH
02B2B4  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
02B2B7  2D D5 00              SUB    ax, 0xd5 ; ARITH
02B2BA  50                    PUSH   ax ; STACK_PUSH
02B2BB  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
02B2C0  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02B2C3  B9 12 00              MOV    cx, 0x12 ; CONST_LOAD
02B2C6  99                    CDQ ; ARITH
02B2C7  F7 F9                 IDIV   cx ; ARITH
02B2C9  EB 39                 JMP    0x2b304 ; JUMP
02B2CB  90                    NOP ; NOP
02B2CC  81 3E EA 07 98 00     CMP    word ptr [0x7ea], 0x98 ; CMP
02B2D2  7C 08                 JL     0x2b2dc ; CJUMP
02B2D4  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
02B2D9  EB 06                 JMP    0x2b2e1 ; JUMP
02B2DB  90                    NOP ; NOP
02B2DC  C7 46 FC 02 00        MOV    word ptr [bp - 4], 2 ; LOCAL_STORE
02B2E1  6A 53                 PUSH   0x53 ; PUSH_CONST
02B2E3  6A 00                 PUSH   0 ; STACK_PUSH
02B2E5  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
02B2E8  2D D5 00              SUB    ax, 0xd5 ; ARITH
02B2EB  50                    PUSH   ax ; STACK_PUSH
02B2EC  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
02B2F1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02B2F4  40                    INC    ax ; ARITH
02B2F5  B9 05 00              MOV    cx, 5 ; MOV
02B2F8  99                    CDQ ; ARITH
02B2F9  F7 F9                 IDIV   cx ; ARITH
02B2FB  6B 4E FC 11           IMUL   cx, word ptr [bp - 4], 0x11 ; ARITH
02B2FF  03 C1                 ADD    ax, cx ; ARITH
02B301  2D 0C 00              SUB    ax, 0xc ; ARITH
02B304  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
02B307  A1 76 8D              MOV    ax, word ptr [0x8d76] ; GLOBAL_LOAD
02B30A  48                    DEC    ax ; ARITH
02B30B  3B 46 F8              CMP    ax, word ptr [bp - 8] ; CMP
02B30E  7E 03                 JLE    0x2b313 ; CJUMP
02B310  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
02B313  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
02B318  74 4B                 JE     0x2b365 ; CJUMP
02B31A  C7 06 2E 03 03 00     MOV    word ptr [0x32e], 3 ; GLOBAL_LOAD
02B320  A3 7A 8D              MOV    word ptr [0x8d7a], ax ; GLOBAL_LOAD
02B323  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
02B328  74 37                 JE     0x2b361 ; CJUMP
02B32A  83 3E E4 07 00        CMP    word ptr [0x7e4], 0 ; CMP
02B32F  75 07                 JNE    0x2b338 ; CJUMP
02B331  0E                    PUSH   cs ; STACK_PUSH
02B332  E8 0C 17              CALL   0x2ca41 ; CALL_NEAR
02B335  EB 2A                 JMP    0x2b361 ; JUMP
02B337  90                    NOP ; NOP
02B338  83 3E 72 8D 00        CMP    word ptr [0x8d72], 0 ; CMP
02B33D  74 22                 JE     0x2b361 ; CJUMP
02B33F  A1 78 8D              MOV    ax, word ptr [0x8d78] ; GLOBAL_LOAD
02B342  8B 16 7A 8D           MOV    dx, word ptr [0x8d7a] ; GLOBAL_LOAD
02B346  9A 2A 09 1F 18        LCALL  0x181f, 0x92a ; THUNK -> 0x0427:0x0180 (thunk @file 0x01AF1A type B) overlay @file 0x030E94
02B34B  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
02B34E  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
02B352  2A E4                 SUB    ah, ah ; ARITH
02B354  50                    PUSH   ax ; STACK_PUSH
02B355  9A 42 09 1F 19        LCALL  0x191f, 0x942 ; THUNK -> 0x0000:0x07E6 (thunk @file 0x01BF32 type A) overlay @file 0x0260E6
02B35A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02B35D  0E                    PUSH   cs ; STACK_PUSH
02B35E  E8 CC 16              CALL   0x2ca2d ; CALL_NEAR
02B361  0E                    PUSH   cs ; STACK_PUSH
02B362  E8 13 17              CALL   0x2ca78 ; CALL_NEAR
02B365  C9                    LEAVE ; EPILOGUE
02B366  CB                    RETF ; RETURN
