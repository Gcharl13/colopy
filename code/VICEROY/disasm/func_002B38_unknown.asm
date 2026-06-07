; ============================================================================
; func_002B38_unknown
; Region   : load_image
; Bytes    : file 0x002B38..0x002B72  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002B38  55                    PUSH   bp ; STACK_PUSH
002B39  8B EC                 MOV    bp, sp ; MOV
002B3B  57                    PUSH   di ; STACK_PUSH
002B3C  56                    PUSH   si ; STACK_PUSH
002B3D  8B 7E 0A              MOV    di, word ptr [bp + 0xa] ; LOCAL_LOAD
002B40  8B 76 0E              MOV    si, word ptr [bp + 0xe] ; LOCAL_LOAD
002B43  56                    PUSH   si ; STACK_PUSH
002B44  8B D6                 MOV    dx, si ; MOV
002B46  8B DE                 MOV    bx, si ; MOV
002B48  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
002B4B  9A 0A 00 28 0C        LCALL  0xc28, 0xa ; LCALL
002B50  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
002B54  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
002B58  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002B5B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002B5E  6A 00                 PUSH   0 ; STACK_PUSH
002B60  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
002B64  8B C7                 MOV    ax, di ; MOV
002B66  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
002B69  9A 0C 00 11 0C        LCALL  0xc11, 0xc ; LCALL
002B6E  5E                    POP    si ; STACK_POP
002B6F  5F                    POP    di ; STACK_POP
002B70  C9                    LEAVE ; EPILOGUE
002B71  CB                    RETF ; RETURN
