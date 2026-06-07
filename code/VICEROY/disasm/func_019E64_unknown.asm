; ============================================================================
; func_019E64_unknown
; Region   : load_image
; Bytes    : file 0x019E64..0x019E6F  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019E64  55                    PUSH   bp ; STACK_PUSH
019E65  8B EC                 MOV    bp, sp ; MOV
019E67  2E C6 06 6F 05 00     MOV    byte ptr cs:[0x56f], 0 ; GLOBAL_LOAD
019E6D  8C CB                 MOV    bx, cs ; MOV
