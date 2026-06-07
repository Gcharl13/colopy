; ============================================================================
; func_00822A_unknown
; Region   : load_image
; Bytes    : file 0x00822A..0x00824E  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00822A  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00822E  6B 5E 06 4E           IMUL   bx, word ptr [bp + 6], 0x4e ; ARITH
008232  8A 87 D8 5A           MOV    al, byte ptr [bx + 0x5ad8] ; MOV
008236  2A E4                 SUB    ah, ah ; ARITH
008238  0B C0                 OR     ax, ax ; LOGIC
00823A  74 08                 JE     0x8244 ; CJUMP
00823C  48                    DEC    ax ; ARITH
00823D  74 05                 JE     0x8244 ; CJUMP
00823F  48                    DEC    ax ; ARITH
008240  74 0C                 JE     0x824e ; CJUMP
008242  EB 14                 JMP    0x8258 ; JUMP
008244  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
008249  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00824C  C9                    LEAVE ; EPILOGUE
00824D  CB                    RETF ; RETURN
