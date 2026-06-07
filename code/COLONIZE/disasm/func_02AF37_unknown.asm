; ============================================================================
; func_02AF37_unknown
; Region   : load_image
; Bytes    : file 0x02AF37..0x02AF5B  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AF37  55                    PUSH   bp                           ; UNKNOWN
02AF38  8B EC                 MOV    bp, sp                       ; UNKNOWN
02AF3A  56                    PUSH   si                           ; UNKNOWN
02AF3B  2B F6                 SUB    si, si                       ; UNKNOWN
02AF3D  9A F6 00 28 1A        LCALL  0x1a28, 0xf6                 ; UNKNOWN
02AF42  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
02AF47  0B C0                 OR     ax, ax                       ; UNKNOWN
02AF49  74 07                 JE     0x2af52                      ; UNKNOWN
02AF4B  9A 14 00 9A 5B        LCALL  0x5b9a, 0x14                 ; UNKNOWN
02AF50  8B F0                 MOV    si, ax                       ; UNKNOWN
02AF52  0B F6                 OR     si, si                       ; UNKNOWN
02AF54  74 E7                 JE     0x2af3d                      ; UNKNOWN
02AF56  8B C6                 MOV    ax, si                       ; UNKNOWN
02AF58  5E                    POP    si                           ; UNKNOWN
02AF59  C9                    LEAVE                               ; UNKNOWN
02AF5A  CB                    RETF                                ; UNKNOWN
