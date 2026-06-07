; ============================================================================
; func_067E28_unknown
; Region   : overlay
; Bytes    : file 0x067E28..0x067E6D  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067E28  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
067E2C  8B 0E 6C 01           MOV    cx, word ptr [0x16c] ; GLOBAL_LOAD
067E30  8B 16 6E 01           MOV    dx, word ptr [0x16e] ; GLOBAL_LOAD
067E34  89 4E FC              MOV    word ptr [bp - 4], cx ; LOCAL_STORE
067E37  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
067E3A  83 3E 84 01 00        CMP    word ptr [0x184], 0 ; CMP
067E3F  75 2D                 JNE    0x67e6e ; CJUMP
067E41  8A 1E A5 1E           MOV    bl, byte ptr [0x1ea5] ; GLOBAL_LOAD
067E45  2A FF                 SUB    bh, bh ; ARITH
067E47  03 1E A6 A5           ADD    bx, word ptr [0xa5a6] ; ARITH
067E4B  83 EB 0F              SUB    bx, 0xf ; ARITH
067E4E  53                    PUSH   bx ; STACK_PUSH
067E4F  8A 1E A4 1E           MOV    bl, byte ptr [0x1ea4] ; GLOBAL_LOAD
067E53  2A FF                 SUB    bh, bh ; ARITH
067E55  03 1E A4 A5           ADD    bx, word ptr [0xa5a4] ; ARITH
067E59  83 EB 08              SUB    bx, 8 ; ARITH
067E5C  53                    PUSH   bx ; STACK_PUSH
067E5D  68 9E 83              PUSH   0x839e ; PUSH_CONST
067E60  50                    PUSH   ax ; STACK_PUSH
067E61  52                    PUSH   dx ; STACK_PUSH
067E62  51                    PUSH   cx ; STACK_PUSH
067E63  9A 5E 02 1F 18        LCALL  0x181f, 0x25e ; THUNK -> 0x0101:0x0050 (thunk @file 0x01A84E type B) overlay @file 0x06044C
067E68  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
067E6B  C9                    LEAVE ; EPILOGUE
067E6C  C3                    RET ; RETURN
