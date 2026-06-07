; ============================================================================
; func_06990E_unknown
; Region   : load_image
; Bytes    : file 0x06990E..0x06992A  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06990E  55                    PUSH   bp                           ; UNKNOWN
06990F  8B EC                 MOV    bp, sp                       ; UNKNOWN
069911  8B 4E 0E              MOV    cx, word ptr [bp + 0xe]      ; UNKNOWN
069914  1E                    PUSH   ds                           ; UNKNOWN
069915  57                    PUSH   di                           ; UNKNOWN
069916  56                    PUSH   si                           ; UNKNOWN
069917  E3 48                 JCXZ   0x69961                      ; UNKNOWN
069919  C5 76 0A              LDS    si, ptr [bp + 0xa]           ; UNKNOWN
06991C  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
06991F  8B C1                 MOV    ax, cx                       ; UNKNOWN
069921  48                    DEC    ax                           ; UNKNOWN
069922  8B D7                 MOV    dx, di                       ; UNKNOWN
069924  F7 D2                 NOT    dx                           ; UNKNOWN
069926  2B C2                 SUB    ax, dx                       ; UNKNOWN
069928  1B DB                 SBB    bx, bx                       ; UNKNOWN
