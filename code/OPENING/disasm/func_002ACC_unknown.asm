; ============================================================================
; func_002ACC_unknown
; Region   : load_image
; Bytes    : file 0x002ACC..0x002AFC  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002ACC  55                    PUSH   bp ; STACK_PUSH
002ACD  8B EC                 MOV    bp, sp ; MOV
002ACF  9A 5A 00 14 08        LCALL  0x814, 0x5a ; LCALL
002AD4  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002AD7  FF 36 3E 39           PUSH   word ptr [0x393e] ; PUSH_GLOBAL
002ADB  FF 36 3C 39           PUSH   word ptr [0x393c] ; PUSH_GLOBAL
002ADF  FF 36 16 39           PUSH   word ptr [0x3916] ; PUSH_GLOBAL
002AE3  FF 36 14 39           PUSH   word ptr [0x3914] ; PUSH_GLOBAL
002AE7  9A 3E 01 52 04        LCALL  0x452, 0x13e ; LCALL
002AEC  8B E5                 MOV    sp, bp ; MOV
002AEE  83 3E C0 47 00        CMP    word ptr [0x47c0], 0 ; CMP
002AF3  74 05                 JE     0x2afa ; CJUMP
002AF5  9A 13 00 14 08        LCALL  0x814, 0x13 ; LCALL
002AFA  C9                    LEAVE ; EPILOGUE
002AFB  CB                    RETF ; RETURN
