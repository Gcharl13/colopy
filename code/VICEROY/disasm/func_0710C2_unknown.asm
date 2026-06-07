; ============================================================================
; func_0710C2_unknown
; Region   : overlay
; Bytes    : file 0x0710C2..0x0710FC  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0710C2  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0710C6  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0710CB  83 3E A6 85 00        CMP    word ptr [0x85a6], 0 ; CMP
0710D0  7F 12                 JG     0x710e4 ; CJUMP
0710D2  7C 08                 JL     0x710dc ; CJUMP
0710D4  81 3E A4 85 E0 2E     CMP    word ptr [0x85a4], 0x2ee0 ; CMP
0710DA  77 08                 JA     0x710e4 ; CJUMP
0710DC  C7 06 5A 01 00 00     MOV    word ptr [0x15a], 0 ; GLOBAL_LOAD
0710E2  EB 06                 JMP    0x710ea ; JUMP
0710E4  C7 06 5A 01 01 00     MOV    word ptr [0x15a], 1 ; GLOBAL_LOAD
0710EA  83 3E 5A 01 00        CMP    word ptr [0x15a], 0 ; CMP
0710EF  74 0B                 JE     0x710fc ; CJUMP
0710F1  C7 06 58 01 0F 27     MOV    word ptr [0x158], 0x270f ; GLOBAL_LOAD
0710F7  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0710FA  C9                    LEAVE ; EPILOGUE
0710FB  CB                    RETF ; RETURN
