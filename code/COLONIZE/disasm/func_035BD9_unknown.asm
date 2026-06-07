; ============================================================================
; func_035BD9_unknown
; Region   : load_image
; Bytes    : file 0x035BD9..0x035C08  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

035BD9  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
035BDD  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
035BE2  83 3E 9A 79 04        CMP    word ptr [0x799a], 4         ; UNKNOWN
035BE7  7D 0C                 JGE    0x35bf5                      ; UNKNOWN
035BE9  6B 1E 9A 79 34        IMUL   bx, word ptr [0x799a], 0x34  ; UNKNOWN
035BEE  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
035BF3  74 13                 JE     0x35c08                      ; UNKNOWN
035BF5  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
035BF9  C7 47 20 00 00        MOV    word ptr [bx + 0x20], 0      ; UNKNOWN
035BFE  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
035C03  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
035C06  C9                    LEAVE                               ; UNKNOWN
035C07  CB                    RETF                                ; UNKNOWN
