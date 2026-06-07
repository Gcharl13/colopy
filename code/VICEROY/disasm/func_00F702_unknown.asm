; ============================================================================
; func_00F702_unknown
; Region   : load_image
; Bytes    : file 0x00F702..0x00F71F  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F702  55                    PUSH   bp ; STACK_PUSH
00F703  8B EC                 MOV    bp, sp ; MOV
00F705  06                    PUSH   es ; STACK_PUSH
00F706  57                    PUSH   di ; STACK_PUSH
00F707  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
00F70A  06                    PUSH   es ; STACK_PUSH
00F70B  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00F70E  06                    PUSH   es ; STACK_PUSH
00F70F  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
00F712  50                    PUSH   ax ; STACK_PUSH
00F713  9A 16 00 1D 0D        LCALL  0xd1d, 0x16 ; LCALL
00F718  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00F71B  5F                    POP    di ; STACK_POP
00F71C  07                    POP    es ; STACK_POP
00F71D  5D                    POP    bp ; STACK_POP
00F71E  CB                    RETF ; RETURN
