; ============================================================================
; func_00A1CC_unknown
; Region   : load_image
; Bytes    : file 0x00A1CC..0x00A1FD  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A1CC  55                    PUSH   bp ; STACK_PUSH
00A1CD  8B EC                 MOV    bp, sp ; MOV
00A1CF  56                    PUSH   si ; STACK_PUSH
00A1D0  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00A1D3  56                    PUSH   si ; STACK_PUSH
00A1D4  0E                    PUSH   cs ; STACK_PUSH
00A1D5  E8 8A FF              CALL   0xa162 ; CALL_NEAR
00A1D8  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00A1DB  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00A1DE  9A 6C 00 34 03        LCALL  0x334, 0x6c ; LCALL
00A1E3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00A1E6  52                    PUSH   dx ; STACK_PUSH
00A1E7  50                    PUSH   ax ; STACK_PUSH
00A1E8  1E                    PUSH   ds ; STACK_PUSH
00A1E9  56                    PUSH   si ; STACK_PUSH
00A1EA  9A 22 0E 88 13        LCALL  0x1388, 0xe22 ; LCALL
00A1EF  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00A1F2  56                    PUSH   si ; STACK_PUSH
00A1F3  0E                    PUSH   cs ; STACK_PUSH
00A1F4  E8 7B FF              CALL   0xa172 ; CALL_NEAR
00A1F7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00A1FA  5E                    POP    si ; STACK_POP
00A1FB  C9                    LEAVE ; EPILOGUE
00A1FC  CB                    RETF ; RETURN
