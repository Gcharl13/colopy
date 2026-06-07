; ============================================================================
; func_064534_unknown
; Region   : overlay
; Bytes    : file 0x064534..0x06454C  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064534  55                    PUSH   bp ; STACK_PUSH
064535  8B EC                 MOV    bp, sp ; MOV
064537  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06453A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06453D  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
064542  8B E5                 MOV    sp, bp ; MOV
064544  0B C0                 OR     ax, ax ; LOGIC
064546  75 04                 JNE    0x6454c ; CJUMP
064548  2B C0                 SUB    ax, ax ; ARITH
06454A  C9                    LEAVE ; EPILOGUE
06454B  CB                    RETF ; RETURN
