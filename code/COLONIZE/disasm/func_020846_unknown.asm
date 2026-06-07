; ============================================================================
; func_020846_unknown
; Region   : load_image
; Bytes    : file 0x020846..0x020857  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020846  C8 56 00 00           ENTER  0x56, 0                      ; UNKNOWN
02084A  57                    PUSH   di                           ; UNKNOWN
02084B  56                    PUSH   si                           ; UNKNOWN
02084C  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
020851  74 03                 JE     0x20856                      ; UNKNOWN
020853  E9 CA 01              JMP    0x20a20                      ; UNKNOWN
020856  6A                    DB     0x6A                         ; UNKNOWN (raw)
