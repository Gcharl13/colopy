; ============================================================================
; func_009B1C_unknown
; Region   : load_image
; Bytes    : file 0x009B1C..0x009B30  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009B1C  55                    PUSH   bp ; STACK_PUSH
009B1D  8B EC                 MOV    bp, sp ; MOV
009B1F  FA                    CLI ; FLAG
009B20  B0 36                 MOV    al, 0x36 ; CONST_LOAD
009B22  E6 43                 OUT    0x43, al ; IO
009B24  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
009B27  E6 40                 OUT    0x40, al ; IO
009B29  8A C4                 MOV    al, ah ; MOV
009B2B  E6 40                 OUT    0x40, al ; IO
009B2D  FB                    STI ; FLAG
009B2E  C9                    LEAVE ; EPILOGUE
009B2F  CB                    RETF ; RETURN
