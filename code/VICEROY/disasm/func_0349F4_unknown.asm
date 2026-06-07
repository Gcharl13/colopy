; ============================================================================
; func_0349F4_unknown
; Region   : overlay
; Bytes    : file 0x0349F4..0x034A3B  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0349F4  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0349F8  83 3E 12 9E 04        CMP    word ptr [0x9e12], 4 ; CMP
0349FD  7D 13                 JGE    0x34a12 ; CJUMP
0349FF  6B 1E 12 9E 34        IMUL   bx, word ptr [0x9e12], 0x34 ; ARITH
034A04  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
034A09  75 07                 JNE    0x34a12 ; CJUMP
034A0B  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
034A10  EB 05                 JMP    0x34a17 ; JUMP
034A12  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
034A17  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
034A1B  80 7F 01 3C           CMP    byte ptr [bx + 1], 0x3c ; CMP
034A1F  7C 1B                 JL     0x34a3c ; CJUMP
034A21  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
034A25  75 03                 JNE    0x34a2a ; CJUMP
034A27  E9 B3 00              JMP    0x34add ; JUMP
034A2A  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
034A2E  8D 06 84 10           LEA    ax, [0x1084] ; ADDR
034A32  2B D2                 SUB    dx, dx ; ARITH
034A34  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
034A39  C9                    LEAVE ; EPILOGUE
034A3A  CB                    RETF ; RETURN
