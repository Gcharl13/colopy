; ============================================================================
; func_004DCA_unknown
; Region   : load_image
; Bytes    : file 0x004DCA..0x004DE2  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004DCA  55                    PUSH   bp ; STACK_PUSH
004DCB  8B EC                 MOV    bp, sp ; MOV
004DCD  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
004DD0  9A 6C 00 34 03        LCALL  0x334, 0x6c ; LCALL
004DD5  8B E5                 MOV    sp, bp ; MOV
004DD7  52                    PUSH   dx ; STACK_PUSH
004DD8  50                    PUSH   ax ; STACK_PUSH
004DD9  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
004DDC  0E                    PUSH   cs ; STACK_PUSH
004DDD  E8 CE FF              CALL   0x4dae ; CALL_NEAR
004DE0  C9                    LEAVE ; EPILOGUE
004DE1  CB                    RETF ; RETURN
