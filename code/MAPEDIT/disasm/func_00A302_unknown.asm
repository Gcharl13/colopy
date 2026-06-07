; ============================================================================
; func_00A302_unknown
; Region   : load_image
; Bytes    : file 0x00A302..0x00A31D  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A302  55                    PUSH   bp ; STACK_PUSH
00A303  8B EC                 MOV    bp, sp ; MOV
00A305  FF 36 98 3A           PUSH   word ptr [0x3a98] ; PUSH_GLOBAL
00A309  FF 36 96 3A           PUSH   word ptr [0x3a96] ; PUSH_GLOBAL
00A30D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A310  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A313  2B C0                 SUB    ax, ax ; ARITH
00A315  9A 02 00 6C 0D        LCALL  0xd6c, 2 ; LCALL
00A31A  48                    DEC    ax ; ARITH
00A31B  C9                    LEAVE ; EPILOGUE
00A31C  CB                    RETF ; RETURN
