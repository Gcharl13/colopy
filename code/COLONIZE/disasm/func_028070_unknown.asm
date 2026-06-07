; ============================================================================
; func_028070_unknown
; Region   : load_image
; Bytes    : file 0x028070..0x028088  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028070  55                    PUSH   bp                           ; UNKNOWN
028071  8B EC                 MOV    bp, sp                       ; UNKNOWN
028073  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
028076  A3 04 0A              MOV    word ptr [0xa04], ax         ; UNKNOWN
028079  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
02807D  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
028080  2B D2                 SUB    dx, dx                       ; UNKNOWN
028082  0E                    PUSH   cs                           ; UNKNOWN
028083  E8 59 FF              CALL   0x27fdf                      ; UNKNOWN
028086  C9                    LEAVE                               ; UNKNOWN
028087  CB                    RETF                                ; UNKNOWN
