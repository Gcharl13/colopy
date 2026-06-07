; ============================================================================
; func_0027CC_unknown
; Region   : load_image
; Bytes    : file 0x0027CC..0x0027EE  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0027CC  55                    PUSH   bp ; STACK_PUSH
0027CD  8B EC                 MOV    bp, sp ; MOV
0027CF  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0027D2  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0027D5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0027D8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0027DB  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0027DE  50                    PUSH   ax ; STACK_PUSH
0027DF  2B C0                 SUB    ax, ax ; ARITH
0027E1  99                    CDQ ; ARITH
0027E2  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
0027E5  9A 06 00 06 08        LCALL  0x806, 6 ; LCALL
0027EA  C9                    LEAVE ; EPILOGUE
0027EB  CA 08 00              RETF   8 ; RETURN
