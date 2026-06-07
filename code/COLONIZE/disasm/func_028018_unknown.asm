; ============================================================================
; func_028018_unknown
; Region   : load_image
; Bytes    : file 0x028018..0x028031  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028018  55                    PUSH   bp                           ; UNKNOWN
028019  8B EC                 MOV    bp, sp                       ; UNKNOWN
02801B  50                    PUSH   ax                           ; UNKNOWN
02801C  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
02801F  0B D2                 OR     dx, dx                       ; UNKNOWN
028021  74 0E                 JE     0x28031                      ; UNKNOWN
028023  8A 4E FE              MOV    cl, byte ptr [bp - 2]        ; UNKNOWN
028026  B8 01 00              MOV    ax, 1                        ; UNKNOWN
028029  D3 E0                 SHL    ax, cl                       ; UNKNOWN
02802B  09 06 FC 09           OR     word ptr [0x9fc], ax         ; UNKNOWN
02802F  C9                    LEAVE                               ; UNKNOWN
028030  CB                    RETF                                ; UNKNOWN
