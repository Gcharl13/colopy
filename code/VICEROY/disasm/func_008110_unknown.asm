; ============================================================================
; func_008110_unknown
; Region   : load_image
; Bytes    : file 0x008110..0x00811E  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008110  55                    PUSH   bp ; STACK_PUSH
008111  8B EC                 MOV    bp, sp ; MOV
008113  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
008117  7C 11                 JL     0x812a ; CJUMP
008119  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00811C  8B C3                 MOV    ax, bx ; MOV
