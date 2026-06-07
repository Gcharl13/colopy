; ============================================================================
; func_028466_unknown
; Region   : overlay
; Bytes    : file 0x028466..0x028513  (173 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028466  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
02846A  8D 46 F4              LEA    ax, [bp - 0xc] ; ADDR
02846D  50                    PUSH   ax ; STACK_PUSH
02846E  8D 46 F6              LEA    ax, [bp - 0xa] ; ADDR
028471  50                    PUSH   ax ; STACK_PUSH
028472  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
028475  50                    PUSH   ax ; STACK_PUSH
028476  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
028479  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
02847C  0E                    PUSH   cs ; STACK_PUSH
02847D  E8 5C 46              CALL   0x2cadc ; CALL_NEAR
028480  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
028483  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
028488  EB 48                 JMP    0x284d2 ; JUMP
02848A  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
02848E  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
028492  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
028496  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
02849A  03 46 F6              ADD    ax, word ptr [bp - 0xa] ; ARITH
02849D  50                    PUSH   ax ; STACK_PUSH
02849E  6A 3F                 PUSH   0x3f ; PUSH_CONST
0284A0  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
0284A3  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
0284A6  03 D8                 ADD    bx, ax ; ARITH
0284A8  40                    INC    ax ; ARITH
0284A9  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
0284AC  42                    INC    dx ; ARITH
0284AD  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
0284B2  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
0284B6  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
0284BA  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
0284BD  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
0284C0  03 46 F8              ADD    ax, word ptr [bp - 8] ; ARITH
0284C3  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
0284C7  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
0284CA  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
0284CF  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
0284D2  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
0284D5  39 46 08              CMP    word ptr [bp + 8], ax ; CMP
0284D8  7E 60                 JLE    0x2853a ; CJUMP
0284DA  C7 46 FC 2F 01        MOV    word ptr [bp - 4], 0x12f ; LOCAL_STORE
0284DF  8B 4E F6              MOV    cx, word ptr [bp - 0xa] ; LOCAL_LOAD
0284E2  41                    INC    cx ; ARITH
0284E3  41                    INC    cx ; ARITH
0284E4  F7 E9                 IMUL   cx ; ARITH
0284E6  05 84 00              ADD    ax, 0x84 ; ARITH
0284E9  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0284EC  8B 4E F8              MOV    cx, word ptr [bp - 8] ; LOCAL_LOAD
0284EF  39 4E 06              CMP    word ptr [bp + 6], cx ; CMP
0284F2  75 96                 JNE    0x2848a ; CJUMP
0284F4  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0284F8  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0284FC  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
028500  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
028504  03 46 F6              ADD    ax, word ptr [bp - 0xa] ; ARITH
028507  48                    DEC    ax ; ARITH
028508  50                    PUSH   ax ; STACK_PUSH
028509  6A 3F                 PUSH   0x3f ; PUSH_CONST
02850B  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
02850E  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
028511  81                    DB     0x81 ; DATA_BYTE
028512  C3                    DB     0xC3 ; DATA_BYTE
