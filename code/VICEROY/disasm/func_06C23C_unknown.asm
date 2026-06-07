; ============================================================================
; func_06C23C_unknown
; Region   : overlay
; Bytes    : file 0x06C23C..0x06C254  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C23C  55                    PUSH   bp ; STACK_PUSH
06C23D  8B EC                 MOV    bp, sp ; MOV
06C23F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06C242  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
06C247  8B E5                 MOV    sp, bp ; MOV
06C249  52                    PUSH   dx ; STACK_PUSH
06C24A  50                    PUSH   ax ; STACK_PUSH
06C24B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06C24E  0E                    PUSH   cs ; STACK_PUSH
06C24F  E8 98 35              CALL   0x6f7ea ; CALL_NEAR
06C252  C9                    LEAVE ; EPILOGUE
06C253  CB                    RETF ; RETURN
