; ============================================================================
; func_02146E_unknown
; Region   : load_image
; Bytes    : file 0x02146E..0x0214BD  (79 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02146E  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
021472  53                    PUSH   bx                           ; UNKNOWN
021473  52                    PUSH   dx                           ; UNKNOWN
021474  50                    PUSH   ax                           ; UNKNOWN
021475  57                    PUSH   di                           ; UNKNOWN
021476  56                    PUSH   si                           ; UNKNOWN
021477  8B F0                 MOV    si, ax                       ; UNKNOWN
021479  8B FA                 MOV    di, dx                       ; UNKNOWN
02147B  57                    PUSH   di                           ; UNKNOWN
02147C  56                    PUSH   si                           ; UNKNOWN
02147D  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
021482  83 C4 04              ADD    sp, 4                        ; UNKNOWN
021485  0B C0                 OR     ax, ax                       ; UNKNOWN
021487  75 03                 JNE    0x2148c                      ; UNKNOWN
021489  E9 34 01              JMP    0x215c0                      ; UNKNOWN
02148C  83 7E F2 04           CMP    word ptr [bp - 0xe], 4       ; UNKNOWN
021490  7C 03                 JL     0x21495                      ; UNKNOWN
021492  E9 2B 01              JMP    0x215c0                      ; UNKNOWN
021495  57                    PUSH   di                           ; UNKNOWN
021496  56                    PUSH   si                           ; UNKNOWN
021497  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
02149C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02149F  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
0214A2  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0214A5  F7 D8                 NEG    ax                           ; UNKNOWN
0214A7  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0214AA  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
0214AD  7E 03                 JLE    0x214b2                      ; UNKNOWN
0214AF  E9 0E 01              JMP    0x215c0                      ; UNKNOWN
0214B2  89 76 EE              MOV    word ptr [bp - 0x12], si     ; UNKNOWN
0214B5  89 7E F0              MOV    word ptr [bp - 0x10], di     ; UNKNOWN
0214B8  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0214BB  8B C3                 MOV    ax, bx                       ; UNKNOWN
