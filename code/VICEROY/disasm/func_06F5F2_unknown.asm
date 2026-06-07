; ============================================================================
; func_06F5F2_unknown
; Region   : overlay
; Bytes    : file 0x06F5F2..0x06F60A  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06F5F2  55                    PUSH   bp ; STACK_PUSH
06F5F3  8B EC                 MOV    bp, sp ; MOV
06F5F5  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
06F5F8  A3 5E 1F              MOV    word ptr [0x1f5e], ax ; GLOBAL_LOAD
06F5FB  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
06F5FF  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06F602  2B D2                 SUB    dx, dx ; ARITH
06F604  0E                    PUSH   cs ; STACK_PUSH
06F605  E8 E7 01              CALL   0x6f7ef ; CALL_NEAR
06F608  C9                    LEAVE ; EPILOGUE
06F609  CB                    RETF ; RETURN
