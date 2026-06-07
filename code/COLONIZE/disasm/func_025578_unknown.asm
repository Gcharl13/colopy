; ============================================================================
; func_025578_unknown
; Region   : load_image
; Bytes    : file 0x025578..0x025587  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025578  55                    PUSH   bp                           ; UNKNOWN
025579  8B EC                 MOV    bp, sp                       ; UNKNOWN
02557B  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
02557E  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
025581  26 89 47 28           MOV    word ptr es:[bx + 0x28], ax  ; UNKNOWN
025585  C9                    LEAVE                               ; UNKNOWN
025586  CB                    RETF                                ; UNKNOWN
