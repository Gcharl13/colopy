; ============================================================================
; func_00261C_unknown
; Region   : load_image
; Bytes    : file 0x00261C..0x002627  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00261C  55                    PUSH   bp ; STACK_PUSH
00261D  8B EC                 MOV    bp, sp ; MOV
00261F  53                    PUSH   bx ; STACK_PUSH
002620  9A 28 00 58 02        LCALL  0x258, 0x28 ; LCALL
002625  C9                    LEAVE ; EPILOGUE
002626  CB                    RETF ; RETURN
