; ============================================================================
; func_0088D0_unknown
; Region   : load_image
; Bytes    : file 0x0088D0..0x008917  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0088D0  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0088D4  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0088D9  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0088DC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0088DF  0E                    PUSH   cs ; STACK_PUSH
0088E0  E8 AF FF              CALL   0x8892 ; CALL_NEAR
0088E3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0088E6  0B C0                 OR     ax, ax ; LOGIC
0088E8  7C 28                 JL     0x8912 ; CJUMP
0088EA  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0088EE  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
0088F1  2A E4                 SUB    ah, ah ; ARITH
0088F3  48                    DEC    ax ; ARITH
0088F4  48                    DEC    ax ; ARITH
0088F5  01 46 08              ADD    word ptr [bp + 8], ax ; ARITH
0088F8  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0088FB  8A 07                 MOV    al, byte ptr [bx] ; MOV
0088FD  2A E4                 SUB    ah, ah ; ARITH
0088FF  48                    DEC    ax ; ARITH
008900  48                    DEC    ax ; ARITH
008901  01 46 06              ADD    word ptr [bp + 6], ax ; ARITH
008904  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
008907  9A 42 01 7F 03        LCALL  0x37f, 0x142 ; LCALL
00890C  25 10 00              AND    ax, 0x10 ; LOGIC
00890F  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
008912  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
008915  C9                    LEAVE ; EPILOGUE
008916  CB                    RETF ; RETURN
