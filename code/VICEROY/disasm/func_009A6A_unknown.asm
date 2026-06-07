; ============================================================================
; func_009A6A_unknown
; Region   : load_image
; Bytes    : file 0x009A6A..0x009AA9  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009A6A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
009A6E  2B C0                 SUB    ax, ax ; ARITH
009A70  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
009A73  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
009A76  EB 26                 JMP    0x9a9e ; JUMP
009A78  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
009A7B  50                    PUSH   ax ; STACK_PUSH
009A7C  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
009A7F  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
009A83  98                    CWDE ; ARITH
009A84  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
009A87  50                    PUSH   ax ; STACK_PUSH
009A88  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
009A8C  98                    CWDE ; ARITH
009A8D  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
009A90  50                    PUSH   ax ; STACK_PUSH
009A91  0E                    PUSH   cs ; STACK_PUSH
009A92  E8 9D FF              CALL   0x9a32 ; CALL_NEAR
009A95  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
009A98  01 46 FE              ADD    word ptr [bp - 2], ax ; ARITH
009A9B  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
009A9E  83 7E FC 08           CMP    word ptr [bp - 4], 8 ; CMP
009AA2  7C D4                 JL     0x9a78 ; CJUMP
009AA4  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
009AA7  C9                    LEAVE ; EPILOGUE
009AA8  CB                    RETF ; RETURN
