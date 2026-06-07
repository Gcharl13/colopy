; ============================================================================
; func_00C30A_unknown
; Region   : load_image
; Bytes    : file 0x00C30A..0x00C31B  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C30A  55                    PUSH   bp ; STACK_PUSH
00C30B  8B EC                 MOV    bp, sp ; MOV
00C30D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00C310  80 E4 7F              AND    ah, 0x7f ; LOGIC
00C313  50                    PUSH   ax ; STACK_PUSH
00C314  9A F2 0D 1D 0D        LCALL  0xd1d, 0xdf2 ; LCALL
00C319  C9                    LEAVE ; EPILOGUE
00C31A  CB                    RETF ; RETURN
