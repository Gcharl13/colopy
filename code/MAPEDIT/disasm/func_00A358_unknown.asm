; ============================================================================
; func_00A358_unknown
; Region   : load_image
; Bytes    : file 0x00A358..0x00A392  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A358  55                    PUSH   bp ; STACK_PUSH
00A359  8B EC                 MOV    bp, sp ; MOV
00A35B  57                    PUSH   di ; STACK_PUSH
00A35C  56                    PUSH   si ; STACK_PUSH
00A35D  8B 7E 0A              MOV    di, word ptr [bp + 0xa] ; LOCAL_LOAD
00A360  8B 76 0E              MOV    si, word ptr [bp + 0xe] ; LOCAL_LOAD
00A363  56                    PUSH   si ; STACK_PUSH
00A364  8B D6                 MOV    dx, si ; MOV
00A366  8B DE                 MOV    bx, si ; MOV
00A368  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
00A36B  9A 06 00 6A 0D        LCALL  0xd6a, 6 ; LCALL
00A370  FF 36 82 00           PUSH   word ptr [0x82] ; PUSH_GLOBAL
00A374  FF 36 80 00           PUSH   word ptr [0x80] ; PUSH_GLOBAL
00A378  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A37B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A37E  6A 00                 PUSH   0 ; STACK_PUSH
00A380  8D 1E F4 3A           LEA    bx, [0x3af4] ; ADDR
00A384  8B C7                 MOV    ax, di ; MOV
00A386  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
00A389  9A 08 00 53 0D        LCALL  0xd53, 8 ; LCALL
00A38E  5E                    POP    si ; STACK_POP
00A38F  5F                    POP    di ; STACK_POP
00A390  C9                    LEAVE ; EPILOGUE
00A391  CB                    RETF ; RETURN
