; ============================================================================
; func_00DCD4_unknown
; Region   : load_image
; Bytes    : file 0x00DCD4..0x00DCF6  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DCD4  55                    PUSH   bp ; STACK_PUSH
00DCD5  8B EC                 MOV    bp, sp ; MOV
00DCD7  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00DCDA  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00DCDD  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00DCE0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00DCE3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00DCE6  50                    PUSH   ax ; STACK_PUSH
00DCE7  2B C0                 SUB    ax, ax ; ARITH
00DCE9  99                    CDQ ; ARITH
00DCEA  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00DCED  9A 0A 00 9E 0B        LCALL  0xb9e, 0xa ; LCALL
00DCF2  C9                    LEAVE ; EPILOGUE
00DCF3  CA 08 00              RETF   8 ; RETURN
