; ============================================================================
; func_03B95A_unknown
; Region   : overlay
; Bytes    : file 0x03B95A..0x03B980  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03B95A  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
03B95E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
03B963  81 3E 8A 53 40 06     CMP    word ptr [0x538a], 0x640 ; CMP
03B969  7C 05                 JL     0x3b970 ; CJUMP
03B96B  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
03B970  81 3E 8A 53 A4 06     CMP    word ptr [0x538a], 0x6a4 ; CMP
03B976  7C 03                 JL     0x3b97b ; CJUMP
03B978  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
03B97B  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
03B97E  C9                    LEAVE ; EPILOGUE
03B97F  CB                    RETF ; RETURN
