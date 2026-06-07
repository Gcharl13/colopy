; ============================================================================
; func_02E16F_unknown
; Region   : load_image
; Bytes    : file 0x02E16F..0x02E1AC  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E16F  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02E173  56                    PUSH   si                           ; UNKNOWN
02E174  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02E177  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02E179  8B 87 88 73           MOV    ax, word ptr [bx + 0x7388]   ; UNKNOWN
02E17D  83 7E 06 0E           CMP    word ptr [bp + 6], 0xe       ; UNKNOWN
02E181  75 0B                 JNE    0x2e18e                      ; UNKNOWN
02E183  83 3E 25 74 00        CMP    word ptr [0x7425], 0         ; UNKNOWN
02E188  74 04                 JE     0x2e18e                      ; UNKNOWN
02E18A  2B 06 25 74           SUB    ax, word ptr [0x7425]        ; UNKNOWN
02E18E  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02E191  D1 E6                 SHL    si, 1                        ; UNKNOWN
02E193  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E197  FF B0 9A 00           PUSH   word ptr [bx + si + 0x9a]    ; UNKNOWN
02E19B  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02E19E  50                    PUSH   ax                           ; UNKNOWN
02E19F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02E1A2  0E                    PUSH   cs                           ; UNKNOWN
02E1A3  E8 85 FF              CALL   0x2e12b                      ; UNKNOWN
02E1A6  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02E1A9  5E                    POP    si                           ; UNKNOWN
02E1AA  C9                    LEAVE                               ; UNKNOWN
02E1AB  CB                    RETF                                ; UNKNOWN
