; ============================================================================
; func_008180_unknown
; Region   : load_image
; Bytes    : file 0x008180..0x008198  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008180  55                    PUSH   bp ; STACK_PUSH
008181  8B EC                 MOV    bp, sp ; MOV
008183  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
008186  A3 5E 05              MOV    word ptr [0x55e], ax ; GLOBAL_LOAD
008189  8D 1E 84 00           LEA    bx, [0x84] ; ADDR
00818D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
008190  2B D2                 SUB    dx, dx ; ARITH
008192  0E                    PUSH   cs ; STACK_PUSH
008193  E8 12 FF              CALL   0x80a8 ; CALL_NEAR
008196  C9                    LEAVE ; EPILOGUE
008197  CB                    RETF ; RETURN
