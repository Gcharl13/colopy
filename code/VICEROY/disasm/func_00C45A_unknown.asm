; ============================================================================
; func_00C45A_unknown
; Region   : load_image
; Bytes    : file 0x00C45A..0x00C486  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C45A  C8 50 00 00           ENTER  0x50, 0 ; PROLOGUE
00C45E  53                    PUSH   bx ; STACK_PUSH
00C45F  56                    PUSH   si ; STACK_PUSH
00C460  8B F3                 MOV    si, bx ; MOV
00C462  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00C465  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00C468  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
00C46B  16                    PUSH   ss ; STACK_PUSH
00C46C  50                    PUSH   ax ; STACK_PUSH
00C46D  0E                    PUSH   cs ; STACK_PUSH
00C46E  E8 9F FF              CALL   0xc410 ; CALL_NEAR
00C471  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00C474  56                    PUSH   si ; STACK_PUSH
00C475  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
00C478  50                    PUSH   ax ; STACK_PUSH
00C479  9A DA 04 1D 0D        LCALL  0xd1d, 0x4da ; LCALL
00C47E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00C481  5E                    POP    si ; STACK_POP
00C482  C9                    LEAVE ; EPILOGUE
00C483  CA 04 00              RETF   4 ; RETURN
