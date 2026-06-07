; ============================================================================
; func_002400_unknown
; Region   : load_image
; Bytes    : file 0x002400..0x002421  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002400  55                    PUSH   bp                           ; UNKNOWN
002401  8B EC                 MOV    bp, sp                       ; UNKNOWN
002403  1E                    PUSH   ds                           ; UNKNOWN
002404  68 40 2D              PUSH   0x2d40                       ; UNKNOWN
002407  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
00240A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00240D  1E                    PUSH   ds                           ; UNKNOWN
00240E  68 42 00              PUSH   0x42                         ; STRING: "$STRING"
002411  B8 09 00              MOV    ax, 9                        ; UNKNOWN
002414  9A 48 00 1F 18        LCALL  0x181f, 0x48                 ; UNKNOWN
002419  C7 06 52 2D 00 00     MOV    word ptr [0x2d52], 0         ; UNKNOWN
00241F  C9                    LEAVE                               ; UNKNOWN
002420  CB                    RETF                                ; UNKNOWN
