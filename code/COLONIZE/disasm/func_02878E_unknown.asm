; ============================================================================
; func_02878E_unknown
; Region   : load_image
; Bytes    : file 0x02878E..0x0287AE  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02878E  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
028792  83 7E 06 06           CMP    word ptr [bp + 6], 6         ; UNKNOWN
028796  7C 16                 JL     0x287ae                      ; UNKNOWN
028798  83 6E 06 06           SUB    word ptr [bp + 6], 6         ; UNKNOWN
02879C  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02879F  D1 F8                 SAR    ax, 1                        ; UNKNOWN
0287A1  03 06 8E 40           ADD    ax, word ptr [0x408e]        ; UNKNOWN
0287A5  8B 16 90 40           MOV    dx, word ptr [0x4090]        ; UNKNOWN
0287A9  83 C0 03              ADD    ax, 3                        ; UNKNOWN
0287AC  C9                    LEAVE                               ; UNKNOWN
0287AD  CB                    RETF                                ; UNKNOWN
