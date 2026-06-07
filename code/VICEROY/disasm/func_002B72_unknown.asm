; ============================================================================
; func_002B72_unknown
; Region   : load_image
; Bytes    : file 0x002B72..0x002BC7  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002B72  55                    PUSH   bp ; STACK_PUSH
002B73  8B EC                 MOV    bp, sp ; MOV
002B75  57                    PUSH   di ; STACK_PUSH
002B76  56                    PUSH   si ; STACK_PUSH
002B77  8B 7E 0E              MOV    di, word ptr [bp + 0xe] ; LOCAL_LOAD
002B7A  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
002B7D  57                    PUSH   di ; STACK_PUSH
002B7E  8B D7                 MOV    dx, di ; MOV
002B80  8B DF                 MOV    bx, di ; MOV
002B82  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
002B85  9A 0A 00 28 0C        LCALL  0xc28, 0xa ; LCALL
002B8A  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
002B8E  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
002B92  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002B95  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002B98  2B C0                 SUB    ax, ax ; ARITH
002B9A  9A 06 00 2A 0C        LCALL  0xc2a, 6 ; LCALL
002B9F  2B F0                 SUB    si, ax ; ARITH
002BA1  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
002BA5  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
002BA9  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002BAC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002BAF  6A 00                 PUSH   0 ; STACK_PUSH
002BB1  8B C6                 MOV    ax, si ; MOV
002BB3  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
002BB7  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
002BBA  8B F0                 MOV    si, ax ; MOV
002BBC  9A 0C 00 11 0C        LCALL  0xc11, 0xc ; LCALL
002BC1  8B C6                 MOV    ax, si ; MOV
002BC3  5E                    POP    si ; STACK_POP
002BC4  5F                    POP    di ; STACK_POP
002BC5  C9                    LEAVE ; EPILOGUE
002BC6  CB                    RETF ; RETURN
