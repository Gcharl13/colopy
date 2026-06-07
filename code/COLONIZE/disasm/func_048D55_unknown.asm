; ============================================================================
; func_048D55_unknown
; Region   : load_image
; Bytes    : file 0x048D55..0x048D64  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048D55  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
048D59  56                    PUSH   si                           ; UNKNOWN
048D5A  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
048D5D  D1 E3                 SHL    bx, 1                        ; UNKNOWN
048D5F  C4 36 CA 0B           LES    si, ptr [0xbca]              ; UNKNOWN
048D63  26                    DB     0x26                         ; UNKNOWN (raw)
