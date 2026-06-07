; ============================================================================
; func_04F9E0_unknown
; Region   : load_image
; Bytes    : file 0x04F9E0..0x04F9FE  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04F9E0  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04F9E4  FF 4E 06              DEC    word ptr [bp + 6]            ; UNKNOWN
04F9E7  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04F9EA  C1 F8 03              SAR    ax, 3                        ; UNKNOWN
04F9ED  8A 4E 06              MOV    cl, byte ptr [bp + 6]        ; UNKNOWN
04F9F0  80 E1 07              AND    cl, 7                        ; UNKNOWN
04F9F3  BA 01 00              MOV    dx, 1                        ; UNKNOWN
04F9F6  D3 E2                 SHL    dx, cl                       ; UNKNOWN
04F9F8  8B D8                 MOV    bx, ax                       ; UNKNOWN
04F9FA  8B C2                 MOV    ax, dx                       ; UNKNOWN
04F9FC  22                    DB     0x22                         ; UNKNOWN (raw)
04F9FD  87                    DB     0x87                         ; UNKNOWN (raw)
