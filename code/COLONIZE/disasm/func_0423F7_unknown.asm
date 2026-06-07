; ============================================================================
; func_0423F7_unknown
; Region   : load_image
; Bytes    : file 0x0423F7..0x04241D  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0423F7  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0423FB  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
042400  81 3E 02 3E 40 06     CMP    word ptr [0x3e02], 0x640     ; UNKNOWN
042406  7C 05                 JL     0x4240d                      ; UNKNOWN
042408  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
04240D  81 3E 02 3E A4 06     CMP    word ptr [0x3e02], 0x6a4     ; UNKNOWN
042413  7C 03                 JL     0x42418                      ; UNKNOWN
042415  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
042418  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04241B  C9                    LEAVE                               ; UNKNOWN
04241C  CB                    RETF                                ; UNKNOWN
