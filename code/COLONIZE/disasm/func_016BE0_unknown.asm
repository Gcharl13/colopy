; ============================================================================
; func_016BE0_unknown
; Region   : load_image
; Bytes    : file 0x016BE0..0x016BF2  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016BE0  55                    PUSH   bp                           ; UNKNOWN
016BE1  8B EC                 MOV    bp, sp                       ; UNKNOWN
016BE3  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
016BE6  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
016BE9  A3 38 08              MOV    word ptr [0x838], ax         ; UNKNOWN
016BEC  89 16 3A 08           MOV    word ptr [0x83a], dx         ; UNKNOWN
016BF0  C9                    LEAVE                               ; UNKNOWN
016BF1  CB                    RETF                                ; UNKNOWN
