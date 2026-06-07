; ============================================================================
; func_02E0C7_unknown
; Region   : load_image
; Bytes    : file 0x02E0C7..0x02E0E6  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E0C7  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02E0CB  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
02E0D0  83 7E 06 13           CMP    word ptr [bp + 6], 0x13      ; UNKNOWN
02E0D4  7D 0B                 JGE    0x2e0e1                      ; UNKNOWN
02E0D6  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02E0D9  8A 87 A6 0A           MOV    al, byte ptr [bx + 0xaa6]    ; UNKNOWN
02E0DD  98                    CWDE                                ; UNKNOWN
02E0DE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02E0E1  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02E0E4  C9                    LEAVE                               ; UNKNOWN
02E0E5  CB                    RETF                                ; UNKNOWN
