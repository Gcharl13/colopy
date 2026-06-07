; ============================================================================
; func_01008E_unknown
; Region   : load_image
; Bytes    : file 0x01008E..0x0100A8  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01008E  55                    PUSH   bp ; STACK_PUSH
01008F  8B EC                 MOV    bp, sp ; MOV
010091  2B C0                 SUB    ax, ax ; ARITH
010093  50                    PUSH   ax ; STACK_PUSH
010094  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
010097  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
01009A  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
01009C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
01009F  9A 3E 0A 1D 0D        LCALL  0xd1d, 0xa3e ; LCALL
0100A4  8B E5                 MOV    sp, bp ; MOV
0100A6  5D                    POP    bp ; STACK_POP
0100A7  CB                    RETF ; RETURN
