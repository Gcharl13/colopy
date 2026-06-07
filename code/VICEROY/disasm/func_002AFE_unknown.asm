; ============================================================================
; func_002AFE_unknown
; Region   : load_image
; Bytes    : file 0x002AFE..0x002B38  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002AFE  55                    PUSH   bp ; STACK_PUSH
002AFF  8B EC                 MOV    bp, sp ; MOV
002B01  56                    PUSH   si ; STACK_PUSH
002B02  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
002B05  6A 00                 PUSH   0 ; STACK_PUSH
002B07  8A 16 30 08           MOV    dl, byte ptr [0x830] ; GLOBAL_LOAD
002B0B  2A F6                 SUB    dh, dh ; ARITH
002B0D  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
002B10  2B DB                 SUB    bx, bx ; ARITH
002B12  9A 0A 00 28 0C        LCALL  0xc28, 0xa ; LCALL
002B17  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
002B1B  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
002B1F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002B22  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002B25  6A 00                 PUSH   0 ; STACK_PUSH
002B27  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
002B2B  8B C6                 MOV    ax, si ; MOV
002B2D  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
002B30  9A 0C 00 11 0C        LCALL  0xc11, 0xc ; LCALL
002B35  5E                    POP    si ; STACK_POP
002B36  C9                    LEAVE ; EPILOGUE
002B37  CB                    RETF ; RETURN
