; ============================================================================
; func_00D3EC_unknown
; Region   : load_image
; Bytes    : file 0x00D3EC..0x00D41D  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D3EC  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
00D3F0  57                    PUSH   di ; STACK_PUSH
00D3F1  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00D3F4  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00D3F7  50                    PUSH   ax ; STACK_PUSH
00D3F8  57                    PUSH   di ; STACK_PUSH
00D3F9  89 7E F8              MOV    word ptr [bp - 8], di ; LOCAL_STORE
00D3FC  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00D3FF  9A 3C 11 1D 0D        LCALL  0xd1d, 0x113c ; LCALL
00D404  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00D407  8B D8                 MOV    bx, ax ; MOV
00D409  03 5E F8              ADD    bx, word ptr [bp - 8] ; ARITH
00D40C  8E 46 FA              MOV    es, word ptr [bp - 6] ; LOCAL_LOAD
00D40F  26 C6 07 0A           MOV    byte ptr es:[bx], 0xa ; CONST_LOAD
00D413  43                    INC    bx ; ARITH
00D414  26 C6 07 00           MOV    byte ptr es:[bx], 0 ; MOV
00D418  5F                    POP    di ; STACK_POP
00D419  C9                    LEAVE ; EPILOGUE
00D41A  CA 04 00              RETF   4 ; RETURN
