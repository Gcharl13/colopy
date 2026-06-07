; ============================================================================
; func_00D72E_unknown
; Region   : load_image
; Bytes    : file 0x00D72E..0x00D77B  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D72E  55                    PUSH   bp ; STACK_PUSH
00D72F  8B EC                 MOV    bp, sp ; MOV
00D731  56                    PUSH   si ; STACK_PUSH
00D732  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
00D735  6A 2E                 PUSH   0x2e ; PUSH_CONST
00D737  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D73A  56                    PUSH   si ; STACK_PUSH
00D73B  9A EA 10 1D 0D        LCALL  0xd1d, 0x10ea ; LCALL
00D740  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00D743  0B D0                 OR     dx, ax ; LOGIC
00D745  75 22                 JNE    0xd769 ; CJUMP
00D747  1E                    PUSH   ds ; STACK_PUSH
00D748  68 26 26              PUSH   0x2626 ; PUSH_CONST
00D74B  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D74E  56                    PUSH   si ; STACK_PUSH
00D74F  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
00D754  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D757  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00D75A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00D75D  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D760  56                    PUSH   si ; STACK_PUSH
00D761  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
00D766  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D769  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
00D76C  50                    PUSH   ax ; STACK_PUSH
00D76D  56                    PUSH   si ; STACK_PUSH
00D76E  9A 18 11 1D 0D        LCALL  0xd1d, 0x1118 ; LCALL
00D773  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00D776  5E                    POP    si ; STACK_POP
00D777  C9                    LEAVE ; EPILOGUE
00D778  CA 08 00              RETF   8 ; RETURN
