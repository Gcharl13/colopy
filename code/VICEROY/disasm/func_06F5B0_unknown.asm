; ============================================================================
; func_06F5B0_unknown
; Region   : overlay
; Bytes    : file 0x06F5B0..0x06F5C8  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06F5B0  55                    PUSH   bp ; STACK_PUSH
06F5B1  8B EC                 MOV    bp, sp ; MOV
06F5B3  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
06F5B6  A3 5C 1F              MOV    word ptr [0x1f5c], ax ; GLOBAL_LOAD
06F5B9  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
06F5BD  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06F5C0  2B D2                 SUB    dx, dx ; ARITH
06F5C2  0E                    PUSH   cs ; STACK_PUSH
06F5C3  E8 29 02              CALL   0x6f7ef ; CALL_NEAR
06F5C6  C9                    LEAVE ; EPILOGUE
06F5C7  CB                    RETF ; RETURN
