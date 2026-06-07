; ============================================================================
; func_06F61C_unknown
; Region   : overlay
; Bytes    : file 0x06F61C..0x06F634  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06F61C  55                    PUSH   bp ; STACK_PUSH
06F61D  8B EC                 MOV    bp, sp ; MOV
06F61F  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
06F622  A3 60 1F              MOV    word ptr [0x1f60], ax ; GLOBAL_LOAD
06F625  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
06F629  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06F62C  2B D2                 SUB    dx, dx ; ARITH
06F62E  0E                    PUSH   cs ; STACK_PUSH
06F62F  E8 BD 01              CALL   0x6f7ef ; CALL_NEAR
06F632  C9                    LEAVE ; EPILOGUE
06F633  CB                    RETF ; RETURN
