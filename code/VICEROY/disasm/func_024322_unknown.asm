; ============================================================================
; func_024322_unknown
; Region   : overlay
; Bytes    : file 0x024322..0x024337  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024322  55                    PUSH   bp ; STACK_PUSH
024323  8B EC                 MOV    bp, sp ; MOV
024325  FF 36 3C 08           PUSH   word ptr [0x83c] ; PUSH_GLOBAL
024329  FF 36 3A 08           PUSH   word ptr [0x83a] ; PUSH_GLOBAL
02432D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
024330  9A 68 04 1F 19        LCALL  0x191f, 0x468 ; THUNK -> 0x0B5E:0x0000 (thunk @file 0x01BA58 type B)
024335  C9                    LEAVE ; EPILOGUE
024336  CB                    RETF ; RETURN
