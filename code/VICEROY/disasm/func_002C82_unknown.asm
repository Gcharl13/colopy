; ============================================================================
; func_002C82_unknown
; Region   : load_image
; Bytes    : file 0x002C82..0x002CE0  (94 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002C82  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
002C86  57                    PUSH   di ; STACK_PUSH
002C87  56                    PUSH   si ; STACK_PUSH
002C88  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
002C8B  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
002C8E  6A 00                 PUSH   0 ; STACK_PUSH
002C90  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
002C93  8B 56 0E              MOV    dx, word ptr [bp + 0xe] ; LOCAL_LOAD
002C96  8B 5E 10              MOV    bx, word ptr [bp + 0x10] ; LOCAL_LOAD
002C99  9A 0A 00 28 0C        LCALL  0xc28, 0xa ; LCALL
002C9E  FF 36 8C 26           PUSH   word ptr [0x268c] ; PUSH_GLOBAL
002CA2  FF 36 8A 26           PUSH   word ptr [0x268a] ; PUSH_GLOBAL
002CA6  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
002CA9  50                    PUSH   ax ; STACK_PUSH
002CAA  57                    PUSH   di ; STACK_PUSH
002CAB  89 7E FC              MOV    word ptr [bp - 4], di ; LOCAL_STORE
002CAE  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
002CB1  2B C0                 SUB    ax, ax ; ARITH
002CB3  9A 06 00 2A 0C        LCALL  0xc2a, 6 ; LCALL
002CB8  2B F0                 SUB    si, ax ; ARITH
002CBA  FF 36 8C 26           PUSH   word ptr [0x268c] ; PUSH_GLOBAL
002CBE  FF 36 8A 26           PUSH   word ptr [0x268a] ; PUSH_GLOBAL
002CC2  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
002CC5  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
002CC8  6A 00                 PUSH   0 ; STACK_PUSH
002CCA  8B C6                 MOV    ax, si ; MOV
002CCC  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
002CD0  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
002CD3  8B F0                 MOV    si, ax ; MOV
002CD5  9A 0C 00 11 0C        LCALL  0xc11, 0xc ; LCALL
002CDA  8B C6                 MOV    ax, si ; MOV
002CDC  5E                    POP    si ; STACK_POP
002CDD  5F                    POP    di ; STACK_POP
002CDE  C9                    LEAVE ; EPILOGUE
002CDF  CB                    RETF ; RETURN
