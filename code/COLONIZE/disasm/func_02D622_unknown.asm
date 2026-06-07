; ============================================================================
; func_02D622_unknown
; Region   : load_image
; Bytes    : file 0x02D622..0x02D64E  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D622  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02D626  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02D62B  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02D62E  A3 86 73              MOV    word ptr [0x7386], ax        ; UNKNOWN
02D631  0B C0                 OR     ax, ax                       ; UNKNOWN
02D633  7C 06                 JL     0x2d63b                      ; UNKNOWN
02D635  3B 06 16 3E           CMP    ax, word ptr [0x3e16]        ; UNKNOWN
02D639  7C 0A                 JL     0x2d645                      ; UNKNOWN
02D63B  C7 46 06 00 00        MOV    word ptr [bp + 6], 0         ; UNKNOWN
02D640  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02D645  A0 0E 3E              MOV    al, byte ptr [0x3e0e]        ; UNKNOWN
02D648  69 5E 06 CA 00        IMUL   bx, word ptr [bp + 6], 0xca  ; UNKNOWN
02D64D  81                    DB     0x81                         ; UNKNOWN (raw)
