; ============================================================================
; func_06D8C8_unknown
; Region   : overlay
; Bytes    : file 0x06D8C8..0x06D938  (112 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06D8C8  C8 54 00 00           ENTER  0x54, 0 ; PROLOGUE
06D8CC  83 3E 66 1F 00        CMP    word ptr [0x1f66], 0 ; CMP
06D8D1  74 63                 JE     0x6d936 ; CJUMP
06D8D3  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06D8D6  26 8B 47 14           MOV    ax, word ptr es:[bx + 0x14] ; MOV
06D8DA  26 03 47 10           ADD    ax, word ptr es:[bx + 0x10] ; ARITH
06D8DE  48                    DEC    ax ; ARITH
06D8DF  48                    DEC    ax ; ARITH
06D8E0  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06D8E3  26 8B 47 16           MOV    ax, word ptr es:[bx + 0x16] ; MOV
06D8E7  26 03 47 12           ADD    ax, word ptr es:[bx + 0x12] ; ARITH
06D8EB  2D 07 00              SUB    ax, 7 ; ARITH
06D8EE  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
06D8F1  8B 0E 9E 08           MOV    cx, word ptr [0x89e] ; GLOBAL_LOAD
06D8F5  8B 16 A0 08           MOV    dx, word ptr [0x8a0] ; GLOBAL_LOAD
06D8F9  26 39 8F 80 00        CMP    word ptr es:[bx + 0x80], cx ; CMP
06D8FE  75 0C                 JNE    0x6d90c ; CJUMP
06D900  26 39 97 82 00        CMP    word ptr es:[bx + 0x82], dx ; CMP
06D905  75 05                 JNE    0x6d90c ; CJUMP
06D907  48                    DEC    ax ; ARITH
06D908  48                    DEC    ax ; ARITH
06D909  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
06D90C  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
06D910  FF 36 34 2F           PUSH   word ptr [0x2f34] ; PUSH_GLOBAL
06D914  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06D917  50                    PUSH   ax ; STACK_PUSH
06D918  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
06D91D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06D920  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
06D923  2A E4                 SUB    ah, ah ; ARITH
06D925  50                    PUSH   ax ; STACK_PUSH
06D926  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
06D929  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
06D92C  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06D92F  16                    PUSH   ss ; STACK_PUSH
06D930  50                    PUSH   ax ; STACK_PUSH
06D931  9A 50 01 1F 18        LCALL  0x181f, 0x150 ; THUNK -> 0x004B:0x02C2 (thunk @file 0x01A740 type B) overlay @file 0x06066A
06D936  C9                    LEAVE ; EPILOGUE
06D937  CB                    RETF ; RETURN
