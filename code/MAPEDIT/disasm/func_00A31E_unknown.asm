; ============================================================================
; func_00A31E_unknown
; Region   : load_image
; Bytes    : file 0x00A31E..0x00A358  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A31E  55                    PUSH   bp ; STACK_PUSH
00A31F  8B EC                 MOV    bp, sp ; MOV
00A321  56                    PUSH   si ; STACK_PUSH
00A322  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
00A325  6A 00                 PUSH   0 ; STACK_PUSH
00A327  8A 16 92 00           MOV    dl, byte ptr [0x92] ; GLOBAL_LOAD
00A32B  2A F6                 SUB    dh, dh ; ARITH
00A32D  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
00A330  2B DB                 SUB    bx, bx ; ARITH
00A332  9A 06 00 6A 0D        LCALL  0xd6a, 6 ; LCALL
00A337  FF 36 82 00           PUSH   word ptr [0x82] ; PUSH_GLOBAL
00A33B  FF 36 80 00           PUSH   word ptr [0x80] ; PUSH_GLOBAL
00A33F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A342  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A345  6A 00                 PUSH   0 ; STACK_PUSH
00A347  8D 1E F4 3A           LEA    bx, [0x3af4] ; ADDR
00A34B  8B C6                 MOV    ax, si ; MOV
00A34D  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
00A350  9A 08 00 53 0D        LCALL  0xd53, 8 ; LCALL
00A355  5E                    POP    si ; STACK_POP
00A356  C9                    LEAVE ; EPILOGUE
00A357  CB                    RETF ; RETURN
