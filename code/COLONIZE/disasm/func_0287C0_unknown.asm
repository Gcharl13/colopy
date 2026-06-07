; ============================================================================
; func_0287C0_unknown
; Region   : load_image
; Bytes    : file 0x0287C0..0x0287D8  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0287C0  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0287C4  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0287C8  74 0E                 JE     0x287d8                      ; UNKNOWN
0287CA  C4 1E 8E 40           LES    bx, ptr [0x408e]             ; UNKNOWN
0287CE  26 8A 47 02           MOV    al, byte ptr es:[bx + 2]     ; UNKNOWN
0287D2  C0 F8 04              SAR    al, 4                        ; UNKNOWN
0287D5  98                    CWDE                                ; UNKNOWN
0287D6  C9                    LEAVE                               ; UNKNOWN
0287D7  CB                    RETF                                ; UNKNOWN
