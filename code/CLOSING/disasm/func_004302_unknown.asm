; ============================================================================
; func_004302_unknown
; Region   : load_image
; Bytes    : file 0x004302..0x00431F  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004302  55                    PUSH   bp ; STACK_PUSH
004303  8B EC                 MOV    bp, sp ; MOV
004305  06                    PUSH   es ; STACK_PUSH
004306  57                    PUSH   di ; STACK_PUSH
004307  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
00430A  06                    PUSH   es ; STACK_PUSH
00430B  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00430E  06                    PUSH   es ; STACK_PUSH
00430F  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
004312  50                    PUSH   ax ; STACK_PUSH
004313  9A 16 00 7D 03        LCALL  0x37d, 0x16 ; LCALL
004318  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00431B  5F                    POP    di ; STACK_POP
00431C  07                    POP    es ; STACK_POP
00431D  5D                    POP    bp ; STACK_POP
00431E  CB                    RETF ; RETURN
