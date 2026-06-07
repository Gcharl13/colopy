; ============================================================================
; func_03CCC3_unknown
; Region   : load_image
; Bytes    : file 0x03CCC3..0x03CD46  (131 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CCC3  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03CCC7  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
03CCCB  7F 09                 JG     0x3ccd6                      ; UNKNOWN
03CCCD  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03CCD0  F7 D0                 NOT    ax                           ; UNKNOWN
03CCD2  40                    INC    ax                           ; UNKNOWN
03CCD3  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
03CCD6  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
03CCDA  7F 09                 JG     0x3cce5                      ; UNKNOWN
03CCDC  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
03CCDF  F7 D0                 NOT    ax                           ; UNKNOWN
03CCE1  40                    INC    ax                           ; UNKNOWN
03CCE2  89 46 08              MOV    word ptr [bp + 8], ax        ; UNKNOWN
03CCE5  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
03CCE8  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
03CCEB  83 F8 01              CMP    ax, 1                        ; UNKNOWN
03CCEE  7F 05                 JG     0x3ccf5                      ; UNKNOWN
03CCF0  B8 01 00              MOV    ax, 1                        ; UNKNOWN
03CCF3  EB 02                 JMP    0x3ccf7                      ; UNKNOWN
03CCF5  2B C0                 SUB    ax, ax                       ; UNKNOWN
03CCF7  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03CCFA  83 7E 0A 01           CMP    word ptr [bp + 0xa], 1       ; UNKNOWN
03CCFE  74 41                 JE     0x3cd41                      ; UNKNOWN
03CD00  83 7E 06 02           CMP    word ptr [bp + 6], 2         ; UNKNOWN
03CD04  7D 0A                 JGE    0x3cd10                      ; UNKNOWN
03CD06  83 7E 08 02           CMP    word ptr [bp + 8], 2         ; UNKNOWN
03CD0A  7D 04                 JGE    0x3cd10                      ; UNKNOWN
03CD0C  80 4E FE 01           OR     byte ptr [bp - 2], 1         ; UNKNOWN
03CD10  83 7E 0A 02           CMP    word ptr [bp + 0xa], 2       ; UNKNOWN
03CD14  74 2B                 JE     0x3cd41                      ; UNKNOWN
03CD16  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
03CD19  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
03CD1C  83 F8 02              CMP    ax, 2                        ; UNKNOWN
03CD1F  7F 05                 JG     0x3cd26                      ; UNKNOWN
03CD21  B8 01 00              MOV    ax, 1                        ; UNKNOWN
03CD24  EB 02                 JMP    0x3cd28                      ; UNKNOWN
03CD26  2B C0                 SUB    ax, ax                       ; UNKNOWN
03CD28  09 46 FE              OR     word ptr [bp - 2], ax        ; UNKNOWN
03CD2B  83 7E 0A 03           CMP    word ptr [bp + 0xa], 3       ; UNKNOWN
03CD2F  74 10                 JE     0x3cd41                      ; UNKNOWN
03CD31  83 7E 06 02           CMP    word ptr [bp + 6], 2         ; UNKNOWN
03CD35  7C 06                 JL     0x3cd3d                      ; UNKNOWN
03CD37  83 7E 08 02           CMP    word ptr [bp + 8], 2         ; UNKNOWN
03CD3B  7D 04                 JGE    0x3cd41                      ; UNKNOWN
03CD3D  80 4E FE 01           OR     byte ptr [bp - 2], 1         ; UNKNOWN
03CD41  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03CD44  C9                    LEAVE                               ; UNKNOWN
03CD45  CB                    RETF                                ; UNKNOWN
