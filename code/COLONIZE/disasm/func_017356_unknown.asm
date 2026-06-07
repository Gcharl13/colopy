; ============================================================================
; func_017356_unknown
; Region   : load_image
; Bytes    : file 0x017356..0x01738B  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

017356  C8 5E 00 00           ENTER  0x5e, 0                      ; UNKNOWN
01735A  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
01735D  8A 87 92 08           MOV    al, byte ptr [bx + 0x892]    ; UNKNOWN
017361  98                    CWDE                                ; UNKNOWN
017362  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
017365  8A 87 97 08           MOV    al, byte ptr [bx + 0x897]    ; UNKNOWN
017369  98                    CWDE                                ; UNKNOWN
01736A  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
01736D  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
017371  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
017375  7C 43                 JL     0x173ba                      ; UNKNOWN
017377  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01737A  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
01737F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
017382  0B C0                 OR     ax, ax                       ; UNKNOWN
017384  74 1C                 JE     0x173a2                      ; UNKNOWN
017386  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
017389  8B C3                 MOV    ax, bx                       ; UNKNOWN
