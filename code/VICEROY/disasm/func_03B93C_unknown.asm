; ============================================================================
; func_03B93C_unknown
; Region   : overlay
; Bytes    : file 0x03B93C..0x03B954  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03B93C  55                    PUSH   bp ; STACK_PUSH
03B93D  8B EC                 MOV    bp, sp ; MOV
03B93F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
03B942  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03B945  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
03B94A  8B E5                 MOV    sp, bp ; MOV
03B94C  0B C0                 OR     ax, ax ; LOGIC
03B94E  74 04                 JE     0x3b954 ; CJUMP
03B950  2B C0                 SUB    ax, ax ; ARITH
03B952  C9                    LEAVE ; EPILOGUE
03B953  CB                    RETF ; RETURN
