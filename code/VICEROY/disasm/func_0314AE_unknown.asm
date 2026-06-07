; ============================================================================
; func_0314AE_unknown
; Region   : overlay
; Bytes    : file 0x0314AE..0x0314DC  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0314AE  55                    PUSH   bp ; STACK_PUSH
0314AF  8B EC                 MOV    bp, sp ; MOV
0314B1  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0314B4  8B C8                 MOV    cx, ax ; MOV
0314B6  D1 E0                 SHL    ax, 1 ; LOGIC
0314B8  03 C1                 ADD    ax, cx ; ARITH
0314BA  C1 E0 02              SHL    ax, 2 ; LOGIC
0314BD  05 93 00              ADD    ax, 0x93 ; ARITH
0314C0  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
0314C3  89 07                 MOV    word ptr [bx], ax ; MOV
0314C5  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
0314C8  C7 07 A5 00           MOV    word ptr [bx], 0xa5 ; CONST_LOAD
0314CC  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
0314CF  C7 07 0A 00           MOV    word ptr [bx], 0xa ; CONST_LOAD
0314D3  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
0314D6  C7 07 0C 00           MOV    word ptr [bx], 0xc ; CONST_LOAD
0314DA  C9                    LEAVE ; EPILOGUE
0314DB  CB                    RETF ; RETURN
