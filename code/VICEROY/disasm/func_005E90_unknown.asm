; ============================================================================
; func_005E90_unknown
; Region   : load_image
; Bytes    : file 0x005E90..0x005ED0  (64 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005E90  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
005E94  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
005E99  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005E9C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005E9F  0E                    PUSH   cs ; STACK_PUSH
005EA0  E8 57 FD              CALL   0x5bfa ; CALL_NEAR
005EA3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005EA6  0B C0                 OR     ax, ax ; LOGIC
005EA8  74 21                 JE     0x5ecb ; CJUMP
005EAA  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005EAD  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005EB0  9A 74 00 E4 03        LCALL  0x3e4, 0x74 ; LCALL
005EB5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005EB8  0B C0                 OR     ax, ax ; LOGIC
005EBA  75 0F                 JNE    0x5ecb ; CJUMP
005EBC  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005EBF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005EC2  0E                    PUSH   cs ; STACK_PUSH
005EC3  E8 F4 FE              CALL   0x5dba ; CALL_NEAR
005EC6  2A E4                 SUB    ah, ah ; ARITH
005EC8  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
005ECB  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
005ECE  C9                    LEAVE ; EPILOGUE
005ECF  CB                    RETF ; RETURN
