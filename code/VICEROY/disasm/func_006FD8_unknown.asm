; ============================================================================
; func_006FD8_unknown
; Region   : load_image
; Bytes    : file 0x006FD8..0x007002  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006FD8  55                    PUSH   bp ; STACK_PUSH
006FD9  8B EC                 MOV    bp, sp ; MOV
006FDB  56                    PUSH   si ; STACK_PUSH
006FDC  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
006FDF  8B C6                 MOV    ax, si ; MOV
006FE1  0E                    PUSH   cs ; STACK_PUSH
006FE2  E8 8D F6              CALL   0x6672 ; CALL_NEAR
006FE5  8B F0                 MOV    si, ax ; MOV
006FE7  0B F6                 OR     si, si ; LOGIC
006FE9  7C 14                 JL     0x6fff ; CJUMP
006FEB  56                    PUSH   si ; STACK_PUSH
006FEC  0E                    PUSH   cs ; STACK_PUSH
006FED  E8 D4 FF              CALL   0x6fc4 ; CALL_NEAR
006FF0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
006FF3  8B C6                 MOV    ax, si ; MOV
006FF5  0E                    PUSH   cs ; STACK_PUSH
006FF6  E8 C1 F6              CALL   0x66ba ; CALL_NEAR
006FF9  8B F0                 MOV    si, ax ; MOV
006FFB  0B F6                 OR     si, si ; LOGIC
006FFD  7D EC                 JGE    0x6feb ; CJUMP
006FFF  5E                    POP    si ; STACK_POP
007000  C9                    LEAVE ; EPILOGUE
007001  CB                    RETF ; RETURN
