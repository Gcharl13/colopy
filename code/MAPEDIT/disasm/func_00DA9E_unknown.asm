; ============================================================================
; func_00DA9E_unknown
; Region   : load_image
; Bytes    : file 0x00DA9E..0x00DAC0  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DA9E  55                    PUSH   bp ; STACK_PUSH
00DA9F  8B EC                 MOV    bp, sp ; MOV
00DAA1  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00DAA4  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00DAA7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00DAAA  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00DAAD  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00DAB0  50                    PUSH   ax ; STACK_PUSH
00DAB1  2B C0                 SUB    ax, ax ; ARITH
00DAB3  99                    CDQ ; ARITH
00DAB4  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00DAB7  9A 04 00 5B 0C        LCALL  0xc5b, 4 ; LCALL
00DABC  C9                    LEAVE ; EPILOGUE
00DABD  CA 08 00              RETF   8 ; RETURN
