; ============================================================================
; func_040AE2_unknown
; Region   : load_image
; Bytes    : file 0x040AE2..0x040AF3  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040AE2  55                    PUSH   bp                           ; UNKNOWN
040AE3  8B EC                 MOV    bp, sp                       ; UNKNOWN
040AE5  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
040AE9  8A 87 97 88           MOV    al, byte ptr [bx - 0x7769]   ; UNKNOWN
040AED  C0 F8 04              SAR    al, 4                        ; UNKNOWN
040AF0  98                    CWDE                                ; UNKNOWN
040AF1  C9                    LEAVE                               ; UNKNOWN
040AF2  CB                    RETF                                ; UNKNOWN
