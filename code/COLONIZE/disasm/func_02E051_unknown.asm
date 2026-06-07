; ============================================================================
; func_02E051_unknown
; Region   : load_image
; Bytes    : file 0x02E051..0x02E096  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E051  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02E055  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
02E05A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02E05D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02E060  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
02E065  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02E068  0B C0                 OR     ax, ax                       ; UNKNOWN
02E06A  74 56                 JE     0x2e0c2                      ; UNKNOWN
02E06C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02E06F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02E072  9A 47 03 C9 33        LCALL  0x33c9, 0x347                ; UNKNOWN
02E077  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02E07A  0B C0                 OR     ax, ax                       ; UNKNOWN
02E07C  7C 44                 JL     0x2e0c2                      ; UNKNOWN
02E07E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02E083  EB 28                 JMP    0x2e0ad                      ; UNKNOWN
02E085  A1 16 3E              MOV    ax, word ptr [0x3e16]        ; UNKNOWN
02E088  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
02E08B  7D 26                 JGE    0x2e0b3                      ; UNKNOWN
02E08D  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
02E090  69 5E FE CA 00        IMUL   bx, word ptr [bp - 2], 0xca  ; UNKNOWN
02E095  38                    DB     0x38                         ; UNKNOWN (raw)
