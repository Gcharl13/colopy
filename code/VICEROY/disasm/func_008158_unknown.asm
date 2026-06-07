; ============================================================================
; func_008158_unknown
; Region   : load_image
; Bytes    : file 0x008158..0x008166  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008158  55                    PUSH   bp ; STACK_PUSH
008159  8B EC                 MOV    bp, sp ; MOV
00815B  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
00815F  7C 11                 JL     0x8172 ; CJUMP
008161  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
008164  8B C3                 MOV    ax, bx ; MOV
