; ============================================================================
; func_011BB6_unknown
; Region   : load_image
; Bytes    : file 0x011BB6..0x011BCA  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011BB6  55                    PUSH   bp ; STACK_PUSH
011BB7  8B EC                 MOV    bp, sp ; MOV
011BB9  FA                    CLI ; FLAG
011BBA  B0 36                 MOV    al, 0x36 ; CONST_LOAD
011BBC  E6 43                 OUT    0x43, al ; IO
011BBE  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
011BC1  E6 40                 OUT    0x40, al ; IO
011BC3  8A C4                 MOV    al, ah ; MOV
011BC5  E6 40                 OUT    0x40, al ; IO
011BC7  FB                    STI ; FLAG
011BC8  C9                    LEAVE ; EPILOGUE
011BC9  CB                    RETF ; RETURN
