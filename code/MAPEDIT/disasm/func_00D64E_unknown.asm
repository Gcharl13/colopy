; ============================================================================
; func_00D64E_unknown
; Region   : load_image
; Bytes    : file 0x00D64E..0x00D69B  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D64E  55                    PUSH   bp ; STACK_PUSH
00D64F  8B EC                 MOV    bp, sp ; MOV
00D651  56                    PUSH   si ; STACK_PUSH
00D652  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
00D655  6A 2E                 PUSH   0x2e ; PUSH_CONST
00D657  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D65A  56                    PUSH   si ; STACK_PUSH
00D65B  9A 82 0D 88 13        LCALL  0x1388, 0xd82 ; LCALL
00D660  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00D663  0B D0                 OR     dx, ax ; LOGIC
00D665  75 22                 JNE    0xd689 ; CJUMP
00D667  1E                    PUSH   ds ; STACK_PUSH
00D668  68 1A 07              PUSH   0x71a ; PUSH_CONST
00D66B  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D66E  56                    PUSH   si ; STACK_PUSH
00D66F  9A 22 0E 88 13        LCALL  0x1388, 0xe22 ; LCALL
00D674  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D677  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00D67A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00D67D  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D680  56                    PUSH   si ; STACK_PUSH
00D681  9A 22 0E 88 13        LCALL  0x1388, 0xe22 ; LCALL
00D686  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D689  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
00D68C  50                    PUSH   ax ; STACK_PUSH
00D68D  56                    PUSH   si ; STACK_PUSH
00D68E  9A B0 0D 88 13        LCALL  0x1388, 0xdb0 ; LCALL
00D693  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00D696  5E                    POP    si ; STACK_POP
00D697  C9                    LEAVE ; EPILOGUE
00D698  CA 08 00              RETF   8 ; RETURN
