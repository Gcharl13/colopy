; ============================================================================
; func_04C298_unknown
; Region   : overlay
; Bytes    : file 0x04C298..0x04C2CD  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C298  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
04C29C  C7 46 FE 0E 00        MOV    word ptr [bp - 2], 0xe ; LOCAL_STORE
04C2A1  EB 20                 JMP    0x4c2c3 ; JUMP
04C2A3  90                    NOP ; NOP
04C2A4  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04C2A7  C1 E3 04              SHL    bx, 4 ; LOGIC
04C2AA  03 5E FE              ADD    bx, word ptr [bp - 2] ; ARITH
04C2AD  C1 E3 02              SHL    bx, 2 ; LOGIC
04C2B0  8B 87 AA 9E           MOV    ax, word ptr [bx - 0x6156] ; MOV
04C2B4  8B 97 AC 9E           MOV    dx, word ptr [bx - 0x6154] ; MOV
04C2B8  89 87 AE 9E           MOV    word ptr [bx - 0x6152], ax ; MOV
04C2BC  89 97 B0 9E           MOV    word ptr [bx - 0x6150], dx ; MOV
04C2C0  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
04C2C3  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
04C2C6  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
04C2C9  7D D9                 JGE    0x4c2a4 ; CJUMP
04C2CB  C9                    LEAVE ; EPILOGUE
04C2CC  CB                    RETF ; RETURN
