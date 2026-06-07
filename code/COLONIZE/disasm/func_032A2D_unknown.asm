; ============================================================================
; func_032A2D_unknown
; Region   : load_image
; Bytes    : file 0x032A2D..0x032A3A  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032A2D  55                    PUSH   bp                           ; UNKNOWN
032A2E  8B EC                 MOV    bp, sp                       ; UNKNOWN
032A30  56                    PUSH   si                           ; UNKNOWN
032A31  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
032A34  69 5E 06 CA 00        IMUL   bx, word ptr [bp + 6], 0xca  ; UNKNOWN
032A39  38                    DB     0x38                         ; UNKNOWN (raw)
