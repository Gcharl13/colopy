; ============================================================================
; func_02AE97_unknown
; Region   : load_image
; Bytes    : file 0x02AE97..0x02AECC  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AE97  55                    PUSH   bp                           ; UNKNOWN
02AE98  8B EC                 MOV    bp, sp                       ; UNKNOWN
02AE9A  56                    PUSH   si                           ; UNKNOWN
02AE9B  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02AE9E  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02AEA1  50                    PUSH   ax                           ; UNKNOWN
02AEA2  56                    PUSH   si                           ; UNKNOWN
02AEA3  1E                    PUSH   ds                           ; UNKNOWN
02AEA4  68 A2 40              PUSH   0x40a2                       ; UNKNOWN
02AEA7  50                    PUSH   ax                           ; UNKNOWN
02AEA8  56                    PUSH   si                           ; UNKNOWN
02AEA9  9A 48 14 65 5F        LCALL  0x5f65, 0x1448               ; UNKNOWN
02AEAE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02AEB1  40                    INC    ax                           ; UNKNOWN
02AEB2  99                    CDQ                                 ; UNKNOWN
02AEB3  9A 0E 01 7A 5B        LCALL  0x5b7a, 0x10e                ; UNKNOWN
02AEB8  52                    PUSH   dx                           ; UNKNOWN
02AEB9  50                    PUSH   ax                           ; UNKNOWN
02AEBA  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
02AEBF  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02AEC2  A1 B4 40              MOV    ax, word ptr [0x40b4]        ; UNKNOWN
02AEC5  FF 06 B4 40           INC    word ptr [0x40b4]            ; UNKNOWN
02AEC9  5E                    POP    si                           ; UNKNOWN
02AECA  C9                    LEAVE                               ; UNKNOWN
02AECB  CB                    RETF                                ; UNKNOWN
