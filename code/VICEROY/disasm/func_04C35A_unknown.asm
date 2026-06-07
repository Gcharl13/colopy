; ============================================================================
; func_04C35A_unknown
; Region   : overlay
; Bytes    : file 0x04C35A..0x04C3A1  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C35A  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
04C35E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
04C363  EB 04                 JMP    0x4c369 ; JUMP
04C365  90                    NOP ; NOP
04C366  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
04C369  83 7E FE 40           CMP    word ptr [bp - 2], 0x40 ; CMP
04C36D  7D 33                 JGE    0x4c3a2 ; CJUMP
04C36F  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
04C372  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04C375  C1 E3 06              SHL    bx, 6 ; LOGIC
04C378  03 5E FE              ADD    bx, word ptr [bp - 2] ; ARITH
04C37B  C1 E3 02              SHL    bx, 2 ; LOGIC
04C37E  38 87 B0 98           CMP    byte ptr [bx - 0x6750], al ; CMP
04C382  75 E2                 JNE    0x4c366 ; CJUMP
04C384  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
04C387  38 87 B1 98           CMP    byte ptr [bx - 0x674f], al ; CMP
04C38B  75 D9                 JNE    0x4c366 ; CJUMP
04C38D  8A 46 0C              MOV    al, byte ptr [bp + 0xc] ; LOCAL_LOAD
04C390  38 87 B2 98           CMP    byte ptr [bx - 0x674e], al ; CMP
04C394  75 D0                 JNE    0x4c366 ; CJUMP
04C396  8A 46 0E              MOV    al, byte ptr [bp + 0xe] ; LOCAL_LOAD
04C399  38 87 B3 98           CMP    byte ptr [bx - 0x674d], al ; CMP
04C39D  7C C7                 JL     0x4c366 ; CJUMP
04C39F  C9                    LEAVE ; EPILOGUE
04C3A0  CB                    RETF ; RETURN
