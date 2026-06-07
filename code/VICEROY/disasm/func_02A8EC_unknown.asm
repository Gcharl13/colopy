; ============================================================================
; func_02A8EC_unknown
; Region   : overlay
; Bytes    : file 0x02A8EC..0x02A92B  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02A8EC  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
02A8F0  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
02A8F5  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
02A8F8  50                    PUSH   ax ; STACK_PUSH
02A8F9  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
02A8FC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02A8FF  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
02A904  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02A907  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
02A90A  50                    PUSH   ax ; STACK_PUSH
02A90B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
02A90E  9A 96 0B 1F 18        LCALL  0x181f, 0xb96 ; THUNK -> 0x05EB:0x3208 (thunk @file 0x01B186 type B) overlay @file 0x02A1F8
02A913  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02A916  0B C0                 OR     ax, ax ; LOGIC
02A918  75 12                 JNE    0x2a92c ; CJUMP
02A91A  50                    PUSH   ax ; STACK_PUSH
02A91B  6A 78                 PUSH   0x78 ; PUSH_CONST
02A91D  6A 04                 PUSH   4 ; STACK_PUSH
02A91F  0E                    PUSH   cs ; STACK_PUSH
02A920  E8 B4 21              CALL   0x2cad7 ; CALL_NEAR
02A923  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02A926  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
02A929  C9                    LEAVE ; EPILOGUE
02A92A  CB                    RETF ; RETURN
