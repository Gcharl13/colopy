; ============================================================================
; func_037958_unknown
; Region   : overlay
; Bytes    : file 0x037958..0x037A10  (184 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "(%d of %d)"  (auto-named via string xrefs)
; ============================================================================

037958  C8 2C 00 00           ENTER  0x2c, 0 ; PROLOGUE
03795C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03795F  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
037964  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
037967  6A 02                 PUSH   2 ; STACK_PUSH
037969  0E                    PUSH   cs ; STACK_PUSH
03796A  E8 E6 24              CALL   0x39e53 ; CALL_NEAR
03796D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
037970  68 90 00              PUSH   0x90 ; PUSH_CONST
037973  6A 05                 PUSH   5 ; STACK_PUSH
037975  68 40 01              PUSH   0x140 ; PUSH_CONST
037978  6A 00                 PUSH   0 ; STACK_PUSH
03797A  FF 36 F6 2D           PUSH   word ptr [0x2df6] ; PUSH_GLOBAL
03797E  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
037983  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
037986  52                    PUSH   dx ; STACK_PUSH
037987  50                    PUSH   ax ; STACK_PUSH
037988  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
03798D  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
037990  B8 0A 00              MOV    ax, 0xa ; CONST_LOAD
037993  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
037996  50                    PUSH   ax ; STACK_PUSH
037997  B8 19 00              MOV    ax, 0x19 ; CONST_LOAD
03799A  89 46 D4              MOV    word ptr [bp - 0x2c], ax ; LOCAL_STORE
03799D  50                    PUSH   ax ; STACK_PUSH
03799E  68 2C 01              PUSH   0x12c ; PUSH_CONST
0379A1  6A 00                 PUSH   0 ; STACK_PUSH
0379A3  6A 00                 PUSH   0 ; STACK_PUSH
0379A5  6A 01                 PUSH   1 ; STACK_PUSH
0379A7  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
0379AB  8B 57 30              MOV    dx, word ptr [bx + 0x30] ; MOV
0379AE  8B 5F 2E              MOV    bx, word ptr [bx + 0x2e] ; MOV
0379B1  B8 39 00              MOV    ax, 0x39 ; CONST_LOAD
0379B4  9A 36 02 1F 18        LCALL  0x181f, 0x236 ; THUNK -> 0x0097:0x0174 (thunk @file 0x01A826 type B) overlay @file 0x027240
0379B9  F6 06 83 53 20        TEST   byte ptr [0x5383], 0x20 ; LOGIC
0379BE  74 2C                 JE     0x379ec ; CJUMP
0379C0  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
0379C4  FF 77 30              PUSH   word ptr [bx + 0x30] ; PUSH_GLOBAL
0379C7  FF 77 2E              PUSH   word ptr [bx + 0x2e] ; PUSH_GLOBAL
0379CA  68 A9 11              PUSH   0x11a9                       ; STRING: "(%d of %d)"
0379CD  8D 46 D8              LEA    ax, [bp - 0x28] ; ADDR
0379D0  50                    PUSH   ax ; STACK_PUSH
0379D1  9A 48 0B 1D 0D        LCALL  0xd1d, 0xb48 ; LCALL
0379D6  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0379D9  6A 0F                 PUSH   0xf ; PUSH_CONST
0379DB  6A 19                 PUSH   0x19 ; PUSH_CONST
0379DD  6A 0A                 PUSH   0xa ; PUSH_CONST
0379DF  8D 46 D8              LEA    ax, [bp - 0x28] ; ADDR
0379E2  16                    PUSH   ss ; STACK_PUSH
0379E3  50                    PUSH   ax ; STACK_PUSH
0379E4  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
0379E9  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
0379EC  6A FF                 PUSH   -1 ; STACK_PUSH
0379EE  6A FE                 PUSH   -2 ; STACK_PUSH
0379F0  0E                    PUSH   cs ; STACK_PUSH
0379F1  E8 3C 24              CALL   0x39e30 ; CALL_NEAR
0379F4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0379F7  6A 00                 PUSH   0 ; STACK_PUSH
0379F9  68 40 01              PUSH   0x140 ; PUSH_CONST
0379FC  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0379FF  2B C0                 SUB    ax, ax ; ARITH
037A01  99                    CDQ ; ARITH
037A02  2B DB                 SUB    bx, bx ; ARITH
037A04  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
037A09  9A C0 03 1F 18        LCALL  0x181f, 0x3c0 ; THUNK -> 0x0262:0x0060 (thunk @file 0x01A9B0 type B) overlay @file 0x021D90
037A0E  C9                    LEAVE ; EPILOGUE
037A0F  CB                    RETF ; RETURN
