; ============================================================================
; func_002632_unknown
; Region   : load_image
; Bytes    : file 0x002632..0x002647  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002632  55                    PUSH   bp                           ; UNKNOWN
002633  8B EC                 MOV    bp, sp                       ; UNKNOWN
002635  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
002638  9A 62 00 00 00        LCALL  0, 0x62                      ; UNKNOWN
00263D  8B E5                 MOV    sp, bp                       ; UNKNOWN
00263F  52                    PUSH   dx                           ; UNKNOWN
002640  50                    PUSH   ax                           ; UNKNOWN
002641  0E                    PUSH   cs                           ; UNKNOWN
002642  E8 C9 FF              CALL   0x260e                       ; UNKNOWN
002645  C9                    LEAVE                               ; UNKNOWN
002646  CB                    RETF                                ; UNKNOWN
