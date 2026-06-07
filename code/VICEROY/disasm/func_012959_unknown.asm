; ============================================================================
; func_012959_unknown
; Region   : load_image
; Bytes    : file 0x012959..0x012973  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012959  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
01295D  06                    PUSH   es ; STACK_PUSH
01295E  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
012961  0B C0                 OR     ax, ax ; LOGIC
012963  74 0B                 JE     0x12970 ; CJUMP
012965  8E C0                 MOV    es, ax ; MOV
012967  B4 49                 MOV    ah, 0x49 ; CONST_LOAD
012969  CD 21                 INT    0x21 ; SYS
01296B  9A 06 01 47 10        LCALL  0x1047, 0x106 ; LCALL
012970  07                    POP    es ; STACK_POP
012971  C9                    LEAVE ; EPILOGUE
012972  CB                    RETF ; RETURN
