; ============================================================================
; func_028041_unknown
; Region   : load_image
; Bytes    : file 0x028041..0x028056  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028041  55                    PUSH   bp                           ; UNKNOWN
028042  8B EC                 MOV    bp, sp                       ; UNKNOWN
028044  50                    PUSH   ax                           ; UNKNOWN
028045  B8 01 00              MOV    ax, 1                        ; UNKNOWN
028048  29 46 FE              SUB    word ptr [bp - 2], ax        ; UNKNOWN
02804B  8A 4E FE              MOV    cl, byte ptr [bp - 2]        ; UNKNOWN
02804E  D3 E0                 SHL    ax, cl                       ; UNKNOWN
028050  23 06 FC 09           AND    ax, word ptr [0x9fc]         ; UNKNOWN
028054  C9                    LEAVE                               ; UNKNOWN
028055  CB                    RETF                                ; UNKNOWN
