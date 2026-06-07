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

002400  55                    PUSH   bp ; STACK_PUSH
002401  8B EC                 MOV    bp, sp ; MOV
002403  1E                    PUSH   ds ; STACK_PUSH
002404  68 40 2D              PUSH   0x2d40 ; PUSH_CONST
002407  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00240A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00240D  1E                    PUSH   ds ; STACK_PUSH
00240E  68 42 00              PUSH   0x42                         ; STRING: "$STRING"
002411  B8 09 00              MOV    ax, 9 ; MOV
002414  9A 48 00 1F 18        LCALL  0x181f, 0x48 ; THUNK -> 0x0000:0x000E (thunk @file 0x01A638 type A) overlay @file 0x02590E
002419  C7 06 52 2D 00 00     MOV    word ptr [0x2d52], 0 ; GLOBAL_LOAD
00241F  C9                    LEAVE ; EPILOGUE
002420  CB                    RETF ; RETURN
