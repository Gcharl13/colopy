; ============================================================================
; func_03744A_unknown
; Region   : overlay
; Bytes    : file 0x03744A..0x03758F  (325 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03744A  C8 6E 00 00           ENTER  0x6e, 0 ; PROLOGUE
03744E  57                    PUSH   di ; STACK_PUSH
03744F  56                    PUSH   si ; STACK_PUSH
037450  6A 01                 PUSH   1 ; STACK_PUSH
037452  0E                    PUSH   cs ; STACK_PUSH
037453  E8 FD 29              CALL   0x39e53 ; CALL_NEAR
037456  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
037459  68 90 00              PUSH   0x90 ; PUSH_CONST
03745C  6A 05                 PUSH   5 ; STACK_PUSH
03745E  68 40 01              PUSH   0x140 ; PUSH_CONST
037461  6A 00                 PUSH   0 ; STACK_PUSH
037463  FF 36 F4 2D           PUSH   word ptr [0x2df4] ; PUSH_GLOBAL
037467  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
03746C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03746F  52                    PUSH   dx ; STACK_PUSH
037470  50                    PUSH   ax ; STACK_PUSH
037471  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
037476  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
037479  C7 46 A6 0A 00        MOV    word ptr [bp - 0x5a], 0xa ; LOCAL_STORE
03747E  C7 46 A4 19 00        MOV    word ptr [bp - 0x5c], 0x19 ; LOCAL_STORE
037483  C7 46 9C 00 00        MOV    word ptr [bp - 0x64], 0 ; LOCAL_STORE
037488  E9 A3 03              JMP    0x3782e ; JUMP
03748B  90                    NOP ; NOP
03748C  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
03748F  8A 87 48 08           MOV    al, byte ptr [bx + 0x848] ; MOV
037493  88 46 92              MOV    byte ptr [bp - 0x6e], al ; LOCAL_STORE
037496  83 FB 0A              CMP    bx, 0xa ; CMP
037499  75 04                 JNE    0x3749f ; CJUMP
03749B  C6 46 92 0C           MOV    byte ptr [bp - 0x6e], 0xc ; LOCAL_STORE
03749F  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
0374A3  53                    PUSH   bx ; STACK_PUSH
0374A4  9A 1A 0A 1F 18        LCALL  0x181f, 0xa1a ; THUNK -> 0x05B3:0x0198 (thunk @file 0x01B00A type B) overlay @file 0x05FDC4
0374A9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0374AC  50                    PUSH   ax ; STACK_PUSH
0374AD  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0374B0  50                    PUSH   ax ; STACK_PUSH
0374B1  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
0374B6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0374B9  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0374BC  50                    PUSH   ax ; STACK_PUSH
0374BD  9A BE 01 1F 18        LCALL  0x181f, 0x1be ; THUNK -> 0x004B:0x0042 (thunk @file 0x01A7AE type B) overlay @file 0x0603EA
0374C2  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0374C5  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
0374C9  F6 47 03 80           TEST   byte ptr [bx + 3], 0x80 ; LOGIC
0374CD  74 49                 JE     0x37518 ; CJUMP
0374CF  FF 36 BE 2E           PUSH   word ptr [0x2ebe] ; PUSH_GLOBAL
0374D3  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0374D6  50                    PUSH   ax ; STACK_PUSH
0374D7  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
0374DC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0374DF  6A 00                 PUSH   0 ; STACK_PUSH
0374E1  8B 46 94              MOV    ax, word ptr [bp - 0x6c] ; LOCAL_LOAD
0374E4  40                    INC    ax ; ARITH
0374E5  50                    PUSH   ax ; STACK_PUSH
0374E6  FF 76 98              PUSH   word ptr [bp - 0x68] ; PUSH_GLOBAL
0374E9  8D 4E AE              LEA    cx, [bp - 0x52] ; ADDR
0374EC  16                    PUSH   ss ; STACK_PUSH
0374ED  51                    PUSH   cx ; STACK_PUSH
0374EE  8B F0                 MOV    si, ax ; MOV
0374F0  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
0374F5  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
0374F8  6A 00                 PUSH   0 ; STACK_PUSH
0374FA  FF 76 94              PUSH   word ptr [bp - 0x6c] ; PUSH_GLOBAL
0374FD  8B 46 98              MOV    ax, word ptr [bp - 0x68] ; LOCAL_LOAD
037500  40                    INC    ax ; ARITH
037501  50                    PUSH   ax ; STACK_PUSH
037502  8D 4E AE              LEA    cx, [bp - 0x52] ; ADDR
037505  16                    PUSH   ss ; STACK_PUSH
037506  51                    PUSH   cx ; STACK_PUSH
037507  8B F8                 MOV    di, ax ; MOV
037509  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
03750E  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
037511  6A 00                 PUSH   0 ; STACK_PUSH
037513  56                    PUSH   si ; STACK_PUSH
037514  57                    PUSH   di ; STACK_PUSH
037515  EB 37                 JMP    0x3754e ; JUMP
037517  90                    NOP ; NOP
037518  6A 00                 PUSH   0 ; STACK_PUSH
03751A  FF 76 94              PUSH   word ptr [bp - 0x6c] ; PUSH_GLOBAL
03751D  8B 46 98              MOV    ax, word ptr [bp - 0x68] ; LOCAL_LOAD
037520  40                    INC    ax ; ARITH
037521  50                    PUSH   ax ; STACK_PUSH
037522  8D 4E AE              LEA    cx, [bp - 0x52] ; ADDR
037525  16                    PUSH   ss ; STACK_PUSH
037526  51                    PUSH   cx ; STACK_PUSH
037527  8B F0                 MOV    si, ax ; MOV
037529  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
03752E  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
037531  6A 00                 PUSH   0 ; STACK_PUSH
037533  8B 46 94              MOV    ax, word ptr [bp - 0x6c] ; LOCAL_LOAD
037536  40                    INC    ax ; ARITH
037537  50                    PUSH   ax ; STACK_PUSH
037538  FF 76 98              PUSH   word ptr [bp - 0x68] ; PUSH_GLOBAL
03753B  8D 4E AE              LEA    cx, [bp - 0x52] ; ADDR
03753E  16                    PUSH   ss ; STACK_PUSH
03753F  51                    PUSH   cx ; STACK_PUSH
037540  8B F8                 MOV    di, ax ; MOV
037542  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
037547  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
03754A  6A 00                 PUSH   0 ; STACK_PUSH
03754C  57                    PUSH   di ; STACK_PUSH
03754D  56                    PUSH   si ; STACK_PUSH
03754E  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
037551  16                    PUSH   ss ; STACK_PUSH
037552  50                    PUSH   ax ; STACK_PUSH
037553  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
037558  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
03755B  8A 46 92              MOV    al, byte ptr [bp - 0x6e] ; LOCAL_LOAD
03755E  2A E4                 SUB    ah, ah ; ARITH
037560  50                    PUSH   ax ; STACK_PUSH
037561  FF 76 94              PUSH   word ptr [bp - 0x6c] ; PUSH_GLOBAL
037564  FF 76 98              PUSH   word ptr [bp - 0x68] ; PUSH_GLOBAL
037567  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
03756A  16                    PUSH   ss ; STACK_PUSH
03756B  50                    PUSH   ax ; STACK_PUSH
03756C  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
037571  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
037574  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
037577  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
03757B  F6 47 03 80           TEST   byte ptr [bx + 3], 0x80 ; LOGIC
03757F  74 03                 JE     0x37584 ; CJUMP
037581  E9 A3 02              JMP    0x37827 ; JUMP
037584  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
037588  8A 5F 02              MOV    bl, byte ptr [bx + 2] ; MOV
03758B  2A FF                 SUB    bh, bh ; ARITH
03758D  8B C3                 MOV    ax, bx ; MOV
