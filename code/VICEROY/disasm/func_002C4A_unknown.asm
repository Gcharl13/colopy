; ============================================================================
; func_002C4A_unknown
; Region   : load_image
; Bytes    : file 0x002C4A..0x002C82  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002C4A  55                    PUSH   bp ; STACK_PUSH
002C4B  8B EC                 MOV    bp, sp ; MOV
002C4D  56                    PUSH   si ; STACK_PUSH
002C4E  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
002C51  6A 00                 PUSH   0 ; STACK_PUSH
002C53  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
002C56  8B 56 0E              MOV    dx, word ptr [bp + 0xe] ; LOCAL_LOAD
002C59  8B 5E 10              MOV    bx, word ptr [bp + 0x10] ; LOCAL_LOAD
002C5C  9A 0A 00 28 0C        LCALL  0xc28, 0xa ; LCALL
002C61  FF 36 8C 26           PUSH   word ptr [0x268c] ; PUSH_GLOBAL
002C65  FF 36 8A 26           PUSH   word ptr [0x268a] ; PUSH_GLOBAL
002C69  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002C6C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002C6F  6A 00                 PUSH   0 ; STACK_PUSH
002C71  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
002C75  8B C6                 MOV    ax, si ; MOV
002C77  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
002C7A  9A 0C 00 11 0C        LCALL  0xc11, 0xc ; LCALL
002C7F  5E                    POP    si ; STACK_POP
002C80  C9                    LEAVE ; EPILOGUE
002C81  CB                    RETF ; RETURN
