; ============================================================================
; func_03B2F8_unknown
; Region   : overlay
; Bytes    : file 0x03B2F8..0x03B369  (113 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03B2F8  C8 2C 00 00           ENTER  0x2c, 0 ; PROLOGUE
03B2FC  6B 06 98 53 34        IMUL   ax, word ptr [0x5398], 0x34 ; ARITH
03B301  05 0E 54              ADD    ax, 0x540e ; ARITH
03B304  50                    PUSH   ax ; STACK_PUSH
03B305  8D 46 D6              LEA    ax, [bp - 0x2a] ; ADDR
03B308  50                    PUSH   ax ; STACK_PUSH
03B309  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
03B30E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B311  A1 98 53              MOV    ax, word ptr [0x5398] ; GLOBAL_LOAD
03B314  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
03B317  A0 82 53              MOV    al, byte ptr [0x5382] ; GLOBAL_LOAD
03B31A  25 01 00              AND    ax, 1 ; LOGIC
03B31D  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
03B320  A0 82 53              MOV    al, byte ptr [0x5382] ; GLOBAL_LOAD
03B323  25 08 00              AND    ax, 8 ; LOGIC
03B326  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
03B329  A1 8A 53              MOV    ax, word ptr [0x538a] ; GLOBAL_LOAD
03B32C  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
03B32F  A1 8C 53              MOV    ax, word ptr [0x538c] ; GLOBAL_LOAD
03B332  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
03B335  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
03B338  2A E4                 SUB    ah, ah ; ARITH
03B33A  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
03B33D  6A 00                 PUSH   0 ; STACK_PUSH
03B33F  0E                    PUSH   cs ; STACK_PUSH
03B340  E8 27 00              CALL   0x3b36a ; CALL_NEAR
03B343  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03B346  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
03B349  8D 46 D4              LEA    ax, [bp - 0x2c] ; ADDR
03B34C  50                    PUSH   ax ; STACK_PUSH
03B34D  6A 01                 PUSH   1 ; STACK_PUSH
03B34F  0E                    PUSH   cs ; STACK_PUSH
03B350  E8 21 00              CALL   0x3b374 ; CALL_NEAR
03B353  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03B356  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03B359  8B 46 D4              MOV    ax, word ptr [bp - 0x2c] ; LOCAL_LOAD
03B35C  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03B35F  8D 46 D6              LEA    ax, [bp - 0x2a] ; ADDR
03B362  50                    PUSH   ax ; STACK_PUSH
03B363  0E                    PUSH   cs ; STACK_PUSH
03B364  E8 08 00              CALL   0x3b36f ; CALL_NEAR
03B367  C9                    LEAVE ; EPILOGUE
03B368  CB                    RETF ; RETURN
