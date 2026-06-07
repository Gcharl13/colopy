; ============================================================================
; func_001C3A_unknown
; Region   : load_image
; Bytes    : file 0x001C3A..0x001C6F  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

001C3A  55                    PUSH   bp ; STACK_PUSH
001C3B  8B EC                 MOV    bp, sp ; MOV
001C3D  56                    PUSH   si ; STACK_PUSH
001C3E  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
001C41  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
001C44  50                    PUSH   ax ; STACK_PUSH
001C45  56                    PUSH   si ; STACK_PUSH
001C46  1E                    PUSH   ds ; STACK_PUSH
001C47  68 7A 48              PUSH   0x487a ; PUSH_CONST
001C4A  50                    PUSH   ax ; STACK_PUSH
001C4B  56                    PUSH   si ; STACK_PUSH
001C4C  9A 20 0D 7D 03        LCALL  0x37d, 0xd20 ; LCALL
001C51  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
001C54  40                    INC    ax ; ARITH
001C55  99                    CDQ ; ARITH
001C56  9A 18 01 11 07        LCALL  0x711, 0x118 ; LCALL
001C5B  52                    PUSH   dx ; STACK_PUSH
001C5C  50                    PUSH   ax ; STACK_PUSH
001C5D  9A 38 0D 7D 03        LCALL  0x37d, 0xd38 ; LCALL
001C62  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
001C65  A1 E8 53              MOV    ax, word ptr [0x53e8] ; GLOBAL_LOAD
001C68  FF 06 E8 53           INC    word ptr [0x53e8] ; ARITH
001C6C  5E                    POP    si ; STACK_POP
001C6D  C9                    LEAVE ; EPILOGUE
001C6E  CB                    RETF ; RETURN
