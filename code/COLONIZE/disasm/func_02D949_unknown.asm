; ============================================================================
; func_02D949_unknown
; Region   : load_image
; Bytes    : file 0x02D949..0x02D958  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D949  55                    PUSH   bp                           ; UNKNOWN
02D94A  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D94C  56                    PUSH   si                           ; UNKNOWN
02D94D  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
02D951  7D 05                 JGE    0x2d958                      ; UNKNOWN
02D953  2B C0                 SUB    ax, ax                       ; UNKNOWN
02D955  5E                    POP    si                           ; UNKNOWN
02D956  C9                    LEAVE                               ; UNKNOWN
02D957  CB                    RETF                                ; UNKNOWN
