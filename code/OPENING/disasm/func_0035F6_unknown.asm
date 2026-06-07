; ============================================================================
; func_0035F6_unknown
; Region   : load_image
; Bytes    : file 0x0035F6..0x003618  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0035F6  55                    PUSH   bp ; STACK_PUSH
0035F7  8B EC                 MOV    bp, sp ; MOV
0035F9  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0035FC  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0035FF  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
003602  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
003605  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
003608  50                    PUSH   ax ; STACK_PUSH
003609  2B C0                 SUB    ax, ax ; ARITH
00360B  99                    CDQ ; ARITH
00360C  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00360F  9A 08 00 A1 02        LCALL  0x2a1, 8 ; LCALL
003614  C9                    LEAVE ; EPILOGUE
003615  CA 08 00              RETF   8 ; RETURN
