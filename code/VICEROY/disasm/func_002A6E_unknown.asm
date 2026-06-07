; ============================================================================
; func_002A6E_unknown
; Region   : load_image
; Bytes    : file 0x002A6E..0x002A98  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002A6E  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
002A72  6A 0A                 PUSH   0xa ; PUSH_CONST
002A74  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
002A77  50                    PUSH   ax ; STACK_PUSH
002A78  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
002A7B  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
002A7E  9A 16 09 1D 0D        LCALL  0xd1d, 0x916 ; LCALL
002A83  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
002A86  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
002A89  16                    PUSH   ss ; STACK_PUSH
002A8A  50                    PUSH   ax ; STACK_PUSH
002A8B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002A8E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002A91  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
002A96  C9                    LEAVE ; EPILOGUE
002A97  CB                    RETF ; RETURN
