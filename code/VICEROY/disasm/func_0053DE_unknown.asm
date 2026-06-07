; ============================================================================
; func_0053DE_unknown
; Region   : load_image
; Bytes    : file 0x0053DE..0x00540A  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0053DE  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0053E2  FF 4E 06              DEC    word ptr [bp + 6] ; ARITH
0053E5  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0053E8  C1 F8 03              SAR    ax, 3 ; LOGIC
0053EB  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0053EE  8A 4E 06              MOV    cl, byte ptr [bp + 6] ; LOCAL_LOAD
0053F1  80 E1 07              AND    cl, 7 ; LOGIC
0053F4  BA 01 00              MOV    dx, 1 ; MOV
0053F7  D3 E2                 SHL    dx, cl ; LOGIC
0053F9  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
0053FC  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
005400  74 08                 JE     0x540a ; CJUMP
005402  8B D8                 MOV    bx, ax ; MOV
005404  08 97 0A 54           OR     byte ptr [bx + 0x540a], dl ; LOGIC
005408  C9                    LEAVE ; EPILOGUE
005409  CB                    RETF ; RETURN
