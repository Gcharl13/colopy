; ============================================================================
; func_0318D2_unknown
; Region   : overlay
; Bytes    : file 0x0318D2..0x0319A5  (211 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0318D2  C8 56 00 00           ENTER  0x56, 0 ; PROLOGUE
0318D6  6A 33                 PUSH   0x33 ; PUSH_CONST
0318D8  6A 46                 PUSH   0x46 ; PUSH_CONST
0318DA  6A 76                 PUSH   0x76 ; PUSH_CONST
0318DC  6A 01                 PUSH   1 ; STACK_PUSH
0318DE  0E                    PUSH   cs ; STACK_PUSH
0318DF  E8 EA 4F              CALL   0x368cc ; CALL_NEAR
0318E2  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0318E5  FF 36 CC 2D           PUSH   word ptr [0x2dcc] ; PUSH_GLOBAL
0318E9  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
0318EE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0318F1  52                    PUSH   dx ; STACK_PUSH
0318F2  50                    PUSH   ax ; STACK_PUSH
0318F3  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0318F6  16                    PUSH   ss ; STACK_PUSH
0318F7  50                    PUSH   ax ; STACK_PUSH
0318F8  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
0318FD  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
031900  6A 45                 PUSH   0x45 ; PUSH_CONST
031902  6A 78                 PUSH   0x78 ; PUSH_CONST
031904  6A 46                 PUSH   0x46 ; PUSH_CONST
031906  6A 01                 PUSH   1 ; STACK_PUSH
031908  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
03190B  16                    PUSH   ss ; STACK_PUSH
03190C  50                    PUSH   ax ; STACK_PUSH
03190D  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
031912  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
031915  C7 46 AC 02 00        MOV    word ptr [bp - 0x54], 2 ; LOCAL_STORE
03191A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
03191F  A1 12 9E              MOV    ax, word ptr [0x9e12] ; GLOBAL_LOAD
031922  2D 10 00              SUB    ax, 0x10 ; ARITH
031925  8B D0                 MOV    dx, ax ; MOV
031927  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
03192C  EB 1F                 JMP    0x3194d ; JUMP
03192E  6A FF                 PUSH   -1 ; STACK_PUSH
031930  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
031933  50                    PUSH   ax ; STACK_PUSH
031934  6A 01                 PUSH   1 ; STACK_PUSH
031936  6A 0D                 PUSH   0xd ; PUSH_CONST
031938  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
03193B  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
03193E  0E                    PUSH   cs ; STACK_PUSH
03193F  E8 E9 4F              CALL   0x3692b ; CALL_NEAR
031942  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
031945  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
031948  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
03194D  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
031950  0B C0                 OR     ax, ax ; LOGIC
031952  7D DA                 JGE    0x3192e ; CJUMP
031954  A1 12 9E              MOV    ax, word ptr [0x9e12] ; GLOBAL_LOAD
031957  2D 0C 00              SUB    ax, 0xc ; ARITH
03195A  8B D0                 MOV    dx, ax ; MOV
03195C  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
031961  EB 20                 JMP    0x31983 ; JUMP
031963  90                    NOP ; NOP
031964  6A FF                 PUSH   -1 ; STACK_PUSH
031966  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
031969  50                    PUSH   ax ; STACK_PUSH
03196A  6A 01                 PUSH   1 ; STACK_PUSH
03196C  6A 0D                 PUSH   0xd ; PUSH_CONST
03196E  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
031971  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
031974  0E                    PUSH   cs ; STACK_PUSH
031975  E8 B3 4F              CALL   0x3692b ; CALL_NEAR
031978  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
03197B  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
03197E  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
031983  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
031986  0B C0                 OR     ax, ax ; LOGIC
031988  7D DA                 JGE    0x31964 ; CJUMP
03198A  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
03198E  74 13                 JE     0x319a3 ; CJUMP
031990  6A 76                 PUSH   0x76 ; PUSH_CONST
031992  6A 46                 PUSH   0x46 ; PUSH_CONST
031994  6A 33                 PUSH   0x33 ; PUSH_CONST
031996  B8 01 00              MOV    ax, 1 ; MOV
031999  BA 76 00              MOV    dx, 0x76 ; CONST_LOAD
03199C  8B D8                 MOV    bx, ax ; MOV
03199E  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
0319A3  C9                    LEAVE ; EPILOGUE
0319A4  CB                    RETF ; RETURN
