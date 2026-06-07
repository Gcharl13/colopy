; ============================================================================
; func_028887_unknown
; Region   : load_image
; Bytes    : file 0x028887..0x0288A8  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028887  55                    PUSH   bp                           ; UNKNOWN
028888  8B EC                 MOV    bp, sp                       ; UNKNOWN
02888A  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02888D  C4 1E 8E 40           LES    bx, ptr [0x408e]             ; UNKNOWN
028891  26 89 07              MOV    word ptr es:[bx], ax         ; UNKNOWN
028894  6A 00                 PUSH   0                            ; UNKNOWN
028896  6A 01                 PUSH   1                            ; UNKNOWN
028898  0E                    PUSH   cs                           ; UNKNOWN
028899  E8 49 FF              CALL   0x287e5                      ; UNKNOWN
02889C  8B E5                 MOV    sp, bp                       ; UNKNOWN
02889E  6A 00                 PUSH   0                            ; UNKNOWN
0288A0  6A 00                 PUSH   0                            ; UNKNOWN
0288A2  0E                    PUSH   cs                           ; UNKNOWN
0288A3  E8 3F FF              CALL   0x287e5                      ; UNKNOWN
0288A6  C9                    LEAVE                               ; UNKNOWN
0288A7  CB                    RETF                                ; UNKNOWN
