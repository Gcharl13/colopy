; ============================================================================
; func_008168_unknown
; Region   : load_image
; Bytes    : file 0x008168..0x008180  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008168  55                    PUSH   bp ; STACK_PUSH
008169  8B EC                 MOV    bp, sp ; MOV
00816B  C7 06 5C 05 08 00     MOV    word ptr [0x55c], 8 ; GLOBAL_LOAD
008171  8D 1E 84 00           LEA    bx, [0x84] ; ADDR
008175  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
008178  2B D2                 SUB    dx, dx ; ARITH
00817A  0E                    PUSH   cs ; STACK_PUSH
00817B  E8 2A FF              CALL   0x80a8 ; CALL_NEAR
00817E  C9                    LEAVE ; EPILOGUE
00817F  CB                    RETF ; RETURN
