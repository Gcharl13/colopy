; ============================================================================
; func_002C0C_unknown
; Region   : load_image
; Bytes    : file 0x002C0C..0x002C4A  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002C0C  55                    PUSH   bp ; STACK_PUSH
002C0D  8B EC                 MOV    bp, sp ; MOV
002C0F  56                    PUSH   si ; STACK_PUSH
002C10  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
002C13  6A 00                 PUSH   0 ; STACK_PUSH
002C15  8A 16 30 08           MOV    dl, byte ptr [0x830] ; GLOBAL_LOAD
002C19  2A F6                 SUB    dh, dh ; ARITH
002C1B  8A 1E 33 08           MOV    bl, byte ptr [0x833] ; GLOBAL_LOAD
002C1F  2A FF                 SUB    bh, bh ; ARITH
002C21  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
002C24  9A 0A 00 28 0C        LCALL  0xc28, 0xa ; LCALL
002C29  FF 36 8C 26           PUSH   word ptr [0x268c] ; PUSH_GLOBAL
002C2D  FF 36 8A 26           PUSH   word ptr [0x268a] ; PUSH_GLOBAL
002C31  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002C34  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002C37  6A 00                 PUSH   0 ; STACK_PUSH
002C39  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
002C3D  8B C6                 MOV    ax, si ; MOV
002C3F  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
002C42  9A 0C 00 11 0C        LCALL  0xc11, 0xc ; LCALL
002C47  5E                    POP    si ; STACK_POP
002C48  C9                    LEAVE ; EPILOGUE
002C49  CB                    RETF ; RETURN
