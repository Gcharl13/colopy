; ============================================================================
; func_015228_unknown
; Region   : load_image
; Bytes    : file 0x015228..0x01523D  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015228  55                    PUSH   bp ; STACK_PUSH
015229  8B EC                 MOV    bp, sp ; MOV
01522B  2B C0                 SUB    ax, ax ; ARITH
01522D  50                    PUSH   ax ; STACK_PUSH
01522E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
015231  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
015234  9A 7C 03 88 13        LCALL  0x1388, 0x37c ; LCALL
015239  8B E5                 MOV    sp, bp ; MOV
01523B  5D                    POP    bp ; STACK_POP
01523C  CB                    RETF ; RETURN
