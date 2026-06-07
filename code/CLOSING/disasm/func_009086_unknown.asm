; ============================================================================
; func_009086_unknown
; Region   : load_image
; Bytes    : file 0x009086..0x00909A  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009086  55                    PUSH   bp ; STACK_PUSH
009087  8B EC                 MOV    bp, sp ; MOV
009089  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00908C  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00908F  A3 E6 3E              MOV    word ptr [0x3ee6], ax ; GLOBAL_LOAD
009092  89 16 E8 3E           MOV    word ptr [0x3ee8], dx ; GLOBAL_LOAD
009096  C9                    LEAVE ; EPILOGUE
009097  CA 04 00              RETF   4 ; RETURN
