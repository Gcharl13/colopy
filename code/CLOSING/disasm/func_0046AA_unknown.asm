; ============================================================================
; func_0046AA_unknown
; Region   : load_image
; Bytes    : file 0x0046AA..0x0046BF  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0046AA  55                    PUSH   bp ; STACK_PUSH
0046AB  8B EC                 MOV    bp, sp ; MOV
0046AD  2B C0                 SUB    ax, ax ; ARITH
0046AF  50                    PUSH   ax ; STACK_PUSH
0046B0  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0046B3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0046B6  9A AE 04 7D 03        LCALL  0x37d, 0x4ae ; LCALL
0046BB  8B E5                 MOV    sp, bp ; MOV
0046BD  5D                    POP    bp ; STACK_POP
0046BE  CB                    RETF ; RETURN
