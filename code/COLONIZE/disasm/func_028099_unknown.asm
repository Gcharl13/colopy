; ============================================================================
; func_028099_unknown
; Region   : load_image
; Bytes    : file 0x028099..0x0280B1  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028099  55                    PUSH   bp                           ; UNKNOWN
02809A  8B EC                 MOV    bp, sp                       ; UNKNOWN
02809C  C7 06 04 0A 08 00     MOV    word ptr [0xa04], 8          ; UNKNOWN
0280A2  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0280A6  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0280A9  2B D2                 SUB    dx, dx                       ; UNKNOWN
0280AB  0E                    PUSH   cs                           ; UNKNOWN
0280AC  E8 30 FF              CALL   0x27fdf                      ; UNKNOWN
0280AF  C9                    LEAVE                               ; UNKNOWN
0280B0  CB                    RETF                                ; UNKNOWN
