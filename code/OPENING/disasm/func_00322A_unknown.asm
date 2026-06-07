; ============================================================================
; func_00322A_unknown
; Region   : load_image
; Bytes    : file 0x00322A..0x003277  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00322A  55                    PUSH   bp ; STACK_PUSH
00322B  8B EC                 MOV    bp, sp ; MOV
00322D  56                    PUSH   si ; STACK_PUSH
00322E  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
003231  6A 2E                 PUSH   0x2e ; PUSH_CONST
003233  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
003236  56                    PUSH   si ; STACK_PUSH
003237  9A 7E 0D 52 04        LCALL  0x452, 0xd7e ; LCALL
00323C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00323F  0B D0                 OR     dx, ax ; LOGIC
003241  75 22                 JNE    0x3265 ; CJUMP
003243  1E                    PUSH   ds ; STACK_PUSH
003244  68 62 05              PUSH   0x562 ; PUSH_CONST
003247  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00324A  56                    PUSH   si ; STACK_PUSH
00324B  9A 1E 0E 52 04        LCALL  0x452, 0xe1e ; LCALL
003250  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
003253  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
003256  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
003259  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00325C  56                    PUSH   si ; STACK_PUSH
00325D  9A 1E 0E 52 04        LCALL  0x452, 0xe1e ; LCALL
003262  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
003265  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
003268  50                    PUSH   ax ; STACK_PUSH
003269  56                    PUSH   si ; STACK_PUSH
00326A  9A AC 0D 52 04        LCALL  0x452, 0xdac ; LCALL
00326F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
003272  5E                    POP    si ; STACK_POP
003273  C9                    LEAVE ; EPILOGUE
003274  CA 08 00              RETF   8 ; RETURN
