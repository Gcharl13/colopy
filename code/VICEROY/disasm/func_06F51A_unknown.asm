; ============================================================================
; func_06F51A_unknown
; Region   : overlay
; Bytes    : file 0x06F51A..0x06F54C  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06F51A  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
06F51E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
06F523  0E                    PUSH   cs ; STACK_PUSH
06F524  E8 DC 02              CALL   0x6f803 ; CALL_NEAR
06F527  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06F52A  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
06F52D  0B D0                 OR     dx, ax ; LOGIC
06F52F  74 16                 JE     0x6f547 ; CJUMP
06F531  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06F534  50                    PUSH   ax ; STACK_PUSH
06F535  0E                    PUSH   cs ; STACK_PUSH
06F536  E8 C0 02              CALL   0x6f7f9 ; CALL_NEAR
06F539  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06F53C  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06F53F  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
06F542  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
06F547  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
06F54A  C9                    LEAVE ; EPILOGUE
06F54B  CB                    RETF ; RETURN
