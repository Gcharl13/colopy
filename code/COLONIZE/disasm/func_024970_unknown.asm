; ============================================================================
; func_024970_unknown
; Region   : load_image
; Bytes    : file 0x024970..0x0249B1  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024970  55                    PUSH   bp                           ; UNKNOWN
024971  8B EC                 MOV    bp, sp                       ; UNKNOWN
024973  56                    PUSH   si                           ; UNKNOWN
024974  8B 46 04              MOV    ax, word ptr [bp + 4]        ; UNKNOWN
024977  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
02497A  05 84 00              ADD    ax, 0x84                     ; UNKNOWN
02497D  52                    PUSH   dx                           ; UNKNOWN
02497E  50                    PUSH   ax                           ; UNKNOWN
02497F  53                    PUSH   bx                           ; UNKNOWN
024980  8B F3                 MOV    si, bx                       ; UNKNOWN
024982  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
024987  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02498A  40                    INC    ax                           ; UNKNOWN
02498B  2B D2                 SUB    dx, dx                       ; UNKNOWN
02498D  9A 0E 01 7A 5B        LCALL  0x5b7a, 0x10e                ; UNKNOWN
024992  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
024995  26 89 47 6C           MOV    word ptr es:[bx + 0x6c], ax  ; UNKNOWN
024999  26 89 57 6E           MOV    word ptr es:[bx + 0x6e], dx  ; UNKNOWN
02499D  1E                    PUSH   ds                           ; UNKNOWN
02499E  56                    PUSH   si                           ; UNKNOWN
02499F  52                    PUSH   dx                           ; UNKNOWN
0249A0  26 FF 77 6C           PUSH   word ptr es:[bx + 0x6c]      ; UNKNOWN
0249A4  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
0249A9  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0249AC  5E                    POP    si                           ; UNKNOWN
0249AD  C9                    LEAVE                               ; UNKNOWN
0249AE  C2 04 00              RET    4                            ; UNKNOWN
