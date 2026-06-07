; ============================================================================
; func_001C0E_unknown
; Region   : load_image
; Bytes    : file 0x001C0E..0x001C2F  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

001C0E  55                    PUSH   bp ; STACK_PUSH
001C0F  8B EC                 MOV    bp, sp ; MOV
001C11  1E                    PUSH   ds ; STACK_PUSH
001C12  68 7A 48              PUSH   0x487a ; PUSH_CONST
001C15  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
001C18  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
001C1B  1E                    PUSH   ds ; STACK_PUSH
001C1C  68 C4 01              PUSH   0x1c4 ; PUSH_CONST
001C1F  B8 09 00              MOV    ax, 9 ; MOV
001C22  9A 0E 00 11 07        LCALL  0x711, 0xe ; LCALL
001C27  C7 06 E8 53 00 00     MOV    word ptr [0x53e8], 0 ; GLOBAL_LOAD
001C2D  C9                    LEAVE ; EPILOGUE
001C2E  CB                    RETF ; RETURN
