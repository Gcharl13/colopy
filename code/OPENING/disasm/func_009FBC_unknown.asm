; ============================================================================
; func_009FBC_unknown
; Region   : load_image
; Bytes    : file 0x009FBC..0x009FD0  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009FBC  55                    PUSH   bp ; STACK_PUSH
009FBD  8B EC                 MOV    bp, sp ; MOV
009FBF  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
009FC2  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
009FC5  A3 3C 41              MOV    word ptr [0x413c], ax ; GLOBAL_LOAD
009FC8  89 16 3E 41           MOV    word ptr [0x413e], dx ; GLOBAL_LOAD
009FCC  C9                    LEAVE ; EPILOGUE
009FCD  CA 04 00              RETF   4 ; RETURN
