; ============================================================================
; func_03CC92_unknown
; Region   : load_image
; Bytes    : file 0x03CC92..0x03CCC3  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CC92  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03CC96  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
03CC9B  83 7E 06 01           CMP    word ptr [bp + 6], 1         ; UNKNOWN
03CC9F  7C 18                 JL     0x3ccb9                      ; UNKNOWN
03CCA1  83 7E 08 01           CMP    word ptr [bp + 8], 1         ; UNKNOWN
03CCA5  7C 12                 JL     0x3ccb9                      ; UNKNOWN
03CCA7  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03CCAA  48                    DEC    ax                           ; UNKNOWN
03CCAB  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
03CCAE  7E 09                 JLE    0x3ccb9                      ; UNKNOWN
03CCB0  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03CCB3  48                    DEC    ax                           ; UNKNOWN
03CCB4  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
03CCB7  7F 05                 JG     0x3ccbe                      ; UNKNOWN
03CCB9  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03CCBE  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03CCC1  C9                    LEAVE                               ; UNKNOWN
03CCC2  CB                    RETF                                ; UNKNOWN
