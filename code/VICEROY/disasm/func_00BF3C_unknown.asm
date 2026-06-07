; ============================================================================
; func_00BF3C_unknown
; Region   : load_image
; Bytes    : file 0x00BF3C..0x00BFF2  (182 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BF3C  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
00BF40  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00BF45  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00BF48  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
00BF4B  7E 03                 JLE    0xbf50 ; CJUMP
00BF4D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00BF50  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
00BF53  3B 4E 06              CMP    cx, word ptr [bp + 6] ; CMP
00BF56  7D 03                 JGE    0xbf5b ; CJUMP
00BF58  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
00BF5B  89 4E F8              MOV    word ptr [bp - 8], cx ; LOCAL_STORE
00BF5E  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
00BF61  3B 4E 08              CMP    cx, word ptr [bp + 8] ; CMP
00BF64  7E 03                 JLE    0xbf69 ; CJUMP
00BF66  8B 4E 08              MOV    cx, word ptr [bp + 8] ; LOCAL_LOAD
00BF69  89 4E FA              MOV    word ptr [bp - 6], cx ; LOCAL_STORE
00BF6C  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
00BF6F  3B 4E 08              CMP    cx, word ptr [bp + 8] ; CMP
00BF72  7D 03                 JGE    0xbf77 ; CJUMP
00BF74  8B 4E 08              MOV    cx, word ptr [bp + 8] ; LOCAL_LOAD
00BF77  89 4E F6              MOV    word ptr [bp - 0xa], cx ; LOCAL_STORE
00BF7A  8B 0E 28 83           MOV    cx, word ptr [0x8328] ; GLOBAL_LOAD
00BF7E  41                    INC    cx ; ARITH
00BF7F  41                    INC    cx ; ARITH
00BF80  3B C1                 CMP    ax, cx ; CMP
00BF82  7D 0C                 JGE    0xbf90 ; CJUMP
00BF84  83 3E 28 83 01        CMP    word ptr [0x8328], 1 ; CMP
00BF89  7E 05                 JLE    0xbf90 ; CJUMP
00BF8B  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
00BF90  A1 2E 83              MOV    ax, word ptr [0x832e] ; GLOBAL_LOAD
00BF93  40                    INC    ax ; ARITH
00BF94  40                    INC    ax ; ARITH
00BF95  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
00BF98  7E 0C                 JLE    0xbfa6 ; CJUMP
00BF9A  83 3E 2E 83 01        CMP    word ptr [0x832e], 1 ; CMP
00BF9F  7E 05                 JLE    0xbfa6 ; CJUMP
00BFA1  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
00BFA6  A1 04 88              MOV    ax, word ptr [0x8804] ; GLOBAL_LOAD
00BFA9  48                    DEC    ax ; ARITH
00BFAA  48                    DEC    ax ; ARITH
00BFAB  3B 46 F8              CMP    ax, word ptr [bp - 8] ; CMP
00BFAE  7D 10                 JGE    0xbfc0 ; CJUMP
00BFB0  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
00BFB3  48                    DEC    ax ; ARITH
00BFB4  48                    DEC    ax ; ARITH
00BFB5  3B 06 04 88           CMP    ax, word ptr [0x8804] ; CMP
00BFB9  7E 05                 JLE    0xbfc0 ; CJUMP
00BFBB  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
00BFC0  A1 06 88              MOV    ax, word ptr [0x8806] ; GLOBAL_LOAD
00BFC3  48                    DEC    ax ; ARITH
00BFC4  48                    DEC    ax ; ARITH
00BFC5  3B 46 F6              CMP    ax, word ptr [bp - 0xa] ; CMP
00BFC8  7D 10                 JGE    0xbfda ; CJUMP
00BFCA  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
00BFCD  48                    DEC    ax ; ARITH
00BFCE  48                    DEC    ax ; ARITH
00BFCF  3B 06 06 88           CMP    ax, word ptr [0x8806] ; CMP
00BFD3  7E 05                 JLE    0xbfda ; CJUMP
00BFD5  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
00BFDA  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
00BFDE  74 0D                 JE     0xbfed ; CJUMP
00BFE0  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
00BFE3  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00BFE6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00BFE9  0E                    PUSH   cs ; STACK_PUSH
00BFEA  E8 F1 FE              CALL   0xbede ; CALL_NEAR
00BFED  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00BFF0  C9                    LEAVE ; EPILOGUE
00BFF1  CB                    RETF ; RETURN
