; ============================================================================
; func_0294D2_unknown
; Region   : load_image
; Bytes    : file 0x0294D2..0x0294FC  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0294D2  C8 64 00 00           ENTER  0x64, 0                      ; UNKNOWN
0294D6  56                    PUSH   si                           ; UNKNOWN
0294D7  83 3E 18 3E 0C        CMP    word ptr [0x3e18], 0xc       ; UNKNOWN
0294DC  7C 1E                 JL     0x294fc                      ; UNKNOWN
0294DE  C7 06 2A 3F 0C 00     MOV    word ptr [0x3f2a], 0xc       ; UNKNOWN
0294E4  C7 06 2C 3F 00 00     MOV    word ptr [0x3f2c], 0         ; UNKNOWN
0294EA  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0294EE  8D 06 D1 19           LEA    ax, [0x19d1]                 ; UNKNOWN
0294F2  2B D2                 SUB    dx, dx                       ; UNKNOWN
0294F4  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
0294F9  5E                    POP    si                           ; UNKNOWN
0294FA  C9                    LEAVE                               ; UNKNOWN
0294FB  CB                    RETF                                ; UNKNOWN
