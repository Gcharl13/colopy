; ============================================================================
; func_048A79_unknown
; Region   : load_image
; Bytes    : file 0x048A79..0x048A8F  (22 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048A79  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
048A7D  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
048A82  B8 B0 01              MOV    ax, 0x1b0                    ; UNKNOWN
048A85  99                    CDQ                                 ; UNKNOWN
048A86  9A FC 00 4F 00        LCALL  0x4f, 0xfc                   ; UNKNOWN
048A8B  A3 CA 0B              MOV    word ptr [0xbca], ax         ; UNKNOWN
048A8E  89                    DB     0x89                         ; UNKNOWN (raw)
