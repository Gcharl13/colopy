; ============================================================================
; func_00A2B8_unknown
; Region   : load_image
; Bytes    : file 0x00A2B8..0x00A2E6  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A2B8  55                    PUSH   bp ; STACK_PUSH
00A2B9  8B EC                 MOV    bp, sp ; MOV
00A2BB  57                    PUSH   di ; STACK_PUSH
00A2BC  56                    PUSH   si ; STACK_PUSH
00A2BD  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00A2C0  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00A2C3  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00A2C6  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00A2C9  50                    PUSH   ax ; STACK_PUSH
00A2CA  56                    PUSH   si ; STACK_PUSH
00A2CB  8B F8                 MOV    di, ax ; MOV
00A2CD  0E                    PUSH   cs ; STACK_PUSH
00A2CE  E8 BD FF              CALL   0xa28e ; CALL_NEAR
00A2D1  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00A2D4  1E                    PUSH   ds ; STACK_PUSH
00A2D5  68 68 06              PUSH   0x668 ; PUSH_CONST
00A2D8  57                    PUSH   di ; STACK_PUSH
00A2D9  56                    PUSH   si ; STACK_PUSH
00A2DA  9A 22 0E 88 13        LCALL  0x1388, 0xe22 ; LCALL
00A2DF  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00A2E2  5E                    POP    si ; STACK_POP
00A2E3  5F                    POP    di ; STACK_POP
00A2E4  C9                    LEAVE ; EPILOGUE
00A2E5  CB                    RETF ; RETURN
