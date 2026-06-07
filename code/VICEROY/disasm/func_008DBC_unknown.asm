; ============================================================================
; func_008DBC_unknown
; Region   : load_image
; Bytes    : file 0x008DBC..0x008E01  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008DBC  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
008DC0  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
008DC3  D1 E3                 SHL    bx, 1 ; LOGIC
008DC5  8B 87 C8 8D           MOV    ax, word ptr [bx - 0x7238] ; MOV
008DC9  2B 87 0A 8E           SUB    ax, word ptr [bx - 0x71f6] ; ARITH
008DCD  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
008DD0  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
008DD3  80 BF A2 02 00        CMP    byte ptr [bx + 0x2a2], 0 ; CMP
008DD8  7C 22                 JL     0x8dfc ; CJUMP
008DDA  8A 87 A2 02           MOV    al, byte ptr [bx + 0x2a2] ; MOV
008DDE  98                    CWDE ; ARITH
008DDF  8B D8                 MOV    bx, ax ; MOV
008DE1  D1 E3                 SHL    bx, 1 ; LOGIC
008DE3  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
008DE6  2B 87 5A 8E           SUB    ax, word ptr [bx - 0x71a6] ; ARITH
008DEA  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
008DED  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
008DF1  74 09                 JE     0x8dfc ; CJUMP
008DF3  8B 87 5A 8E           MOV    ax, word ptr [bx - 0x71a6] ; MOV
008DF7  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
008DFA  89 07                 MOV    word ptr [bx], ax ; MOV
008DFC  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
008DFF  C9                    LEAVE ; EPILOGUE
008E00  CB                    RETF ; RETURN
