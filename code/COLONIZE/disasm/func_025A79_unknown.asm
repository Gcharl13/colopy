; ============================================================================
; func_025A79_unknown
; Region   : load_image
; Bytes    : file 0x025A79..0x025AB6  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025A79  55                    PUSH   bp                           ; UNKNOWN
025A7A  8B EC                 MOV    bp, sp                       ; UNKNOWN
025A7C  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
025A7F  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
025A82  05 84 00              ADD    ax, 0x84                     ; UNKNOWN
025A85  52                    PUSH   dx                           ; UNKNOWN
025A86  50                    PUSH   ax                           ; UNKNOWN
025A87  B8 14 00              MOV    ax, 0x14                     ; UNKNOWN
025A8A  99                    CDQ                                 ; UNKNOWN
025A8B  9A 0E 01 7A 5B        LCALL  0x5b7a, 0x10e                ; UNKNOWN
025A90  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
025A93  26 89 47 64           MOV    word ptr es:[bx + 0x64], ax  ; UNKNOWN
025A97  26 89 57 66           MOV    word ptr es:[bx + 0x66], dx  ; UNKNOWN
025A9B  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
025A9E  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
025AA1  26 C4 5F 64           LES    bx, ptr es:[bx + 0x64]       ; UNKNOWN
025AA5  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax   ; UNKNOWN
025AA9  26 89 57 0E           MOV    word ptr es:[bx + 0xe], dx   ; UNKNOWN
025AAD  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
025AB0  26 89 47 04           MOV    word ptr es:[bx + 4], ax     ; UNKNOWN
025AB4  8B C3                 MOV    ax, bx                       ; UNKNOWN
