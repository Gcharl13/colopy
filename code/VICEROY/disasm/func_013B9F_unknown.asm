; ============================================================================
; func_013B9F_unknown
; Region   : load_image
; Bytes    : file 0x013B9F..0x013BB5  (22 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013B9F  55                    PUSH   bp ; STACK_PUSH
013BA0  8B EC                 MOV    bp, sp ; MOV
013BA2  50                    PUSH   ax ; STACK_PUSH
013BA3  53                    PUSH   bx ; STACK_PUSH
013BA4  9C                    PUSHF ; STACK_PUSH
013BA5  58                    POP    ax ; STACK_POP
013BA6  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
013BA9  2E A1 A5 5D           MOV    ax, word ptr cs:[0x5da5] ; GLOBAL_LOAD
013BAD  2E 03 06 A3 5D        ADD    ax, word ptr cs:[0x5da3] ; ARITH
013BB2  40                    INC    ax ; ARITH
013BB3  8C C3                 MOV    bx, es ; MOV
