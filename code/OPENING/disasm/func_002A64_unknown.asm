; ============================================================================
; func_002A64_unknown
; Region   : load_image
; Bytes    : file 0x002A64..0x002A99  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002A64  55                    PUSH   bp ; STACK_PUSH
002A65  8B EC                 MOV    bp, sp ; MOV
002A67  56                    PUSH   si ; STACK_PUSH
002A68  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
002A6B  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
002A6E  50                    PUSH   ax ; STACK_PUSH
002A6F  56                    PUSH   si ; STACK_PUSH
002A70  1E                    PUSH   ds ; STACK_PUSH
002A71  68 CC 4A              PUSH   0x4acc ; PUSH_CONST
002A74  50                    PUSH   ax ; STACK_PUSH
002A75  56                    PUSH   si ; STACK_PUSH
002A76  9A D0 0D 52 04        LCALL  0x452, 0xdd0 ; LCALL
002A7B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
002A7E  40                    INC    ax ; ARITH
002A7F  99                    CDQ ; ARITH
002A80  9A 0A 01 F1 07        LCALL  0x7f1, 0x10a ; LCALL
002A85  52                    PUSH   dx ; STACK_PUSH
002A86  50                    PUSH   ax ; STACK_PUSH
002A87  9A E8 0D 52 04        LCALL  0x452, 0xde8 ; LCALL
002A8C  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
002A8F  A1 22 62              MOV    ax, word ptr [0x6222] ; GLOBAL_LOAD
002A92  FF 06 22 62           INC    word ptr [0x6222] ; ARITH
002A96  5E                    POP    si ; STACK_POP
002A97  C9                    LEAVE ; EPILOGUE
002A98  CB                    RETF ; RETURN
