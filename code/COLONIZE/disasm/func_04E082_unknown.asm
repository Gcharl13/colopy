; ============================================================================
; func_04E082_unknown
; Region   : load_image
; Bytes    : file 0x04E082..0x04E09A  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E082  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
04E086  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04E089  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
04E08B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04E08E  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04E091  D1 E8                 SHR    ax, 1                        ; UNKNOWN
04E093  73 03                 JAE    0x4e098                      ; UNKNOWN
04E095  33 46 08              XOR    ax, word ptr [bp + 8]        ; UNKNOWN
04E098  C9                    LEAVE                               ; UNKNOWN
04E099  CB                    RETF                                ; UNKNOWN
