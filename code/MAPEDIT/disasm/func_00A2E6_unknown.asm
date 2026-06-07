; ============================================================================
; func_00A2E6_unknown
; Region   : load_image
; Bytes    : file 0x00A2E6..0x00A301  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A2E6  55                    PUSH   bp ; STACK_PUSH
00A2E7  8B EC                 MOV    bp, sp ; MOV
00A2E9  FF 36 82 00           PUSH   word ptr [0x82] ; PUSH_GLOBAL
00A2ED  FF 36 80 00           PUSH   word ptr [0x80] ; PUSH_GLOBAL
00A2F1  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A2F4  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A2F7  2B C0                 SUB    ax, ax ; ARITH
00A2F9  9A 02 00 6C 0D        LCALL  0xd6c, 2 ; LCALL
00A2FE  48                    DEC    ax ; ARITH
00A2FF  C9                    LEAVE ; EPILOGUE
00A300  CB                    RETF ; RETURN
