; ============================================================================
; func_008BE6_unknown
; Region   : load_image
; Bytes    : file 0x008BE6..0x008BFA  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008BE6  55                    PUSH   bp ; STACK_PUSH
008BE7  8B EC                 MOV    bp, sp ; MOV
008BE9  FA                    CLI ; FLAG
008BEA  B0 36                 MOV    al, 0x36 ; CONST_LOAD
008BEC  E6 43                 OUT    0x43, al ; IO
008BEE  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
008BF1  E6 40                 OUT    0x40, al ; IO
008BF3  8A C4                 MOV    al, ah ; MOV
008BF5  E6 40                 OUT    0x40, al ; IO
008BF7  FB                    STI ; FLAG
008BF8  C9                    LEAVE ; EPILOGUE
008BF9  CB                    RETF ; RETURN
