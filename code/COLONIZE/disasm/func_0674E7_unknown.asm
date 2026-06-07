; ============================================================================
; func_0674E7_unknown
; Region   : load_image
; Bytes    : file 0x0674E7..0x06750A  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0674E7  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0674EB  1E                    PUSH   ds                           ; UNKNOWN
0674EC  06                    PUSH   es                           ; UNKNOWN
0674ED  56                    PUSH   si                           ; UNKNOWN
0674EE  57                    PUSH   di                           ; UNKNOWN
0674EF  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
0674F2  26 8B 5D 02           MOV    bx, word ptr es:[di + 2]     ; UNKNOWN
0674F6  26 8B 75 04           MOV    si, word ptr es:[di + 4]     ; UNKNOWN
0674FA  26 8B 4D 06           MOV    cx, word ptr es:[di + 6]     ; UNKNOWN
0674FE  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
067501  F7 E3                 MUL    bx                           ; UNKNOWN
067503  C1 E2 0C              SHL    dx, 0xc                      ; UNKNOWN
067506  03 CA                 ADD    cx, dx                       ; UNKNOWN
067508  8B D0                 MOV    dx, ax                       ; UNKNOWN
