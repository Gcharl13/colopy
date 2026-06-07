; ============================================================================
; func_005F82_unknown
; Region   : load_image
; Bytes    : file 0x005F82..0x005FA1  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005F82  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
005F86  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
005F8B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005F8E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005F91  0E                    PUSH   cs ; STACK_PUSH
005F92  E8 65 FC              CALL   0x5bfa ; CALL_NEAR
005F95  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005F98  0B C0                 OR     ax, ax ; LOGIC
005F9A  75 06                 JNE    0x5fa2 ; CJUMP
005F9C  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
005F9F  C9                    LEAVE ; EPILOGUE
005FA0  CB                    RETF ; RETURN
