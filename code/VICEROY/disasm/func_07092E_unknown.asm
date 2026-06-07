; ============================================================================
; func_07092E_unknown
; Region   : overlay
; Bytes    : file 0x07092E..0x070A1A  (236 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

07092E  C8 62 00 00           ENTER  0x62, 0 ; PROLOGUE
070932  C4 1E 8A 26           LES    bx, ptr [0x268a] ; MOV_FAR
070936  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
070939  8B C8                 MOV    cx, ax ; MOV
07093B  D0 E8                 SHR    al, 1 ; LOGIC
07093D  2A E4                 SUB    ah, ah ; ARITH
07093F  2D 28 00              SUB    ax, 0x28 ; ARITH
070942  F7 D8                 NEG    ax ; ARITH
070944  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
070947  2A ED                 SUB    ch, ch ; ARITH
070949  8B D0                 MOV    dx, ax ; MOV
07094B  03 C1                 ADD    ax, cx ; ARITH
07094D  05 04 00              ADD    ax, 4 ; ARITH
070950  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
070953  03 C8                 ADD    cx, ax ; ARITH
070955  83 C1 04              ADD    cx, 4 ; ARITH
070958  89 4E A0              MOV    word ptr [bp - 0x60], cx ; LOCAL_STORE
07095B  C6 46 9E FE           MOV    byte ptr [bp - 0x62], 0xfe ; LOCAL_STORE
07095F  68 FD 00              PUSH   0xfd ; PUSH_CONST
070962  68 FE 00              PUSH   0xfe ; PUSH_CONST
070965  52                    PUSH   dx ; STACK_PUSH
070966  B8 70 00              MOV    ax, 0x70 ; CONST_LOAD
070969  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
07096C  50                    PUSH   ax ; STACK_PUSH
07096D  2B C0                 SUB    ax, ax ; ARITH
07096F  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
070972  50                    PUSH   ax ; STACK_PUSH
070973  FF 36 0E 2F           PUSH   word ptr [0x2f0e] ; PUSH_GLOBAL
070977  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
07097C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
07097F  52                    PUSH   dx ; STACK_PUSH
070980  50                    PUSH   ax ; STACK_PUSH
070981  9A C8 01 1F 18        LCALL  0x181f, 0x1c8 ; THUNK -> 0x004B:0x0430 (thunk @file 0x01A7B8 type B) overlay @file 0x0607D8
070986  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
070989  68 FD 00              PUSH   0xfd ; PUSH_CONST
07098C  68 FE 00              PUSH   0xfe ; PUSH_CONST
07098F  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
070992  6A 70                 PUSH   0x70 ; PUSH_CONST
070994  6A 00                 PUSH   0 ; STACK_PUSH
070996  FF 36 10 2F           PUSH   word ptr [0x2f10] ; PUSH_GLOBAL
07099A  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
07099F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0709A2  52                    PUSH   dx ; STACK_PUSH
0709A3  50                    PUSH   ax ; STACK_PUSH
0709A4  9A C8 01 1F 18        LCALL  0x181f, 0x1c8 ; THUNK -> 0x004B:0x0430 (thunk @file 0x01A7B8 type B) overlay @file 0x0607D8
0709A9  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
0709AC  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
0709B0  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0709B3  50                    PUSH   ax ; STACK_PUSH
0709B4  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
0709B9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0709BC  FF 36 FC 2E           PUSH   word ptr [0x2efc] ; PUSH_GLOBAL
0709C0  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0709C3  50                    PUSH   ax ; STACK_PUSH
0709C4  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
0709C9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0709CC  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0709CF  50                    PUSH   ax ; STACK_PUSH
0709D0  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
0709D5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0709D8  68 FE 00              PUSH   0xfe ; PUSH_CONST
0709DB  68 B6 00              PUSH   0xb6 ; PUSH_CONST
0709DE  6A 70                 PUSH   0x70 ; PUSH_CONST
0709E0  6A 00                 PUSH   0 ; STACK_PUSH
0709E2  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0709E5  16                    PUSH   ss ; STACK_PUSH
0709E6  50                    PUSH   ax ; STACK_PUSH
0709E7  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
0709EC  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0709EF  6A 00                 PUSH   0 ; STACK_PUSH
0709F1  6A 70                 PUSH   0x70 ; PUSH_CONST
0709F3  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0709F6  2B C0                 SUB    ax, ax ; ARITH
0709F8  99                    CDQ ; ARITH
0709F9  2B DB                 SUB    bx, bx ; ARITH
0709FB  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
070A00  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0 ; LOCAL_STORE
070A05  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
070A08  0E                    PUSH   cs ; STACK_PUSH
070A09  E8 53 02              CALL   0x70c5f ; CALL_NEAR
070A0C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
070A0F  FF 46 AC              INC    word ptr [bp - 0x54] ; ARITH
070A12  83 7E AC 04           CMP    word ptr [bp - 0x54], 4 ; CMP
070A16  7C ED                 JL     0x70a05 ; CJUMP
070A18  C9                    LEAVE ; EPILOGUE
070A19  CB                    RETF ; RETURN
