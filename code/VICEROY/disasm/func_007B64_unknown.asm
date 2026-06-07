; ============================================================================
; func_007B64_unknown
; Region   : load_image
; Bytes    : file 0x007B64..0x007BCD  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007B64  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
007B68  57                    PUSH   di ; STACK_PUSH
007B69  56                    PUSH   si ; STACK_PUSH
007B6A  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
007B6F  C7 46 FC 0F 27        MOV    word ptr [bp - 4], 0x270f ; LOCAL_STORE
007B74  2B F6                 SUB    si, si ; ARITH
007B76  39 36 9C 53           CMP    word ptr [0x539c], si ; CMP
007B7A  7E 44                 JLE    0x7bc0 ; CJUMP
007B7C  BF 47 31              MOV    di, 0x3147 ; CONST_LOAD
007B7F  8A 05                 MOV    al, byte ptr [di] ; MOV
007B81  24 0F                 AND    al, 0xf ; LOGIC
007B83  3A 46 06              CMP    al, byte ptr [bp + 6] ; CMP
007B86  75 2E                 JNE    0x7bb6 ; CJUMP
007B88  39 76 08              CMP    word ptr [bp + 8], si ; CMP
007B8B  74 29                 JE     0x7bb6 ; CJUMP
007B8D  8A 45 FE              MOV    al, byte ptr [di - 2] ; MOV
007B90  2A E4                 SUB    ah, ah ; ARITH
007B92  2B 46 0C              SUB    ax, word ptr [bp + 0xc] ; ARITH
007B95  F7 D8                 NEG    ax ; ARITH
007B97  50                    PUSH   ax ; STACK_PUSH
007B98  8A 45 FD              MOV    al, byte ptr [di - 3] ; MOV
007B9B  2A E4                 SUB    ah, ah ; ARITH
007B9D  2B 46 0A              SUB    ax, word ptr [bp + 0xa] ; ARITH
007BA0  F7 D8                 NEG    ax ; ARITH
007BA2  50                    PUSH   ax ; STACK_PUSH
007BA3  9A 40 00 4C 02        LCALL  0x24c, 0x40 ; LCALL
007BA8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007BAB  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
007BAE  7F 06                 JG     0x7bb6 ; CJUMP
007BB0  89 76 FA              MOV    word ptr [bp - 6], si ; LOCAL_STORE
007BB3  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
007BB6  83 C7 1C              ADD    di, 0x1c ; ARITH
007BB9  46                    INC    si ; ARITH
007BBA  39 36 9C 53           CMP    word ptr [0x539c], si ; CMP
007BBE  7F BF                 JG     0x7b7f ; CJUMP
007BC0  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
007BC3  A3 F8 8C              MOV    word ptr [0x8cf8], ax ; GLOBAL_LOAD
007BC6  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
007BC9  5E                    POP    si ; STACK_POP
007BCA  5F                    POP    di ; STACK_POP
007BCB  C9                    LEAVE ; EPILOGUE
007BCC  CB                    RETF ; RETURN
