; ============================================================================
; func_0082FB_unknown
; Region   : load_image
; Bytes    : file 0x0082FB..0x00830B  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0082FB  55                    PUSH   bp ; STACK_PUSH
0082FC  8B EC                 MOV    bp, sp ; MOV
0082FE  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
008301  89 87 52 39           MOV    word ptr [bx + 0x3952], ax ; MOV
008305  FE 06 62 39           INC    byte ptr [0x3962] ; ARITH
008309  5D                    POP    bp ; STACK_POP
00830A  CB                    RETF ; RETURN
