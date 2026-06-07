; ============================================================================
; func_008846_unknown
; Region   : load_image
; Bytes    : file 0x008846..0x008861  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008846  55                    PUSH   bp ; STACK_PUSH
008847  8B EC                 MOV    bp, sp ; MOV
008849  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00884C  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
00884F  F7 D8                 NEG    ax ; ARITH
008851  83 D2 00              ADC    dx, 0 ; ARITH
008854  F7 DA                 NEG    dx ; ARITH
008856  52                    PUSH   dx ; STACK_PUSH
008857  50                    PUSH   ax ; STACK_PUSH
008858  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00885B  0E                    PUSH   cs ; STACK_PUSH
00885C  E8 A7 FF              CALL   0x8806 ; CALL_NEAR
00885F  C9                    LEAVE ; EPILOGUE
008860  CB                    RETF ; RETURN
