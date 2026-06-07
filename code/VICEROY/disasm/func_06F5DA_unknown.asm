; ============================================================================
; func_06F5DA_unknown
; Region   : overlay
; Bytes    : file 0x06F5DA..0x06F5F2  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06F5DA  55                    PUSH   bp ; STACK_PUSH
06F5DB  8B EC                 MOV    bp, sp ; MOV
06F5DD  C7 06 5C 1F 08 00     MOV    word ptr [0x1f5c], 8 ; GLOBAL_LOAD
06F5E3  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
06F5E7  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06F5EA  2B D2                 SUB    dx, dx ; ARITH
06F5EC  0E                    PUSH   cs ; STACK_PUSH
06F5ED  E8 FF 01              CALL   0x6f7ef ; CALL_NEAR
06F5F0  C9                    LEAVE ; EPILOGUE
06F5F1  CB                    RETF ; RETURN
