; ============================================================================
; func_02D9BF_unknown
; Region   : load_image
; Bytes    : file 0x02D9BF..0x02D9E1  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D9BF  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02D9C3  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02D9C8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D9CB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D9CE  0E                    PUSH   cs                           ; UNKNOWN
02D9CF  E8 77 FF              CALL   0x2d949                      ; UNKNOWN
02D9D2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02D9D5  0B C0                 OR     ax, ax                       ; UNKNOWN
02D9D7  74 03                 JE     0x2d9dc                      ; UNKNOWN
02D9D9  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02D9DC  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
02D9DF  8B C3                 MOV    ax, bx                       ; UNKNOWN
