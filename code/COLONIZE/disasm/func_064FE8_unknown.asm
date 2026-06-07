; ============================================================================
; func_064FE8_unknown
; Region   : load_image
; Bytes    : file 0x064FE8..0x064FFD  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064FE8  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
064FEC  52                    PUSH   dx                           ; UNKNOWN
064FED  50                    PUSH   ax                           ; UNKNOWN
064FEE  57                    PUSH   di                           ; UNKNOWN
064FEF  56                    PUSH   si                           ; UNKNOWN
064FF0  8B C8                 MOV    cx, ax                       ; UNKNOWN
064FF2  D1 E0                 SHL    ax, 1                        ; UNKNOWN
064FF4  03 C1                 ADD    ax, cx                       ; UNKNOWN
064FF6  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
064FF9  8B C2                 MOV    ax, dx                       ; UNKNOWN
064FFB  D1 E2                 SHL    dx, 1                        ; UNKNOWN
