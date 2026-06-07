; ============================================================================
; func_002668_unknown
; Region   : load_image
; Bytes    : file 0x002668..0x00268B  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002668  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
00266C  6A 0A                 PUSH   0xa ; PUSH_CONST
00266E  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
002671  50                    PUSH   ax ; STACK_PUSH
002672  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002675  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002678  9A 16 09 1D 0D        LCALL  0xd1d, 0x916 ; LCALL
00267D  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
002680  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
002683  16                    PUSH   ss ; STACK_PUSH
002684  50                    PUSH   ax ; STACK_PUSH
002685  0E                    PUSH   cs ; STACK_PUSH
002686  E8 85 FF              CALL   0x260e ; CALL_NEAR
002689  C9                    LEAVE ; EPILOGUE
00268A  CB                    RETF ; RETURN
