; ============================================================================
; func_033407_unknown
; Region   : load_image
; Bytes    : file 0x033407..0x03341B  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

033407  55                    PUSH   bp                           ; UNKNOWN
033408  8B EC                 MOV    bp, sp                       ; UNKNOWN
03340A  B8 01 00              MOV    ax, 1                        ; UNKNOWN
03340D  8A 4E 06              MOV    cl, byte ptr [bp + 6]        ; UNKNOWN
033410  D3 E0                 SHL    ax, cl                       ; UNKNOWN
033412  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
033416  23 47 20              AND    ax, word ptr [bx + 0x20]     ; UNKNOWN
033419  C9                    LEAVE                               ; UNKNOWN
03341A  CB                    RETF                                ; UNKNOWN
