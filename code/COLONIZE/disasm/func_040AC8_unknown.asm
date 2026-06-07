; ============================================================================
; func_040AC8_unknown
; Region   : load_image
; Bytes    : file 0x040AC8..0x040AE2  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040AC8  55                    PUSH   bp                           ; UNKNOWN
040AC9  8B EC                 MOV    bp, sp                       ; UNKNOWN
040ACB  56                    PUSH   si                           ; UNKNOWN
040ACC  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
040ACF  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040AD2  8A 87 97 88           MOV    al, byte ptr [bx - 0x7769]   ; UNKNOWN
040AD6  32 46 08              XOR    al, byte ptr [bp + 8]        ; UNKNOWN
040AD9  24 0F                 AND    al, 0xf                      ; UNKNOWN
040ADB  30 87 97 88           XOR    byte ptr [bx - 0x7769], al   ; UNKNOWN
040ADF  5E                    POP    si                           ; UNKNOWN
040AE0  C9                    LEAVE                               ; UNKNOWN
040AE1  CB                    RETF                                ; UNKNOWN
