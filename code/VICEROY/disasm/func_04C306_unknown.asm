; ============================================================================
; func_04C306_unknown
; Region   : overlay
; Bytes    : file 0x04C306..0x04C35A  (84 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C306  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
04C30A  2B C0                 SUB    ax, ax ; ARITH
04C30C  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
04C30F  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
04C312  EB 3B                 JMP    0x4c34f ; JUMP
04C314  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
04C317  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04C31A  C1 E3 06              SHL    bx, 6 ; LOGIC
04C31D  03 5E FC              ADD    bx, word ptr [bp - 4] ; ARITH
04C320  C1 E3 02              SHL    bx, 2 ; LOGIC
04C323  38 87 B0 98           CMP    byte ptr [bx - 0x6750], al ; CMP
04C327  75 23                 JNE    0x4c34c ; CJUMP
04C329  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
04C32C  38 87 B1 98           CMP    byte ptr [bx - 0x674f], al ; CMP
04C330  75 1A                 JNE    0x4c34c ; CJUMP
04C332  8A 46 0C              MOV    al, byte ptr [bp + 0xc] ; LOCAL_LOAD
04C335  38 87 B2 98           CMP    byte ptr [bx - 0x674e], al ; CMP
04C339  75 11                 JNE    0x4c34c ; CJUMP
04C33B  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
04C33E  38 87 B3 98           CMP    byte ptr [bx - 0x674d], al ; CMP
04C342  7C 08                 JL     0x4c34c ; CJUMP
04C344  8A 87 B3 98           MOV    al, byte ptr [bx - 0x674d] ; MOV
04C348  98                    CWDE ; ARITH
04C349  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
04C34C  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
04C34F  83 7E FC 40           CMP    word ptr [bp - 4], 0x40 ; CMP
04C353  7C BF                 JL     0x4c314 ; CJUMP
04C355  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
04C358  C9                    LEAVE ; EPILOGUE
04C359  CB                    RETF ; RETURN
