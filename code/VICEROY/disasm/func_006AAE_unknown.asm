; ============================================================================
; func_006AAE_unknown
; Region   : load_image
; Bytes    : file 0x006AAE..0x006B15  (103 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006AAE  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
006AB2  56                    PUSH   si ; STACK_PUSH
006AB3  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
006AB6  0B F6                 OR     si, si ; LOGIC
006AB8  7C 24                 JL     0x6ade ; CJUMP
006ABA  39 76 06              CMP    word ptr [bp + 6], si ; CMP
006ABD  75 13                 JNE    0x6ad2 ; CJUMP
006ABF  8D 46 08              LEA    ax, [bp + 8] ; ADDR
006AC2  50                    PUSH   ax ; STACK_PUSH
006AC3  8D 46 06              LEA    ax, [bp + 6] ; ADDR
006AC6  50                    PUSH   ax ; STACK_PUSH
006AC7  9A 2A 00 4C 02        LCALL  0x24c, 0x2a ; LCALL
006ACC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006ACF  BE FF FF              MOV    si, 0xffff ; CONST_LOAD
006AD2  8B C6                 MOV    ax, si ; MOV
006AD4  0E                    PUSH   cs ; STACK_PUSH
006AD5  E8 E2 FB              CALL   0x66ba ; CALL_NEAR
006AD8  8B F0                 MOV    si, ax ; MOV
006ADA  0B F6                 OR     si, si ; LOGIC
006ADC  7D DC                 JGE    0x6aba ; CJUMP
006ADE  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
006AE1  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
006AE5  89 5E FE              MOV    word ptr [bp - 2], bx ; LOCAL_STORE
006AE8  39 87 5E 31           CMP    word ptr [bx + 0x315e], ax ; CMP
006AEC  75 28                 JNE    0x6b16 ; CJUMP
006AEE  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
006AF1  8B 87 5E 31           MOV    ax, word ptr [bx + 0x315e] ; MOV
006AF5  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
006AF8  89 84 5E 31           MOV    word ptr [si + 0x315e], ax ; MOV
006AFC  8B 84 5C 31           MOV    ax, word ptr [si + 0x315c] ; MOV
006B00  89 87 5C 31           MOV    word ptr [bx + 0x315c], ax ; MOV
006B04  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
006B07  89 87 5E 31           MOV    word ptr [bx + 0x315e], ax ; MOV
006B0B  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
006B0E  89 84 5C 31           MOV    word ptr [si + 0x315c], ax ; MOV
006B12  5E                    POP    si ; STACK_POP
006B13  C9                    LEAVE ; EPILOGUE
006B14  CB                    RETF ; RETURN
