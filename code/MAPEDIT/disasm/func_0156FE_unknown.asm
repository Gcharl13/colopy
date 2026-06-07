; ============================================================================
; func_0156FE_unknown
; Region   : load_image
; Bytes    : file 0x0156FE..0x015718  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0156FE  55                    PUSH   bp ; STACK_PUSH
0156FF  8B EC                 MOV    bp, sp ; MOV
015701  2B C0                 SUB    ax, ax ; ARITH
015703  50                    PUSH   ax ; STACK_PUSH
015704  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
015707  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
01570A  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
01570C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
01570F  9A FE 07 88 13        LCALL  0x1388, 0x7fe ; LCALL
015714  8B E5                 MOV    sp, bp ; MOV
015716  5D                    POP    bp ; STACK_POP
015717  CB                    RETF ; RETURN
