; ============================================================================
; func_034B00_unknown
; Region   : load_image
; Bytes    : file 0x034B00..0x034B16  (22 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034B00  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
034B04  56                    PUSH   si                           ; UNKNOWN
034B05  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
034B09  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
034B0C  8A 40 4C              MOV    al, byte ptr [bx + si + 0x4c] ; UNKNOWN
034B0F  40                    INC    ax                           ; UNKNOWN
034B10  88 40 4C              MOV    byte ptr [bx + si + 0x4c], al ; UNKNOWN
034B13  5E                    POP    si                           ; UNKNOWN
034B14  C9                    LEAVE                               ; UNKNOWN
034B15  CB                    RETF                                ; UNKNOWN
