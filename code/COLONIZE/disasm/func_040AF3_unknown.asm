; ============================================================================
; func_040AF3_unknown
; Region   : load_image
; Bytes    : file 0x040AF3..0x040B12  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040AF3  55                    PUSH   bp                           ; UNKNOWN
040AF4  8B EC                 MOV    bp, sp                       ; UNKNOWN
040AF6  56                    PUSH   si                           ; UNKNOWN
040AF7  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
040AFA  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040AFD  8A 87 97 88           MOV    al, byte ptr [bx - 0x7769]   ; UNKNOWN
040B01  24 0F                 AND    al, 0xf                      ; UNKNOWN
040B03  8A 4E 08              MOV    cl, byte ptr [bp + 8]        ; UNKNOWN
040B06  C0 E1 04              SHL    cl, 4                        ; UNKNOWN
040B09  0A C1                 OR     al, cl                       ; UNKNOWN
040B0B  88 87 97 88           MOV    byte ptr [bx - 0x7769], al   ; UNKNOWN
040B0F  5E                    POP    si                           ; UNKNOWN
040B10  C9                    LEAVE                               ; UNKNOWN
040B11  CB                    RETF                                ; UNKNOWN
