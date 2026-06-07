; ============================================================================
; func_051EE6_unknown
; Region   : overlay
; Bytes    : file 0x051EE6..0x051EF3  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

051EE6  55                    PUSH   bp ; STACK_PUSH
051EE7  8B EC                 MOV    bp, sp ; MOV
051EE9  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
051EEC  9A A8 05 1F 1A        LCALL  0x1a1f, 0x5a8 ; THUNK -> 0x0000:0x035E (thunk @file 0x01CB98 type A) overlay @file 0x025C5E
051EF1  C9                    LEAVE ; EPILOGUE
051EF2  CB                    RETF ; RETURN
