; ============================================================================
; func_04C4AE_unknown
; Region   : overlay
; Bytes    : file 0x04C4AE..0x04C4CB  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C4AE  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
04C4B2  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
04C4B7  EB 04                 JMP    0x4c4bd ; JUMP
04C4B9  90                    NOP ; NOP
04C4BA  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
04C4BD  83 7E FE 10           CMP    word ptr [bp - 2], 0x10 ; CMP
04C4C1  7D 47                 JGE    0x4c50a ; CJUMP
04C4C3  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
04C4C6  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
04C4C9  8B CB                 MOV    cx, bx ; MOV
