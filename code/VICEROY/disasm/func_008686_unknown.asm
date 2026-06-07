; ============================================================================
; func_008686_unknown
; Region   : load_image
; Bytes    : file 0x008686..0x0086A8  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008686  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00868A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00868F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
008692  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
008695  0E                    PUSH   cs ; STACK_PUSH
008696  E8 75 FF              CALL   0x860e ; CALL_NEAR
008699  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00869C  0B C0                 OR     ax, ax ; LOGIC
00869E  74 03                 JE     0x86a3 ; CJUMP
0086A0  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
0086A3  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
0086A6  8B C3                 MOV    ax, bx ; MOV
