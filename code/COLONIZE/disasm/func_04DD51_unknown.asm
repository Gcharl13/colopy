; ============================================================================
; func_04DD51_unknown
; Region   : load_image
; Bytes    : file 0x04DD51..0x04DD65  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04DD51  55                    PUSH   bp                           ; UNKNOWN
04DD52  8B EC                 MOV    bp, sp                       ; UNKNOWN
04DD54  8B 4E 08              MOV    cx, word ptr [bp + 8]        ; UNKNOWN
04DD57  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04DD5A  2B D2                 SUB    dx, dx                       ; UNKNOWN
04DD5C  8A C1                 MOV    al, cl                       ; UNKNOWN
04DD5E  FE C0                 INC    al                           ; UNKNOWN
04DD60  83 E0 07              AND    ax, 7                        ; UNKNOWN
04DD63  3B C3                 CMP    ax, bx                       ; UNKNOWN
