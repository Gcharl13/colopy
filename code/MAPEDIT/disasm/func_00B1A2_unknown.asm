; ============================================================================
; func_00B1A2_unknown
; Region   : load_image
; Bytes    : file 0x00B1A2..0x00B1DB  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B1A2  55                    PUSH   bp ; STACK_PUSH
00B1A3  8B EC                 MOV    bp, sp ; MOV
00B1A5  57                    PUSH   di ; STACK_PUSH
00B1A6  56                    PUSH   si ; STACK_PUSH
00B1A7  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
00B1AA  BE 19 00              MOV    si, 0x19 ; CONST_LOAD
00B1AD  57                    PUSH   di ; STACK_PUSH
00B1AE  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B1B1  9A 0E 00 AB 02        LCALL  0x2ab, 0xe ; LCALL
00B1B6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B1B9  0B C0                 OR     ax, ax ; LOGIC
00B1BB  74 18                 JE     0xb1d5 ; CJUMP
00B1BD  57                    PUSH   di ; STACK_PUSH
00B1BE  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B1C1  9A 12 01 AB 02        LCALL  0x2ab, 0x112 ; LCALL
00B1C6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B1C9  2A E4                 SUB    ah, ah ; ARITH
00B1CB  50                    PUSH   ax ; STACK_PUSH
00B1CC  0E                    PUSH   cs ; STACK_PUSH
00B1CD  E8 A6 FF              CALL   0xb176 ; CALL_NEAR
00B1D0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00B1D3  8B F0                 MOV    si, ax ; MOV
00B1D5  8B C6                 MOV    ax, si ; MOV
00B1D7  5E                    POP    si ; STACK_POP
00B1D8  5F                    POP    di ; STACK_POP
00B1D9  C9                    LEAVE ; EPILOGUE
00B1DA  CB                    RETF ; RETURN
