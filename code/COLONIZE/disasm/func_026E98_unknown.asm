; ============================================================================
; func_026E98_unknown
; Region   : load_image
; Bytes    : file 0x026E98..0x026EBA  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026E98  55                    PUSH   bp                           ; UNKNOWN
026E99  8B EC                 MOV    bp, sp                       ; UNKNOWN
026E9B  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
026E9E  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
026EA1  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026EA4  26 89 47 50           MOV    word ptr es:[bx + 0x50], ax  ; UNKNOWN
026EA8  26 89 57 52           MOV    word ptr es:[bx + 0x52], dx  ; UNKNOWN
026EAC  06                    PUSH   es                           ; UNKNOWN
026EAD  53                    PUSH   bx                           ; UNKNOWN
026EAE  2B C0                 SUB    ax, ax                       ; UNKNOWN
026EB0  BA 01 00              MOV    dx, 1                        ; UNKNOWN
026EB3  8B DA                 MOV    bx, dx                       ; UNKNOWN
026EB5  E8 A9 FA              CALL   0x26961                      ; UNKNOWN
026EB8  C9                    LEAVE                               ; UNKNOWN
026EB9  CB                    RETF                                ; UNKNOWN
