; ============================================================================
; func_06936C_unknown
; Region   : overlay
; Bytes    : file 0x06936C..0x0694AE  (322 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06936C  C8 58 00 00           ENTER  0x58, 0 ; PROLOGUE
069370  C7 46 AA 0A 00        MOV    word ptr [bp - 0x56], 0xa ; LOCAL_STORE
069375  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
069378  05 17 00              ADD    ax, 0x17 ; ARITH
06937B  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
06937E  83 7E 06 10           CMP    word ptr [bp + 6], 0x10 ; CMP
069382  75 05                 JNE    0x69389 ; CJUMP
069384  C7 46 AC 37 00        MOV    word ptr [bp - 0x54], 0x37 ; LOCAL_STORE
069389  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
06938C  D1 E3                 SHL    bx, 1 ; LOGIC
06938E  8B 87 C0 97           MOV    ax, word ptr [bx - 0x6840] ; MOV
069392  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
069395  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
069399  7D 10                 JGE    0x693ab ; CJUMP
06939B  C7 46 AC 3A 00        MOV    word ptr [bp - 0x54], 0x3a ; LOCAL_STORE
0693A0  C7 46 08 08 00        MOV    word ptr [bp + 8], 8 ; LOCAL_STORE
0693A5  A1 1C 2F              MOV    ax, word ptr [0x2f1c] ; GLOBAL_LOAD
0693A8  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0693AB  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
0693AF  7C 24                 JL     0x693d5 ; CJUMP
0693B1  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
0693B5  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
0693B9  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
0693BC  48                    DEC    ax ; ARITH
0693BD  48                    DEC    ax ; ARITH
0693BE  50                    PUSH   ax ; STACK_PUSH
0693BF  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0693C2  05 52 00              ADD    ax, 0x52 ; ARITH
0693C5  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
0693C9  8B 56 AA              MOV    dx, word ptr [bp - 0x56] ; LOCAL_LOAD
0693CC  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
0693D1  83 46 AA 0E           ADD    word ptr [bp - 0x56], 0xe ; ARITH
0693D5  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
0693D9  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
0693DD  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0693E0  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
0693E3  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
0693E7  8B 56 AA              MOV    dx, word ptr [bp - 0x56] ; LOCAL_LOAD
0693EA  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
0693EF  83 46 AA 10           ADD    word ptr [bp - 0x56], 0x10 ; ARITH
0693F3  C7 46 A8 00 00        MOV    word ptr [bp - 0x58], 0 ; LOCAL_STORE
0693F8  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
0693FC  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
069400  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
069403  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
069406  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06940A  8B 56 AA              MOV    dx, word ptr [bp - 0x56] ; LOCAL_LOAD
06940D  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
069412  83 46 AA 04           ADD    word ptr [bp - 0x56], 4 ; ARITH
069416  FF 46 A8              INC    word ptr [bp - 0x58] ; ARITH
069419  83 7E A8 06           CMP    word ptr [bp - 0x58], 6 ; CMP
06941D  7C D9                 JL     0x693f8 ; CJUMP
06941F  83 46 AA 0C           ADD    word ptr [bp - 0x56], 0xc ; ARITH
069423  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
069427  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
06942A  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06942D  50                    PUSH   ax ; STACK_PUSH
06942E  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
069433  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
069436  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
06943A  7C 56                 JL     0x69492 ; CJUMP
06943C  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06943F  50                    PUSH   ax ; STACK_PUSH
069440  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
069445  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069448  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06944B  50                    PUSH   ax ; STACK_PUSH
06944C  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
069451  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069454  FF 36 1E 2F           PUSH   word ptr [0x2f1e] ; PUSH_GLOBAL
069458  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06945B  50                    PUSH   ax ; STACK_PUSH
06945C  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
069461  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
069464  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
069467  50                    PUSH   ax ; STACK_PUSH
069468  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
06946D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069470  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
069473  C1 E3 03              SHL    bx, 3 ; LOGIC
069476  FF B7 A4 8E           PUSH   word ptr [bx - 0x715c] ; PUSH_GLOBAL
06947A  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06947D  50                    PUSH   ax ; STACK_PUSH
06947E  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
069483  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
069486  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
069489  50                    PUSH   ax ; STACK_PUSH
06948A  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
06948F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069492  A0 30 08              MOV    al, byte ptr [0x830] ; GLOBAL_LOAD
069495  2A E4                 SUB    ah, ah ; ARITH
069497  50                    PUSH   ax ; STACK_PUSH
069498  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06949B  05 04 00              ADD    ax, 4 ; ARITH
06949E  50                    PUSH   ax ; STACK_PUSH
06949F  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
0694A2  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0694A5  16                    PUSH   ss ; STACK_PUSH
0694A6  50                    PUSH   ax ; STACK_PUSH
0694A7  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
0694AC  C9                    LEAVE ; EPILOGUE
0694AD  CB                    RETF ; RETURN
