; ============================================================================
; func_002A38_unknown
; Region   : load_image
; Bytes    : file 0x002A38..0x002A59  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002A38  55                    PUSH   bp ; STACK_PUSH
002A39  8B EC                 MOV    bp, sp ; MOV
002A3B  1E                    PUSH   ds ; STACK_PUSH
002A3C  68 CC 4A              PUSH   0x4acc ; PUSH_CONST
002A3F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002A42  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002A45  1E                    PUSH   ds ; STACK_PUSH
002A46  68 1A 04              PUSH   0x41a ; PUSH_CONST
002A49  B8 09 00              MOV    ax, 9 ; MOV
002A4C  9A 00 00 F1 07        LCALL  0x7f1, 0 ; LCALL
002A51  C7 06 22 62 00 00     MOV    word ptr [0x6222], 0 ; GLOBAL_LOAD
002A57  C9                    LEAVE ; EPILOGUE
002A58  CB                    RETF ; RETURN
