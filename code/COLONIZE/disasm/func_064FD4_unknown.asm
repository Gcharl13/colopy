; ============================================================================
; func_064FD4_unknown
; Region   : load_image
; Bytes    : file 0x064FD4..0x064FE8  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064FD4  55                    PUSH   bp                           ; UNKNOWN
064FD5  8B EC                 MOV    bp, sp                       ; UNKNOWN
064FD7  BA DA 03              MOV    dx, 0x3da                    ; UNKNOWN
064FDA  B4 08                 MOV    ah, 8                        ; UNKNOWN
064FDC  EC                    IN     al, dx                       ; UNKNOWN
064FDD  22 C4                 AND    al, ah                       ; UNKNOWN
064FDF  75 FB                 JNE    0x64fdc                      ; UNKNOWN
064FE1  EC                    IN     al, dx                       ; UNKNOWN
064FE2  22 C4                 AND    al, ah                       ; UNKNOWN
064FE4  74 FB                 JE     0x64fe1                      ; UNKNOWN
064FE6  C9                    LEAVE                               ; UNKNOWN
064FE7  CB                    RETF                                ; UNKNOWN
