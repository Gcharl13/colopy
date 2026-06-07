; ============================================================================
; func_0050FC_unknown
; Region   : load_image
; Bytes    : file 0x0050FC..0x005107  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0050FC  55                    PUSH   bp ; STACK_PUSH
0050FD  8B EC                 MOV    bp, sp ; MOV
0050FF  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005102  A3 98 00              MOV    word ptr [0x98], ax ; GLOBAL_LOAD
005105  C9                    LEAVE ; EPILOGUE
005106  CB                    RETF ; RETURN
