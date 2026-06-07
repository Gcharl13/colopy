; ============================================================================
; func_008BD4_unknown
; Region   : load_image
; Bytes    : file 0x008BD4..0x008C1D  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008BD4  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
008BD8  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
008BDB  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
008BDE  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
008BE1  A1 78 8D              MOV    ax, word ptr [0x8d78] ; GLOBAL_LOAD
008BE4  EB 2B                 JMP    0x8c11 ; JUMP
008BE6  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
008BEA  7D 2C                 JGE    0x8c18 ; CJUMP
008BEC  50                    PUSH   ax ; STACK_PUSH
008BED  0E                    PUSH   cs ; STACK_PUSH
008BEE  E8 A5 FF              CALL   0x8b96 ; CALL_NEAR
008BF1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
008BF4  0B C0                 OR     ax, ax ; LOGIC
008BF6  74 11                 JE     0x8c09 ; CJUMP
008BF8  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
008BFB  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
008BFE  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
008C01  75 06                 JNE    0x8c09 ; CJUMP
008C03  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
008C06  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
008C09  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
008C0C  9A 4A 00 27 04        LCALL  0x427, 0x4a ; LCALL
008C11  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
008C14  0B C0                 OR     ax, ax ; LOGIC
008C16  7D CE                 JGE    0x8be6 ; CJUMP
008C18  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
008C1B  C9                    LEAVE ; EPILOGUE
008C1C  CB                    RETF ; RETURN
