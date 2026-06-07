; ============================================================================
; func_040B12_unknown
; Region   : load_image
; Bytes    : file 0x040B12..0x040B37  (37 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040B12  55                    PUSH   bp                           ; UNKNOWN
040B13  8B EC                 MOV    bp, sp                       ; UNKNOWN
040B15  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
040B19  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
040B1D  2A FF                 SUB    bh, bh                       ; UNKNOWN
040B1F  83 FB 04              CMP    bx, 4                        ; UNKNOWN
040B22  74 13                 JE     0x40b37                      ; UNKNOWN
040B24  83 FB 05              CMP    bx, 5                        ; UNKNOWN
040B27  74 0E                 JE     0x40b37                      ; UNKNOWN
040B29  83 FB 15              CMP    bx, 0x15                     ; UNKNOWN
040B2C  74 09                 JE     0x40b37                      ; UNKNOWN
040B2E  83 FB 16              CMP    bx, 0x16                     ; UNKNOWN
040B31  74 04                 JE     0x40b37                      ; UNKNOWN
040B33  2B C0                 SUB    ax, ax                       ; UNKNOWN
040B35  C9                    LEAVE                               ; UNKNOWN
040B36  CB                    RETF                                ; UNKNOWN
