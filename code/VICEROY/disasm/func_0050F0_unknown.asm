; ============================================================================
; func_0050F0_unknown
; Region   : load_image
; Bytes    : file 0x0050F0..0x0050FB  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0050F0  55                    PUSH   bp ; STACK_PUSH
0050F1  8B EC                 MOV    bp, sp ; MOV
0050F3  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0050F6  A3 9A 00              MOV    word ptr [0x9a], ax ; GLOBAL_LOAD
0050F9  C9                    LEAVE ; EPILOGUE
0050FA  CB                    RETF ; RETURN
