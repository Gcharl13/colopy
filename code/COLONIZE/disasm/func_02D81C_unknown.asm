; ============================================================================
; func_02D81C_unknown
; Region   : load_image
; Bytes    : file 0x02D81C..0x02D831  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D81C  55                    PUSH   bp                           ; UNKNOWN
02D81D  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D81F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D822  0E                    PUSH   cs                           ; UNKNOWN
02D823  E8 E3 FF              CALL   0x2d809                      ; UNKNOWN
02D826  8B D8                 MOV    bx, ax                       ; UNKNOWN
02D828  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
02D82B  8B 87 33 38           MOV    ax, word ptr [bx + 0x3833]   ; UNKNOWN
02D82F  C9                    LEAVE                               ; UNKNOWN
02D830  CB                    RETF                                ; UNKNOWN
