; ============================================================================
; func_03334E_unknown
; Region   : overlay
; Bytes    : file 0x03334E..0x03337D  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03334E  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
033352  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
033357  83 3E 12 9E 04        CMP    word ptr [0x9e12], 4 ; CMP
03335C  7D 0C                 JGE    0x3336a ; CJUMP
03335E  6B 1E 12 9E 34        IMUL   bx, word ptr [0x9e12], 0x34 ; ARITH
033363  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
033368  74 14                 JE     0x3337e ; CJUMP
03336A  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
03336E  C7 47 20 00 00        MOV    word ptr [bx + 0x20], 0 ; MOV
033373  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
033378  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
03337B  C9                    LEAVE ; EPILOGUE
03337C  CB                    RETF ; RETURN
