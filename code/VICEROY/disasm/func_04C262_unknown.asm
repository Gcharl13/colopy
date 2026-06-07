; ============================================================================
; func_04C262_unknown
; Region   : overlay
; Bytes    : file 0x04C262..0x04C297  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C262  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
04C266  C7 46 FE 3E 00        MOV    word ptr [bp - 2], 0x3e ; LOCAL_STORE
04C26B  EB 20                 JMP    0x4c28d ; JUMP
04C26D  90                    NOP ; NOP
04C26E  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04C271  C1 E3 06              SHL    bx, 6 ; LOGIC
04C274  03 5E FE              ADD    bx, word ptr [bp - 2] ; ARITH
04C277  C1 E3 02              SHL    bx, 2 ; LOGIC
04C27A  8B 87 B0 98           MOV    ax, word ptr [bx - 0x6750] ; MOV
04C27E  8B 97 B2 98           MOV    dx, word ptr [bx - 0x674e] ; MOV
04C282  89 87 B4 98           MOV    word ptr [bx - 0x674c], ax ; MOV
04C286  89 97 B6 98           MOV    word ptr [bx - 0x674a], dx ; MOV
04C28A  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
04C28D  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
04C290  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
04C293  7D D9                 JGE    0x4c26e ; CJUMP
04C295  C9                    LEAVE ; EPILOGUE
04C296  CB                    RETF ; RETURN
