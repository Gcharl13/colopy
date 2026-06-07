; ============================================================================
; func_046BEA_unknown
; Region   : load_image
; Bytes    : file 0x046BEA..0x046C1C  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046BEA  55                    PUSH   bp                           ; UNKNOWN
046BEB  8B EC                 MOV    bp, sp                       ; UNKNOWN
046BED  56                    PUSH   si                           ; UNKNOWN
046BEE  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
046BF1  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
046BF5  98                    CWDE                                ; UNKNOWN
046BF6  6B 76 06 1C           IMUL   si, word ptr [bp + 6], 0x1c  ; UNKNOWN
046BFA  8A 8C 81 88           MOV    cl, byte ptr [si - 0x777f]   ; UNKNOWN
046BFE  2A ED                 SUB    ch, ch                       ; UNKNOWN
046C00  03 C1                 ADD    ax, cx                       ; UNKNOWN
046C02  50                    PUSH   ax                           ; UNKNOWN
046C03  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
046C07  98                    CWDE                                ; UNKNOWN
046C08  8A 8C 80 88           MOV    cl, byte ptr [si - 0x7780]   ; UNKNOWN
046C0C  03 C8                 ADD    cx, ax                       ; UNKNOWN
046C0E  51                    PUSH   cx                           ; UNKNOWN
046C0F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
046C12  0E                    PUSH   cs                           ; UNKNOWN
046C13  E8 BE F3              CALL   0x45fd4                      ; UNKNOWN
046C16  83 C4 06              ADD    sp, 6                        ; UNKNOWN
046C19  5E                    POP    si                           ; UNKNOWN
046C1A  C9                    LEAVE                               ; UNKNOWN
046C1B  CB                    RETF                                ; UNKNOWN
