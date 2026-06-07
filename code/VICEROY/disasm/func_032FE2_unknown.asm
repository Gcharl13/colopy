; ============================================================================
; func_032FE2_unknown
; Region   : overlay
; Bytes    : file 0x032FE2..0x033073  (145 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032FE2  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
032FE6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
032FE9  0E                    PUSH   cs ; STACK_PUSH
032FEA  E8 16 39              CALL   0x36903 ; CALL_NEAR
032FED  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
032FF0  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
032FF3  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
032FF6  8A 8F 4C 31           MOV    cl, byte ptr [bx + 0x314c] ; MOV
032FFA  88 4E F4              MOV    byte ptr [bp - 0xc], cl ; LOCAL_STORE
032FFD  C6 87 4C 31 00        MOV    byte ptr [bx + 0x314c], 0 ; MOV
033002  50                    PUSH   ax ; STACK_PUSH
033003  9A 20 09 1F 18        LCALL  0x181f, 0x920 ; THUNK -> 0x0427:0x10BE (thunk @file 0x01AF10 type B) overlay @file 0x031DD2
033008  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03300B  2B D2                 SUB    dx, dx ; ARITH
03300D  89 16 5E 1F           MOV    word ptr [0x1f5e], dx ; GLOBAL_LOAD
033011  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
033015  8D 06 FC 0F           LEA    ax, [0xffc] ; ADDR
033019  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
03301E  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
033021  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
033024  0B D0                 OR     dx, ax ; LOGIC
033026  75 03                 JNE    0x3302b ; CJUMP
033028  E9 F9 00              JMP    0x33124 ; JUMP
03302B  6A 00                 PUSH   0 ; STACK_PUSH
03302D  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
033030  9A EA 07 1F 18        LCALL  0x181f, 0x7ea ; THUNK -> 0x0427:0x04D6 (thunk @file 0x01ADDA type B) overlay @file 0x0311EA
033035  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
033038  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
03303B  9A EE 02 1F 18        LCALL  0x181f, 0x2ee ; THUNK -> 0x0427:0x0002 (thunk @file 0x01A8DE type B) overlay @file 0x030D16
033040  EB 2A                 JMP    0x3306c ; JUMP
033042  6A 00                 PUSH   0 ; STACK_PUSH
033044  6A 00                 PUSH   0 ; STACK_PUSH
033046  6A 00                 PUSH   0 ; STACK_PUSH
033048  9A DA 02 1F 18        LCALL  0x181f, 0x2da ; THUNK -> 0x012B:0x0060 (thunk @file 0x01A8CA type B) overlay @file 0x0235CA
03304D  50                    PUSH   ax ; STACK_PUSH
03304E  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
033052  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
033056  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
033059  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
03305C  9A 30 02 1F 19        LCALL  0x191f, 0x230 ; THUNK -> 0x0000:0x0F3C (thunk @file 0x01B820 type A) overlay @file 0x02683C
033061  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
033064  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
033067  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
03306C  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
03306F  0B C0                 OR     ax, ax ; LOGIC
033071  7D CF                 JGE    0x33042 ; CJUMP
