; ============================================================================
; func_00C498_unknown
; Region   : load_image
; Bytes    : file 0x00C498..0x00C4A3  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C498  55                    PUSH   bp ; STACK_PUSH
00C499  8B EC                 MOV    bp, sp ; MOV
00C49B  53                    PUSH   bx ; STACK_PUSH
00C49C  9A 22 00 22 0B        LCALL  0xb22, 0x22 ; LCALL
00C4A1  C9                    LEAVE ; EPILOGUE
00C4A2  CB                    RETF ; RETURN
