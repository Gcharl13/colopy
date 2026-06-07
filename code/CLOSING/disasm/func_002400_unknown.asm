; ============================================================================
; func_002400_unknown
; Region   : load_image
; Bytes    : file 0x002400..0x00244D  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002400  55                    PUSH   bp ; STACK_PUSH
002401  8B EC                 MOV    bp, sp ; MOV
002403  56                    PUSH   si ; STACK_PUSH
002404  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
002407  6A 2E                 PUSH   0x2e ; PUSH_CONST
002409  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00240C  56                    PUSH   si ; STACK_PUSH
00240D  9A CE 0C 7D 03        LCALL  0x37d, 0xcce ; LCALL
002412  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
002415  0B D0                 OR     dx, ax ; LOGIC
002417  75 22                 JNE    0x243b ; CJUMP
002419  1E                    PUSH   ds ; STACK_PUSH
00241A  68 0C 03              PUSH   0x30c ; PUSH_CONST
00241D  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
002420  56                    PUSH   si ; STACK_PUSH
002421  9A 6E 0D 7D 03        LCALL  0x37d, 0xd6e ; LCALL
002426  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
002429  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00242C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00242F  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
002432  56                    PUSH   si ; STACK_PUSH
002433  9A 6E 0D 7D 03        LCALL  0x37d, 0xd6e ; LCALL
002438  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00243B  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
00243E  50                    PUSH   ax ; STACK_PUSH
00243F  56                    PUSH   si ; STACK_PUSH
002440  9A FC 0C 7D 03        LCALL  0x37d, 0xcfc ; LCALL
002445  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
002448  5E                    POP    si ; STACK_POP
002449  C9                    LEAVE ; EPILOGUE
00244A  CA 08 00              RETF   8 ; RETURN
