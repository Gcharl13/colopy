; ============================================================================
; func_015131_unknown
; Region   : load_image
; Bytes    : file 0x015131..0x015145  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015131  55                    PUSH   bp ; STACK_PUSH
015132  8B EC                 MOV    bp, sp ; MOV
015134  1E                    PUSH   ds ; STACK_PUSH
015135  56                    PUSH   si ; STACK_PUSH
015136  50                    PUSH   ax ; STACK_PUSH
015137  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
01513A  2E A1 52 39           MOV    ax, word ptr cs:[0x3952] ; GLOBAL_LOAD
01513E  89 04                 MOV    word ptr [si], ax ; MOV
015140  58                    POP    ax ; STACK_POP
015141  5E                    POP    si ; STACK_POP
015142  1F                    POP    ds ; STACK_POP
015143  5D                    POP    bp ; STACK_POP
015144  CB                    RETF ; RETURN
