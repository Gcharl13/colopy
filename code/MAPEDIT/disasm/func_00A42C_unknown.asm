; ============================================================================
; func_00A42C_unknown
; Region   : load_image
; Bytes    : file 0x00A42C..0x00A46A  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A42C  55                    PUSH   bp ; STACK_PUSH
00A42D  8B EC                 MOV    bp, sp ; MOV
00A42F  56                    PUSH   si ; STACK_PUSH
00A430  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
00A433  6A 00                 PUSH   0 ; STACK_PUSH
00A435  8A 16 92 00           MOV    dl, byte ptr [0x92] ; GLOBAL_LOAD
00A439  2A F6                 SUB    dh, dh ; ARITH
00A43B  8A 1E 95 00           MOV    bl, byte ptr [0x95] ; GLOBAL_LOAD
00A43F  2A FF                 SUB    bh, bh ; ARITH
00A441  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
00A444  9A 06 00 6A 0D        LCALL  0xd6a, 6 ; LCALL
00A449  FF 36 98 3A           PUSH   word ptr [0x3a98] ; PUSH_GLOBAL
00A44D  FF 36 96 3A           PUSH   word ptr [0x3a96] ; PUSH_GLOBAL
00A451  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A454  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A457  6A 00                 PUSH   0 ; STACK_PUSH
00A459  8D 1E F4 3A           LEA    bx, [0x3af4] ; ADDR
00A45D  8B C6                 MOV    ax, si ; MOV
00A45F  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
00A462  9A 08 00 53 0D        LCALL  0xd53, 8 ; LCALL
00A467  5E                    POP    si ; STACK_POP
00A468  C9                    LEAVE ; EPILOGUE
00A469  CB                    RETF ; RETURN
