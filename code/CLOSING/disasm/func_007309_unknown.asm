; ============================================================================
; func_007309_unknown
; Region   : load_image
; Bytes    : file 0x007309..0x007319  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007309  55                    PUSH   bp ; STACK_PUSH
00730A  8B EC                 MOV    bp, sp ; MOV
00730C  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00730F  89 87 FC 36           MOV    word ptr [bx + 0x36fc], ax ; MOV
007313  FE 06 0C 37           INC    byte ptr [0x370c] ; ARITH
007317  5D                    POP    bp ; STACK_POP
007318  CB                    RETF ; RETURN
