; ============================================================================
; func_0029DE_unknown
; Region   : load_image
; Bytes    : file 0x0029DE..0x002A05  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0029DE  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
0029E2  6A 0A                 PUSH   0xa ; PUSH_CONST
0029E4  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
0029E7  50                    PUSH   ax ; STACK_PUSH
0029E8  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0029EB  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
0029F0  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0029F3  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
0029F6  16                    PUSH   ss ; STACK_PUSH
0029F7  50                    PUSH   ax ; STACK_PUSH
0029F8  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0029FB  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0029FE  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
002A03  C9                    LEAVE ; EPILOGUE
002A04  CB                    RETF ; RETURN
