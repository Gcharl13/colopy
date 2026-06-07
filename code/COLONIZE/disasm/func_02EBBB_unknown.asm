; ============================================================================
; func_02EBBB_unknown
; Region   : load_image
; Bytes    : file 0x02EBBB..0x02EBFC  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EBBB  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02EBBF  C7 46 FC 14 00        MOV    word ptr [bp - 4], 0x14      ; UNKNOWN
02EBC4  C7 46 FA C8 00        MOV    word ptr [bp - 6], 0xc8      ; UNKNOWN
02EBC9  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
02EBCD  74 07                 JE     0x2ebd6                      ; UNKNOWN
02EBCF  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
02EBD2  C7 07 14 00           MOV    word ptr [bx], 0x14          ; UNKNOWN
02EBD6  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
02EBDA  74 1B                 JE     0x2ebf7                      ; UNKNOWN
02EBDC  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
02EBE0  26 8B 87 52 01        MOV    ax, word ptr es:[bx + 0x152] ; UNKNOWN
02EBE5  40                    INC    ax                           ; UNKNOWN
02EBE6  F7 6E FC              IMUL   word ptr [bp - 4]            ; UNKNOWN
02EBE9  48                    DEC    ax                           ; UNKNOWN
02EBEA  83 F8 76              CMP    ax, 0x76                     ; UNKNOWN
02EBED  7E 03                 JLE    0x2ebf2                      ; UNKNOWN
02EBEF  B8 76 00              MOV    ax, 0x76                     ; UNKNOWN
02EBF2  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02EBF5  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
02EBF7  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02EBFA  C9                    LEAVE                               ; UNKNOWN
02EBFB  CB                    RETF                                ; UNKNOWN
