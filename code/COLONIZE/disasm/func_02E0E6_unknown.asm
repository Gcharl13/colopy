; ============================================================================
; func_02E0E6_unknown
; Region   : load_image
; Bytes    : file 0x02E0E6..0x02E12B  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E0E6  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02E0EA  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02E0ED  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02E0EF  8B 87 88 73           MOV    ax, word ptr [bx + 0x7388]   ; UNKNOWN
02E0F3  2B 87 C9 73           SUB    ax, word ptr [bx + 0x73c9]   ; UNKNOWN
02E0F7  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02E0FA  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02E0FD  80 BF 54 0A 00        CMP    byte ptr [bx + 0xa54], 0     ; UNKNOWN
02E102  7C 22                 JL     0x2e126                      ; UNKNOWN
02E104  8A 87 54 0A           MOV    al, byte ptr [bx + 0xa54]    ; UNKNOWN
02E108  98                    CWDE                                ; UNKNOWN
02E109  8B D8                 MOV    bx, ax                       ; UNKNOWN
02E10B  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02E10D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02E110  2B 87 19 74           SUB    ax, word ptr [bx + 0x7419]   ; UNKNOWN
02E114  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02E117  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
02E11B  74 09                 JE     0x2e126                      ; UNKNOWN
02E11D  8B 87 19 74           MOV    ax, word ptr [bx + 0x7419]   ; UNKNOWN
02E121  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
02E124  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
02E126  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02E129  C9                    LEAVE                               ; UNKNOWN
02E12A  CB                    RETF                                ; UNKNOWN
