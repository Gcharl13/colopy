; ============================================================================
; func_024DAD_unknown
; Region   : load_image
; Bytes    : file 0x024DAD..0x024DEC  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024DAD  55                    PUSH   bp                           ; UNKNOWN
024DAE  8B EC                 MOV    bp, sp                       ; UNKNOWN
024DB0  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
024DB3  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
024DB6  26 89 07              MOV    word ptr es:[bx], ax         ; UNKNOWN
024DB9  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
024DBC  26 89 47 02           MOV    word ptr es:[bx + 2], ax     ; UNKNOWN
024DC0  8B 46 12              MOV    ax, word ptr [bp + 0x12]     ; UNKNOWN
024DC3  26 89 47 04           MOV    word ptr es:[bx + 4], ax     ; UNKNOWN
024DC7  8B 46 14              MOV    ax, word ptr [bp + 0x14]     ; UNKNOWN
024DCA  26 89 47 06           MOV    word ptr es:[bx + 6], ax     ; UNKNOWN
024DCE  8B 46 16              MOV    ax, word ptr [bp + 0x16]     ; UNKNOWN
024DD1  26 89 47 08           MOV    word ptr es:[bx + 8], ax     ; UNKNOWN
024DD5  8B 46 18              MOV    ax, word ptr [bp + 0x18]     ; UNKNOWN
024DD8  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax   ; UNKNOWN
024DDC  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
024DDF  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
024DE2  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax   ; UNKNOWN
024DE6  26 89 57 0E           MOV    word ptr es:[bx + 0xe], dx   ; UNKNOWN
024DEA  C9                    LEAVE                               ; UNKNOWN
024DEB  CB                    RETF                                ; UNKNOWN
