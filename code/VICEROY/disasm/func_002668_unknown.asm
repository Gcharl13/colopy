; ============================================================================
; func_002668_unknown
; Region   : load_image
; Bytes    : file 0x002668..0x00268B  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002668  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
00266C  6A 0A                 PUSH   0xa                          ; UNKNOWN
00266E  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
002671  50                    PUSH   ax                           ; UNKNOWN
002672  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
002675  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
002678  9A 16 09 1D 0D        LCALL  0xd1d, 0x916                 ; UNKNOWN
00267D  83 C4 08              ADD    sp, 8                        ; UNKNOWN
002680  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
002683  16                    PUSH   ss                           ; UNKNOWN
002684  50                    PUSH   ax                           ; UNKNOWN
002685  0E                    PUSH   cs                           ; UNKNOWN
002686  E8 85 FF              CALL   0x260e                       ; UNKNOWN
002689  C9                    LEAVE                               ; UNKNOWN
00268A  CB                    RETF                                ; UNKNOWN
