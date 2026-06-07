; ============================================================================
; func_067EEC_unknown
; Region   : overlay
; Bytes    : file 0x067EEC..0x067F31  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067EEC  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
067EF0  8B 0E 6C 01           MOV    cx, word ptr [0x16c] ; GLOBAL_LOAD
067EF4  8B 16 6E 01           MOV    dx, word ptr [0x16e] ; GLOBAL_LOAD
067EF8  89 4E FC              MOV    word ptr [bp - 4], cx ; LOCAL_STORE
067EFB  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
067EFE  83 3E 84 01 00        CMP    word ptr [0x184], 0 ; CMP
067F03  75 2D                 JNE    0x67f32 ; CJUMP
067F05  8A 1E A5 1E           MOV    bl, byte ptr [0x1ea5] ; GLOBAL_LOAD
067F09  2A FF                 SUB    bh, bh ; ARITH
067F0B  03 1E A6 A5           ADD    bx, word ptr [0xa5a6] ; ARITH
067F0F  83 EB 0F              SUB    bx, 0xf ; ARITH
067F12  53                    PUSH   bx ; STACK_PUSH
067F13  8A 1E A4 1E           MOV    bl, byte ptr [0x1ea4] ; GLOBAL_LOAD
067F17  2A FF                 SUB    bh, bh ; ARITH
067F19  03 1E A4 A5           ADD    bx, word ptr [0xa5a4] ; ARITH
067F1D  83 EB 08              SUB    bx, 8 ; ARITH
067F20  53                    PUSH   bx ; STACK_PUSH
067F21  68 9E 83              PUSH   0x839e ; PUSH_CONST
067F24  50                    PUSH   ax ; STACK_PUSH
067F25  52                    PUSH   dx ; STACK_PUSH
067F26  51                    PUSH   cx ; STACK_PUSH
067F27  9A 68 02 1F 18        LCALL  0x181f, 0x268 ; THUNK -> 0x0101:0x00B4 (thunk @file 0x01A858 type B) overlay @file 0x0604B0
067F2C  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
067F2F  C9                    LEAVE ; EPILOGUE
067F30  C3                    RET ; RETURN
