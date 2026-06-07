; ============================================================================
; func_00A392_unknown
; Region   : load_image
; Bytes    : file 0x00A392..0x00A3E7  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A392  55                    PUSH   bp ; STACK_PUSH
00A393  8B EC                 MOV    bp, sp ; MOV
00A395  57                    PUSH   di ; STACK_PUSH
00A396  56                    PUSH   si ; STACK_PUSH
00A397  8B 7E 0E              MOV    di, word ptr [bp + 0xe] ; LOCAL_LOAD
00A39A  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
00A39D  57                    PUSH   di ; STACK_PUSH
00A39E  8B D7                 MOV    dx, di ; MOV
00A3A0  8B DF                 MOV    bx, di ; MOV
00A3A2  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
00A3A5  9A 06 00 6A 0D        LCALL  0xd6a, 6 ; LCALL
00A3AA  FF 36 82 00           PUSH   word ptr [0x82] ; PUSH_GLOBAL
00A3AE  FF 36 80 00           PUSH   word ptr [0x80] ; PUSH_GLOBAL
00A3B2  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A3B5  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A3B8  2B C0                 SUB    ax, ax ; ARITH
00A3BA  9A 02 00 6C 0D        LCALL  0xd6c, 2 ; LCALL
00A3BF  2B F0                 SUB    si, ax ; ARITH
00A3C1  FF 36 82 00           PUSH   word ptr [0x82] ; PUSH_GLOBAL
00A3C5  FF 36 80 00           PUSH   word ptr [0x80] ; PUSH_GLOBAL
00A3C9  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A3CC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A3CF  6A 00                 PUSH   0 ; STACK_PUSH
00A3D1  8B C6                 MOV    ax, si ; MOV
00A3D3  8D 1E F4 3A           LEA    bx, [0x3af4] ; ADDR
00A3D7  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
00A3DA  8B F0                 MOV    si, ax ; MOV
00A3DC  9A 08 00 53 0D        LCALL  0xd53, 8 ; LCALL
00A3E1  8B C6                 MOV    ax, si ; MOV
00A3E3  5E                    POP    si ; STACK_POP
00A3E4  5F                    POP    di ; STACK_POP
00A3E5  C9                    LEAVE ; EPILOGUE
00A3E6  CB                    RETF ; RETURN
