; ============================================================================
; func_024E5B_unknown
; Region   : load_image
; Bytes    : file 0x024E5B..0x024E9B  (64 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024E5B  55                    PUSH   bp                           ; UNKNOWN
024E5C  8B EC                 MOV    bp, sp                       ; UNKNOWN
024E5E  0B C0                 OR     ax, ax                       ; UNKNOWN
024E60  74 0D                 JE     0x24e6f                      ; UNKNOWN
024E62  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
024E65  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa]       ; UNKNOWN
024E69  26 8B 57 04           MOV    dx, word ptr es:[bx + 4]     ; UNKNOWN
024E6D  EB 1C                 JMP    0x24e8b                      ; UNKNOWN
024E6F  0B D2                 OR     dx, dx                       ; UNKNOWN
024E71  74 0D                 JE     0x24e80                      ; UNKNOWN
024E73  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
024E76  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa]       ; UNKNOWN
024E7A  26 8B 57 06           MOV    dx, word ptr es:[bx + 6]     ; UNKNOWN
024E7E  EB 0B                 JMP    0x24e8b                      ; UNKNOWN
024E80  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
024E83  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa]       ; UNKNOWN
024E87  26 8B 57 02           MOV    dx, word ptr es:[bx + 2]     ; UNKNOWN
024E8B  26 8B 5F 08           MOV    bx, word ptr es:[bx + 8]     ; UNKNOWN
024E8F  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
024E92  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
024E97  C9                    LEAVE                               ; UNKNOWN
024E98  C2 04 00              RET    4                            ; UNKNOWN
