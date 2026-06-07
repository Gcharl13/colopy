; ============================================================================
; func_0094E6_unknown
; Region   : load_image
; Bytes    : file 0x0094E6..0x0094FD  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0094E6  55                    PUSH   bp                           ; UNKNOWN
0094E7  8B EC                 MOV    bp, sp                       ; UNKNOWN
0094E9  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0094EC  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
0094EF  8B D8                 MOV    bx, ax                       ; UNKNOWN
0094F1  C1 EB 04              SHR    bx, 4                        ; UNKNOWN
0094F4  03 D3                 ADD    dx, bx                       ; UNKNOWN
0094F6  25 0F 00              AND    ax, 0xf                      ; UNKNOWN
0094F9  C9                    LEAVE                               ; UNKNOWN
0094FA  CA 04 00              RETF   4                            ; UNKNOWN
