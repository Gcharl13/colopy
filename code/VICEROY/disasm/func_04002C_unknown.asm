; ============================================================================
; func_04002C_unknown
; Region   : overlay
; Bytes    : file 0x04002C..0x04007E  (82 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04002C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
040030  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
040033  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
040036  0E                    PUSH   cs ; STACK_PUSH
040037  E8 B0 00              CALL   0x400ea ; CALL_NEAR
04003A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04003D  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
040040  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
040043  FF 06 9C 53           INC    word ptr [0x539c] ; ARITH
040047  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
04004A  50                    PUSH   ax ; STACK_PUSH
04004B  9A 94 08 1F 18        LCALL  0x181f, 0x894 ; THUNK -> 0x0427:0x0D1E (thunk @file 0x01AE84 type B) overlay @file 0x031A32
040050  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040053  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
040057  C6 87 46 31 17        MOV    byte ptr [bx + 0x3146], 0x17 ; CONST_LOAD
04005C  C6 87 4A 31 FF        MOV    byte ptr [bx + 0x314a], 0xff ; CONST_LOAD
040061  C6 87 4B 31 2D        MOV    byte ptr [bx + 0x314b], 0x2d ; CONST_LOAD
040066  C6 87 50 31 00        MOV    byte ptr [bx + 0x3150], 0 ; MOV
04006B  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
04006E  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
040071  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
040074  9A 44 08 1F 18        LCALL  0x181f, 0x844 ; THUNK -> 0x0427:0x02CA (thunk @file 0x01AE34 type B) overlay @file 0x030FDE
040079  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
04007C  C9                    LEAVE ; EPILOGUE
04007D  CB                    RETF ; RETURN
