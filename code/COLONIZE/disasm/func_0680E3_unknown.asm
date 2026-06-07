; ============================================================================
; func_0680E3_unknown
; Region   : load_image
; Bytes    : file 0x0680E3..0x0680F7  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0680E3  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
0680E7  56                    PUSH   si                           ; UNKNOWN
0680E8  57                    PUSH   di                           ; UNKNOWN
0680E9  1E                    PUSH   ds                           ; UNKNOWN
0680EA  C4 46 06              LES    ax, ptr [bp + 6]             ; UNKNOWN
0680ED  83 C0 0F              ADD    ax, 0xf                      ; UNKNOWN
0680F0  C1 E8 04              SHR    ax, 4                        ; UNKNOWN
0680F3  8C C2                 MOV    dx, es                       ; UNKNOWN
0680F5  03 D0                 ADD    dx, ax                       ; UNKNOWN
