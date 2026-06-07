; ============================================================================
; func_002648_unknown
; Region   : load_image
; Bytes    : file 0x002648..0x002668  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002648  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
00264C  6A 0A                 PUSH   0xa ; PUSH_CONST
00264E  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
002651  50                    PUSH   ax ; STACK_PUSH
002652  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002655  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
00265A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00265D  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
002660  16                    PUSH   ss ; STACK_PUSH
002661  50                    PUSH   ax ; STACK_PUSH
002662  0E                    PUSH   cs ; STACK_PUSH
002663  E8 A8 FF              CALL   0x260e ; CALL_NEAR
002666  C9                    LEAVE ; EPILOGUE
002667  CB                    RETF ; RETURN
