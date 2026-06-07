; ============================================================================
; func_005C2C_unknown
; Region   : load_image
; Bytes    : file 0x005C2C..0x005CB0  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005C2C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
005C30  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
005C34  7F 09                 JG     0x5c3f ; CJUMP
005C36  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005C39  F7 D0                 NOT    ax ; LOGIC
005C3B  40                    INC    ax ; ARITH
005C3C  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
005C3F  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
005C43  7F 09                 JG     0x5c4e ; CJUMP
005C45  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
005C48  F7 D0                 NOT    ax ; LOGIC
005C4A  40                    INC    ax ; ARITH
005C4B  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
005C4E  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
005C51  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
005C54  3D 01 00              CMP    ax, 1 ; CMP
005C57  7F 05                 JG     0x5c5e ; CJUMP
005C59  B8 01 00              MOV    ax, 1 ; MOV
005C5C  EB 02                 JMP    0x5c60 ; JUMP
005C5E  2B C0                 SUB    ax, ax ; ARITH
005C60  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
005C63  83 7E 0A 01           CMP    word ptr [bp + 0xa], 1 ; CMP
005C67  74 42                 JE     0x5cab ; CJUMP
005C69  83 7E 06 02           CMP    word ptr [bp + 6], 2 ; CMP
005C6D  7D 0A                 JGE    0x5c79 ; CJUMP
005C6F  83 7E 08 02           CMP    word ptr [bp + 8], 2 ; CMP
005C73  7D 04                 JGE    0x5c79 ; CJUMP
005C75  80 4E FE 01           OR     byte ptr [bp - 2], 1 ; LOGIC
005C79  83 7E 0A 02           CMP    word ptr [bp + 0xa], 2 ; CMP
005C7D  74 2C                 JE     0x5cab ; CJUMP
005C7F  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
005C82  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
005C85  3D 02 00              CMP    ax, 2 ; CMP
005C88  7F 06                 JG     0x5c90 ; CJUMP
005C8A  B8 01 00              MOV    ax, 1 ; MOV
005C8D  EB 03                 JMP    0x5c92 ; JUMP
005C8F  90                    NOP ; NOP
005C90  2B C0                 SUB    ax, ax ; ARITH
005C92  09 46 FE              OR     word ptr [bp - 2], ax ; LOGIC
005C95  83 7E 0A 03           CMP    word ptr [bp + 0xa], 3 ; CMP
005C99  74 10                 JE     0x5cab ; CJUMP
005C9B  83 7E 06 02           CMP    word ptr [bp + 6], 2 ; CMP
005C9F  7C 06                 JL     0x5ca7 ; CJUMP
005CA1  83 7E 08 02           CMP    word ptr [bp + 8], 2 ; CMP
005CA5  7D 04                 JGE    0x5cab ; CJUMP
005CA7  80 4E FE 01           OR     byte ptr [bp - 2], 1 ; LOGIC
005CAB  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
005CAE  C9                    LEAVE ; EPILOGUE
005CAF  CB                    RETF ; RETURN
