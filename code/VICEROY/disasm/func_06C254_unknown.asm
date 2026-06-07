; ============================================================================
; func_06C254_unknown
; Region   : overlay
; Bytes    : file 0x06C254..0x06C27C  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C254  C8 50 00 00           ENTER  0x50, 0 ; PROLOGUE
06C258  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
06C25C  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06C25F  50                    PUSH   ax ; STACK_PUSH
06C260  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06C263  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
06C266  9A 2E 04 1F 18        LCALL  0x181f, 0x42e ; THUNK -> 0x05B3:0x0144 (thunk @file 0x01AA1E type B) overlay @file 0x05FD70
06C26B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06C26E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06C271  16                    PUSH   ss ; STACK_PUSH
06C272  50                    PUSH   ax ; STACK_PUSH
06C273  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06C276  0E                    PUSH   cs ; STACK_PUSH
06C277  E8 70 35              CALL   0x6f7ea ; CALL_NEAR
06C27A  C9                    LEAVE ; EPILOGUE
06C27B  CB                    RETF ; RETURN
