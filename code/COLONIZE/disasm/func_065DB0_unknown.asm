; ============================================================================
; func_065DB0_unknown
; Region   : load_image
; Bytes    : file 0x065DB0..0x065DDE  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065DB0  C8 10 00 00           ENTER  0x10, 0                      ; UNKNOWN
065DB4  50                    PUSH   ax                           ; UNKNOWN
065DB5  57                    PUSH   di                           ; UNKNOWN
065DB6  56                    PUSH   si                           ; UNKNOWN
065DB7  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
065DBC  1E                    PUSH   ds                           ; UNKNOWN
065DBD  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
065DC0  8B 76 F0              MOV    si, word ptr [bp - 0x10]     ; UNKNOWN
065DC3  8B DE                 MOV    bx, si                       ; UNKNOWN
065DC5  D1 E3                 SHL    bx, 1                        ; UNKNOWN
065DC7  8B 56 EE              MOV    dx, word ptr [bp - 0x12]     ; UNKNOWN
065DCA  4A                    DEC    dx                           ; UNKNOWN
065DCB  3B F2                 CMP    si, dx                       ; UNKNOWN
065DCD  7C 03                 JL     0x65dd2                      ; UNKNOWN
065DCF  E9 9A 00              JMP    0x65e6c                      ; UNKNOWN
065DD2  26 8B 41 02           MOV    ax, word ptr es:[bx + di + 2] ; UNKNOWN
065DD6  26 3B 01              CMP    ax, word ptr es:[bx + di]    ; UNKNOWN
065DD9  72 09                 JB     0x65de4                      ; UNKNOWN
065DDB  46                    INC    si                           ; UNKNOWN
065DDC  83                    DB     0x83                         ; UNKNOWN (raw)
065DDD  C3                    DB     0xC3                         ; UNKNOWN (raw)
