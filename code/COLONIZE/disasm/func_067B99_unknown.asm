; ============================================================================
; func_067B99_unknown
; Region   : load_image
; Bytes    : file 0x067B99..0x067BB8  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067B99  55                    PUSH   bp                           ; UNKNOWN
067B9A  8B EC                 MOV    bp, sp                       ; UNKNOWN
067B9C  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
067B9F  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
067BA2  A3 76 11              MOV    word ptr [0x1176], ax        ; UNKNOWN
067BA5  89 16 78 11           MOV    word ptr [0x1178], dx        ; UNKNOWN
067BA9  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
067BAC  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
067BAF  A3 7A 11              MOV    word ptr [0x117a], ax        ; UNKNOWN
067BB2  89 16 7C 11           MOV    word ptr [0x117c], dx        ; UNKNOWN
067BB6  C9                    LEAVE                               ; UNKNOWN
067BB7  CB                    RETF                                ; UNKNOWN
