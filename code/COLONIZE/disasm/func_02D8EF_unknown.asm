; ============================================================================
; func_02D8EF_unknown
; Region   : load_image
; Bytes    : file 0x02D8EF..0x02D911  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D8EF  55                    PUSH   bp                           ; UNKNOWN
02D8F0  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D8F2  56                    PUSH   si                           ; UNKNOWN
02D8F3  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02D8F6  C1 FE 03              SAR    si, 3                        ; UNKNOWN
02D8F9  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02D8FD  8A 80 8A 00           MOV    al, byte ptr [bx + si + 0x8a] ; UNKNOWN
02D901  98                    CWDE                                ; UNKNOWN
02D902  8A 4E 06              MOV    cl, byte ptr [bp + 6]        ; UNKNOWN
02D905  80 E1 07              AND    cl, 7                        ; UNKNOWN
02D908  BA 01 00              MOV    dx, 1                        ; UNKNOWN
02D90B  D3 E2                 SHL    dx, cl                       ; UNKNOWN
02D90D  23 C2                 AND    ax, dx                       ; UNKNOWN
02D90F  5E                    POP    si                           ; UNKNOWN
02D910  C9                    LEAVE                               ; UNKNOWN
