; ============================================================================
; func_02E5B1_unknown
; Region   : load_image
; Bytes    : file 0x02E5B1..0x02E5D2  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E5B1  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02E5B5  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E5B9  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E5BC  98                    CWDE                                ; UNKNOWN
02E5BD  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
02E5C0  7E 1A                 JLE    0x2e5dc                      ; UNKNOWN
02E5C2  83 7E 08 13           CMP    word ptr [bp + 8], 0x13      ; UNKNOWN
02E5C6  7D 0A                 JGE    0x2e5d2                      ; UNKNOWN
02E5C8  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02E5CD  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02E5D0  C9                    LEAVE                               ; UNKNOWN
02E5D1  CB                    RETF                                ; UNKNOWN
