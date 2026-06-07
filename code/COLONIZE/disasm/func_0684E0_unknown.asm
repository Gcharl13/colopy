; ============================================================================
; func_0684E0_unknown
; Region   : load_image
; Bytes    : file 0x0684E0..0x0684FC  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0684E0  55                    PUSH   bp                           ; UNKNOWN
0684E1  8B EC                 MOV    bp, sp                       ; UNKNOWN
0684E3  57                    PUSH   di                           ; UNKNOWN
0684E4  56                    PUSH   si                           ; UNKNOWN
0684E5  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
0684E8  26 8B 0D              MOV    cx, word ptr es:[di]         ; UNKNOWN
0684EB  A1 E8 CE              MOV    ax, word ptr [0xcee8]        ; UNKNOWN
0684EE  8B 16 EA CE           MOV    dx, word ptr [0xceea]        ; UNKNOWN
0684F2  83 FA FF              CMP    dx, -1                       ; UNKNOWN
0684F5  74 1C                 JE     0x68513                      ; UNKNOWN
0684F7  50                    PUSH   ax                           ; UNKNOWN
0684F8  0B C2                 OR     ax, dx                       ; UNKNOWN
0684FA  58                    POP    ax                           ; UNKNOWN
0684FB  74                    DB     0x74                         ; UNKNOWN (raw)
