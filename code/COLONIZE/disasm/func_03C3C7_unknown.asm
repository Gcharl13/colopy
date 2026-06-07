; ============================================================================
; func_03C3C7_unknown
; Region   : load_image
; Bytes    : file 0x03C3C7..0x03C3DC  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C3C7  55                    PUSH   bp                           ; UNKNOWN
03C3C8  8B EC                 MOV    bp, sp                       ; UNKNOWN
03C3CA  FF 36 6E 09           PUSH   word ptr [0x96e]             ; UNKNOWN
03C3CE  FF 36 6C 09           PUSH   word ptr [0x96c]             ; UNKNOWN
03C3D2  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03C3D5  9A 02 00 A2 5C        LCALL  0x5ca2, 2                    ; UNKNOWN
03C3DA  C9                    LEAVE                               ; UNKNOWN
03C3DB  CB                    RETF                                ; UNKNOWN
