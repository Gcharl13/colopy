; ============================================================================
; func_040AB8_unknown
; Region   : load_image
; Bytes    : file 0x040AB8..0x040AC8  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040AB8  55                    PUSH   bp                           ; UNKNOWN
040AB9  8B EC                 MOV    bp, sp                       ; UNKNOWN
040ABB  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
040ABF  8A 87 97 88           MOV    al, byte ptr [bx - 0x7769]   ; UNKNOWN
040AC3  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
040AC6  C9                    LEAVE                               ; UNKNOWN
040AC7  CB                    RETF                                ; UNKNOWN
