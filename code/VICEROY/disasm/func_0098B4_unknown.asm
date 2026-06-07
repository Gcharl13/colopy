; ============================================================================
; func_0098B4_unknown
; Region   : load_image
; Bytes    : file 0x0098B4..0x0098F5  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0098B4  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0098B8  C7 46 FC 14 00        MOV    word ptr [bp - 4], 0x14 ; LOCAL_STORE
0098BD  C7 46 FA C8 00        MOV    word ptr [bp - 6], 0xc8 ; LOCAL_STORE
0098C2  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
0098C6  74 07                 JE     0x98cf ; CJUMP
0098C8  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
0098CB  C7 07 14 00           MOV    word ptr [bx], 0x14 ; CONST_LOAD
0098CF  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0098D3  74 1B                 JE     0x98f0 ; CJUMP
0098D5  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
0098D9  26 8B 87 52 01        MOV    ax, word ptr es:[bx + 0x152] ; MOV
0098DE  40                    INC    ax ; ARITH
0098DF  F7 6E FC              IMUL   word ptr [bp - 4] ; ARITH
0098E2  48                    DEC    ax ; ARITH
0098E3  3D 76 00              CMP    ax, 0x76 ; CMP
0098E6  7E 03                 JLE    0x98eb ; CJUMP
0098E8  B8 76 00              MOV    ax, 0x76 ; CONST_LOAD
0098EB  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0098EE  89 07                 MOV    word ptr [bx], ax ; MOV
0098F0  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
0098F3  C9                    LEAVE ; EPILOGUE
0098F4  CB                    RETF ; RETURN
