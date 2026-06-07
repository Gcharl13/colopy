; ============================================================================
; func_009818_unknown
; Region   : load_image
; Bytes    : file 0x009818..0x00985A  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009818  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00981C  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
009821  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
009824  0E                    PUSH   cs ; STACK_PUSH
009825  E8 32 FF              CALL   0x975a ; CALL_NEAR
009828  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00982B  0B C0                 OR     ax, ax ; LOGIC
00982D  75 2B                 JNE    0x985a ; CJUMP
00982F  A1 78 8D              MOV    ax, word ptr [0x8d78] ; GLOBAL_LOAD
009832  EB 17                 JMP    0x984b ; JUMP
009834  50                    PUSH   ax ; STACK_PUSH
009835  0E                    PUSH   cs ; STACK_PUSH
009836  E8 5D F3              CALL   0x8b96 ; CALL_NEAR
009839  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00983C  0B C0                 OR     ax, ax ; LOGIC
00983E  74 03                 JE     0x9843 ; CJUMP
009840  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
009843  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
009846  9A 4A 00 27 04        LCALL  0x427, 0x4a ; LCALL
00984B  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00984E  0B C0                 OR     ax, ax ; LOGIC
009850  7D E2                 JGE    0x9834 ; CJUMP
009852  F7 5E FE              NEG    word ptr [bp - 2] ; ARITH
009855  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
009858  C9                    LEAVE ; EPILOGUE
009859  CB                    RETF ; RETURN
