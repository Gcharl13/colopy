; ============================================================================
; func_007BE8_unknown
; Region   : load_image
; Bytes    : file 0x007BE8..0x007C2A  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007BE8  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
007BEC  2B C0                 SUB    ax, ax ; ARITH
007BEE  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
007BF1  50                    PUSH   ax ; STACK_PUSH
007BF2  9A 8E 03 EB 05        LCALL  0x5eb, 0x38e ; LCALL
007BF7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007BFA  0B C0                 OR     ax, ax ; LOGIC
007BFC  74 05                 JE     0x7c03 ; CJUMP
007BFE  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
007C03  6A 01                 PUSH   1 ; STACK_PUSH
007C05  9A 8E 03 EB 05        LCALL  0x5eb, 0x38e ; LCALL
007C0A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007C0D  0B C0                 OR     ax, ax ; LOGIC
007C0F  74 03                 JE     0x7c14 ; CJUMP
007C11  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
007C14  6A 02                 PUSH   2 ; STACK_PUSH
007C16  9A 8E 03 EB 05        LCALL  0x5eb, 0x38e ; LCALL
007C1B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007C1E  0B C0                 OR     ax, ax ; LOGIC
007C20  74 03                 JE     0x7c25 ; CJUMP
007C22  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
007C25  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
007C28  C9                    LEAVE ; EPILOGUE
007C29  CB                    RETF ; RETURN
