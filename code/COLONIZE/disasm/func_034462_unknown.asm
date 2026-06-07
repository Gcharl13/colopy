; ============================================================================
; func_034462_unknown
; Region   : load_image
; Bytes    : file 0x034462..0x034498  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034462  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
034466  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
034469  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
03446E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034471  52                    PUSH   dx                           ; UNKNOWN
034472  50                    PUSH   ax                           ; UNKNOWN
034473  9A 1F 02 13 24        LCALL  0x2413, 0x21f                ; UNKNOWN
034478  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
03447B  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
03447D  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
034481  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
034484  2A E4                 SUB    ah, ah                       ; UNKNOWN
034486  48                    DEC    ax                           ; UNKNOWN
034487  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
03448A  C7 07 25 00           MOV    word ptr [bx], 0x25          ; UNKNOWN
03448E  83 C0 04              ADD    ax, 4                        ; UNKNOWN
034491  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
034494  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
034496  C9                    LEAVE                               ; UNKNOWN
034497  C3                    RET                                 ; UNKNOWN
