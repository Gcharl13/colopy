; ============================================================================
; func_024224_unknown
; Region   : overlay
; Bytes    : file 0x024224..0x02424C  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024224  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
024228  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
02422D  A1 1E 98              MOV    ax, word ptr [0x981e] ; GLOBAL_LOAD
024230  2D 0D 00              SUB    ax, 0xd ; ARITH
024233  74 29                 JE     0x2425e ; CJUMP
024235  2D 13 00              SUB    ax, 0x13 ; ARITH
024238  75 6A                 JNE    0x242a4 ; CJUMP
02423A  83 3E C6 53 00        CMP    word ptr [0x53c6], 0 ; CMP
02423F  74 0B                 JE     0x2424c ; CJUMP
024241  C7 06 C4 53 00 00     MOV    word ptr [0x53c4], 0 ; GLOBAL_LOAD
024247  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
02424A  C9                    LEAVE ; EPILOGUE
02424B  CB                    RETF ; RETURN
