; ============================================================================
; func_069A98_unknown
; Region   : load_image
; Bytes    : file 0x069A98..0x069AAF  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069A98  55                    PUSH   bp                           ; UNKNOWN
069A99  8B EC                 MOV    bp, sp                       ; UNKNOWN
069A9B  8B D7                 MOV    dx, di                       ; UNKNOWN
069A9D  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
069AA0  33 C0                 XOR    ax, ax                       ; UNKNOWN
069AA2  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
069AA5  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
069AA7  F7 D1                 NOT    cx                           ; UNKNOWN
069AA9  49                    DEC    cx                           ; UNKNOWN
069AAA  91                    XCHG   cx, ax                       ; UNKNOWN
069AAB  8B FA                 MOV    di, dx                       ; UNKNOWN
069AAD  5D                    POP    bp                           ; UNKNOWN
069AAE  CB                    RETF                                ; UNKNOWN
