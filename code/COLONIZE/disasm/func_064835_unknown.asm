; ============================================================================
; func_064835_unknown
; Region   : load_image
; Bytes    : file 0x064835..0x064873  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064835  55                    PUSH   bp                           ; UNKNOWN
064836  8B EC                 MOV    bp, sp                       ; UNKNOWN
064838  C4 5E 0E              LES    bx, ptr [bp + 0xe]           ; UNKNOWN
06483B  26 C6 47 01 00        MOV    byte ptr es:[bx + 1], 0      ; UNKNOWN
064840  26 88 07              MOV    byte ptr es:[bx], al         ; UNKNOWN
064843  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
064846  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
064849  26 89 47 06           MOV    word ptr es:[bx + 6], ax     ; UNKNOWN
06484D  26 89 57 08           MOV    word ptr es:[bx + 8], dx     ; UNKNOWN
064851  26 89 47 02           MOV    word ptr es:[bx + 2], ax     ; UNKNOWN
064855  26 89 57 04           MOV    word ptr es:[bx + 4], dx     ; UNKNOWN
064859  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
06485C  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
06485F  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax   ; UNKNOWN
064863  26 89 57 10           MOV    word ptr es:[bx + 0x10], dx  ; UNKNOWN
064867  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax   ; UNKNOWN
06486B  26 89 57 0C           MOV    word ptr es:[bx + 0xc], dx   ; UNKNOWN
06486F  C9                    LEAVE                               ; UNKNOWN
064870  CA 0C 00              RETF   0xc                          ; UNKNOWN
