; ============================================================================
; func_00A46A_unknown
; Region   : load_image
; Bytes    : file 0x00A46A..0x00A4A2  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A46A  55                    PUSH   bp ; STACK_PUSH
00A46B  8B EC                 MOV    bp, sp ; MOV
00A46D  56                    PUSH   si ; STACK_PUSH
00A46E  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
00A471  6A 00                 PUSH   0 ; STACK_PUSH
00A473  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
00A476  8B 56 0E              MOV    dx, word ptr [bp + 0xe] ; LOCAL_LOAD
00A479  8B 5E 10              MOV    bx, word ptr [bp + 0x10] ; LOCAL_LOAD
00A47C  9A 06 00 6A 0D        LCALL  0xd6a, 6 ; LCALL
00A481  FF 36 98 3A           PUSH   word ptr [0x3a98] ; PUSH_GLOBAL
00A485  FF 36 96 3A           PUSH   word ptr [0x3a96] ; PUSH_GLOBAL
00A489  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A48C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A48F  6A 00                 PUSH   0 ; STACK_PUSH
00A491  8D 1E F4 3A           LEA    bx, [0x3af4] ; ADDR
00A495  8B C6                 MOV    ax, si ; MOV
00A497  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
00A49A  9A 08 00 53 0D        LCALL  0xd53, 8 ; LCALL
00A49F  5E                    POP    si ; STACK_POP
00A4A0  C9                    LEAVE ; EPILOGUE
00A4A1  CB                    RETF ; RETURN
