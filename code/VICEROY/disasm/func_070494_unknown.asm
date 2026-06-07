; ============================================================================
; func_070494_unknown
; Region   : overlay
; Bytes    : file 0x070494..0x070580  (236 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

070494  C8 62 00 00           ENTER  0x62, 0 ; PROLOGUE
070498  C4 1E 8A 26           LES    bx, ptr [0x268a] ; MOV_FAR
07049C  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
07049F  8B C8                 MOV    cx, ax ; MOV
0704A1  D0 E8                 SHR    al, 1 ; LOGIC
0704A3  2A E4                 SUB    ah, ah ; ARITH
0704A5  2D 14 00              SUB    ax, 0x14 ; ARITH
0704A8  F7 D8                 NEG    ax ; ARITH
0704AA  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
0704AD  2A ED                 SUB    ch, ch ; ARITH
0704AF  8B D0                 MOV    dx, ax ; MOV
0704B1  03 C1                 ADD    ax, cx ; ARITH
0704B3  05 04 00              ADD    ax, 4 ; ARITH
0704B6  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
0704B9  03 C8                 ADD    cx, ax ; ARITH
0704BB  83 C1 04              ADD    cx, 4 ; ARITH
0704BE  89 4E A0              MOV    word ptr [bp - 0x60], cx ; LOCAL_STORE
0704C1  C6 46 9E FE           MOV    byte ptr [bp - 0x62], 0xfe ; LOCAL_STORE
0704C5  68 FD 00              PUSH   0xfd ; PUSH_CONST
0704C8  68 FE 00              PUSH   0xfe ; PUSH_CONST
0704CB  52                    PUSH   dx ; STACK_PUSH
0704CC  B8 44 00              MOV    ax, 0x44 ; CONST_LOAD
0704CF  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0704D2  50                    PUSH   ax ; STACK_PUSH
0704D3  B8 17 00              MOV    ax, 0x17 ; CONST_LOAD
0704D6  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
0704D9  50                    PUSH   ax ; STACK_PUSH
0704DA  FF 36 FE 2E           PUSH   word ptr [0x2efe] ; PUSH_GLOBAL
0704DE  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
0704E3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0704E6  52                    PUSH   dx ; STACK_PUSH
0704E7  50                    PUSH   ax ; STACK_PUSH
0704E8  9A C8 01 1F 18        LCALL  0x181f, 0x1c8 ; THUNK -> 0x004B:0x0430 (thunk @file 0x01A7B8 type B) overlay @file 0x0607D8
0704ED  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
0704F0  68 FD 00              PUSH   0xfd ; PUSH_CONST
0704F3  68 FE 00              PUSH   0xfe ; PUSH_CONST
0704F6  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
0704F9  6A 44                 PUSH   0x44 ; PUSH_CONST
0704FB  6A 17                 PUSH   0x17 ; PUSH_CONST
0704FD  FF 36 00 2F           PUSH   word ptr [0x2f00] ; PUSH_GLOBAL
070501  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
070506  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
070509  52                    PUSH   dx ; STACK_PUSH
07050A  50                    PUSH   ax ; STACK_PUSH
07050B  9A C8 01 1F 18        LCALL  0x181f, 0x1c8 ; THUNK -> 0x004B:0x0430 (thunk @file 0x01A7B8 type B) overlay @file 0x0607D8
070510  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
070513  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
070517  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
07051A  50                    PUSH   ax ; STACK_PUSH
07051B  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
070520  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
070523  FF 36 FC 2E           PUSH   word ptr [0x2efc] ; PUSH_GLOBAL
070527  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
07052A  50                    PUSH   ax ; STACK_PUSH
07052B  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
070530  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
070533  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
070536  50                    PUSH   ax ; STACK_PUSH
070537  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
07053C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
07053F  68 FE 00              PUSH   0xfe ; PUSH_CONST
070542  6A 51                 PUSH   0x51 ; PUSH_CONST
070544  6A 44                 PUSH   0x44 ; PUSH_CONST
070546  6A 17                 PUSH   0x17 ; PUSH_CONST
070548  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
07054B  16                    PUSH   ss ; STACK_PUSH
07054C  50                    PUSH   ax ; STACK_PUSH
07054D  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
070552  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
070555  6A 00                 PUSH   0 ; STACK_PUSH
070557  68 80 00              PUSH   0x80 ; PUSH_CONST
07055A  6A 67                 PUSH   0x67 ; PUSH_CONST
07055C  2B C0                 SUB    ax, ax ; ARITH
07055E  99                    CDQ ; ARITH
07055F  2B DB                 SUB    bx, bx ; ARITH
070561  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
070566  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0 ; LOCAL_STORE
07056B  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
07056E  0E                    PUSH   cs ; STACK_PUSH
07056F  E8 DE 06              CALL   0x70c50 ; CALL_NEAR
070572  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
070575  FF 46 AC              INC    word ptr [bp - 0x54] ; ARITH
070578  83 7E AC 05           CMP    word ptr [bp - 0x54], 5 ; CMP
07057C  7C ED                 JL     0x7056b ; CJUMP
07057E  C9                    LEAVE ; EPILOGUE
07057F  CB                    RETF ; RETURN
