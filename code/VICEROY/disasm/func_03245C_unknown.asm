; ============================================================================
; func_03245C_unknown
; Region   : overlay
; Bytes    : file 0x03245C..0x0324B6  (90 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03245C  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
032460  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
032463  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
032466  9A EC 0A 1F 18        LCALL  0x181f, 0xaec ; THUNK -> 0x05EB:0x317C (thunk @file 0x01B0DC type B) overlay @file 0x02A16C
03246B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03246E  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
032471  0B C0                 OR     ax, ax ; LOGIC
032473  7C 3C                 JL     0x324b1 ; CJUMP
032475  A1 C4 8D              MOV    ax, word ptr [0x8dc4] ; GLOBAL_LOAD
032478  3B 46 0A              CMP    ax, word ptr [bp + 0xa] ; CMP
03247B  7E 18                 JLE    0x32495 ; CJUMP
03247D  2B 46 0A              SUB    ax, word ptr [bp + 0xa] ; ARITH
032480  50                    PUSH   ax ; STACK_PUSH
032481  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
032484  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
032487  9A 58 0D 1F 18        LCALL  0x181f, 0xd58 ; THUNK -> 0x05EB:0x30B8 (thunk @file 0x01B348 type B) overlay @file 0x02A0A8
03248C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03248F  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
032492  A3 C4 8D              MOV    word ptr [0x8dc4], ax ; GLOBAL_LOAD
032495  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
032498  0E                    PUSH   cs ; STACK_PUSH
032499  E8 77 43              CALL   0x36813 ; CALL_NEAR
03249C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03249F  F7 2E C4 8D           IMUL   word ptr [0x8dc4] ; ARITH
0324A3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0324A6  FF 36 C4 8D           PUSH   word ptr [0x8dc4] ; PUSH_GLOBAL
0324AA  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
0324AD  0E                    PUSH   cs ; STACK_PUSH
0324AE  E8 67 43              CALL   0x36818 ; CALL_NEAR
0324B1  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0324B4  C9                    LEAVE ; EPILOGUE
0324B5  CB                    RETF ; RETURN
