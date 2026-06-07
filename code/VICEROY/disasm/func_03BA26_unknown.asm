; ============================================================================
; func_03BA26_unknown
; Region   : overlay
; Bytes    : file 0x03BA26..0x03BA5A  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03BA26  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
03BA2A  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
03BA2D  C6 07 00              MOV    byte ptr [bx], 0 ; MOV
03BA30  FF 36 F2 96           PUSH   word ptr [0x96f2] ; PUSH_GLOBAL
03BA34  53                    PUSH   bx ; STACK_PUSH
03BA35  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03BA3A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03BA3D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
03BA40  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03BA45  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03BA48  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
03BA4B  2D 18 00              SUB    ax, 0x18 ; ARITH
03BA4E  50                    PUSH   ax ; STACK_PUSH
03BA4F  1E                    PUSH   ds ; STACK_PUSH
03BA50  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
03BA53  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
03BA58  C9                    LEAVE ; EPILOGUE
03BA59  CB                    RETF ; RETURN
