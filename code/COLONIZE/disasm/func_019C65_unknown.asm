; ============================================================================
; func_019C65_unknown
; Region   : load_image
; Bytes    : file 0x019C65..0x019C7C  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019C65  55                    PUSH   bp                           ; UNKNOWN
019C66  8B EC                 MOV    bp, sp                       ; UNKNOWN
019C68  C7 06 18 09 01 00     MOV    word ptr [0x918], 1          ; UNKNOWN
019C6E  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
019C71  A3 E5 32              MOV    word ptr [0x32e5], ax        ; UNKNOWN
019C74  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
019C77  A3 E7 32              MOV    word ptr [0x32e7], ax        ; UNKNOWN
019C7A  C9                    LEAVE                               ; UNKNOWN
019C7B  CB                    RETF                                ; UNKNOWN
