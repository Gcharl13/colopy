; ============================================================================
; func_00B5A8_unknown
; Region   : load_image
; Bytes    : file 0x00B5A8..0x00B5FA  (82 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B5A8  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00B5AC  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
00B5B1  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
00B5B5  7D 07                 JGE    0xb5be ; CJUMP
00B5B7  2B C0                 SUB    ax, ax ; ARITH
00B5B9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00B5BC  EB 26                 JMP    0xb5e4 ; JUMP
00B5BE  83 7E 06 2A           CMP    word ptr [bp + 6], 0x2a ; CMP
00B5C2  7D 0A                 JGE    0xb5ce ; CJUMP
00B5C4  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
00B5C9  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00B5CC  EB 16                 JMP    0xb5e4 ; JUMP
00B5CE  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00B5D1  2D 2A 00              SUB    ax, 0x2a ; ARITH
00B5D4  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00B5D7  3D 07 00              CMP    ax, 7 ; CMP
00B5DA  7D 0B                 JGE    0xb5e7 ; CJUMP
00B5DC  C7 46 FC 02 00        MOV    word ptr [bp - 4], 2 ; LOCAL_STORE
00B5E1  05 0B 00              ADD    ax, 0xb ; ARITH
00B5E4  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00B5E7  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
00B5EB  74 08                 JE     0xb5f5 ; CJUMP
00B5ED  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00B5F0  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00B5F3  89 07                 MOV    word ptr [bx], ax ; MOV
00B5F5  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00B5F8  C9                    LEAVE ; EPILOGUE
00B5F9  CB                    RETF ; RETURN
