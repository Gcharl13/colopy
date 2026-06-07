; ============================================================================
; func_002AC6_unknown
; Region   : load_image
; Bytes    : file 0x002AC6..0x002AE1  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002AC6  55                    PUSH   bp ; STACK_PUSH
002AC7  8B EC                 MOV    bp, sp ; MOV
002AC9  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
002ACD  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
002AD1  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002AD4  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002AD7  2B C0                 SUB    ax, ax ; ARITH
002AD9  9A 06 00 2A 0C        LCALL  0xc2a, 6 ; LCALL
002ADE  48                    DEC    ax ; ARITH
002ADF  C9                    LEAVE ; EPILOGUE
002AE0  CB                    RETF ; RETURN
