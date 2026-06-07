; ============================================================================
; func_03C2CB_unknown
; Region   : load_image
; Bytes    : file 0x03C2CB..0x03C2F3  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C2CB  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03C2CF  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
03C2D4  A1 DA 79              MOV    ax, word ptr [0x79da]        ; UNKNOWN
03C2D7  83 E8 0D              SUB    ax, 0xd                      ; UNKNOWN
03C2DA  74 29                 JE     0x3c305                      ; UNKNOWN
03C2DC  83 E8 13              SUB    ax, 0x13                     ; UNKNOWN
03C2DF  75 68                 JNE    0x3c349                      ; UNKNOWN
03C2E1  83 3E 3E 3E 00        CMP    word ptr [0x3e3e], 0         ; UNKNOWN
03C2E6  74 0B                 JE     0x3c2f3                      ; UNKNOWN
03C2E8  C7 06 3C 3E 00 00     MOV    word ptr [0x3e3c], 0         ; UNKNOWN
03C2EE  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
03C2F1  C9                    LEAVE                               ; UNKNOWN
03C2F2  CB                    RETF                                ; UNKNOWN
