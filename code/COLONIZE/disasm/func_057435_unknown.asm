; ============================================================================
; func_057435_unknown
; Region   : load_image
; Bytes    : file 0x057435..0x057458  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

057435  C8 3A 00 00           ENTER  0x3a, 0                      ; UNKNOWN
057439  57                    PUSH   di                           ; UNKNOWN
05743A  56                    PUSH   si                           ; UNKNOWN
05743B  2B C0                 SUB    ax, ax                       ; UNKNOWN
05743D  89 46 CC              MOV    word ptr [bp - 0x34], ax     ; UNKNOWN
057440  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
057443  89 46 D8              MOV    word ptr [bp - 0x28], ax     ; UNKNOWN
057446  C7 46 DC 01 00        MOV    word ptr [bp - 0x24], 1      ; UNKNOWN
05744B  81 7E 06 FF 01        CMP    word ptr [bp + 6], 0x1ff     ; UNKNOWN
057450  7C 06                 JL     0x57458                      ; UNKNOWN
057452  2B C0                 SUB    ax, ax                       ; UNKNOWN
057454  5E                    POP    si                           ; UNKNOWN
057455  5F                    POP    di                           ; UNKNOWN
057456  C9                    LEAVE                               ; UNKNOWN
057457  CB                    RETF                                ; UNKNOWN
