; ============================================================================
; func_078856_unknown
; Region   : overlay
; Bytes    : file 0x078856..0x078872  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078856  55                    PUSH   bp ; STACK_PUSH
078857  8B EC                 MOV    bp, sp ; MOV
078859  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
07885C  0B 46 08              OR     ax, word ptr [bp + 8] ; LOGIC
07885F  74 0F                 JE     0x78870 ; CJUMP
078861  C7 06 72 26 01 00     MOV    word ptr [0x2672], 1 ; GLOBAL_LOAD
078867  FF 5E 06              LCALL  [bp + 6] ; LCALL
07886A  C7 06 72 26 00 00     MOV    word ptr [0x2672], 0 ; GLOBAL_LOAD
078870  C9                    LEAVE ; EPILOGUE
078871  CB                    RETF ; RETURN
