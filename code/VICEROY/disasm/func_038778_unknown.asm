; ============================================================================
; func_038778_unknown
; Region   : overlay
; Bytes    : file 0x038778..0x038879  (257 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

038778  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
03877C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03877F  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
038784  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038787  6A 05                 PUSH   5 ; STACK_PUSH
038789  0E                    PUSH   cs ; STACK_PUSH
03878A  E8 C6 16              CALL   0x39e53 ; CALL_NEAR
03878D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038790  68 90 00              PUSH   0x90 ; PUSH_CONST
038793  6A 05                 PUSH   5 ; STACK_PUSH
038795  68 40 01              PUSH   0x140 ; PUSH_CONST
038798  6A 00                 PUSH   0 ; STACK_PUSH
03879A  FF 36 1E 2E           PUSH   word ptr [0x2e1e] ; PUSH_GLOBAL
03879E  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
0387A3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0387A6  52                    PUSH   dx ; STACK_PUSH
0387A7  50                    PUSH   ax ; STACK_PUSH
0387A8  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
0387AD  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0387B0  68 91 00              PUSH   0x91 ; PUSH_CONST
0387B3  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
0387B7  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
0387BA  2A E4                 SUB    ah, ah ; ARITH
0387BC  05 06 00              ADD    ax, 6 ; ARITH
0387BF  50                    PUSH   ax ; STACK_PUSH
0387C0  68 40 01              PUSH   0x140 ; PUSH_CONST
0387C3  6A 00                 PUSH   0 ; STACK_PUSH
0387C5  FF 36 58 2F           PUSH   word ptr [0x2f58] ; PUSH_GLOBAL
0387C9  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
0387CE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0387D1  52                    PUSH   dx ; STACK_PUSH
0387D2  50                    PUSH   ax ; STACK_PUSH
0387D3  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
0387D8  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0387DB  C7 46 FE 5A 00        MOV    word ptr [bp - 2], 0x5a ; LOCAL_STORE
0387E0  C7 46 FC 19 00        MOV    word ptr [bp - 4], 0x19 ; LOCAL_STORE
0387E5  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0387E9  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0387ED  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0387F1  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0387F5  6A 77                 PUSH   0x77 ; PUSH_CONST
0387F7  B8 57 00              MOV    ax, 0x57 ; CONST_LOAD
0387FA  BA 19 00              MOV    dx, 0x19 ; CONST_LOAD
0387FD  BB B2 00              MOV    bx, 0xb2 ; CONST_LOAD
038800  9A B2 08 1F 19        LCALL  0x191f, 0x8b2 ; THUNK -> 0x0BC3:0x0006 (thunk @file 0x01BEA2 type B)
038805  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
03880A  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
03880E  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
038812  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
038815  40                    INC    ax ; ARITH
038816  40                    INC    ax ; ARITH
038817  50                    PUSH   ax ; STACK_PUSH
038818  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
03881B  05 17 00              ADD    ax, 0x17 ; ARITH
03881E  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
038822  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
038825  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
03882A  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
03882E  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
038832  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
038836  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
03883A  6A 77                 PUSH   0x77 ; PUSH_CONST
03883C  83 46 FE 0E           ADD    word ptr [bp - 2], 0xe ; ARITH
038840  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
038843  2D 03 00              SUB    ax, 3 ; ARITH
038846  BA 19 00              MOV    dx, 0x19 ; CONST_LOAD
038849  BB B2 00              MOV    bx, 0xb2 ; CONST_LOAD
03884C  9A B2 08 1F 19        LCALL  0x191f, 0x8b2 ; THUNK -> 0x0BC3:0x0006 (thunk @file 0x01BEA2 type B)
038851  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
038854  83 7E FA 10           CMP    word ptr [bp - 6], 0x10 ; CMP
038858  7C B0                 JL     0x3880a ; CJUMP
03885A  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
03885F  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
038863  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
038867  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
03886B  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
03886F  6A 77                 PUSH   0x77 ; PUSH_CONST
038871  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
038874  C1 E3 03              SHL    bx, 3 ; LOGIC
038877  83                    DB     0x83 ; DATA_BYTE
038878  C3                    DB     0xC3 ; DATA_BYTE
