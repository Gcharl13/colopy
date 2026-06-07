; ============================================================================
; func_00B23E_unknown
; Region   : load_image
; Bytes    : file 0x00B23E..0x00B26C  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B23E  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00B242  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
00B245  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00B248  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00B24B  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00B24F  8A 07                 MOV    al, byte ptr [bx] ; MOV
00B251  2A E4                 SUB    ah, ah ; ARITH
00B253  8A 57 01              MOV    dl, byte ptr [bx + 1] ; MOV
00B256  2A F6                 SUB    dh, dh ; ARITH
00B258  9A 5C 00 27 04        LCALL  0x427, 0x5c ; LCALL
00B25D  EB 37                 JMP    0xb296 ; JUMP
00B25F  90                    NOP ; NOP
00B260  6B 5E FA 1C           IMUL   bx, word ptr [bp - 6], 0x1c ; ARITH
00B264  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
00B268  2A FF                 SUB    bh, bh ; ARITH
00B26A  8B C3                 MOV    ax, bx ; MOV
