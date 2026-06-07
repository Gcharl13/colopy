; ============================================================================
; func_033D6E_unknown
; Region   : load_image
; Bytes    : file 0x033D6E..0x033D9C  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

033D6E  55                    PUSH   bp                           ; UNKNOWN
033D6F  8B EC                 MOV    bp, sp                       ; UNKNOWN
033D71  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
033D74  8B C8                 MOV    cx, ax                       ; UNKNOWN
033D76  D1 E0                 SHL    ax, 1                        ; UNKNOWN
033D78  03 C1                 ADD    ax, cx                       ; UNKNOWN
033D7A  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
033D7D  05 93 00              ADD    ax, 0x93                     ; UNKNOWN
033D80  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
033D83  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
033D85  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
033D88  C7 07 A5 00           MOV    word ptr [bx], 0xa5          ; UNKNOWN
033D8C  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
033D8F  C7 07 0A 00           MOV    word ptr [bx], 0xa           ; UNKNOWN
033D93  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
033D96  C7 07 0C 00           MOV    word ptr [bx], 0xc           ; UNKNOWN
033D9A  C9                    LEAVE                               ; UNKNOWN
033D9B  CB                    RETF                                ; UNKNOWN
