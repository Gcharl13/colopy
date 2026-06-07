; ============================================================================
; func_032E24_unknown
; Region   : load_image
; Bytes    : file 0x032E24..0x032E39  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032E24  55                    PUSH   bp                           ; UNKNOWN
032E25  8B EC                 MOV    bp, sp                       ; UNKNOWN
032E27  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
032E2A  A3 9A 79              MOV    word ptr [0x799a], ax        ; UNKNOWN
032E2D  69 C0 3C 01           IMUL   ax, ax, 0x13c                ; UNKNOWN
032E31  05 AA 74              ADD    ax, 0x74aa                   ; UNKNOWN
032E34  A3 A8 74              MOV    word ptr [0x74a8], ax        ; UNKNOWN
032E37  C9                    LEAVE                               ; UNKNOWN
032E38  CB                    RETF                                ; UNKNOWN
