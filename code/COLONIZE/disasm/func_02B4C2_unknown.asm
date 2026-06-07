; ============================================================================
; func_02B4C2_unknown
; Region   : load_image
; Bytes    : file 0x02B4C2..0x02B4E0  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B4C2  55                    PUSH   bp                           ; UNKNOWN
02B4C3  8B EC                 MOV    bp, sp                       ; UNKNOWN
02B4C5  56                    PUSH   si                           ; UNKNOWN
02B4C6  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; UNKNOWN
02B4CA  7C 14                 JL     0x2b4e0                      ; UNKNOWN
02B4CC  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
02B4CF  6B 76 06 4E           IMUL   si, word ptr [bp + 6], 0x4e  ; UNKNOWN
02B4D3  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
02B4D6  88 80 C6 7E           MOV    byte ptr [bx + si + 0x7ec6], al ; UNKNOWN
02B4DA  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
02B4DD  5E                    POP    si                           ; UNKNOWN
02B4DE  C9                    LEAVE                               ; UNKNOWN
02B4DF  CB                    RETF                                ; UNKNOWN
