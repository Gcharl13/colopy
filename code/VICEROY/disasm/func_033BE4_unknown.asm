; ============================================================================
; func_033BE4_unknown
; Region   : overlay
; Bytes    : file 0x033BE4..0x033C19  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

033BE4  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
033BE8  56                    PUSH   si ; STACK_PUSH
033BE9  FF 36 2C 9E           PUSH   word ptr [0x9e2c] ; PUSH_GLOBAL
033BED  0E                    PUSH   cs ; STACK_PUSH
033BEE  E8 44 2D              CALL   0x36935 ; CALL_NEAR
033BF1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033BF4  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
033BF7  6A 01                 PUSH   1 ; STACK_PUSH
033BF9  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
033BFE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033C01  8B 1E 12 9E           MOV    bx, word ptr [0x9e12] ; GLOBAL_LOAD
033C05  D1 E3                 SHL    bx, 1 ; LOGIC
033C07  FF B7 0A 8D           PUSH   word ptr [bx - 0x72f6] ; PUSH_GLOBAL
033C0B  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
033C10  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033C13  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
033C17  8B C3                 MOV    ax, bx ; MOV
