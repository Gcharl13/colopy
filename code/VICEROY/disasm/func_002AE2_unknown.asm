; ============================================================================
; func_002AE2_unknown
; Region   : load_image
; Bytes    : file 0x002AE2..0x002AFD  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002AE2  55                    PUSH   bp ; STACK_PUSH
002AE3  8B EC                 MOV    bp, sp ; MOV
002AE5  FF 36 8C 26           PUSH   word ptr [0x268c] ; PUSH_GLOBAL
002AE9  FF 36 8A 26           PUSH   word ptr [0x268a] ; PUSH_GLOBAL
002AED  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002AF0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002AF3  2B C0                 SUB    ax, ax ; ARITH
002AF5  9A 06 00 2A 0C        LCALL  0xc2a, 6 ; LCALL
002AFA  48                    DEC    ax ; ARITH
002AFB  C9                    LEAVE ; EPILOGUE
002AFC  CB                    RETF ; RETURN
