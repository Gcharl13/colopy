; ============================================================================
; func_066065_unknown
; Region   : load_image
; Bytes    : file 0x066065..0x066075  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066065  55                    PUSH   bp                           ; UNKNOWN
066066  8B EC                 MOV    bp, sp                       ; UNKNOWN
066068  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
06606B  89 87 08 0F           MOV    word ptr [bx + 0xf08], ax    ; UNKNOWN
06606F  FE 06 18 0F           INC    byte ptr [0xf18]             ; UNKNOWN
066073  5D                    POP    bp                           ; UNKNOWN
066074  CB                    RETF                                ; UNKNOWN
