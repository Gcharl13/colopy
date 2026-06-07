; ============================================================================
; func_02EA63_unknown
; Region   : load_image
; Bytes    : file 0x02EA63..0x02EA7B  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EA63  55                    PUSH   bp                           ; UNKNOWN
02EA64  8B EC                 MOV    bp, sp                       ; UNKNOWN
02EA66  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
02EA6A  7C 1D                 JL     0x2ea89                      ; UNKNOWN
02EA6C  EB 08                 JMP    0x2ea76                      ; UNKNOWN
02EA6E  8A 87 16 39           MOV    al, byte ptr [bx + 0x3916]   ; UNKNOWN
02EA72  98                    CWDE                                ; UNKNOWN
02EA73  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
02EA76  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02EA79  8B C3                 MOV    ax, bx                       ; UNKNOWN
