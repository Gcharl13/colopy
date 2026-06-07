; ============================================================================
; func_002A98_unknown
; Region   : load_image
; Bytes    : file 0x002A98..0x002AC6  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002A98  55                    PUSH   bp ; STACK_PUSH
002A99  8B EC                 MOV    bp, sp ; MOV
002A9B  57                    PUSH   di ; STACK_PUSH
002A9C  56                    PUSH   si ; STACK_PUSH
002A9D  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
002AA0  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
002AA3  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
002AA6  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
002AA9  50                    PUSH   ax ; STACK_PUSH
002AAA  56                    PUSH   si ; STACK_PUSH
002AAB  8B F8                 MOV    di, ax ; MOV
002AAD  0E                    PUSH   cs ; STACK_PUSH
002AAE  E8 BD FF              CALL   0x2a6e ; CALL_NEAR
002AB1  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
002AB4  1E                    PUSH   ds ; STACK_PUSH
002AB5  68 6E 00              PUSH   0x6e ; PUSH_CONST
002AB8  57                    PUSH   di ; STACK_PUSH
002AB9  56                    PUSH   si ; STACK_PUSH
002ABA  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
002ABF  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
002AC2  5E                    POP    si ; STACK_POP
002AC3  5F                    POP    di ; STACK_POP
002AC4  C9                    LEAVE ; EPILOGUE
002AC5  CB                    RETF ; RETURN
