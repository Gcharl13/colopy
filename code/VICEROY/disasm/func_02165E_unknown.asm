; ============================================================================
; func_02165E_unknown
; Region   : overlay
; Bytes    : file 0x02165E..0x0216AB  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02165E  C8 54 00 00           ENTER  0x54, 0 ; PROLOGUE
021662  56                    PUSH   si ; STACK_PUSH
021663  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
021666  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
021669  C7 46 AE 00 00        MOV    word ptr [bp - 0x52], 0 ; LOCAL_STORE
02166E  8B 5E AC              MOV    bx, word ptr [bp - 0x54] ; LOCAL_LOAD
021671  C1 E3 06              SHL    bx, 6 ; LOGIC
021674  03 5E AE              ADD    bx, word ptr [bp - 0x52] ; ARITH
021677  C1 E3 02              SHL    bx, 2 ; LOGIC
02167A  80 BF B2 98 FF        CMP    byte ptr [bx - 0x674e], 0xff ; CMP
02167F  74 21                 JE     0x216a2 ; CJUMP
021681  8A 87 B2 98           MOV    al, byte ptr [bx - 0x674e] ; MOV
021685  98                    CWDE ; ARITH
021686  40                    INC    ax ; ARITH
021687  50                    PUSH   ax ; STACK_PUSH
021688  8A 87 B3 98           MOV    al, byte ptr [bx - 0x674d] ; MOV
02168C  98                    CWDE ; ARITH
02168D  50                    PUSH   ax ; STACK_PUSH
02168E  8A 87 B1 98           MOV    al, byte ptr [bx - 0x674f] ; MOV
021692  98                    CWDE ; ARITH
021693  50                    PUSH   ax ; STACK_PUSH
021694  8A 87 B0 98           MOV    al, byte ptr [bx - 0x6750] ; MOV
021698  98                    CWDE ; ARITH
021699  50                    PUSH   ax ; STACK_PUSH
02169A  9A 2C 01 1F 19        LCALL  0x191f, 0x12c ; THUNK -> 0x0000:0x0008 (thunk @file 0x01B71C type A) overlay @file 0x025908
02169F  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0216A2  FF 46 AE              INC    word ptr [bp - 0x52] ; ARITH
0216A5  83 7E AE 40           CMP    word ptr [bp - 0x52], 0x40 ; CMP
0216A9  7C C3                 JL     0x2166e ; CJUMP
