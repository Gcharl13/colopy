; ============================================================================
; func_065050_unknown
; Region   : load_image
; Bytes    : file 0x065050..0x065064  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065050  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
065054  52                    PUSH   dx                           ; UNKNOWN
065055  50                    PUSH   ax                           ; UNKNOWN
065056  56                    PUSH   si                           ; UNKNOWN
065057  8B C8                 MOV    cx, ax                       ; UNKNOWN
065059  D1 E0                 SHL    ax, 1                        ; UNKNOWN
06505B  03 C1                 ADD    ax, cx                       ; UNKNOWN
06505D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
065060  8B C2                 MOV    ax, dx                       ; UNKNOWN
065062  D1 E2                 SHL    dx, 1                        ; UNKNOWN
