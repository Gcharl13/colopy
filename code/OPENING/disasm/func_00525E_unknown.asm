; ============================================================================
; func_00525E_unknown
; Region   : load_image
; Bytes    : file 0x00525E..0x00527B  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00525E  55                    PUSH   bp ; STACK_PUSH
00525F  8B EC                 MOV    bp, sp ; MOV
005261  06                    PUSH   es ; STACK_PUSH
005262  57                    PUSH   di ; STACK_PUSH
005263  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
005266  06                    PUSH   es ; STACK_PUSH
005267  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00526A  06                    PUSH   es ; STACK_PUSH
00526B  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
00526E  50                    PUSH   ax ; STACK_PUSH
00526F  9A 22 00 52 04        LCALL  0x452, 0x22 ; LCALL
005274  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
005277  5F                    POP    di ; STACK_POP
005278  07                    POP    es ; STACK_POP
005279  5D                    POP    bp ; STACK_POP
00527A  CB                    RETF ; RETURN
