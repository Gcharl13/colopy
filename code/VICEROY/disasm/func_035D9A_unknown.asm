; ============================================================================
; func_035D9A_unknown
; Region   : overlay
; Bytes    : file 0x035D9A..0x035DB5  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

035D9A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
035D9E  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
035DA1  C7 07 02 00           MOV    word ptr [bx], 2 ; MOV
035DA5  2B C0                 SUB    ax, ax ; ARITH
035DA7  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
035DAA  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
035DAD  EB 19                 JMP    0x35dc8 ; JUMP
035DAF  90                    NOP ; NOP
035DB0  69 D8 CA 00           IMUL   bx, ax, 0xca ; ARITH
035DB4  8A                    DB     0x8A ; DATA_BYTE
