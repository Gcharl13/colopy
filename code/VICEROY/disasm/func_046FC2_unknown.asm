; ============================================================================
; func_046FC2_unknown
; Region   : overlay
; Bytes    : file 0x046FC2..0x046FFA  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046FC2  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
046FC6  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
046FC9  05 04 00              ADD    ax, 4 ; ARITH
046FCC  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
046FCF  A1 9A 53              MOV    ax, word ptr [0x539a] ; GLOBAL_LOAD
046FD2  48                    DEC    ax ; ARITH
046FD3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
046FD6  EB 1A                 JMP    0x46ff2 ; JUMP
046FD8  8A 46 FC              MOV    al, byte ptr [bp - 4] ; LOCAL_LOAD
046FDB  6B 5E FE 12           IMUL   bx, word ptr [bp - 2], 0x12 ; ARITH
046FDF  38 87 EE 54           CMP    byte ptr [bx + 0x54ee], al ; CMP
046FE3  75 0A                 JNE    0x46fef ; CJUMP
046FE5  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
046FE8  0E                    PUSH   cs ; STACK_PUSH
046FE9  E8 16 4A              CALL   0x4ba02 ; CALL_NEAR
046FEC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
046FEF  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
046FF2  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
046FF6  7D E0                 JGE    0x46fd8 ; CJUMP
046FF8  C9                    LEAVE ; EPILOGUE
046FF9  CB                    RETF ; RETURN
