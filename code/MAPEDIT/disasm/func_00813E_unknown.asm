; ============================================================================
; func_00813E_unknown
; Region   : load_image
; Bytes    : file 0x00813E..0x008156  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00813E  55                    PUSH   bp ; STACK_PUSH
00813F  8B EC                 MOV    bp, sp ; MOV
008141  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
008144  A3 5C 05              MOV    word ptr [0x55c], ax ; GLOBAL_LOAD
008147  8D 1E 84 00           LEA    bx, [0x84] ; ADDR
00814B  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00814E  2B D2                 SUB    dx, dx ; ARITH
008150  0E                    PUSH   cs ; STACK_PUSH
008151  E8 54 FF              CALL   0x80a8 ; CALL_NEAR
008154  C9                    LEAVE ; EPILOGUE
008155  CB                    RETF ; RETURN
